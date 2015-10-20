//
//  ContentGuideViewRowCarouselViewPosterView.m
//  CartoonCollector
//
//  Created by Binh Le on 5/31/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

#import "ContentGuideViewRowCarouselViewPosterView.h"

#define POSTER_IMAGE_VIEW_FRAME CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - (heightTitlePoster + heightSubTitlePoster))

#define ICON_LEFT_FRAME   CGRectMake(5, POSTER_IMAGE_VIEW_FRAME.size.height - 18, 16, 16)
#define LABEL_LEFT_FRAME CGRectMake(25, POSTER_IMAGE_VIEW_FRAME.size.height - 18, self.frame.size.width/3 - 20, 16)

#define ICON_RIGHT_FRAME   CGRectMake(self.frame.size.width/3 + 15, POSTER_IMAGE_VIEW_FRAME.size.height - 18, 16, 16)
#define LABEL_RIGHT_FRAME CGRectMake(self.frame.size.width/3 + 35, POSTER_IMAGE_VIEW_FRAME.size.height - 18, self.frame.size.width/3 - 20, 16)

#define BG_BOTTOM_FRAME   CGRectMake(0, POSTER_IMAGE_VIEW_FRAME.size.height - 20, self.frame.size.width, 20)
#define LABEL_TITLE_FRAME CGRectMake(0, imageView.frame.size.height, self.frame.size.width, heightTitlePoster)
#define LABEL_SUB_TITLE_FRAME CGRectMake(0, lbTitle.frame.origin.y + lbTitle.frame.size.height, self.frame.size.width, heightSubTitlePoster)
#define BUTTON_CENTER_FRAME CGRectMake(POSTER_IMAGE_VIEW_FRAME.size.width/2 - 16, POSTER_IMAGE_VIEW_FRAME.size.height/2 - 16, 32, 32)
#define BUTTON_CLICK_VIEW CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
#define TOP_ICON_FRAME CGRectMake(5, 5, 20, 20)
@interface ContentGuideViewRowCarouselViewPosterView()
{
    UIImageView *imageView;
    UILabel *lbTitle;
    UILabel *lblSubtitle;
    CGFloat heightTitlePoster;
    CGFloat heightSubTitlePoster;
    UIFont *fontTitle;
    UIFont *fontSubTitle;
    UIImageView *btnCenter;
    UIView *btnClickView;
    UIImageView *topIcon;
}
-(void)removeFromSuperview;
- (void) _initSubviews;
@end

@implementation ContentGuideViewRowCarouselViewPosterView
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize style = _style;
@synthesize index = _index;
@synthesize isSelect = _isSelect;
@synthesize isHighLight = _isHighLight;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithStyle:ContentGuideViewRowCarouselViewPosterViewStyleDefault reuseIdentifier:@"ContentGuideViewRowCarouselViewPosterViewStyleDefault"];
}
- (id)initWithStyle:(ContentGuideViewRowCarouselViewPosterViewStyle)aStyle reuseIdentifier:(NSString *)aReuseIdentifier{
    if (self = [super initWithFrame:CGRectZero]) {
        self.opaque = YES;
        _reuseIdentifier = aReuseIdentifier;
        _style = aStyle;
        [self _initSubviews];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setFrameForViews];
}

- (void) _initSubviews{
    
    _isSelect = NO;
    
    imageView = [[UIImageView alloc] init];
    btnCenter = [[UIImageView alloc] init];
    lbTitle = [[UILabel alloc] init];
    lblSubtitle = [[UILabel alloc] init];
    btnClickView = [[UIView alloc] init];
    [imageView setBackgroundColor:[UIColor clearColor]];
    topIcon = [[UIImageView alloc] initWithFrame:TOP_ICON_FRAME];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self setClipsToBounds:YES];
    [topIcon setBackgroundColor:[UIColor clearColor]];
    [topIcon setHidden:YES];
    switch (_style) {
        case ContentGuideViewRowCarouselViewPosterViewStyleDefault:
            heightTitlePoster = HEIGHT_TITLE_POSTER_DEFAULT;
            heightSubTitlePoster = 0;
            break;
        case ContentGuideViewRowCarouselViewPosterViewStyleTwoTitles:
            heightTitlePoster = HEIGHT_TITLE_POSTER_DEFAULT;
            heightSubTitlePoster = HEIGHT_SUB_TITLE_POSTER_DEFAULT;
            break;
        case ContentGuideViewRowCarouselViewPosterViewStyleNoneTitle:
            heightTitlePoster = 0;
            heightSubTitlePoster = 0;
            break;
    }
    fontTitle = FONT_TITLE_POSTER_DEFAULT;
    fontSubTitle = FONT_SUB_TITLE_POSTER_DEFAULT;
    
    [lbTitle setBackgroundColor:[UIColor clearColor]];
    [lbTitle setNumberOfLines:2];
    [lbTitle setLineBreakMode:NSLineBreakByTruncatingTail];
    [lbTitle setTextAlignment:NSTextAlignmentLeft];
    [lbTitle setFont:fontTitle];
    
    [lblSubtitle setBackgroundColor:[UIColor clearColor]];
    [lblSubtitle setNumberOfLines:1];
    [lblSubtitle setLineBreakMode:NSLineBreakByTruncatingTail];
    [lblSubtitle setTextAlignment:NSTextAlignmentLeft];
    [lblSubtitle setFont:fontSubTitle];
    
    [btnClickView setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionClickView)];
    [btnClickView addGestureRecognizer:singleTap];
    
    [btnCenter setBackgroundColor:[UIColor clearColor]];
    [topIcon setImage:[UIImage imageNamed:@"photos_play.png"]];
    [self addSubview:imageView];
    [self addSubview:btnCenter];
    [self addSubview:lbTitle];
    [self addSubview:lblSubtitle];
    [self addSubview:topIcon];
    [self addSubview:btnClickView];

}
- (void) setFrameForViews{
    [imageView setFrame:POSTER_IMAGE_VIEW_FRAME];
    [lbTitle setFrame:LABEL_TITLE_FRAME];
    [lblSubtitle setFrame:LABEL_SUB_TITLE_FRAME];
    [btnClickView setFrame:BUTTON_CLICK_VIEW];
    [btnCenter setFrame:BUTTON_CENTER_FRAME];
}

