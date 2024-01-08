//
//  CatBreedsListTableViewCell.h
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/7/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CatBreedListImageView;

@interface CatBreedsListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CatBreedListImageView *catBreedListImageView;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;

@end

NS_ASSUME_NONNULL_END
