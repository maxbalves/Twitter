//
//  TweetViewModel.h
//  twitter
//
//  Created by Max Bagatini Alves on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

// Frameworks
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Models
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetViewModel : NSObject

- (instancetype) initWithTweet:(Tweet *) tweet;

- (instancetype) initWithDict:(NSDictionary *)dictionary;

- (UIImage *)getRetweetImageForTweet:(Tweet *)tweet;

- (UIImage *)getFavoriteImageForTweet:(Tweet *)tweet;

- (void) favoriteTweet;

- (void) retweetTweet;

+ (NSArray *)tweetViewsWithArray:(NSArray *)tweets;

@property (nonatomic, strong) Tweet *tweet;

// All tweet properties needed
@property (nonatomic, strong) NSString *whoRetweeted;
@property (nonatomic) BOOL shouldWhoRetweetedHide;

@property (nonatomic, strong) NSURL *profilePictureUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *tweetText;
@property (nonatomic, strong) NSString *shortDate;
@property (nonatomic, strong) NSString *date;

@property (nonatomic, strong) UIImage *favoriteButtonImage;
@property (nonatomic, strong) NSString *favoriteCount;
@property (nonatomic, strong) UIImage *retweetButtonImage;
@property (nonatomic, strong) NSString *retweetCount;

@end

NS_ASSUME_NONNULL_END
