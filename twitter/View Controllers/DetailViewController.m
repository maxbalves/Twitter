//
//  DetailViewController.m
//  twitter
//
//  Created by Max Bagatini Alves on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailViewController.h"
#import "APIManager.h"
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
    // Unretweet
    if (self.tweet.retweeted == YES) {
        //Update image
        UIImage *notRetweetedImage = [UIImage imageNamed:@"retweet-icon.png"];
        [self.retweetButton setImage:notRetweetedImage forState:UIControlStateNormal];
        // Update the local tweet model
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        // Update cell UI
        NSString *retwCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        self.retweetCount.text = [retwCount stringByAppendingFormat:@" RETWEETS"];
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
        NSString *retwCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        self.retweetCount.text = [retwCount stringByAppendingFormat:@" RETWEETS"];
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
- (IBAction)didTapFavorite:(id)sender {
    // Unfavorite
    if (self.tweet.favorited == YES) {
        //Update image
        UIImage *notLikedImage = [UIImage imageNamed:@"favor-icon.png"];
        [self.favoriteButton setImage:notLikedImage forState:UIControlStateNormal];
        // Update the local tweet model
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        // Update cell UI
        NSString *favCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        self.favoriteCount.text = [favCount stringByAppendingFormat:@" FAVORITES"];
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
        [self.favoriteButton setImage:likedImage forState:UIControlStateNormal];
        // Update the local tweet model
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        // Update cell UI
        NSString *favCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        self.favoriteCount.text = [favCount stringByAppendingFormat:@" FAVORITES"];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.name.text = self.tweet.user.name;
    self.username.text = [NSString stringWithFormat:@"@%@", self.tweet.user.screenName];
    self.text.text = self.tweet.text;
    self.date.text = self.tweet.createdAtString;
    
    NSString *retwCount = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.retweetCount.text = [retwCount stringByAppendingFormat:@" RETWEETS"];
    
    NSString *favCount = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.favoriteCount.text = [favCount stringByAppendingFormat:@" FAVORITES"];
    
    // Profile Picture
    self.profilePicture.image = nil;
    if (self.tweet.user.profilePicture != nil) {
        NSString *URLString = self.tweet.user.profilePicture;
        NSString *QualityURL = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
        NSURL *url = [NSURL URLWithString:QualityURL];
        [self.profilePicture setImageWithURL:url];
    }
    
    if (self.tweet.retweetedByUser) {
        NSString *retweetedBy = self.tweet.retweetedByUser.name;
        retweetedBy = [retweetedBy stringByAppendingFormat:@" retweeted"];
        self.wasRetweet.hidden = NO;
        [self.wasRetweet setTitle:retweetedBy forState:UIControlStateNormal];
    } else {
        self.wasRetweet.hidden = YES;
    }
    
    // Reply Button Text
    // Reply Count is not able to be retrieved by the API
    // NSString *replyCount = [NSString stringWithFormat:@"%d", self.tweet.replyCount];
    [self.replyButton setTitle:@"" forState:UIControlStateNormal];
    [self.replyButton setTitle:@"" forState:UIControlStateSelected];
    [self.replyButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Like Button Text
    [self.favoriteButton setTitle:@"" forState:UIControlStateNormal];
    [self.favoriteButton setTitle:@"" forState:UIControlStateSelected];
    [self.favoriteButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Like Button Image
    UIImage *notLikedImage = [UIImage imageNamed:@"favor-icon.png"];
    UIImage *likedImage = [UIImage imageNamed:@"favor-icon-red.png"];
    if (self.tweet.favorited)
        [self.favoriteButton setImage:likedImage forState:UIControlStateNormal];
    else
        [self.favoriteButton setImage:notLikedImage forState:UIControlStateNormal];
    
    // Retweet Button Text
    [self.retweetButton setTitle:@"" forState:UIControlStateNormal];
    [self.retweetButton setTitle:@"" forState:UIControlStateSelected];
    [self.retweetButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Retweet Button Image
    UIImage *notRetweetedImage = [UIImage imageNamed:@"retweet-icon.png"];
    UIImage *retweetedImage = [UIImage imageNamed:@"retweet-icon-green.png"];
    if (self.tweet.retweeted)
        [self.retweetButton setImage:retweetedImage forState:UIControlStateNormal];
    else
        [self.retweetButton setImage:notRetweetedImage forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
