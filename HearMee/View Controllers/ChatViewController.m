//
//  ChatViewController.m
//  HearMee
//
//  Created by jose1009 on 7/15/21.
//

#import "ChatViewController.h"
#import "APIManager.h"
#import "ChatCell.h"
#import "Parse/Parse.h"
#import "Post.h"

@interface ChatViewController () < UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *const tableView;
@property (weak, nonatomic) IBOutlet UITextField *const messageField;
@property (weak, nonatomic) IBOutlet UIButton *const sendButton;
@property (nonatomic, strong) UIRefreshControl *const refreshControl;
@property (strong, nonatomic) NSMutableArray *const messageArray;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.messageField.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    currently disable becuase of to many request, in official demo activating again this code
    //    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_fetchMessages) userInfo:nil repeats:true];
    
    [self _fetchMessages];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(_fetchMessages) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

#pragma mark - Private

- (void)_fetchMessages {
    [[APIManager shared] fetchAllMessage:^(NSArray * _Nonnull messages, NSError * _Nonnull error) {
        if(messages){
            self.messageArray = (NSMutableArray *) messages;
            [self.tableView reloadData];
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    } withChannel:self.channel];
}

- (IBAction)_backDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_sendDidTap:(id)sender {
    [ChatMessage postMessage:self.messageField.text withChannelID:self.channel withCompletion:nil];
    self.messageField.text = @"";
}

-(void)_dismissKeyboard {
    [self.messageField resignFirstResponder];
}

#pragma mark - UICollectionViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *const cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    ChatMessage *const message = self.messageArray[indexPath.row];
    cell.message = message;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
