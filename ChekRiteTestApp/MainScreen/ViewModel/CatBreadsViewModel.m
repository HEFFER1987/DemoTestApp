//
//  CatBreadsViewModel.m
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/6/24.
//

#import "CatBreadsViewModel.h"
#import "CatBreed.h"
#import "CatApiService.h"
#import <UIKit/UIKey.h>

@interface CatBreadsViewModel ()

@property (nonatomic, retain) NSArray<CatBreed *> *catBreeds;
@property (nonatomic, retain) NSError* error;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation CatBreadsViewModel

-(void) setCatBreeds:(NSArray<CatBreed *> *)catBreeds {
    _catBreeds = catBreeds;
    _error = nil;
    _isLoading = NO;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.delegate didChangedState: LoadedState];
    });
}

-(void) setError:(NSError *)error {
    _catBreeds = nil;
    _error = error;
    _isLoading = NO;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.delegate didChangedState: ErrorOccuredState];
    });
}

-(void) setIsLoading:(BOOL)isLoading {
    _catBreeds = nil;
    _error = nil;
    _isLoading = isLoading;
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self.delegate didChangedState: LoadingState];
    });
}

-(State) state {
    if (_isLoading) {
        return LoadingState;
    } else {
        if (_error) {
            return ErrorOccuredState;
        } else {
            return LoadedState;
        }
    }
}

-(void) load {
    self.isLoading = YES;
    __weak CatBreadsViewModel* weakSelf = self;
    [[CatApiService sharedService] getCatBreedsCompletionHandler:^(NSError * _Nonnull error, NSArray * _Nonnull array) {
        if (error) {
            weakSelf.error = error;
        } else {
            weakSelf.catBreeds = array;
        }
    }];
}

-(void) selectByIndex:(NSInteger) index {
    if (index < _catBreeds.count) {
        [_delegate didSelect: [_catBreeds objectAtIndex:index]];
    }
}

-(NSInteger) count {
    return _catBreeds.count;
}

-(NSString *) nameByIndex:(NSInteger) index {
    if (index < _catBreeds.count) {
        return [_catBreeds objectAtIndex:index].name;
    } else {
        return @"";
    }
}

-(NSString *) catBreadIdByIndex: (NSInteger) index {
    if (index < _catBreeds.count) {
        return [_catBreeds objectAtIndex:index].iD;
    } else {
        return @"";
    }
}

-(NSError *) getError {
    return _error;
}

// MARK: Errors

-(NSError* ) noIdError {
    NSString *desc = NSLocalizedString(@"Cat breed didn't contain id", @"");
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:-201 userInfo:userInfo];
}

-(NSError *) indexOutOfRange {
    NSString *desc = NSLocalizedString(@"Index out of range", @"");
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:-202 userInfo:userInfo];
}

@end
