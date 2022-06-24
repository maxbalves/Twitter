//
//  ComposeViewController.m
//  twitter
//
//  Created by Max Bagatini Alves on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"


@interface ComposeViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation ComposeViewController

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Set the max character limit
    int characterLimit = 140;

    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.text.text stringByReplacingCharactersInRange:range withString:text];
    
    // Should the new text should be allowed? True/False
    return newText.length < characterLimit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [[APIManager new] postStatusWithText:self.text.text completion:^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        } else {
            [self.delegate didTweet:tweet];
            [self clickedClose:self.closeButton];
        }
    }];
}

@end
