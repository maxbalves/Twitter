//
//  TweetCell.m
//  twitter
//
//  Created by Max Bagatini Alves on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *tweetText;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *date;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
@property (strong, nonatomic) IBOutlet UIButton *retweetButton;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;


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
    
    // Reply Button
    NSString *replyCount = [NSString stringWithFormat:@"%d", self.tweet.replyCount];
    [self.likeButton setTitle:replyCount forState:UIControlStateNormal];
    [self.likeButton setTitle:replyCount forState:UIControlStateSelected];
    [self.likeButton setTitle:replyCount forState:UIControlStateHighlighted];
    
    // Like Button
    NSString *likeCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [self.likeButton setTitle:likeCount forState:UIControlStateNormal];
    [self.likeButton setTitle:likeCount forState:UIControlStateSelected];
    [self.likeButton setTitle:likeCount forState:UIControlStateHighlighted];
    
    // Retweet Button
    NSString *retweetCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [self.likeButton setTitle:retweetCount forState:UIControlStateNormal];
    [self.likeButton setTitle:retweetCount forState:UIControlStateSelected];
    [self.likeButton setTitle:retweetCount forState:UIControlStateHighlighted];
    
    // Profile Picture
    self.profilePicture.image = nil;
    if (tweet.user.profilePicture != nil) {
        NSString *URLString = tweet.user.profilePicture;
        NSString *QualityURL = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
        NSURL *url = [NSURL URLWithString:QualityURL];
        [self.profilePicture setImageWithURL:url];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
