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
    
    [TPLHttpInterceptor enable];
    
    NSURL *url = [NSURL URLWithString:@"https://www.google.de"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
