//
//  ContentGuideViewRow.m
//  CartoonCollector
//
//  Created by Binh Le on 5/31/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

#import "ContentGuideViewRow.h"
#import "ContentGuideViewRowHeader.h"
#import "ContentGuideViewRowCarouselViewPosterView.h"

@interface ContentGuideViewRow()<UIScrollViewDelegate, ContentGuideViewRowCarouselViewPosterViewDelegate, ContentGuideViewRowCarouselViewPosterViewDataSource, ContentGuideViewRowHeaderDelegate>{
    BOOL isDidScroll;
    UIActivityIndicatorView *loadingView;
}
@property (nonatomic, retain) UIScrollView *carouselScrollView;
@property (nonatomic, retain) ContentGuideViewRowHeader *headerView;
@property (nonatomic, assign) NSInteger beginVisiblePosterIndex;
@property (nonatomic, assign) NSUInteger numberPosters;
- (void)_layOutForHeaderView;
- (void) _performInitHeader;
- (void) _performInitCarouselScrollView;
- (void)_layOutForCarouselScrollView;
- (void)_addVisibleToLeftPoster:(ContentGuideViewRowCarouselViewPosterView *)thisPoster
                posterViewIndex:(NSUInteger)index;
- (void)_addVisibleToRightPoster:(ContentGuideViewRowCarouselViewPosterView *)thisPoster
                 posterViewIndex:(NSUInteger)index;
