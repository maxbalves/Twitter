//
//  TweetCell.m
//  twitter
//
//  Created by Max Bagatini Alves on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface TweetCell ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *tweetText;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *date;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) IBOutlet UIButton *retweetButton;


@end

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTweet:(Tweet *)tweet {
    // Since we're replacing the default setter, we have to set the underlying private storage _tweet ourselves.
    // _tweet was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.    
    _tweet = tweet;

    self.name.text = self.tweet.user.name;
    self.tweetText.text = self.tweet.text;
    self.username.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.date.text = self.tweet.createdAtString;
    
    // Reply Button Text
    NSString *replyCount = [NSString stringWithFormat:@"%d", self.tweet.replyCount];
    [self.replyButton setTitle:replyCount forState:UIControlStateNormal];
    [self.replyButton setTitle:replyCount forState:UIControlStateSelected];
    [self.replyButton setTitle:replyCount forState:UIControlStateHighlighted];
    
    // Like Button Text
    NSString *likeCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.likeButton setTitle:likeCount forState:UIControlStateNormal];
    [self.likeButton setTitle:likeCount forState:UIControlStateSelected];
    [self.likeButton setTitle:likeCount forState:UIControlStateHighlighted];
    
    // Like Button Image
    UIImage *notLikedImage = [UIImage imageNamed:@"favor-icon.png"];
    UIImage *likedImage = [UIImage imageNamed:@"favor-icon-red.png"];
    if (self.tweet.favorited)
        [self.likeButton setImage:likedImage forState:UIControlStateNormal];
    else
        [self.likeButton setImage:notLikedImage forState:UIControlStateNormal];
    
    // Retweet Button Text
    NSString *retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [self.retweetButton setTitle:retweetCount forState:UIControlStateNormal];
    [self.retweetButton setTitle:retweetCount forState:UIControlStateSelected];
    [self.retweetButton setTitle:retweetCount forState:UIControlStateHighlighted];
    
    // Retweet Button Image
    UIImage *notRetweetedImage = [UIImage imageNamed:@"retweet-icon.png"];
    UIImage *retweetedImage = [UIImage imageNamed:@"retweet-icon-green.png"];
    if (self.tweet.retweeted)
        [self.retweetButton setImage:retweetedImage forState:UIControlStateNormal];
    else
        [self.retweetButton setImage:notRetweetedImage forState:UIControlStateNormal];
    
    // Profile Picture
    self.profilePicture.image = nil;
    if (tweet.user.profilePicture != nil) {
        NSString *URLString = tweet.user.profilePicture;
        NSString *QualityURL = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
        NSURL *url = [NSURL URLWithString:QualityURL];
        [self.profilePicture setImageWithURL:url];
    }
}

- (IBAction)didTapFavorite:(id)sender {
    // Unfavorite
    if (self.tweet.favorited == YES) {
        //Update image
        UIImage *notLikedImage = [UIImage imageNamed:@"favor-icon.png"];
        [self.likeButton setImage:notLikedImage forState:UIControlStateNormal];
        // Update the local tweet model
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        // Update cell UI
        [self setTweet:self.tweet];
        // Send a POST requrest to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet alreadyFavorited:YES completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
             } else {
                 // NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
             }
         }];
    } else { // Favorite
        // Update image
        UIImage *likedImage = [UIImage imageNamed:@"favor-icon-red.png"];
        [self.likeButton setImage:likedImage forState:UIControlStateNormal];
        // Update the local tweet model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        // Update cell UI
        [self setTweet:self.tweet];
        // Send a POST requrest to the POST favorites/create endpoint
        [[APIManager shared] favorite:self.tweet alreadyFavorited:NO completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
             } else {
                 // NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
             }
         }];
    }
}

- (IBAction)didTapRetweet:(id)sender {
    // Unretweet
    if (self.tweet.retweeted == YES) {
        //Update image
        UIImage *notRetweetedImage = [UIImage imageNamed:@"retweet-icon.png"];
        [self.retweetButton setImage:notRetweetedImage forState:UIControlStateNormal];
        // Update the local tweet model
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        // Update cell UI
        [self setTweet:self.tweet];
        // Send a POST requrest to the POST favorites/create endpoint
        [[APIManager shared] retweet:self.tweet alreadyRetweeted:YES completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
             } else {
                 // NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
             }
         }];
    } else { // Retweet
        // Update image
        UIImage *retweetedImage = [UIImage imageNamed:@"retweet-icon-green.png"];
        [self.retweetButton setImage:retweetedImage forState:UIControlStateNormal];
        // Update the local tweet model
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        // Update cell UI
        [self setTweet:self.tweet];
        // Send a POST requrest to the POST favorites/create endpoint
        [[APIManager shared] retweet:self.tweet alreadyRetweeted:NO completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
             } else {
                 // NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
             }
         }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
