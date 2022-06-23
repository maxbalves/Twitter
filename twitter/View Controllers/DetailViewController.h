//
//  DetailViewController.h
//  twitter
//
//  Created by Max Bagatini Alves on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