- (ContentGuideViewRowCarouselViewPosterView *)_visiblePosteratIndexPath:(NSUInteger )relativeCellIndex;
- (ContentGuideViewRowCarouselViewPosterView *)_removeVisibleLeftPoster;
- (ContentGuideViewRowCarouselViewPosterView *)_removeVisibleRightPoster;
- (NSUInteger)_getPosterIndexFromOffsetX:(CGFloat) offsetX;
- (CGFloat)_getOffsetXFromPosterIndex:(NSUInteger) absoluteIndex;
- (void)prepareForReuse;
- (void) loadLayoutMetrics;
- (void)removeOldSubviews;
@end
@implementation ContentGuideViewRow
@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize style = _style;
@synthesize visiblePosters = _visiblePosters;
- (id)initWithFrame:(CGRect)frame
{
    return [self initWithStyle:ContentGuideViewRowStyleDefault reuseIdentifier:@"ContentGuideViewRowStyleDefault"];
}
- (id)initWithStyle:(ContentGuideViewRowStyle)aStyle reuseIdentifier:(NSString *)aReuseIdentifier{
    if (self = [super initWithFrame:CGRectZero]) {
        self.opaque = YES;
        _reuseIdentifier = aReuseIdentifier;
        _style = aStyle;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}
- (void)setBackground:(UIImage *)image{
    if (!backgroundView) {
        backgroundView = [[UIImageView alloc] initWithFrame:SET_X_Y_FRAME(0, 0, self.frame)];
        [self insertSubview:backgroundView atIndex:0];
        [backgroundView setImage:image];
    }
}
- (void)_layOutForHeaderView{
    if (!self.headerView) {
        [self _performInitHeader];
    }
}
- (void) _performInitHeader{
    if ([self.dataSource respondsToSelector:@selector(headerForRow:)]) {
        self.headerView = [self.dataSource headerForRow:self];
        [self.headerView setDelegate:self];
        CGRect frameHeader = self.frame;
        if ([self.delegate respondsToSelector:@selector(heightForContentGuideViewRowHeader:)]) {
            CGFloat heightHeader = [self.delegate heightForContentGuideViewRowHeader:self];
            frameHeader.size.height = heightHeader;
            frameHeader.origin.y = [self.delegate pandingTopOfRowHeader:self];
            frameHeader.origin.x = 0;
        }
        [self.headerView setFrame:frameHeader];
        if (self.headerView) [self addSubview:self.headerView];
    }
}
- (void)_layOutForCarouselScrollView{
    if (self.carouselScrollView.contentOffset.x < 0 || self.numberPosters < 1) return;
    if (self.beginVisiblePosterIndex <0) {
        [self _performInitCarouselScrollView];
        
    }
    NSInteger beginUpdatePosterIndex =[self _getPosterIndexFromOffsetX:self.carouselScrollView.contentOffset.x];
    NSInteger deltaBeginPosterIndex= beginUpdatePosterIndex - self.beginVisiblePosterIndex;
    if (deltaBeginPosterIndex >0) {
        for (NSUInteger i=0; i < deltaBeginPosterIndex; i++) {
            //remove to the left
            if ([self.visiblePosters count]>0) {
                [self.delegate posterViewRemoved:[self _removeVisibleLeftPoster] fromContentGuideViewRow:self];
            }
        }
    }
    else {
        for (NSInteger i=0; deltaBeginPosterIndex < i ; i--) {
            // add the left
            ContentGuideViewRowCarouselViewPosterView *missingPoster = [self.dataSource contentGuide:self posterViewIndex:self.beginVisiblePosterIndex - 1 ];
            [self _addVisibleToLeftPoster:missingPoster posterViewIndex:self.beginVisiblePosterIndex - 1];
            
        }
    }
    NSInteger endTrackedHeaderIndex= self.beginVisiblePosterIndex + [self.visiblePosters count] -1;
    NSInteger endUpdateHeadwerIndex =[self _getPosterIndexFromOffsetX:self.carouselScrollView.contentOffset.x + self.carouselScrollView.frame.size.width];
    if (endUpdateHeadwerIndex > self.numberPosters -1) {
        endUpdateHeadwerIndex =self.numberPosters -1 ;
    }
    NSInteger deltaEndHeaderIndex = endUpdateHeadwerIndex - endTrackedHeaderIndex;
    if (deltaEndHeaderIndex >0) {
        for (NSInteger j=0; j < deltaEndHeaderIndex; j++) {
            // add to the right
            if ((self.beginVisiblePosterIndex + [self.visiblePosters count]) > self.numberPosters) {
                break; // Reach to limit end header // No more add
            }
            ContentGuideViewRowCarouselViewPosterView *missingPoster = [self.dataSource contentGuide:self posterViewIndex:self.beginVisiblePosterIndex + [self.visiblePosters count]];
            if (!missingPoster) {
                break;
            }
            [self _addVisibleToRightPoster:missingPoster posterViewIndex:self.beginVisiblePosterIndex + [self.visiblePosters count]];
        }
    }
    else {
        for (NSInteger j=0; j > deltaEndHeaderIndex ; j--) {
            // remove to the right
            ContentGuideViewRowCarouselViewPosterView *posterView = [self _removeVisibleRightPoster];
            if(posterView)
                [self.delegate posterViewRemoved:posterView fromContentGuideViewRow:self];
        }
    }
}
-(void)_addVisibleToLeftPoster:(ContentGuideViewRowCarouselViewPosterView *)thisPoster posterViewIndex:(NSUInteger)index{
    
    if (!self.visiblePosters) {
        _visiblePosters= [[NSMutableArray alloc] init];
    }
    [thisPoster setDelegate:self];
    [thisPoster setDataSource:self];
    [thisPoster setIndex:index];
    [self.visiblePosters insertObject:thisPoster atIndex:0];
    [self.carouselScrollView addSubview:thisPoster];
    NSUInteger newIndex = -- self.beginVisiblePosterIndex;
    if ([self.delegate respondsToSelector:@selector(didChangedBeginVisiblePosterIndex:toIndex:)]) {
        [self.delegate didChangedBeginVisiblePosterIndex:self toIndex:newIndex];
    }
    if (isDidScroll && [self.delegate respondsToSelector:@selector(contentGuideViewRow:didScrollToVisibleposterIndex:withDirection:)]) {
        [self.delegate contentGuideViewRow:self didScrollToVisibleposterIndex:index withDirection:CarouselViewScrollDirectionLeftToRight];
    }
}
-(void)_addVisibleToRightPoster:(ContentGuideViewRowCarouselViewPosterView *)thisPoster posterViewIndex:(NSUInteger)index{
    
    if (!self.visiblePosters) {
        _visiblePosters= [[NSMutableArray alloc] init];
    }
    [thisPoster setDelegate:self];
    [thisPoster setDataSource:self];
    [thisPoster setIndex:index];
    [self.visiblePosters addObject:thisPoster];
    [self.carouselScrollView addSubview:thisPoster];
    if (isDidScroll && [self.delegate respondsToSelector:@selector(contentGuideViewRow:didScrollToVisibleposterIndex:withDirection:)]) {
        [self.delegate contentGuideViewRow:self didScrollToVisibleposterIndex:index withDirection:CarouselViewScrollDirectionRightToLeft];
    }
}
-(ContentGuideViewRowCarouselViewPosterView *)_visiblePosteratIndexPath:(NSUInteger )relativeCellIndex {
    return [self.visiblePosters objectAtIndex:relativeCellIndex];
}
-(ContentGuideViewRowCarouselViewPosterView *)_removeVisibleLeftPoster {
    
    if(self.visiblePosters && self.visiblePosters.count > 0){
        ContentGuideViewRowCarouselViewPosterView *result = [self.visiblePosters objectAtIndex:0];
        [self.visiblePosters removeObjectAtIndex:0];
        NSUInteger newIndex = ++ self.beginVisiblePosterIndex;
        if ([self.delegate respondsToSelector:@selector(didChangedBeginVisiblePosterIndex:toIndex:)]) {
            [self.delegate didChangedBeginVisiblePosterIndex:self toIndex:newIndex];
        }
        [result removeFromSuperview];
        return result;
    } else return nil;
}
-(ContentGuideViewRowCarouselViewPosterView *)_removeVisibleRightPoster {
    
    if(self.visiblePosters && self.visiblePosters.count > 0){
        ContentGuideViewRowCarouselViewPosterView *result = [self.visiblePosters lastObject];
        [self.visiblePosters removeLastObject];
        [result removeFromSuperview];
        return result;
    } else return nil;
}

-(NSUInteger)_getPosterIndexFromOffsetX:(CGFloat) offsetX{
    CGFloat widthPosterView = [self.delegate widthForContentGuideViewRowCarouselViewPosterView:self] + [self.delegate spaceBetweenCarouselViewPosterViews:self];
    if (widthPosterView <=0) {
        return -1;
    }
    if (offsetX < [self.delegate spaceBetweenCarouselViewPosterViews:self]) {
        return 0;
    }
    NSInteger result= (NSInteger)((offsetX - [self.delegate spaceBetweenCarouselViewPosterViews:self]/2)/widthPosterView);
    return result;
}
- (CGFloat)_getOffsetXFromPosterIndex:(NSUInteger) absoluteIndex{
    CGFloat result = 0.f;
    for (NSUInteger i=0; i < absoluteIndex; i++) {
        result += [self.delegate widthForContentGuideViewRowCarouselViewPosterView:self] + [self.delegate spaceBetweenCarouselViewPosterViews:self];;
    }
    return result;
}
- (void) _performInitCarouselScrollView{
    [self.carouselScrollView setUserInteractionEnabled:YES];
    self.carouselScrollView = [[UIScrollView alloc] init];
    [self.carouselScrollView setScrollsToTop:NO];
    self.carouselScrollView.delegate = self;
    [self.carouselScrollView setShowsHorizontalScrollIndicator:NO];
    [self.carouselScrollView setShowsVerticalScrollIndicator:NO];
    self.beginVisiblePosterIndex = 0;
    _visiblePosters= [[NSMutableArray alloc] init];
    [self.carouselScrollView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.carouselScrollView];
}

- (void) _performInitLoadingView{
    loadingView = [[UIActivityIndicatorView alloc] init];
    CGFloat heightHeader = [self.delegate heightForContentGuideViewRowHeader:self] + [self.delegate pandingTopOfRowHeader:self] + [self.delegate pandingBottomOfRowHeader:self];
    CGRect tmpRect = self.frame;
    tmpRect.origin.x = tmpRect.size.width/2 - 20;
    tmpRect.origin.y = (tmpRect.size.height + heightHeader)/2 - 20;
    tmpRect.size.width = 40;
    tmpRect.size.height = 40;
    [loadingView setFrame:tmpRect];
    [self addSubview:loadingView];
    if ([self.dataSource respondsToSelector:@selector(showWating:)]) {
        BOOL isShow = [self.dataSource showWating:self];
        if (isShow) {
            [self showWaiting];
        }else{
            [self hideWaiting];
        }
    }
}

- (void)setBackgroundView:(UIImageView *)aBackgroundView{
    [backgroundView removeFromSuperview];
    backgroundView = aBackgroundView;
    [self insertSubview:backgroundView atIndex:0];
    [self setNeedsLayout];
}
- (void) setBackgroundColorForScrollView:(UIColor *)color{
    if (color) {
        [self.carouselScrollView setBackgroundColor:color];
    }
}
- (void)prepareForReuse{
    [self removeOldSubviews];
    [self setUserInteractionEnabled:YES];
    isDidScroll = false;
    self.headerView = nil;
    self.carouselScrollView = nil;
}
- (void) reloadData{
    [self.layer removeAllAnimations];
    self.numberPosters=[self.dataSource numberOfPostersInCarousel:self];
    [self removeOldSubviews];
    [self _performInitHeader];
    [self _performInitCarouselScrollView];
    [self _performInitLoadingView];
    [self loadLayoutMetrics];
    if ([self.dataSource respondsToSelector:@selector(beginVisiblePosterIndex:)] && [self.dataSource beginVisiblePosterIndex:self] > 0) {
        self.beginVisiblePosterIndex = [self.dataSource beginVisiblePosterIndex:self] + 1;
    }
    CGFloat offsetX = [self _getOffsetXFromPosterIndex:self.beginVisiblePosterIndex];
    if ((self.carouselScrollView.contentSize.width > self.carouselScrollView.frame.size.width) &&
        (offsetX + self.carouselScrollView.frame.size.width > self.carouselScrollView.contentSize.width)) {
        offsetX = (int)(self.carouselScrollView.contentSize.width - self.carouselScrollView.frame.size.width);
    }
    [self.carouselScrollView setContentOffset:CGPointMake(offsetX, 0)];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}
- (void) showWaiting{
    [self setUserInteractionEnabled:NO];
    [loadingView startAnimating];
}
- (void) hideWaiting{
    [self setUserInteractionEnabled:YES];
    [loadingView stopAnimating];
}
- (void) loadLayoutMetrics
{
    if (self.numberPosters < 1) return;
    CGFloat heightHeader = [self.delegate heightForContentGuideViewRowHeader:self] + [self.delegate pandingTopOfRowHeader:self] + [self.delegate pandingBottomOfRowHeader:self];
    CGRect tmpRect = CGRectZero;
    tmpRect.size.height = self.frame.size.height - heightHeader + .5f;
    tmpRect.size.width = self.frame.size.width;
    tmpRect.origin.x = 0;
    tmpRect.origin.y = heightHeader - .5f;
    self.carouselScrollView.frame = tmpRect;
    CGFloat totalGuideWidth = 0;
    CGFloat totalGuideHeight = tmpRect.size.height;
    for(int i = 0; i < self.numberPosters; i++)
    {
        totalGuideWidth += [self.delegate widthForContentGuideViewRowCarouselViewPosterView:self];
    }
    totalGuideWidth += (self.numberPosters + 1) *[self.delegate spaceBetweenCarouselViewPosterViews:self];
    
    self.carouselScrollView.contentSize = CGSizeMake(totalGuideWidth > [self.delegate spaceBetweenCarouselViewPosterViews:self] ? totalGuideWidth : 0, totalGuideHeight);
}

- (void)removeOldSubviews{
    for (UIView* subView in self.subviews) {
        if ([self.delegate respondsToSelector:@selector(headerViewRemoved:fromContentGuideViewRow:)]&&[subView isKindOfClass:[ContentGuideViewRowHeader class]]) {
            [self.delegate headerViewRemoved:(ContentGuideViewRowHeader*)subView fromContentGuideViewRow:self];
        }else if ([subView isKindOfClass:[UIScrollView class]]){
            for (UIView* subViewOfCarouselView in subView.subviews) {
                if ([self.delegate respondsToSelector:@selector(posterViewRemoved:fromContentGuideViewRow:)]&&[subViewOfCarouselView isKindOfClass:[ContentGuideViewRowCarouselViewPosterView class]]){
                    [self.delegate posterViewRemoved:(ContentGuideViewRowCarouselViewPosterView*)subViewOfCarouselView fromContentGuideViewRow:self];
                }
                [subViewOfCarouselView removeFromSuperview];
            }
        }else if([subView isKindOfClass:[UIActivityIndicatorView class]]){
            [((UIActivityIndicatorView*)subView) stopAnimating];
        }
        [subView removeFromSuperview];
    }
}
#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    isDidScroll = true;
    [self _layOutForCarouselScrollView];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGPoint targetScrollContentOffset = *targetContentOffset;
    CGFloat widthPosterView = [self.delegate widthForContentGuideViewRowCarouselViewPosterView:self] + [self.delegate spaceBetweenCarouselViewPosterViews:self];
    NSInteger indexTarget = [self _getPosterIndexFromOffsetX:targetScrollContentOffset.x];
    CGFloat offsetX = [self _getOffsetXFromPosterIndex:indexTarget];
    targetScrollContentOffset.x = offsetX + round((targetScrollContentOffset.x - offsetX)/widthPosterView)*widthPosterView;
    if (targetScrollContentOffset.x + scrollView.frame.size.width > scrollView.contentSize.width) {
        targetScrollContentOffset.x = (int)(scrollView.contentSize.width - scrollView.frame.size.width);
    }
    *targetContentOffset = targetScrollContentOffset;
}
#pragma mark -- Layout methods
-(void) layoutSubviews{
    backgroundView.frame = self.frame;
    [self _layOutForCarouselScrollView];
    [self _layOutForHeaderView];
}
#pragma mark - ContentGuideViewRowCarouselViewPosterViewDelegate methods
- (void) didSelectPosterView:(ContentGuideViewRowCarouselViewPosterView*) posterView{
    if ([self.delegate respondsToSelector:@selector(contentGuideViewRow:didSelectPosterViewAtIndex:)]) {
        [self.delegate contentGuideViewRow:self didSelectPosterViewAtIndex:posterView.index];
    }
}

- (void) hightLightedPosterView:(ContentGuideViewRowCarouselViewPosterView*) posterView{
    
}

#pragma mark - ContentGuideViewRowCarouselViewPosterViewDataSource methods
- (UIImage*) imageCenterButtonForPosterView:(ContentGuideViewRowCarouselViewPosterView*) posterView{
    if ([self.dataSource respondsToSelector:@selector(imageCenterButtonForPosterView:)]) {
        return [self.dataSource imageCenterButtonForPosterView:self];
    }
    return nil;
}
- (UIImage*) imageBackgroundBottomPosterView:(ContentGuideViewRowCarouselViewPosterView*) posterView{
    if ([self.dataSource respondsToSelector:@selector(imageBackgroundBottomPosterView:)]) {
        return [self.dataSource imageBackgroundBottomPosterView:self];
    }
    return nil;
}
#pragma mark - ContentGuideViewRowHeaderDelegate methods
- (void)didTapBtOpen:(ContentGuideViewRowHeader*)contentGuideViewRowHeader{
    if ([self.delegate respondsToSelector:@selector(didTapBtOpen:)]) {
        [self.delegate didTapBtOpen:self];
    }
}
@end

