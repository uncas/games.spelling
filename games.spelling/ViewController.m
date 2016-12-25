//
//  ViewController.m
//  games.spelling
//
//  Created by Soerensen, Ole Lynge on 22/12/2016.
//  Copyright (c) 2016 Uncas. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()

@end

@implementation ViewController{
    NSArray *_words;
    int _wordIndex;
    NSDictionary *_word;
    AVAudioPlayer *_audioPlayer;
}

- (void)viewDidLoad {
    _wordIndex = 0;
    [super viewDidLoad];
    [self fetchWords];
}

- (void)showImageFromUrl: (NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    self.imageView.image = image;
}

- (void)showAWord {
    _word = _words[_wordIndex];
    NSString *imageUrl = _word[@"imageUrl"];
    if ([imageUrl length] > 0) {
        [self showImageFromUrl:imageUrl];
    } else {
        [self playSound:_word[@"soundUrl"]];
    }
}

- (void)playSound : (NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    NSData* data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchWords;
{
    RestService *restService;
    restService = [RestService alloc];
    restService = [restService init];
    NSString *apiCode = @"l7YSboIW6rgQBaavhoF24p6gvHApLaTt2/OX4urNlWYisINNkqsRtQ==";
    NSString *game = @"spelling";
    NSString *urlString = [NSString stringWithFormat:
            @"https://uncas.azurewebsites.net/api/HttpTriggerJS1?code=%@&game=%@", apiCode, game];
    [restService DownloadJson : urlString : ^(NSDictionary *result){
        _words = result[@"words"];
        [self showAWord];
    }];
}

- (IBAction)nextTapped:(UIButton *)sender
{
    NSString *input = self.textView.text;
    NSString *expected = _word[@"word"];
    if ([input isEqualToString:expected]) {
        self.statusLabel.text = @"Korrekt!";
    }
    else {
        self.statusLabel.text = @"Forkert!";
    }

    _wordIndex += 1;
    if (_wordIndex >= [_words count]) {
        _wordIndex = 0;
    }

    [self showAWord];
}

@end