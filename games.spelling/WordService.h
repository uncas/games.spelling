//
// Created by Soerensen, Ole Lynge on 30/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WordService : NSObject {
    void (^_completionHandler)(NSArray *result);
}

- (void)FetchWords:(void (^)(NSArray *))handler;

@end