- (void)setPathImagePoster:(NSString*)strURL placeholderImage:(UIImage *)placeholderImage{
    [self setPathImagePoster:strURL placeholderImage:placeholderImage withIsBlurred:NO];
}
- (void)setPathImagePoster:(NSString*)strURL placeholderImage:(UIImage *)placeholderImage withIsBlurred:(BOOL)isBlurred{
    if (strURL && ![strURL isEqualToString:@""] && imageView) {
        NSURL *url = [NSURL URLWithString:strURL];
        [self setURLImagePoster:url placeholderImage:placeholderImage withIsBlurred:isBlurred];
    }
}
- (void) setURLImagePoster:(NSURL*)uRL placeholderImage:(UIImage *)placeholderImage{
    [self setURLImagePoster:uRL placeholderImage:placeholderImage withIsBlurred:NO];
}
- (void) setURLImagePoster:(NSURL*)uRL placeholderImage:(UIImage *)placeholderImage withIsBlurred:(BOOL)isBlurred{
    __block __weak UIImageView  *tmpImageView = imageView;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:uRL];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [imageView setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *tmpImage = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                [tmpImageView setImage:tmpImage];
            });});
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {}];
    
}
- (void)setHeightTitlePosterView:(CGFloat)height{
    if (height > 0) {
        heightTitlePoster = height;
        [self setFrameForViews];
    }
}
- (void)setHeightSubTitlePosterView:(CGFloat)height{
    if (height > 0) {
        heightSubTitlePoster = height;
        [self setFrameForViews];
    }
}
- (void) setTextTitlePoster:(NSString*) txtTitle{
    if (txtTitle) {
        [lbTitle setText:txtTitle];
    }
}
- (void) setFontTitlePoster:(UIFont*) font{
    if (font) {
        [lbTitle setFont:font];
    }
}
- (void) setColorTitlePoster:(UIColor *)color{
    if (color) {
        [lbTitle setTextColor:color];
    }
}
- (void) setTextSubTitlePoster:(NSString*) txtTitle{
    if (txtTitle) {
        [lblSubtitle setText:txtTitle];
    }
}
- (void) setFontSubTitlePoster:(UIFont*) font{
    if (font) {
        [lblSubtitle setFont:font];
    }
}
- (void) setColorSubTitlePoster:(UIColor *)color{
    if (color) {
        [lblSubtitle setTextColor:color];
    }
}
- (void) setIsSelectView{
    _isSelect = YES;
}
- (void) setViewWithHighLight:(BOOL)isHighLight{
    _isHighLight = isHighLight;
    if (isHighLight) {
        if ([self.dataSource respondsToSelector:@selector(imageCenterButtonForPosterView:)]) {
            UIImage *image = [self.dataSource imageCenterButtonForPosterView:self];
            if (image) {
                [btnCenter setImage:image];
                [btnClickView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
            }
        }
    }else{
        [btnCenter setImage:nil];
        [btnClickView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void) setImagePoster:(UIImage*) image{
    if (image) {
        [imageView setImage:image];
    }
}
- (void) setShowOrHideTopIcon:(BOOL)isShow{
    [topIcon setHidden:!isShow];
}
-(void)removeFromSuperview{
    [super removeFromSuperview];
    [imageView cancelImageRequestOperation];
    [imageView setImage:nil];
    [btnCenter setImage:nil];
    [topIcon setHidden:YES];
    [btnClickView setBackgroundColor:[UIColor clearColor]];
    [lbTitle setText:@""];
    [lblSubtitle setText:@""];
    _isHighLight = NO;
    _isSelect = NO;
}

- (void) actionClickView{
    if ([self.delegate respondsToSelector:@selector(didSelectPosterView:)]) {
        [self.delegate didSelectPosterView:self];
    }
}
@end
