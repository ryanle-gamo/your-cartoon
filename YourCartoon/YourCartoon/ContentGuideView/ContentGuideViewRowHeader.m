//
//  ContentGuideViewRowHeader.m
//  CartoonCollector
//
//  Created by Binh Le on 5/31/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

#import "ContentGuideViewRowHeader.h"

#define _PADDING_IMAGE_LEFT_DEFAULD_STYLE_ 5
#define _PADDING_ICON_DEFAULD_STYLE_ 10
#define _HEIGHT_ICON_DEFAULD_STYLE_ 25
#define _WIDTH_ICON_DEFAULD_STYLE_(heightIcon) (heightIcon*2.6)
#define _WIDTH_BT_OPEN_ 60
#define _WIDTH_IMG_OPEN_ 20

@interface ContentGuideViewRowHeader()
{
    CGFloat pandingLeft;
    UIFont *fontTitleRowHeader;
    UIImageView *backgroundView;
    UIButton *btOpen;
    UIImageView *imgOpen;
    
}
@property (nonatomic, retain) UILabel *lbTitleRowHeader;

- (void)initCommon;
@end
@implementation ContentGuideViewRowHeader
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize style = _style;

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithStyle:ContentGuideViewRowHeaderStyleDefault reuseIdentifier:@"ContentGuideViewRowHeaderStyleDefault"];
}
- (id)initWithStyle:(ContentGuideViewRowHeaderStyle)aStyle reuseIdentifier:(NSString *)aReuseIdentifier{
    if (self = [super initWithFrame:CGRectZero]) {
        self.opaque = YES;
        _reuseIdentifier = aReuseIdentifier;
        _style = aStyle;
        [self setBackgroundRowHeader:BACKGROUND_COLOR_ROWHEADER];
        self.lbTitleRowHeader = [[UILabel alloc] init];
        [self.lbTitleRowHeader setBackgroundColor:[UIColor clearColor]];
        if (IS_IPAD) {
            fontTitleRowHeader = IPAD_FONT_TITLE_ROW_HEADER_DEFAULT;
        } else {
            fontTitleRowHeader = FONT_TITLE_ROW_HEADER_DEFAULT;
        }
        [self addSubview:self.lbTitleRowHeader];
        pandingLeft = PANDING_LEFT_CONTENT_GUIDE_ROW_HEADER_DEFAULT;
        
        btOpen = [UIButton buttonWithType:UIButtonTypeCustom];
        [btOpen addTarget:self action:@selector(didTapTextBtOpen) forControlEvents:UIControlEventTouchUpInside];
        imgOpen = [[UIImageView alloc] init];
        [self addSubview:imgOpen];
        [self addSubview:btOpen];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self initCommon];
    
}
- (void)initCommon{
    [self setPandingLeftTitle:pandingLeft];
    [self setFontTitleRowHeader:fontTitleRowHeader];
    [self setColorTextTitleRowHeader:TITLE_COLOR];

    [imgOpen setBackgroundColor:[UIColor clearColor]];
    [btOpen setBackgroundColor:[UIColor clearColor]];
}
- (void)prepareForReuse{
}
- (void)updateSubViewsFrame{
    
    CGRect frame = SET_X_Y_FRAME(pandingLeft, 0, self.frame);
    frame.size.width = self.frame.size.width - pandingLeft;
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    CGRect frameTxtRow = CGRectZero;
    CGRect frameImgOpen = CGRectZero;
    
    frameTxtRow = CGRectMake(pandingLeft, 0, width - pandingLeft*2 - _WIDTH_BT_OPEN_, height);
    frameImgOpen = CGRectMake(width - _WIDTH_IMG_OPEN_ - pandingLeft, height/6, _WIDTH_IMG_OPEN_, _WIDTH_IMG_OPEN_);
    
    [self.lbTitleRowHeader setFrame:frameTxtRow];
    [imgOpen setFrame:frameImgOpen];
    
    CGRect newFrame = frameImgOpen;
    newFrame.origin.x -= 20;
    newFrame.size.width += 20;
    [btOpen setFrame:newFrame];
}
- (void) setBackground:(UIImage *)image{
    if (!backgroundView) {
        CGRect frameBG = self.frame;
        frameBG.origin.x = 0;
        frameBG.origin.y = 0;
        backgroundView = [[UIImageView alloc] initWithFrame:frameBG];
        [backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
        [self insertSubview:backgroundView atIndex:0];
    }
    [backgroundView setImage:image];
}

- (void) setTextTitleRowHeader:(NSString*) txtTitle{
    if (txtTitle) {
        [self.lbTitleRowHeader setText:txtTitle];
    }
}
- (void) setColorTextTitleRowHeader:(UIColor*)color {
    if (color) {
        [self.lbTitleRowHeader setTextColor:color];
    }
}

- (void) setFontTitleRowHeader:(UIFont*) font{
    if (font) {
        [self.lbTitleRowHeader setFont:font];
        [btOpen.titleLabel setFont:font];
    }
}
- (void) setBackgroundRowHeader:(UIColor *)backgroundColor{
    if (backgroundColor) {
        [self setBackgroundColor:backgroundColor];
    }
}
- (void) setPandingLeftTitle:(CGFloat) _pandingLeft{
    pandingLeft = _pandingLeft;
    [self updateSubViewsFrame];
}
- (void)setPicturesCount:(NSUInteger)count withIcon:(UIImage*)icoImage{
}
- (void)setPeopleCount:(NSUInteger)count withIcon:(UIImage*)icoImage{
}
- (void)setLockWithIcon:(UIImage*)icoImage{
}
- (void) setTxtOpen:(NSString*)txtOpen withIcon:(UIImage*)icoImage{
    if (icoImage) {
        [imgOpen setImage:icoImage];
    }
    if (txtOpen) {
        [btOpen setTitle:txtOpen forState:UIControlStateNormal];
    }
    
}

- (void)didTapTextBtOpen{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapBtOpen:)]) {
        [self.delegate didTapBtOpen:self];
    }
}
@end
