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

@implementation ViewController{
    NSArray *_images;
    int _imageIndex;
}

- (void)viewDidLoad {
    _imageIndex = 0;
    [super viewDidLoad];
    [self fetchImages];
}

- (void)showImage: (NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    self.imageView.image = image;
}

- (void)showAnImage {
    NSDictionary *firstImage = _images[_imageIndex];
    [self showImage:firstImage[@"imageUrl"]];
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
    NSString *apiCode = @"l7YSboIW6rgQBaavhoF24p6gvHApLaTt2/OX4urNlWYisINNkqsRtQ==";
    NSString *game = @"spelling";
    NSString *urlString = [NSString stringWithFormat:
            @"https://uncas.azurewebsites.net/api/HttpTriggerJS1?code=%@&game=%@", apiCode, game];
    [restService DownloadJson : urlString : ^(NSDictionary *result){
        NSArray *images = result[@"images"];
        _images = images;
        [self showAnImage];
    }];
}

- (IBAction)nextTapped:(UIButton *)sender
{
    _imageIndex += 1;
    if (_imageIndex >= [_images count]){
        _imageIndex = 0;
    }

    [self showAnImage];
}

@end