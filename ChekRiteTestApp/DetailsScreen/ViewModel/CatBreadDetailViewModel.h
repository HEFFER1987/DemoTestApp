//
//  CatBreadDetailViewModel.h
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/7/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CatBreed;

@interface CatBreadDetailViewModel : NSObject

-(instancetype)initWithCatBreed:(CatBreed *) catBreed;

-(NSString*) name;
-(NSString*) temperament;
-(NSString*) origin;
-(NSString*) descr;
-(NSString*) lifespan;
-(NSString*) iD;

@end

NS_ASSUME_NONNULL_END
