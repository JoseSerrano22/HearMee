//
//  ChannelsViewController.m
//  HearMee
//
//  Created by jose1009 on 7/20/21.
//

#import "ChannelsViewController.h"
#import "ChatViewController.h"
#import "APIManager.h"
#import "Channels.h"
#import "ChannelsCell.h"

@interface ChannelsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *const tableView;
@property (nonatomic, strong) UIRefreshControl *const refreshControl;
@property (strong, nonatomic) NSMutableArray *const channelsArray;

@end

@implementation ChannelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self _fetchChannels];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(_fetchChannels) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)_fetchChannels {
    
    [[APIManager shared] fetchAllChannels:^(NSArray * _Nonnull channel, NSError * _Nonnull error) {
        if (channel) {
            self.channelsArray = (NSMutableArray *) channel;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)_createChannelDidTap:(id)sender {
    [self _showInputAlert];
}

-(void)_showInputAlert {
    
    UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"Create Channel" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        {
            textField.placeholder=@"Title";
            textField.clearButtonMode=UITextFieldViewModeWhileEditing;
        }
    }];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder=@"Caption";
        textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    }];
    
    UIAlertAction *const cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:cancelAction];
    
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *title=alertVC.textFields[0].text;
        NSString *caption=alertVC.textFields[1].text;
        
        [Channels postChannelTitle:title withImage:nil withCaption:caption withCompletion:nil];
    }];
    
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:true completion:nil];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChannelsCell *const cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelsCell" forIndexPath:indexPath];
    Channels *const channel = self.channelsArray[indexPath.row];
    cell.channel = channel;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.channelsArray.count;
}

#pragma mark - UITableViewDataDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self performSegueWithIdentifier:@"ChatSegue" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UINavigationController *const nav = [segue destinationViewController];
    ChatViewController *chatVC = (ChatViewController *)[nav topViewController];
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Channels *channelObject = self.channelsArray[indexPath.row];
    chatVC.channel = channelObject;
    
}

@end
