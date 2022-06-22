//
//  ComposeViewController.m
//  twitter
//
//  Created by Max Bagatini Alves on 6/21/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"


@interface ComposeViewController ()
@property (strong, nonatomic) IBOutlet UITextView *text;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
            NSLog(@"Compose Tweet Success!");
            [self.delegate didTweet:tweet];
            [self clickedClose:self.closeButton];
        }
    }];
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
