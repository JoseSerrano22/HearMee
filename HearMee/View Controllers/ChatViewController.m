//
//  ChatViewController.m
//  HearMee
//
//  Created by jose1009 on 7/15/21.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import "Parse/Parse.h"
#import "Post.h"

@interface ChatViewController () < UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *const tableview;
@property (weak, nonatomic) IBOutlet UITextField *const messageField;
@property (weak, nonatomic) IBOutlet UITextField *const chatWithField;
@property (weak, nonatomic) IBOutlet UIButton *const chatWithButton;
@property (weak, nonatomic) IBOutlet UIButton *const sendButton;
@property (strong, nonatomic) NSMutableArray* const messageArray;
@property (nonatomic, assign) BOOL chatWith;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatWith = FALSE;
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.messageField.delegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_fetchMessages) userInfo:nil repeats:true];
    [self _fetchMessages];
}

#pragma mark - Private

- (void)_fetchMessages {
    PFQuery *const postQuery = [ChatMessage query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<ChatMessage *> * _Nullable messages, NSError * _Nullable error) {
        if (messages) {
            self.messageArray = (NSMutableArray *) messages;
            [self.tableview reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)_sendDidTap:(id)sender {
    [ChatMessage postMessage:self.messageField.text withCompletion:nil];
    self.messageField.text = @"";
}

- (IBAction)_chatWithDidTap:(id)sender {
}


-(void)_dismissKeyboard {
    [self.messageField resignFirstResponder];
}

#pragma mark - UICollectionViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ChatCell *const cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    ChatMessage *const message = self.messageArray[indexPath.row];
    cell.message = message;
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
