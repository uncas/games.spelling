//
//  ViewController.m
//  games.spelling
//
//  Created by Soerensen, Ole Lynge on 22/12/2016.
//  Copyright (c) 2016 Uncas. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchImages];
}

- (void)showImage: (NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    self.imageView.image = image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchImages;
{
    RestService *restService;
    restService = [RestService alloc];
    restService = [restService init];
    [restService DownloadJson : @"https://uncas.azurewebsites.net/api/HttpTriggerJS1?code=l7YSboIW6rgQBaavhoF24p6gvHApLaTt2/OX4urNlWYisINNkqsRtQ==&game=spelling" : ^(NSDictionary *result){
        [self showImage:result[@"imageUrl"]];
    }];
}

@end