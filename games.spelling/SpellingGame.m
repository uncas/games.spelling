//
// Created by Soerensen, Ole Lynge on 27/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import "SpellingGame.h"


@implementation SpellingGame {
    NSArray *_words;
    int _wordIndex;
    NSDictionary *_word;
    int _points;
    int _tries;
}

- (void)loadWords:(NSArray *)words {
    _words = words;
    _wordIndex = 0;
    _points = 0;
    _tries = 0;
    _word = _words[_wordIndex];
}

- (NSString *)getCurrentImageUrl {
    return _word[@"imageUrl"];
}

- (NSString *)getCurrentSoundUrl {
    return _word[@"soundUrl"];
}

- (BOOL)tryWord:(NSString *)input {
    _tries++;
    NSString *expected = _word[@"word"];
    BOOL isCorrect = [input isEqualToString:expected];
    if (isCorrect && _tries == 1)
        _points += [expected length];

    _tries = 0;
    return isCorrect;
}

- (int)getPoints {
    return _points;
}

- (void)goToNextWord {
    _wordIndex += 1;
    if (_wordIndex >= [_words count]) {
        _wordIndex = 0;
    }

    _word = _words[_wordIndex];
}

@end