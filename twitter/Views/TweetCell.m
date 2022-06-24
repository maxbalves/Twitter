//
//  TweetCell.m
//  twitter
//
//  Created by Max Bagatini Alves on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

// APIs
#import "APIManager.h"

// Views
#import "TweetCell.h"

// Frameworks
#import "UIImageView+AFNetworking.h"

@interface TweetCell ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;

@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UITextView *tweetText;
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

- (void)setTweetVM:(TweetViewModel *)tweetVM {
    // Since we're replacing the default setter, we have to set the underlying private storage _tweetVM ourselves.
    // _tweetVM was an automatically declared variable with the @propery declaration.
    // Do this any time you create a custom setter.
    _tweetVM = tweetVM;

    self.name.text = tweetVM.name;
    self.tweetText.text = tweetVM.tweetText;
    self.username.text = tweetVM.username;
    self.date.text = tweetVM.shortDate;
    
    // Reply Button Text
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.replyButton setTitle:@"" forState:UIControlStateSelected];
    [self.replyButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Like Button Text
    [self.likeButton setTitle:tweetVM.favoriteCount forState:UIControlStateNormal];
    [self.likeButton setTitle:tweetVM.favoriteCount forState:UIControlStateSelected];
    [self.likeButton setTitle:tweetVM.favoriteCount forState:UIControlStateHighlighted];
    
    // Like Button Image
    [self.likeButton setImage:tweetVM.favoriteButtonImage forState:UIControlStateNormal];
    
    // Retweet Button Text
    [self.retweetButton setTitle:tweetVM.retweetCount forState:UIControlStateNormal];
    [self.retweetButton setTitle:tweetVM.retweetCount forState:UIControlStateSelected];
    [self.retweetButton setTitle:tweetVM.retweetCount forState:UIControlStateHighlighted];
    
    // Retweet Button Image
    [self.retweetButton setImage:tweetVM.retweetButtonImage forState:UIControlStateNormal];
    
    // Profile Picture
    [self.profilePicture setImageWithURL:tweetVM.profilePictureUrl];
}

- (IBAction)didTapFavorite:(id)sender {
    [self.tweetVM favoriteTweet];
    [self setTweetVM:self.tweetVM];
    [[APIManager shared] favorite:self.tweetVM completion:^(TweetViewModel *tweetVM, NSError *error) {
        if (error) {
            NSLog(@"Error favoriting/unfavoriting tweet: %@", error.localizedDescription);
         } else {
             // nothing, all good
         }
     }];
}

- (IBAction)didTapRetweet:(id)sender {
    [self.tweetVM retweetTweet];
    [self setTweetVM:self.tweetVM];
    [[APIManager shared] retweet:self.tweetVM completion:^(TweetViewModel *tweetVM, NSError *error) {
        if (error) {
            NSLog(@"Error retweeting/unretweeting tweet: %@", error.localizedDescription);
         } else {
             // nothing, all good
         }
     }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
    [super setSelected:selected animated:animated];
}

@end
