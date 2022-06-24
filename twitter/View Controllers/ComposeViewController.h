//
//  ComposeViewController.h
//  twitter
//
//  Created by Max Bagatini Alves on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

// ViewModels
#import "TweetViewModel.h"

// Frameworks
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ComposeViewControllerDelegate

- (void)didTweet:(TweetViewModel *)tweet;

@end

@interface ComposeViewController : UIViewController

@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
