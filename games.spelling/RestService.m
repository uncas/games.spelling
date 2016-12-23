//
// Created by Soerensen, Ole Lynge on 23/12/2016.
// Copyright (c) 2016 Uncas. All rights reserved.
//

#import "RestService.h"


@implementation RestService {
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)DownloadJson : (NSString *)urlString : (void(^)(NSDictionary*))handler {
    _completionHandler = [handler copy];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection
            sendAsynchronousRequest:request
                              queue:[NSOperationQueue mainQueue]
                  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
                  {
                      if (0 == data.length || connectionError != nil)
                          return;

                      NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                      _completionHandler(greeting);
                      _completionHandler = nil;
                  }];
}
#pragma clang diagnostic pop

@end