//
//  DetailViewController.m
//  twitter
//
//  Created by Max Bagatini Alves on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

// APIs
#import "APIManager.h"

// View Controllers
#import "ComposeViewController.h"
#import "DetailViewController.h"

// Frameworks
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()

@property (strong, nonatomic) IBOutlet UIButton *wasRetweet;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *text;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *retweetCount;
@property (strong, nonatomic) IBOutlet UILabel *favoriteCount;
@property (strong, nonatomic) IBOutlet UIButton *replyButton;
@property (strong, nonatomic) IBOutlet UIButton *retweetButton;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation DetailViewController

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

- (void)setTweetVM:(TweetViewModel *)tweetVM {
    _tweetVM = tweetVM;
    
    self.name.text = tweetVM.name;
    self.username.text = tweetVM.username;
    self.text.text = tweetVM.tweetText;
    self.date.text = tweetVM.date;
    
    self.retweetCount.text = [tweetVM.retweetCount stringByAppendingFormat:@" RETWEETS"];
    
    self.favoriteCount.text = [tweetVM.favoriteCount stringByAppendingFormat:@" FAVORITES"];
    
    // Profile Picture
    [self.profilePicture setImageWithURL:tweetVM.profilePictureUrl];
    
    self.wasRetweet.hidden = tweetVM.shouldWhoRetweetedHide;
    [self.wasRetweet setTitle:tweetVM.whoRetweeted forState:UIControlStateNormal];
    
    // Like Button Image
    [self.favoriteButton setImage:tweetVM.favoriteButtonImage forState:UIControlStateNormal];
    
    // Retweet Button Image
    [self.retweetButton setImage:tweetVM.retweetButtonImage forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Reply Button Text
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.replyButton setTitle:@"" forState:UIControlStateSelected];
    [self.replyButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Like Button Text
    [self.favoriteButton setTitle:@"" forState:UIControlStateNormal];
    [self.favoriteButton setTitle:@"" forState:UIControlStateSelected];
    [self.favoriteButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Retweet Button Text
    [self.retweetButton setTitle:@"" forState:UIControlStateNormal];
    [self.retweetButton setTitle:@"" forState:UIControlStateSelected];
    [self.retweetButton setTitle:@"" forState:UIControlStateHighlighted];
    
    [self setTweetVM:self.tweetVM];
}

@end
