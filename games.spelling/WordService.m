//
// Created by Soerensen, Ole Lynge on 30/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import "WordService.h"
#import "RestService.h"
#import "Word.h"


@implementation WordService {
}

- (void)FetchWords:(void (^)(NSMutableArray<Word *> *))handler {
    _completionHandler = [handler copy];
    RestService *restService = [[RestService alloc] init];
    NSString *apiCode = @"l7YSboIW6rgQBaavhoF24p6gvHApLaTt2/OX4urNlWYisINNkqsRtQ==";
    NSString *game = @"spelling";
    NSString *urlString = [NSString stringWithFormat:
            @"https://uncas.azurewebsites.net/api/HttpTriggerJS1?code=%@&game=%@", apiCode, game];
    [restService DownloadJson:urlString :^(NSDictionary *result) {
        NSArray *words = result[@"words"];
        NSMutableArray<Word *> *wordObjects = [[NSMutableArray<Word *> alloc] init];
        for (NSDictionary *word in words) {
            Word *wordObject = [[Word alloc] init];
            wordObject.word = word[@"word"];
            wordObject.imageUrl = word[@"imageUrl"];
            wordObject.soundUrl = word[@"soundUrl"];
            [wordObjects addObject:wordObject];
        }
        _completionHandler(wordObjects);
        _completionHandler = nil;
    }];
}

@end