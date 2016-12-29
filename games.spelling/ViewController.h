//
//  ViewController.h
//  games.spelling
//
//  Created by Soerensen, Ole Lynge on 22/12/2016.
//  Copyright (c) 2016 Uncas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestService.h"


@interface ViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(weak, nonatomic) IBOutlet UIButton *nextButton;
@property(weak, nonatomic) IBOutlet UITextField *textView;
@property(weak, nonatomic) IBOutlet UILabel *statusLabel;
@property(weak, nonatomic) IBOutlet UILabel *pointsLabel;

- (IBAction)nextTapped:(UIButton *)sender;

@end
