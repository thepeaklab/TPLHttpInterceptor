//
//  TPLHttpInterceptor.m
//  Pods
//
//  Created by Christoph Pageler on 04.03.16.
//
//

#import "TPLHttpInterceptor.h"


static NSString *TPL_HTTP_INTERCEPTOR_HEADER_MARKER = @"X-TPL_HTTP_INTERCEPTOR";

@interface TPLHttpInterceptor()<NSURLConnectionDataDelegate>

/**
 *  mutable copy of incoming request
 */
@property (strong, nonatomic) NSMutableURLRequest *mutableRequest;

@end



@implementation TPLHttpInterceptor

/**
 *  Block which gets called just before the request starts
 *
 *  @see enableWithBlock:
 */
static void (^block)(NSMutableURLRequest *request);

+ (void)enable
{
    [self _assertBlock];
    [self _registerClass];
}

+ (void)enableWithBlock:(void (^)(NSMutableURLRequest * _Nonnull))b
{
    block = b;
    [self _assertBlock];
    [self _registerClass];
}

+ (void)disable
{
    [NSURLProtocol unregisterClass:[self class]];
}

#pragma mark - private methods

/**
 *  registers this class in NSURLProtocol
 */
+ (void)_registerClass
{
    [NSURLProtocol registerClass:[self class]];
}

/**
 *  asserts block existence
 */
+ (void)_assertBlock
{
    NSAssert(block, @"block can not be empty");
}

/**
 *  copies NSURLRequest mutable and adds TPL_HTTP_INTERCEPTOR_HEADER_MARKER in HTTP Headers to determine 
 *  whether the request was modified already
 *
 *  @param urlRequest request to copy
 *
 *  @return mutable copy
 */
- (NSMutableURLRequest *)copyRequestMutable:(NSURLRequest *)urlRequest
{
    NSMutableURLRequest *mutableCopy = [urlRequest mutableCopy];
    [mutableCopy setValue:@"true" forHTTPHeaderField:TPL_HTTP_INTERCEPTOR_HEADER_MARKER];
    return mutableCopy;
}

#pragma mark - NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return [request allHTTPHeaderFields][TPL_HTTP_INTERCEPTOR_HEADER_MARKER] == nil;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a
                       toRequest:(NSURLRequest *)b
{
    return NO;
}

- (instancetype)initWithRequest:(NSURLRequest *)request
                 cachedResponse:(NSCachedURLResponse *)cachedResponse
                         client:(id<NSURLProtocolClient>)client
{
    if (self = [super initWithRequest:request
                       cachedResponse:cachedResponse
                               client:client]) {
        // copy
        _mutableRequest = [self copyRequestMutable:request];
        
    }
    return self;
}

- (void)startLoading
{
    block(_mutableRequest);
    [NSURLConnection connectionWithRequest:_mutableRequest delegate:self];
}

- (void)stopLoading
{
    _mutableRequest = nil;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    [self.client URLProtocol:self
          didReceiveResponse:response
          cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self
                 didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [self.client URLProtocol:self
            didFailWithError:error];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
    if (redirectResponse) {
        NSMutableURLRequest *mutableRequest = [self copyRequestMutable:request];
        block(mutableRequest);
        return mutableRequest;
    }
    
    return request;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

@end
