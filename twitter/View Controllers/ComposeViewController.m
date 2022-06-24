//
//  ComposeViewController.m
//  twitter
//
//  Created by Max Bagatini Alves on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

// APIs
#import "APIManager.h"

// ViewControllers
#import "ComposeViewController.h"


@interface ComposeViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UILabel *characterCountLabel;

@property (nonatomic) long unsigned TWEET_SIZE_MAX;

@end

@implementation ComposeViewController

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.text.text stringByReplacingCharactersInRange:range withString:text];
    
    self.characterCountLabel.text = [NSString stringWithFormat:@"%lu characters left", (self.TWEET_SIZE_MAX - newText.length)];
    
    // Should the new text should be allowed? True/False
    return newText.length < self.TWEET_SIZE_MAX;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.TWEET_SIZE_MAX = 280;
    self.characterCountLabel.text = [NSString stringWithFormat:@"%lu characters left", self.TWEET_SIZE_MAX];
    
    self.text.delegate = self;

    // Remove any text from  close button
    [self.closeButton setTitle:@"" forState:UIControlStateNormal];
    [self.closeButton setTitle:@"" forState:UIControlStateSelected];
    [self.closeButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Setting up the border of our UITextView
    self.text.layer.borderWidth = 0.5;
    self.text.layer.borderColor = [[UIColor grayColor] CGColor];
    self.text.layer.cornerRadius = 5.0;
}

- (IBAction)clickedClose:(id)sender {
    // Close tweet view
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)clickedTweet:(id)sender {
    [[APIManager new] postStatusWithText:self.text.text completion:^(TweetViewModel *tweetVM, NSError *error) {
        if (error) {
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        } else {
            [self.delegate didTweet:tweetVM];
            [self clickedClose:self.closeButton];
        }
    }];
}

@end
