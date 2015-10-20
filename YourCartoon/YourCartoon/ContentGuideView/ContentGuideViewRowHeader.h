//
//  ContentGuideViewRowHeader.h
//  CartoonCollector
//
//  Created by Binh Le on 5/31/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ContentGuideViewRowHeader;

typedef enum {
    ContentGuideViewRowHeaderStyleDefault,
} ContentGuideViewRowHeaderStyle;

@protocol ContentGuideViewRowHeaderDelegate <NSObject>
@optional
- (void)didTapBtOpen:(ContentGuideViewRowHeader*)contentGuideViewRowHeader;
@end
@interface ContentGuideViewRowHeader : UIView {
    
}
@property (nonatomic, assign) IBOutlet id <ContentGuideViewRowHeaderDelegate> delegate;
@property(nonatomic,readonly,copy) NSString *reuseIdentifier;
@property (nonatomic, readonly) NSInteger style;
- (id)initWithStyle:(ContentGuideViewRowHeaderStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setFrame:(CGRect)frame;
- (void)prepareForReuse;
- (void) setTextTitleRowHeader:(NSString*) txtTitle;
- (void) setColorTextTitleRowHeader:(UIColor*)color;
- (void) setFontTitleRowHeader:(UIFont*) font;
- (void) setBackgroundRowHeader:(UIColor *)backgroundColor;
- (void) setPandingLeftTitle:(CGFloat) pandingLeft;
- (void) setBackground:(UIImage *)image;
- (void) setPicturesCount:(NSUInteger)count withIcon:(UIImage*)icoImage;
- (void) setPeopleCount:(NSUInteger)count withIcon:(UIImage*)icoImage;
- (void) setLockWithIcon:(UIImage*)icoImage;
- (void) setTxtOpen:(NSString*)txtOpen withIcon:(UIImage*)icoImage;

@end
