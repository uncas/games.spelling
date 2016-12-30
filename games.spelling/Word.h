//
// Created by Soerensen, Ole Lynge on 30/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Word : NSObject

@property (nonatomic, copy, readwrite) NSString *word;
@property (nonatomic, copy, readwrite) NSString *imageUrl;
@property (nonatomic, copy, readwrite) NSString *soundUrl;

@end