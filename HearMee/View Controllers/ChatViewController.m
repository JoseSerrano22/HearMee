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
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UITextField *chatWithField;
@property (weak, nonatomic) IBOutlet UIButton *chatWithButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) NSMutableArray* messageArray;
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

- (void)_fetchMessages {
    PFQuery *const postQuery = [ChatMessage query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
