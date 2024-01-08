//
//  CatBreed.m
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/6/24.
//

#import "CatBreed.h"

@implementation CatBreed

- (id) initWithDict:(NSDictionary *) dict {
    if ( self = [super init] ) {
        _iD = dict[@"id"];
        _name = dict[@"name"];
        _temperament = dict[@"temperament"];
        _origin = dict[@"origin"];
        _descr = dict[@"description"];
        _life_span = dict[@"life_span"];
        _reference_image_id = dict[@"reference_image_id"];
    }
    return self;
}

@end
