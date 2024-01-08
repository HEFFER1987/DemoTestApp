//
//  CatBreedListImageView.h
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CatBreedListImageView : UIView

-(void) loadByCatBreedId:(NSString *) iD full:(BOOL) full;

@end

NS_ASSUME_NONNULL_END
