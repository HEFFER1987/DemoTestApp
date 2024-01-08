//
//  CatBreedListImageView.m
//  ChekRiteTestApp
//
//  Created by Roman Seredenko on 1/8/24.
//

#import "CatBreedListImageView.h"
#import "CatApiService.h"

@interface CatBreedListImageView ()

@property (nonatomic, retain) NSURLSessionDataTask *linkLoadingTask;
@property (nonatomic, retain) NSURLSessionTask *imageLoadingTask;

@property (weak, nonatomic) IBOutlet UILabel *noImageErrorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CatBreedListImageView

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"CatBreedListImageView" owner:self options:nil] objectAtIndex:0];
        xibView.frame = self.bounds;
        xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: xibView];
    }
    return self;
}

-(void) loadByCatBreedId:(NSString *) iD full:(BOOL) full{
    if (_linkLoadingTask) {
        [_linkLoadingTask cancel];
    }
    
    if (_imageLoadingTask) {
        [_imageLoadingTask cancel];
    }
    
    _imageView.hidden = YES;
    _noImageErrorLabel.hidden = YES;
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    __weak typeof(self) weakSelf = self;
    _linkLoadingTask = [[CatApiService sharedService] getCatBreedImageLinkById:iD full:NO completionHandler:^(NSError * _Nonnull error, NSString * _Nonnull link, NSString * _Nonnull catBreadId) {
        weakSelf.imageLoadingTask = [[CatApiService sharedService] fetchImageWithURLString:link completionHandler:^(UIImage * _Nonnull image, NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if ([error.localizedDescription isEqualToString:@"cancelled"]) {
                        return; // do nothing
                    }
                    NSLog(@"error = %@", error.localizedDescription);
                    weakSelf.noImageErrorLabel.hidden = NO;
                    weakSelf.noImageErrorLabel.text = error.localizedDescription;
                } else {
                    weakSelf.imageView.hidden = NO;
                    weakSelf.noImageErrorLabel.hidden = YES;
                    weakSelf.imageView.image = image;
                }
                [weakSelf.activityIndicator stopAnimating];
                weakSelf.activityIndicator.hidden = YES;
            });
        }];
    }];
}

@end
