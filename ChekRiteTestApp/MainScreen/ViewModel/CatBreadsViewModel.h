//
//  CatBreadsViewModel.h
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/6/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, State) {
    LoadingState,
    LoadedState,
    ErrorOccuredState
};

@class CatBreed;

@protocol CatBreadsViewModelDelegate <NSObject>
- (void) didChangedState:(State) state;
- (void) didSelect:(CatBreed *) catBreed;
@end

@interface CatBreadsViewModel : NSObject

@property (nonatomic, readonly) State state;
@property (nonatomic, weak) id <CatBreadsViewModelDelegate> delegate;

-(void) load;
-(void) selectByIndex:(NSInteger) index;

-(NSInteger) count;
-(NSString *) nameByIndex:(NSInteger) index;
-(NSString *) catBreadIdByIndex: (NSInteger) index;
-(NSError *) getError;

@end

NS_ASSUME_NONNULL_END
