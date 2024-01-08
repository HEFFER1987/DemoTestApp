//
//  CatApiService.h
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/6/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CatApiService : NSObject

+ (id)sharedService;

-(void) getCatBreedsCompletionHandler:(void (^)(NSError *error, NSArray *array))completionHandler;
-(NSURLSessionDataTask *) getCatBreedImageLinkById:(NSString*) iD full:(BOOL) isFull completionHandler:(void (^)(NSError *error, NSString* link, NSString* catBreadId)) completionHandler;
- (NSURLSessionTask *)fetchImageWithURLString:(NSString *)urlString completionHandler:(void (^)(UIImage *image, NSError *error))completionHandler;

@end

NS_ASSUME_NONNULL_END
