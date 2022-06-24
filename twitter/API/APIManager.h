//
//  APIManager.h
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

// Session Manager (Not Sure of Category)
#import "BDBOAuth1SessionManager.h"
#import "BDBOAuth1SessionManager+SFAuthenticationSession.h"

// ViewModels
#import "TweetViewModel.h"

@interface APIManager : BDBOAuth1SessionManager

+ (instancetype)shared;

- (void)getHomeTimelineWith:(int)count TweetsAndCompletion:(void(^)(NSArray *tweetVMs, NSError *error))completion;

- (void)postStatusWithText:(NSString *)text completion:(void (^)(TweetViewModel *, NSError *))completion;

- (void)favorite:(TweetViewModel *)tweetVM completion:(void (^)(TweetViewModel *, NSError *))completion;

- (void)retweet:(TweetViewModel *)tweetVM completion:(void (^)(TweetViewModel *, NSError *))completion;


@end
