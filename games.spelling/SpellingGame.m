//
// Created by Soerensen, Ole Lynge on 27/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import "SpellingGame.h"


@implementation SpellingGame {
    NSMutableArray *_words;
    NSDictionary *_word;
    int _points;
    int _tries;
    int _possiblePoints;
    NSString *_wordString;
    NSString *_wordAttempt;
}

- (void)loadWords:(NSArray *)words {
    _words = [[NSMutableArray alloc] initWithArray:words];
    _points = 0;
    _tries = 0;
    _possiblePoints = 0;
    [self goToNextWord];
}

- (NSString *)getCurrentImageUrl {
    return _word[@"imageUrl"];
}

- (NSString *)getCurrentSoundUrl {
    return _word[@"soundUrl"];
}

- (BOOL)tryWord:(NSString *)input {
    _tries++;
    NSString *expected = _wordString;
    BOOL isCorrect = [input isEqualToString:expected];
    _wordAttempt = input;
    if (isCorrect && _tries == 1) {
        _points += [expected length];
    }

    if (isCorrect) {
        _tries = 0;
        _possiblePoints += [expected length];
        [_words removeObject:_word];
    }

    return isCorrect;
}

- (int)getPoints {
    return _points;
}

- (int)getTries {
    return _tries;
}

- (int)getWeightedPoints {
    return (100.0 * _points) / (1.0 * _possiblePoints);
}

- (BOOL)goToNextWord {
    if ([_words count] == 0)
        return NO;

    NSUInteger nextIndex = arc4random() % [_words count];
    _word = _words[nextIndex];
    _wordString = _word[@"word"];
    return YES;
}

- (NSString *)getPattern {
    NSString *output = @"";
    for (int i = 0; i < _wordString.length; ++i) {
        output = [NSString stringWithFormat:@"%@*", output];
    }

    return output;
}

- (NSString *)getWord {
    return _wordString;
}
@end