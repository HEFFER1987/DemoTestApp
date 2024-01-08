//
//  CatApiService.m
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/6/24.
//

#import "CatApiService.h"
#import "CatBreed.h"
#import <UIKit/UIKit.h>

@interface CatApiService ()

@property (nonatomic, strong) NSCache<NSString* , NSString *> *imageLinkCache;;
@property (nonatomic, strong) NSCache<NSString *, UIImage *> *imageCache;

@end

@implementation CatApiService

+ (id)sharedService {
    static CatApiService *catApiService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        catApiService = [[self alloc] init];
    });
    return catApiService;
}

-(instancetype)init {
    if (self = [super init]) {
        self.imageCache = [[NSCache alloc] init];
        self.imageLinkCache = [[NSCache alloc] init];
    }
    return self;
}

-(void) getCatBreedsCompletionHandler:(void (^)(NSError *error, NSArray *array))completionHandler {
    NSURL * url = [NSURL URLWithString:@"https://api.thecatapi.com/v1/breeds"];
    if (!url) {
        NSError *error = [self invalidUrlError];
        completionHandler(error, nil);
        return;
    }
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completionHandler(error, nil);
            return;
        }
        
        NSError *serializationError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
        
        if(serializationError) {
            completionHandler(serializationError, nil);
        }
        
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            NSArray *jsonArray = (NSArray *)jsonObject;
            NSMutableArray * catBreedsArray = [NSMutableArray array];
            for(NSDictionary *dictionary in jsonArray) {
                [catBreedsArray addObject:[[CatBreed alloc] initWithDict:dictionary]];
            }
            completionHandler(nil, catBreedsArray);
        } else {
            NSError *unexpectedError = [self unexpectedSerializationError];
            completionHandler(unexpectedError, nil);
        }
    }] resume];
}

-(NSURLSessionDataTask *) getCatBreedImageLinkById:(NSString*) iD full:(BOOL) isFull completionHandler:(void (^)(NSError *error, NSString* link, NSString* catBreadId)) completionHandler {
    
    if (!iD) {
        NSError *error = [self idIsNilError];
        completionHandler(error, nil, nil);
        return nil;
    }
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"https://api.thecatapi.com/v1/images/search?breed_ids=%@", iD];
    if (isFull) {
        [urlString appendString:@"&size=full"];
    } else {
        [urlString appendString:@"&size=thumb"];
    }
    
    NSString * cachedLink = [self.imageLinkCache objectForKey:urlString];
    if (cachedLink) {
        completionHandler(nil, cachedLink, iD);
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        NSError *error = [self invalidUrlError];
        completionHandler(error, nil, nil);
        return nil;
    }
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completionHandler(error, nil, nil);
            return;
        }
        
        NSError *serializationError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&serializationError];
        
        if(serializationError) {
            completionHandler(serializationError, nil, nil);
            return;
        }
        
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            NSArray *jsonArray = (NSArray *)jsonObject;
            NSString* link;
            for(NSDictionary *dictionary in jsonArray) {
                link = dictionary[@"url"];
            }
            if (link) {
                [self.imageLinkCache setObject:link forKey:urlString];
                completionHandler(nil, link, iD);
            } else {
                NSError *error = [self noImageUrlError];
                completionHandler(error, nil, iD);
            }
        } else {
            NSError *unexpectedError = [self unexpectedSerializationError];
            completionHandler(unexpectedError, nil, nil);
        }
    }];
     
    [task resume];
    
    return task;
}

- (NSURLSessionTask *)fetchImageWithURLString:(NSString *)urlString completionHandler:(void (^)(UIImage *image, NSError *error))completionHandler {
    UIImage *cachedImage = [self.imageCache objectForKey:urlString];
    if (cachedImage) {
        completionHandler(cachedImage, nil);
        return nil;
    }

    NSURL *url = [NSURL URLWithString:urlString];
    if (!url) {
        NSError *error = [self invalidUrlError];
        completionHandler(nil, error);
        return nil;
    }

    NSURLSessionTask *task = [NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil, error);
            return;
        }

        if (!data) {
            NSError *error = [self networkError];
            completionHandler(nil, error);
        }

        UIImage *image = [UIImage imageWithData:data];
        if (!image) {
            NSError *error = [self invalidImageError];
            completionHandler(nil, error);
        }

        [self.imageCache setObject:image forKey:urlString];
        completionHandler(image, nil);
    }];

    [task resume];

    return task;
}

// MARK: Errors
-(NSError* )unexpectedSerializationError {
    NSString *desc = NSLocalizedString(@"Unexpected type after serialization", @"");
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:-101 userInfo:userInfo];
}

-(NSError* )invalidUrlError {
    NSString *desc = NSLocalizedString(@"Invalid url", @"");
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:-102 userInfo:userInfo];
}

-(NSError* )networkError {
    NSString *desc = NSLocalizedString(@"Network error", @"");
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:-103 userInfo:userInfo];
}

-(NSError*)invalidImageError {
    NSString *desc = NSLocalizedString(@"Invalid image error", @"");
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:-104 userInfo:userInfo];
}

-(NSError*) noImageUrlError {
    NSString *desc = NSLocalizedString(@"Response didn't contain image url", @"");
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:-105 userInfo:userInfo];
}

-(NSError*) idIsNilError {
    NSString *desc = NSLocalizedString(@"Bread id is nil", @"");
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : desc };
    return [NSError errorWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:-106 userInfo:userInfo];
}

@end
