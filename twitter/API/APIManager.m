//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

// APIs
#import "APIManager.h"

// ViewModels
#import "TweetViewModel.h"

static NSString * const baseURLString = @"https://api.twitter.com";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    
    // API Keys from our new Keys.plist file
    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];;
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];;
    NSString *key = [dict objectForKey:@"consumer_Key"];
    NSString *secret = [dict objectForKey:@"consumer_Secret"];
    
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];

    return self;
}

- (void)getHomeTimelineWith:(int)count TweetsAndCompletion:(void(^)(NSArray *tweetVMs, NSError *error))completion {
    NSDictionary *parameter = @{@"tweet_mode": @"extended", @"count":[NSString stringWithFormat:@"%d", count]};
    [self GET:@"1.1/statuses/home_timeline.json"
       parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
           // Success
           NSArray *tweetVMs = [TweetViewModel tweetViewsWithArray:tweetDictionaries];
           completion(tweetVMs, nil);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           // There was a problem
           completion(nil, error);
    }];
}

// Post Composed Tweet Method
- (void)postStatusWithText:(NSString *)text completion:(void (^)(TweetViewModel *, NSError *))completion {
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text, @"tweet_mode": @"extended"};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        TweetViewModel *tweetVM = [[TweetViewModel alloc] initWithDict:tweetDictionary];
        completion(tweetVM, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

// Favorite/Like (or Unfavorite/Unlike) Tweet Method
- (void)favorite:(TweetViewModel *)tweetVM completion:(void (^)(TweetViewModel *, NSError *))completion {
    NSString *favoriteOrDestroy = @"destroy";
    if (tweetVM.tweet.favorited)
        favoriteOrDestroy = @"create";
    
    NSString *urlString = [NSString stringWithFormat:@"1.1/favorites/%@.json", favoriteOrDestroy];
    NSDictionary *parameters = @{@"id": tweetVM.tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        TweetViewModel *tweetVM = [[TweetViewModel alloc] initWithDict:tweetDictionary];
        completion(tweetVM, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

// Retweet (or Unretweet) Tweet Method
- (void)retweet:(TweetViewModel *)tweetVM completion:(void (^)(TweetViewModel *, NSError *))completion {
    NSString *retweetOrUnretweet = @"unretweet";
    if (tweetVM.tweet.retweeted)
        retweetOrUnretweet = @"retweet";
    
    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/%@/%@.json", retweetOrUnretweet, tweetVM.tweet.idStr];
    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        TweetViewModel *tweetVM = [[TweetViewModel alloc] initWithDict:tweetDictionary];
        completion(tweetVM, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
