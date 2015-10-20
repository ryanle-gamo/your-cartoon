//
//  ContentGuideViewRowCarouselViewPosterView.h
//  CartoonCollector
//
//  Created by Binh Le on 5/31/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>

@class ContentGuideViewRowCarouselViewPosterView;

typedef enum {
    ContentGuideViewRowCarouselViewPosterViewStyleDefault,
    ContentGuideViewRowCarouselViewPosterViewStyleTwoTitles,
    ContentGuideViewRowCarouselViewPosterViewStyleNoneTitle
} ContentGuideViewRowCarouselViewPosterViewStyle;

@protocol ContentGuideViewRowCarouselViewPosterViewDataSource <NSObject>
@optional
- (UIImage*) imageCenterButtonForPosterView:(ContentGuideViewRowCarouselViewPosterView*) posterView;
- (UIImage*) imageBackgroundBottomPosterView:(ContentGuideViewRowCarouselViewPosterView*) posterView;
@end

@protocol ContentGuideViewRowCarouselViewPosterViewDelegate <NSObject>
@optional
- (void) didSelectPosterView:(ContentGuideViewRowCarouselViewPosterView*) posterView;
- (void) hightLightedPosterView:(ContentGuideViewRowCarouselViewPosterView*) posterView;
@end

@interface ContentGuideViewRowCarouselViewPosterView : UIView

@property (nonatomic, assign) IBOutlet id <ContentGuideViewRowCarouselViewPosterViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id <ContentGuideViewRowCarouselViewPosterViewDataSource> dataSource;
@property(nonatomic,readonly,copy) NSString *reuseIdentifier;
@property (nonatomic, readonly) NSInteger style;
@property (nonatomic, readwrite) NSInteger index;
@property (nonatomic, readonly) BOOL isSelect;
@property (nonatomic, readonly) BOOL isHighLight;

- (id) initWithStyle:(ContentGuideViewRowCarouselViewPosterViewStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void) setFrame:(CGRect)frame;
- (void) setPathImagePoster:(NSString*)strURL placeholderImage:(UIImage *)placeholderImage;
- (void) setPathImagePoster:(NSString*)strURL placeholderImage:(UIImage *)placeholderImage withIsBlurred:(BOOL)isBlurred;
- (void) setURLImagePoster:(NSURL*)uRL placeholderImage:(UIImage *)placeholderImage;
- (void) setURLImagePoster:(NSURL*)uRL placeholderImage:(UIImage *)placeholderImage withIsBlurred:(BOOL)isBlurred;
- (void) setHeightTitlePosterView:(CGFloat)height;
- (void) setTextTitlePoster:(NSString*) txtTitle;
- (void) setFontTitlePoster:(UIFont*) font;
- (void) setColorTitlePoster:(UIColor*) color;
- (void) setHeightSubTitlePosterView:(CGFloat)height;
- (void) setTextSubTitlePoster:(NSString*) txtTitle;
- (void) setFontSubTitlePoster:(UIFont*) font;
- (void) setColorSubTitlePoster:(UIColor*) color;
- (void) setIsSelectView;
- (void) setViewWithHighLight:(BOOL)isHighLight;
- (void) setImagePoster:(UIImage*) image;
- (void) setShowOrHideTopIcon:(BOOL)isShow;
@end

