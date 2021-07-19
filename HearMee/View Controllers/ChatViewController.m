//
//  ChatViewController.m
//  HearMee
//
//  Created by jose1009 on 7/15/21.
//

#import "ChatViewController.h"
#import "ChatCell.h"

@interface ChatViewController () < UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (strong, nonatomic) NSMutableArray* messageArray;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.messageField.delegate = self;
    
    self.customtoolbar=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height+50, 320, 50)];
    
    self.messageArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < 10; i++) {
        NSNumber* number = [NSNumber numberWithInt:i]; // <-- autoreleased, so you don't need to release it yourself
        NSString* string = [NSString stringWithFormat:@"%@", number];
        [self.messageArray addObject:string];
    }
}

- (IBAction)_sendDidTap:(id)sender {
    
}


-(void)_dismissKeyboard {
    [self.messageField resignFirstResponder];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    cell.textLabel.text = self.messageArray[indexPath.row];
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
