//
// Created by Soerensen, Ole Lynge on 27/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SpellingGame : NSObject
- (void)loadWords:(NSArray *)words;

- (NSString *)getCurrentImageUrl;

- (NSString *)getCurrentSoundUrl;

- (BOOL)tryWord:(NSString *)input;

- (int)getPoints;

- (id)goToNextWord;
@end