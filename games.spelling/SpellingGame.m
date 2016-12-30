//
// Created by Soerensen, Ole Lynge on 27/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import "SpellingGame.h"
#import "Word.h"


@implementation SpellingGame {
    NSMutableArray<Word *> *_words;
    Word *_word;
    NSData *_imageData;
    NSData *_soundData;
    Word *_nextWord;
    NSData *_nextImageData;
    NSData *_nextSoundData;
    int _points;
    int _tries;
    int _possiblePoints;
    NSString *_wordAttempt;
}

- (void)loadWords:(NSMutableArray<Word *> *)words {
    _words = [[NSMutableArray<Word *> alloc] initWithArray:words];
    _points = 0;
    _tries = 0;
    _possiblePoints = 0;
    [self goToNextWord];
}

- (BOOL)tryWord:(NSString *)input {
    _tries++;
    NSString *expected = _word.word;
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

    if (_nextWord) {
        _word = _nextWord;
        _nextWord = nil;
    } else {
        NSUInteger wordIndex = arc4random() % [_words count];
        _word = _words[wordIndex];
    }

    if ([_words count] > 1) {
        NSMutableArray *dummy = [[NSMutableArray alloc] initWithArray:_words];
        [dummy removeObject:_word];
        NSUInteger nextWordIndex = arc4random() % [dummy count];
        _nextWord = dummy[nextWordIndex];
    }

    return YES;
}

- (NSString *)getPattern {
    NSString *output = @"";
    for (int i = 0; i < _word.word.length; ++i) {
        unichar expectedCharacter = [_word.word characterAtIndex:i];
        if (_wordAttempt.length <= i) {
            output = [NSString stringWithFormat:@"%@*", output];
            continue;
        }

        unichar attemptedCharacter = [_wordAttempt characterAtIndex:i];
        if (attemptedCharacter == expectedCharacter)
            output = [NSString stringWithFormat:@"%@%c", output, expectedCharacter];
        else
            output = [NSString stringWithFormat:@"%@*", output];
    }

    return output;
}

- (NSString *)getWord {
    return _word.word;
}

- (NSData *)getCurrentImageData {
    return [self getDataFromUrlString:_word.imageUrl];
}

- (NSData *)getCurrentSoundData {
    return [self getDataFromUrlString:_word.soundUrl];
}

- (NSData *)getDataFromUrlString:(NSString *)urlString {
    if (!urlString)
        return nil;

    NSURL *url = [NSURL URLWithString:urlString];
    return [[NSData alloc] initWithContentsOfURL:url];
}

@end