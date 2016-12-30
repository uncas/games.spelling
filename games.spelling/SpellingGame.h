//
// Created by Soerensen, Ole Lynge on 27/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SpellingGame : NSObject

- (void)loadWords:(NSArray *)words;

- (BOOL)tryWord:(NSString *)input;

- (int)getPoints;

- (int)getTries;

- (int)getWeightedPoints;

- (BOOL)goToNextWord;

- (NSString *)getPattern;

- (NSString *)getWord;

- (NSData *)getCurrentImageData;

- (NSData *)getCurrentSoundData;

- (void)preloadNext;
@end