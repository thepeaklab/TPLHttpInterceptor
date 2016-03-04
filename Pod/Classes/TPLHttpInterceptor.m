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

@property (strong, nonatomic) NSMutableURLRequest *mutableRequest;

@end



@implementation TPLHttpInterceptor

+ (void)enable
{
    [NSURLProtocol registerClass:[self class]];
}

+ (void)disable
{
    [NSURLProtocol unregisterClass:[self class]];
}

#pragma mark - NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    return ([[request allHTTPHeaderFields] objectForKey:TPL_HTTP_INTERCEPTOR_HEADER_MARKER] == nil);
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
        
        _mutableRequest = [request mutableCopy];
        [_mutableRequest addValue:@"True" forHTTPHeaderField:TPL_HTTP_INTERCEPTOR_HEADER_MARKER];
        
    }
    return self;
}

- (void)startLoading
{
    NSLog(@"start load %@", self.request.URL);
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
        return request;
    } else {
        return request;
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

@end
