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
    [self checkWhetherWordsAreCached];
    RestService *restService = [[RestService alloc] init];
    NSString *apiUrl = [self getApiUrl];
    [restService DownloadJson:apiUrl :^(NSDictionary *result) {
        [self addWordsToCache:result];
        [self returnResult:result];
    }];
}

- (void)addWordsToCache:(NSDictionary *)result {
    NSString *filePath = [self getCacheFilePath];
    [result writeToFile:filePath atomically:YES];
}

- (void)checkWhetherWordsAreCached {
    NSString *filePath = [self getCacheFilePath];
    BOOL isDirectory = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        NSDictionary *cachedResult = [NSDictionary dictionaryWithContentsOfFile:filePath];
        [self returnResult:cachedResult];
    }
}

- (NSString *)getCacheFilePath {
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [cacheFolder stringByAppendingPathComponent:@"SpellingGame-Words.txt"];
}

- (NSString *)getApiUrl {
    NSString *apiCode = @"l7YSboIW6rgQBaavhoF24p6gvHApLaTt2/OX4urNlWYisINNkqsRtQ==";
    NSString *game = @"spelling";
    return [NSString stringWithFormat:
            @"https://uncas.azurewebsites.net/api/HttpTriggerJS1?code=%@&game=%@", apiCode, game];
}

- (void)returnResult:(NSDictionary *)result {
    if (!_completionHandler)
        return;

    NSMutableArray<Word *> *words = [self parseWords:result];
    _completionHandler(words);
    _completionHandler = nil;
}

- (NSMutableArray<Word *> *)parseWords:(NSDictionary *)result {
    NSArray *words = result[@"words"];
    NSMutableArray<Word *> *wordObjects = [[NSMutableArray<Word *> alloc] init];
    for (NSDictionary *word in words) {
        Word *wordObject = [[Word alloc] init];
        wordObject.word = word[@"word"];
        wordObject.imageUrl = word[@"imageUrl"];
        wordObject.soundUrl = word[@"soundUrl"];
        [wordObjects addObject:wordObject];
    }

    return wordObjects;
}

@end