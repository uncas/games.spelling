//
// Created by Soerensen, Ole Lynge on 23/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RestService : NSObject
{
    void (^_completionHandler)(NSDictionary *result);
}

- (void)DownloadJson:(NSString *)urlString :(void (^)(NSDictionary *))handler;
@end