//
//  ViewController.m
//  games.spelling
//
//  Created by Soerensen, Ole Lynge on 22/12/2016.
//  Copyright (c) 2016 Uncas. All rights reserved.
//

#import "ViewController.h"
#import "SpellingGame.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()

@end

@implementation ViewController {
    AVAudioPlayer *_audioPlayer;
    BOOL _buttonGoesToNextWord;
    SpellingGame *_game;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchWords];
    self.textView.delegate = self;
    _buttonGoesToNextWord = NO;
}

- (void)showImageFromUrl:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    self.imageView.image = image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)showAWord {
    NSString *imageUrl = _game.getCurrentImageUrl;
    if ([imageUrl length] > 0) {
        [self showImageFromUrl:imageUrl];
    }

    [self playSound];
    self.textView.enabled = YES;
    self.textView.text = @"";
    [self.textView becomeFirstResponder];
    self.statusLabel.text = @"Stav til ordet...";
}

- (void)playSound {
    NSString *soundUrl = _game.getCurrentSoundUrl;
    if ([soundUrl length] > 0) {
        [self playSoundFromUrl:soundUrl];
    }
}

- (void)playSoundFromUrl:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    [_audioPlayer prepareToPlay];
    [_audioPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchWords; {
    RestService *restService = [[RestService alloc] init];
    NSString *apiCode = @"l7YSboIW6rgQBaavhoF24p6gvHApLaTt2/OX4urNlWYisINNkqsRtQ==";
    NSString *game = @"spelling";
    NSString *urlString = [NSString stringWithFormat:
            @"https://uncas.azurewebsites.net/api/HttpTriggerJS1?code=%@&game=%@", apiCode, game];
    [restService DownloadJson:urlString :^(NSDictionary *result) {
        _game = [[SpellingGame alloc] init];
        [_game loadWords:result[@"words"]];
        [self showAWord];
    }];
}

- (IBAction)nextTapped:(UIButton *)sender {
    if (_buttonGoesToNextWord) {
        [self goToNextWord];
        _buttonGoesToNextWord = NO;
    } else
        [self tryWord];
}

- (void)tryWord {
    NSString *input = self.textView.text;
    BOOL isCorrect = [_game tryWord:input];
    if (!isCorrect) {
        self.statusLabel.text = @"Forkert! Prøv igen!";
        [self playSound];
        return;
    }

    NSString *statusText = [NSString stringWithFormat:
            @"Rigtigt! Du har nu %i points", _game.getPoints];
    self.statusLabel.text = statusText;
    _buttonGoesToNextWord = YES;
    self.textView.enabled = NO;
}

- (void)goToNextWord {
    [_game goToNextWord];
    [self showAWord];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self tryWord];
    return NO;
}

@end