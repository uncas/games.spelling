//
// Created by Soerensen, Ole Lynge on 30/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Word;


@interface WordService : NSObject {
    void (^_completionHandler)(NSMutableArray<Word *> *result);
}

- (void)FetchWords:(void (^)(NSMutableArray<Word *> *))handler;

@end