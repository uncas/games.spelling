//
// Created by Soerensen, Ole Lynge on 30/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import "WordService.h"
#import "RestService.h"


@implementation WordService {
}

- (void)FetchWords:(void (^)(NSArray *))handler {
    _completionHandler = [handler copy];
    RestService *restService = [[RestService alloc] init];
    NSString *apiCode = @"l7YSboIW6rgQBaavhoF24p6gvHApLaTt2/OX4urNlWYisINNkqsRtQ==";
    NSString *game = @"spelling";
    NSString *urlString = [NSString stringWithFormat:
            @"https://uncas.azurewebsites.net/api/HttpTriggerJS1?code=%@&game=%@", apiCode, game];
    [restService DownloadJson:urlString :^(NSDictionary *result) {
        _completionHandler(result[@"words"]);
        _completionHandler = nil;
    }];
}

@end