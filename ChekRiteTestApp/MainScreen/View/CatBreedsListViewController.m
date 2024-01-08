//
//  ViewController.m
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/6/24.
//

#import "CatBreedsListViewController.h"
#import "CatBreadsViewModel.h"
#import "CatApiService.h"
#import "CatBreedsListTableViewCell.h"
#import "CatBreadDetailViewController.h"
#import "CatBreadDetailViewModel.h"
#import "CatBreedListImageView.h"

@interface CatBreedsListViewController () <CatBreadsViewModelDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) CatBreadsViewModel *catBreadsViewModel;

// UI
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *errorInfoView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation CatBreedsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.catBreadsViewModel = [[CatBreadsViewModel alloc] init];
    self.catBreadsViewModel.delegate = self;
    [self.catBreadsViewModel load];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:NO];
}

// MARK: - Actions

- (IBAction)reloadBtnPressed:(id)sender {
    [self.catBreadsViewModel load];
}

// MARK: - CatBreadsViewModelDelegate

- (void) didChangedState:(State) state {
    switch (state) {
    case LoadedState:
        _tableView.hidden = NO;
        [_tableView reloadData];
        _errorInfoView.hidden = YES;
        _activityIndicator.hidden = YES;
        [_activityIndicator stopAnimating];
        break;
    case LoadingState:
        _tableView.hidden = YES;
        _errorInfoView.hidden = YES;
        _activityIndicator.hidden = NO;
        [_activityIndicator startAnimating];
        break;
    case ErrorOccuredState:
        _tableView.hidden = YES;
        _errorInfoView.hidden = NO;
        _errorLabel.text = [[_catBreadsViewModel getError] localizedDescription];
        _activityIndicator.hidden = YES;
        [_activityIndicator stopAnimating];
        break;
    }
}

- (void) didSelect:(CatBreed *) catBreed {
    CatBreadDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CatBreadDetailViewController"];
    detailViewController.viewModel = [[CatBreadDetailViewModel alloc] initWithCatBreed:catBreed];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

// MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_catBreadsViewModel count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CatBreedsListTableViewCell *cell = (CatBreedsListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.txtLabel.text = [_catBreadsViewModel nameByIndex:indexPath.row];
    [cell.catBreedListImageView loadByCatBreedId:[_catBreadsViewModel catBreadIdByIndex:indexPath.row] full:NO];
    return cell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_catBreadsViewModel selectByIndex: indexPath.row];
}

@end
