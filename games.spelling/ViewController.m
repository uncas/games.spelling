//
//  ViewController.m
//  games.spelling
//
//  Created by Soerensen, Ole Lynge on 22/12/2016.
//  Copyright (c) 2016 Uncas. All rights reserved.
//

#import "ViewController.h"
#import "SpellingGame.h"
#import "WordService.h"
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
    WordService *wordService = [[WordService alloc] init];
    [wordService FetchWords:^(NSMutableArray<Word *> *result) {
        _game = [[SpellingGame alloc] init];
        [_game loadWords:result];
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
        switch (_game.getTries) {
            case 1:
                self.statusLabel.text = @"Forkert! Prøv igen!";
                break;
            case 2:
                self.statusLabel.text = [NSString stringWithFormat:
                        @"Forkert! Prøv '%@'", _game.getPattern];
                break;
            default:
                self.statusLabel.text = [NSString stringWithFormat:
                        @"Forkert! Prøv '%@'", _game.getWord];
                break;
        }

        [self playSound];
        return;
    }

    NSString *pointsText = [NSString stringWithFormat:
            @"Points: %i (%i %%)", _game.getPoints, _game.getWeightedPoints];
    self.statusLabel.text = @"Rigtigt!";
    self.pointsLabel.text = pointsText;
    _buttonGoesToNextWord = YES;
    self.textView.enabled = NO;
}

- (void)goToNextWord {
    BOOL moreWords = [_game goToNextWord];
    if (moreWords)
        [self showAWord];
    else {
        self.statusLabel.text = @"Færdig";
        self.nextButton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self tryWord];
    return NO;
}

@end