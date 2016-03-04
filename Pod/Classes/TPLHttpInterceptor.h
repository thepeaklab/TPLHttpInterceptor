//
//  TPLHttpInterceptor.h
//  Pods
//
//  Created by Christoph Pageler on 04.03.16.
//
//

#import <Foundation/Foundation.h>

@interface TPLHttpInterceptor : NSURLProtocol

+ (void)enable;

+ (void)disable;

@end
