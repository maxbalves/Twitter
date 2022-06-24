//
//  DetailViewController.h
//  twitter
//
//  Created by Max Bagatini Alves on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

// ViewModels
#import "TweetViewModel.h"

// Frameworks
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (nonatomic, strong) TweetViewModel *tweetVM;

- (void)setTweetVM:(TweetViewModel *)tweetVM;


@end

NS_ASSUME_NONNULL_END
