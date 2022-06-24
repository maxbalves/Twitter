//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

// APIs
#import "APIManager.h"
#import "AppDelegate.h"

// ViewControllers
#import "ComposeViewController.h"
#import "DetailViewController.h"
#import "LoginViewController.h"
#import "TimelineViewController.h"

// Views
#import "TweetCell.h"

// ViewModels
#import "TweetViewModel.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayOfTweetVMs;
@property (strong, nonatomic) IBOutlet UIButton *tweetButton;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) int MAX_TWEETS_SHOWN;

@end

@implementation TimelineViewController

- (void) didTweet:(TweetViewModel *)tweetVM {
    [self.arrayOfTweetVMs insertObject:tweetVM atIndex:0];
    [self.tableView reloadData];
}

- (void) getTimeline:(UIRefreshControl *)refreshControl {
    [refreshControl beginRefreshing];
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWith:self.MAX_TWEETS_SHOWN TweetsAndCompletion:^(NSArray *tweetVMs, NSError *error) {
        if (tweetVMs) {
            self.arrayOfTweetVMs = (NSMutableArray *)tweetVMs;
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.MAX_TWEETS_SHOWN = 20;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Remove text from tweet button
    [self.tweetButton setTitle:@"" forState:UIControlStateNormal];
    [self.tweetButton setTitle:@"" forState:UIControlStateSelected];
    [self.tweetButton setTitle:@"" forState:UIControlStateHighlighted];
    
    self.refreshControl = [UIRefreshControl new];
            
    [self.refreshControl addTarget:self action:@selector(getTimeline:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self getTimeline:self.refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (TweetCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweetVM = self.arrayOfTweetVMs[indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweetVMs.count >= self.MAX_TWEETS_SHOWN ? self.MAX_TWEETS_SHOWN : self.arrayOfTweetVMs.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Prevents cell from having gray background due to being selected
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row + 1 == self.arrayOfTweetVMs.count && self.MAX_TWEETS_SHOWN < 200) {
        self.MAX_TWEETS_SHOWN *= 2;
        
        if (self.MAX_TWEETS_SHOWN > 200)
            self.MAX_TWEETS_SHOWN = 200;
        
        [self getTimeline:self.refreshControl];
    }
}

// Navigation Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ComposeSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if ([segue.identifier isEqualToString:@"DetailSegue"]) {
        DetailViewController *detailController = [segue destinationViewController];
        detailController.tweetVM = self.arrayOfTweetVMs[[self.tableView indexPathForCell:sender].row];
    }
}

@end
