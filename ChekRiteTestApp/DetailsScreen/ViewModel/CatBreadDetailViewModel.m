//
//  CatBreadDetailViewModel.m
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/7/24.
//

#import "CatBreadDetailViewModel.h"
#import "CatBreed.h"
#import "CatApiService.h"

@interface CatBreadDetailViewModel ()

@property (nonatomic, retain) CatBreed *catBreed;

@end

@implementation CatBreadDetailViewModel

-(instancetype)initWithCatBreed:(CatBreed *) catBreed {
    if (self = [super init]) {
        self.catBreed = catBreed;
    }
    return self;
}

-(NSString*) name {
    return _catBreed.name;
}

-(NSString*) temperament {
    return _catBreed.temperament;
}

-(NSString*) origin {
    return _catBreed.origin;
}

-(NSString*) descr {
    return _catBreed.descr;
}

-(NSString*) lifespan {
    return _catBreed.life_span;
}

-(NSString*) iD {
    return _catBreed.iD;
}

// MARK: Errors

-(NSError* ) noIdError {
    NSString *desc = NSLocalizedString(@"Cat breed didn't contain id", @"");
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:-201 userInfo:userInfo];
}

@end
