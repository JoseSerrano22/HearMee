//
//  PodcastSearchViewController.m
//  HearMee
//
//  Created by jose1009 on 7/28/21.
//

#import "PodcastSearchViewController.h"
#import "APIManager.h"
#import "PodcastSearchCell.h"

@interface PodcastSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *podcasts;

@property BOOL isSearching;

@end

@implementation PodcastSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    [self _fetchPodcasts];
}

- (void)_fetchPodcasts {
    APIManager *manager = [APIManager shared];
    
    NSString *searchText = self.searchBar.text;
    [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    [searchText lowercaseString];
    
    [manager getPodcastwithCompletion:^(NSArray * _Nonnull podcasts, NSError * _Nonnull error) {
        
        if(podcasts){
            self.podcasts = (NSMutableArray *) podcasts;
            [self.tableView reloadData];
        } else{
            NSLog(@"%@", [error localizedDescription]);
        }
        
    } withNamePodcast:searchText];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PodcastSearchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PodcastSearchCell"];
    cell.podcast = self.podcasts[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.podcasts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PodcastSearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:cell.trackViewUrl options:@{} completionHandler:nil];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if([searchText length] != 0) {
        self.isSearching = YES;
        [self _fetchPodcasts];
    }
    else {
        self.isSearching = NO;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self _fetchPodcasts];
}

@end
