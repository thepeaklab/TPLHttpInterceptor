//
//  TPLHttpInterceptor.h
//  Pods
//
//  Created by Christoph Pageler on 04.03.16.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Intercept (and modify) NSURLRequests
 *
 *  TPLHttpInterceptor enables you to intercept and modify all NSURLRequests,
 *  also requests which are not triggered from your own code (UIWebView, other libraries, ...)
 */
@interface TPLHttpInterceptor : NSURLProtocol

/**
 *  enables interception
 *
 *  @warning call ´enableWithBlock´ at least once before ´enable´ to set the block
 *  (enable the interception without the interception-block makes no sense)
 * 
 *  @see enableWithBlock:
 */
+ (void)enable;

/**
 *  enables interception and sets static block
 *
 *  @param block this block gets called just before the ´request´ starts
 */
+ (void)enableWithBlock:(void (^)(NSMutableURLRequest *request))block;

/**
 *  disables interception
 */
+ (void)disable;

@end

NS_ASSUME_NONNULL_END