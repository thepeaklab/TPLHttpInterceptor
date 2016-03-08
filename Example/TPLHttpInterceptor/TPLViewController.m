//
//  TPLViewController.m
//  TPLHttpInterceptor
//
//  Created by Christoph Pageler on 03/04/2016.
//  Copyright (c) 2016 Christoph Pageler. All rights reserved.
//

#import "TPLViewController.h"
#import <TPLHttpInterceptor/TPLHttpInterceptor.h>

@interface TPLViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TPLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [TPLHttpInterceptor enableWithBlock:^(NSMutableURLRequest *request) {
        NSLog(@"will start: %@", request.URL);
    }];
    
    NSURL *url = [NSURL URLWithString:@"http://www.thepeaklab.com"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
