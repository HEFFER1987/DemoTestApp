//
//  CatBreed.h
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CatBreed : NSObject

@property (nonatomic, retain) NSString *iD;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *temperament;
@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *descr;
@property (nonatomic, retain) NSString *life_span;
@property (nonatomic, retain) NSString *reference_image_id;

- (id) initWithDict:(NSDictionary *) dict;

@end

NS_ASSUME_NONNULL_END
