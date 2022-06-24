//
//  TweetViewModel.m
//  twitter
//
//  Created by Max Bagatini Alves on 6/23/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

// Models
#import "Tweet.h"

// ViewModels
#import "TweetViewModel.h"

// Framework
#import "UIImageView+AFNetworking.h"

@implementation TweetViewModel

- (instancetype) initWithTweet:(Tweet *)tweet {
    self = [super init];
    if (!self)
        return nil; // failure
    
    _tweet = tweet;
    
    if (tweet.retweetedByUser) {
        _whoRetweeted = [NSString stringWithFormat:@"%@ retweeted", tweet.retweetedByUser.name];
        _shouldWhoRetweetedHide = NO;
    } else {
        _whoRetweeted = nil;
        _shouldWhoRetweetedHide = YES;
    }

    // Profile Picture
    NSString *URLString = tweet.user.profilePicture;
    NSString *QualityURL = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    _profilePictureUrl = [NSURL URLWithString:QualityURL];

    // Text
    _name = tweet.user.name;
    _username = [NSString stringWithFormat:@"@%@", tweet.user.screenName];
    _tweetText = tweet.text;
    
    // Date
    _date = tweet.createdAtString;
    _shortDate = tweet.createdAtStringShort;
    
    // Retweet
    _retweetCount = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    _retweetButtonImage = [self getRetweetImageForTweet:tweet];
    
    // Favorite
    _favoriteCount = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    _favoriteButtonImage = [self getFavoriteImageForTweet:tweet];
    
    return self;
}

- (UIImage *)getRetweetImageForTweet:(Tweet *)tweet {
    if (self.tweet.retweeted)
        return [UIImage imageNamed:@"retweet-icon-green.png"];
    else
        return [UIImage imageNamed:@"retweet-icon.png"];
}

- (UIImage *)getFavoriteImageForTweet:(Tweet *)tweet {
    if (self.tweet.favorited)
        return [UIImage imageNamed:@"favor-icon-red.png"];
    else
        return [UIImage imageNamed:@"favor-icon.png"];
}

- (void) favoriteTweet {
    // Increment favorite count & change BOOL favorited
    self.tweet.favorited = !self.tweet.favorited;
    if (self.tweet.favorited) {
        self.tweet.favoriteCount++;
    } else {
        self.tweet.favoriteCount--;
    }
    
    // Updates view model
    self.favoriteCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.favoriteButtonImage = [self getFavoriteImageForTweet:self.tweet];
}

- (void) retweetTweet {
    // Increment retweet count & change BOOL retweeted
    self.tweet.retweeted = !self.tweet.retweeted;
    if (self.tweet.retweeted) {
        self.tweet.retweetCount++;
    } else {
        self.tweet.retweetCount--;
    }
    
    // Updates view model
    self.retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.retweetButtonImage = [self getRetweetImageForTweet:self.tweet];
}

- (instancetype) initWithDict:(NSDictionary *)dictionary {
    Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
    return [self initWithTweet:tweet];
}


+ (NSArray *)tweetViewsWithArray:(NSArray *)dictionaries {
    NSMutableArray *tweets = [Tweet tweetsWithArray:dictionaries];
    NSMutableArray *tweetVMsArray = [[NSMutableArray alloc] init];
    for (Tweet *tweet in tweets) {
        TweetViewModel *tweetVM = [[TweetViewModel alloc] initWithTweet:tweet];
        [tweetVMsArray addObject:tweetVM];
    }
    return tweetVMsArray;
}

@end
