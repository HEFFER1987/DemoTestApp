//
//  CatBreadDetailViewController.m
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/7/24.
//

#import "CatBreadDetailViewController.h"
#import "CatBreadDetailViewModel.h"
#import "CatBreedListImageView.h"

@interface CatBreadDetailViewController ()

@property (weak, nonatomic) IBOutlet CatBreedListImageView *catBreedListImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageSizeConstraint;

//
@property (weak, nonatomic) IBOutlet UIView *nameLabelBacground;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *temperamentLabelBacground;
@property (weak, nonatomic) IBOutlet UILabel *temperamentLabel;

@property (weak, nonatomic) IBOutlet UIView *originLabelBackground;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;

@property (weak, nonatomic) IBOutlet UIView *descriptionLabelBackground;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *lifespanLabelBackground;
@property (weak, nonatomic) IBOutlet UILabel *lifespanLabel;

@end

@implementation CatBreadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([_viewModel name]) {
        _nameLabel.text = [_viewModel name];
        _nameLabelBacground.hidden = NO;
    }
    
    if ([_viewModel temperament]) {
        _temperamentLabel.text = [_viewModel temperament];
        _temperamentLabelBacground.hidden = NO;
    }
    
    if ([_viewModel origin]) {
        _originLabel.text = [_viewModel origin];
        _originLabelBackground.hidden = NO;
    }
    
    if ([_viewModel origin]) {
        _descriptionLabel.text = [_viewModel descr];
        _descriptionLabel.hidden = NO;
    }
    
    if ([_viewModel origin]) {
        _lifespanLabel.text = [_viewModel lifespan];
        _lifespanLabelBackground.hidden = NO;
    }
    
    [_catBreedListImageView loadByCatBreedId:[_viewModel iD] full:YES];
}

@end
