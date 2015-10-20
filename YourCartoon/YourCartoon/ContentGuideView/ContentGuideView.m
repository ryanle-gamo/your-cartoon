//
//  ContentGuideView.m
//  CartoonCollector
//
//  Created by Binh Le on 5/31/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

#import "ContentGuideView.h"

@interface ContentGuideView()<UIScrollViewDelegate, ContentGuideViewRowDataSource, ContentGuideViewRowDelegate>{
    NSMutableSet *dequeuedCells;
    NSMutableSet *dequeuedRowHeaderCells;
    NSMutableSet *dequeuedRowPosterCells;
    NSMutableArray *beginVisiblePosterAtRows;
    CGFloat offsetYOfFirstRow;
    CGFloat spacingBottom;
    UIImageView *backbgroundView;
    BOOL isDidScroll;
    NSTimer *timerPullRefresh;
    BOOL isShowPullRefresh;
}
@property (nonatomic, retain) UIScrollView *contentScrollView;
@property (nonatomic, retain) UIView *emptyView;
//layout metrics

// For the rows
@property (nonatomic, retain) NSMutableArray *visibleRows;
@property (nonatomic, assign) NSInteger beginVisibleRowsIndex;
@property (nonatomic, retain) UIView *handleCustomViewAddedToGuideView;
- (void) initCommon;
- (void)_layOutForRowContent;
- (void)_layOutForTopCustomView;
- (void)_performInitViewContent;
- (NSUInteger)_getRowIndexFromOffset:(CGFloat) offsetY;
- (CGFloat)_getRowOffsetYFromIndex:(NSUInteger) absoluteIndex;
- (void)_addVisibleAboveRow:(ContentGuideViewRow *) thisCarousel;
- (void)_addVisibleBelowRow:(ContentGuideViewRow *) thisCarousel;
- (ContentGuideViewRow *)_removeVisibleAboveRow;
- (ContentGuideViewRow *)_removeVisibleBelowRow;
- (ContentGuideViewRow *)_contentGuideViewRowAtRowIndex:(NSUInteger) absoluteRowIndex;
- (void) reloadBeginVisiblePosterAtRows;
- (void) removeDequeueds;
- (void) removeOldSubviews;
- (void) delaySetShowsPullToRefresh;
@end
@implementation ContentGuideView
@synthesize numberRows = _numberRows;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommon];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initCommon];
    }
    return self;
}

- (void) initCommon{
    dequeuedCells =[[NSMutableSet alloc] init];
    dequeuedRowHeaderCells=[[NSMutableSet alloc] init];
    dequeuedRowPosterCells=[[NSMutableSet alloc] init];
    offsetYOfFirstRow = 0;
    spacingBottom = 0;
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [self.contentScrollView setUserInteractionEnabled:YES];
    self.contentScrollView.delegate = self;
    [self.contentScrollView setShowsHorizontalScrollIndicator:NO];
    [self.contentScrollView setShowsVerticalScrollIndicator:NO];
    [self.contentScrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.contentScrollView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.contentScrollView];
    
    self.emptyView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.emptyView setBackgroundColor:[UIColor clearColor]];
    [self.emptyView setUserInteractionEnabled:YES];
    [self.emptyView setHidden:YES];
    [self addSubview:self.emptyView];
    
    UITapGestureRecognizer *singleTapScroll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionClickView)];
    [self.contentScrollView addGestureRecognizer:singleTapScroll];
    UITapGestureRecognizer *singleTapEmptyView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionClickView)];
    [self.emptyView addGestureRecognizer:singleTapEmptyView];
    
    if (self.visibleRows) {// Reset all data
        for (ContentGuideViewRowHeader *thisAvaiRow in self.visibleRows) {
            for (UIView *subView in thisAvaiRow.subviews) {
                [subView removeFromSuperview];
            }
            [thisAvaiRow removeFromSuperview];
        }
    }
    beginVisiblePosterAtRows = [[NSMutableArray alloc] init];
    self.visibleRows = [[NSMutableArray alloc] init];
    if (backbgroundView) {
        [backbgroundView removeFromSuperview];
        backbgroundView = nil;
    }
    CGRect frameBackgroundView = self.frame;
    frameBackgroundView.origin.x = 0;
    frameBackgroundView.origin.y = 0;
    backbgroundView = [[UIImageView alloc] initWithFrame:frameBackgroundView];
    [backbgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self insertSubview:backbgroundView atIndex:0];
    
    __weak ContentGuideView *_contentGuideView_ = self;
    [self.contentScrollView addPullToRefreshWithActionHandler:^{
        if ([_contentGuideView_.delegate respondsToSelector:@selector(contentGuide:shouldRefreshCarouselsAt:)]) {
            [_contentGuideView_.delegate contentGuide:_contentGuideView_ shouldRefreshCarouselsAt:SVPullToRefreshPositionTop];
        }
        [_contentGuideView_.contentScrollView.pullToRefreshView stopAnimating];
    }];
    
    [self.contentScrollView addPullToRefreshWithActionHandler:^{
        if ([_contentGuideView_.delegate respondsToSelector:@selector(contentGuide:shouldRefreshCarouselsAt:)]) {
            [_contentGuideView_.delegate contentGuide:_contentGuideView_ shouldRefreshCarouselsAt:SVPullToRefreshPositionBottom];
        }
        [_contentGuideView_.contentScrollView.pullToRefreshBottomView stopAnimating];
    } position:SVPullToRefreshPositionBottom];
    [self.contentScrollView setShowsPullToRefresh:YES];
    [self.contentScrollView setShowsPullToRefreshBottom:YES];
}

- (void)reloadBeginVisiblePosterAtRows{
    if (_numberRows > beginVisiblePosterAtRows.count) {
        for (NSUInteger i = beginVisiblePosterAtRows.count; i < _numberRows; i++) {
            [beginVisiblePosterAtRows addObject:@(0)];
        }
    }else if (_numberRows < beginVisiblePosterAtRows.count){
        for (NSUInteger i = beginVisiblePosterAtRows.count - _numberRows; i > 0; i--) {
            [beginVisiblePosterAtRows removeLastObject];
        }
    }
}
-(void) setBackground:(UIImage*)image{
    if (image) {
        [backbgroundView setImage:image];
    }
}

#pragma mark -- Layout methods
-(void) layoutSubviews{
    [CATransaction begin];
    [CATransaction setAnimationDuration:0];
    [CATransaction setDisableActions:YES];
    [self _layOutForRowContent];
    [CATransaction commit];
}
- (void)_layOutForTopCustomView{
    if (self.handleCustomViewAddedToGuideView) {
        [self.handleCustomViewAddedToGuideView removeFromSuperview];
        self.handleCustomViewAddedToGuideView = nil;
    }
    if ([self.dataSource respondsToSelector:@selector(topCustomViewForContentGuideView:)]) {
        UIView *topCustomView = [self.dataSource topCustomViewForContentGuideView:self];
        
        if (!topCustomView) return;
        CGRect frameTopCustomView = topCustomView.frame;
        frameTopCustomView.origin.x = 0;
        frameTopCustomView.origin.y = 0;
        [topCustomView setFrame:frameTopCustomView];
        if (self.disabledSrollCustomTopView) {
            self.handleCustomViewAddedToGuideView = topCustomView;
            [self addSubview:topCustomView];
        }else{
            [self.contentScrollView addSubview:topCustomView];
        }
        
    }
}
- (void)_layOutForRowContent{
    NSUInteger beginRowIndexUpdate = [self _getRowIndexFromOffset:self.contentScrollView.contentOffset.y];
    NSInteger beginRowIndexTracked =self.beginVisibleRowsIndex;
    if (beginRowIndexTracked < 0 || [self.visibleRows count] == 0) {
        [self _performInitViewContent];
    }
    beginRowIndexTracked =self.beginVisibleRowsIndex;
    int detalRowWithBeginIndex = (int)(beginRowIndexUpdate - beginRowIndexTracked);
    if (detalRowWithBeginIndex >0) {
        for (NSUInteger i=0; i < detalRowWithBeginIndex; i++) {
            //remove above
            ContentGuideViewRow *contentGuideViewRow = [self _removeVisibleAboveRow];
            if(contentGuideViewRow) [dequeuedCells addObject:contentGuideViewRow];
            
        }
    }
    else {// detalRowWithBeginIndex < 0 || detalRowWithBeginIndex ==0
        for (NSUInteger i=0; i < abs(detalRowWithBeginIndex); i++) {
            // add above
            ContentGuideViewRow *missingRow = [self _contentGuideViewRowAtRowIndex:self.beginVisibleRowsIndex - 1];
            [self _addVisibleAboveRow:missingRow];
        }
    }
    beginRowIndexTracked =self.beginVisibleRowsIndex;
    NSUInteger endRowIndexUpdate =[self _getRowIndexFromOffset:self.contentScrollView.contentOffset.y + self.contentScrollView.frame.size.height];
    NSUInteger endRowIndexTracked = beginRowIndexTracked + [self.visibleRows count] -1;
    int detalRowWithEndIndex = (int)(endRowIndexUpdate - endRowIndexTracked);
    if (detalRowWithEndIndex >0) {
        for (NSUInteger i=0; i < detalRowWithEndIndex; i++) {
            //add below
            if ((self.beginVisibleRowsIndex + [self.visibleRows count]) >= _numberRows) {
                // reach to end of channel.
                break;
            }
            
            ContentGuideViewRow *missingRow = [self _contentGuideViewRowAtRowIndex:self.beginVisibleRowsIndex + [self.visibleRows count]];
            if (!missingRow) {
                break;
            }
            [self _addVisibleBelowRow:missingRow];
        }
    }
    else {
        for (NSUInteger i=0; i < abs(detalRowWithEndIndex); i++) {
            //remove below
            ContentGuideViewRow *contentGuideView = [self _removeVisibleBelowRow];
            if (contentGuideView) [dequeuedCells addObject:contentGuideView];
            
        }
    }
    
}

- (void)_performInitViewContent{
    if (self.visibleRows) {// Reset all data
        for (ContentGuideViewRowHeader *thisAvaiRow in self.visibleRows) {
            for (UIView *subView in thisAvaiRow.subviews) {
                [subView removeFromSuperview];
            }
            [thisAvaiRow removeFromSuperview];
        }
    }
    self.visibleRows = [[NSMutableArray alloc] init];
    NSUInteger beginRowIndex = [self _getRowIndexFromOffset:self.contentScrollView.contentOffset.y];
    self.beginVisibleRowsIndex = beginRowIndex;
}

-(NSUInteger)_getRowIndexFromOffset:(CGFloat) offsetY{
    NSUInteger totalNumRow = _numberRows;
    CGFloat distanceY = offsetYOfFirstRow;
    CGFloat heightForThisRow =0;
    NSInteger result=-1;
    for (NSUInteger i=0; i < totalNumRow; i++) {
        heightForThisRow = [self.delegate heightForContentGuideViewRow:self atRowIndex:i];
        distanceY += heightForThisRow;
        if (distanceY > offsetY) {
            result = i;
            break;
        }
    }
    if (result >= _numberRows -1) {
        result=_numberRows -1;
    }
    return result;
}

-(CGFloat)_getRowOffsetYFromIndex:(NSUInteger) absoluteIndex{
    CGFloat result=0.0f;
    for (NSUInteger i=0; i <= absoluteIndex; i++) {
        result +=[self.delegate heightForContentGuideViewRow:self atRowIndex:i];
    }
    return result;
}
//////////////////
-(void)_addVisibleAboveRow:(ContentGuideViewRow *) thisCarousel {
    if (!self.visibleRows) {
        self.visibleRows =[[NSMutableArray alloc] init];
    }
    self.beginVisibleRowsIndex --;
    if (isDidScroll && [self.delegate respondsToSelector:@selector(contentGuide:didScrollToVisibleRowIndex:withDirection:)]) {
        [self.delegate contentGuide:self didScrollToVisibleRowIndex:self.beginVisibleRowsIndex withDirection:ContentGuideViewScrollDirectionDown];
    }
    [self.visibleRows insertObject:thisCarousel atIndex:0];
    [self.contentScrollView addSubview:thisCarousel];
    [thisCarousel reloadData];
    if ([self.delegate respondsToSelector:@selector(backgroundColorContentRowView:atRowIndex:)]) {
        UIColor *color = [self.delegate backgroundColorContentRowView:self atRowIndex:thisCarousel.rowIndex];
        if (color) {
            [thisCarousel setBackgroundColorForScrollView:color];
        }
    }
}
-(void)_addVisibleBelowRow:(ContentGuideViewRow *) thisCarousel {
    if (!self.visibleRows) {
        self.visibleRows =[[NSMutableArray alloc] init];
    }
    if (isDidScroll && [self.delegate respondsToSelector:@selector(contentGuide:didScrollToVisibleRowIndex:withDirection:)]) {
        [self.delegate contentGuide:self didScrollToVisibleRowIndex:[thisCarousel rowIndex] withDirection:ContentGuideViewScrollDirectionUp];
    }
    [self.visibleRows addObject:thisCarousel];
    [self.contentScrollView addSubview:thisCarousel];
    [thisCarousel reloadData];
    if ([self.delegate respondsToSelector:@selector(backgroundColorContentRowView:atRowIndex:)]) {
        UIColor *color = [self.delegate backgroundColorContentRowView:self atRowIndex:thisCarousel.rowIndex];
        if (color) {
            [thisCarousel setBackgroundColorForScrollView:color];
        }
    }
}
-(ContentGuideViewRow *)_visibleRowCarouselViewatrowNumber:(NSUInteger )relativeRowNumber {
    return [self.visibleRows objectAtIndex:relativeRowNumber];
}
-(ContentGuideViewRow *)_removeVisibleAboveRow {
    
    if(self.visibleRows && self.visibleRows.count > 0){
        ContentGuideViewRow *result = [self.visibleRows objectAtIndex:0];
        [self.visibleRows removeObjectAtIndex:0];
        [result prepareForReuse];
        [result removeFromSuperview];
        self.beginVisibleRowsIndex ++;
        return result;
    } else return nil;
}
-(ContentGuideViewRow *)_removeVisibleBelowRow {
    
    if(self.visibleRows && self.visibleRows.count > 0){
        ContentGuideViewRow *result = [self.visibleRows lastObject];
        [self.visibleRows removeLastObject];
        [result prepareForReuse];
        [result removeFromSuperview];
        return result;
    } else return nil;
}

-(ContentGuideViewRow *)_contentGuideViewRowAtRowIndex:(NSUInteger) absoluteRowIndex{
    ContentGuideViewRow *result = nil;
    
    if ([self.dataSource respondsToSelector:@selector(contentGuide:rowForRowIndex:)]) {
        result = [self.dataSource contentGuide:self rowForRowIndex:absoluteRowIndex];
    }
    
    CGFloat distanceY = offsetYOfFirstRow;
    for (NSUInteger i=0; i < absoluteRowIndex; i++) {
        distanceY +=[self.delegate heightForContentGuideViewRow:self atRowIndex:i];
    }
    CGFloat heighForRow=[self.delegate heightForContentGuideViewRow:self atRowIndex:absoluteRowIndex];
    result.dataSource = self;
    result.delegate = self;
    result.rowIndex = absoluteRowIndex;
    result.frame = CGRectMake(0,distanceY,self.contentScrollView.frame.size.width, heighForRow);
    return result;
}

- (ContentGuideViewRowCarouselViewPosterView*) dequeueReusablePosterViewWithIdentifier:(NSString*) identifier{
    ContentGuideViewRowCarouselViewPosterView* poster = nil;
    for (ContentGuideViewRowCarouselViewPosterView *aPoster in dequeuedRowPosterCells) {
        if ([aPoster.reuseIdentifier isEqualToString:identifier]) {
            poster = aPoster;
            [dequeuedRowPosterCells removeObject:poster];
            break;
        }
    }
    return poster;
}

- (ContentGuideViewRowHeader*) dequeueReusableRowHeaderWithIdentifier:(NSString*) identifier{
    ContentGuideViewRowHeader *rowHeader  = nil;
    for (ContentGuideViewRowHeader *aHeaderCell in dequeuedRowHeaderCells) {
        if ([aHeaderCell.reuseIdentifier isEqualToString:identifier]) {
            rowHeader = aHeaderCell;
            [dequeuedRowHeaderCells removeObject:rowHeader];
            break;
        }
    }
    return rowHeader;
}
- (ContentGuideViewRow*) dequeueReusableRowWithIdentifier:(NSString*) identifier{
    ContentGuideViewRow *row  = nil;
    for (ContentGuideViewRow *aCell in dequeuedCells) {
        if ([aCell.reuseIdentifier isEqualToString:identifier]) {
            row = aCell;
            [dequeuedCells removeObject:row];
            break;
        }
    }
    return row;
}
- (void) scrollToRowIndex:(NSUInteger) rowIndex animated:(BOOL) animated{
    
}

- (void) reloadData{
    [beginVisiblePosterAtRows removeAllObjects];
    [self holdPositionReloadData];
    [self.contentScrollView setContentOffset:CGPointMake(0, 0)];
}

- (void) holdPositionReloadData{
    if (!self.delegate || !self.dataSource) return;
    [self.layer removeAllAnimations];
    _numberRows=[self.dataSource numberOfRowsInContentGuide:self];
    [self reloadBeginVisiblePosterAtRows];
    if (_numberRows > beginVisiblePosterAtRows.count) {
        
    }
    isShowPullRefresh = NO;
    offsetYOfFirstRow = 0;
    spacingBottom = 0;
    if ([self.delegate respondsToSelector:@selector(offsetYOfFirstRow:)]) {
        offsetYOfFirstRow = [self.delegate offsetYOfFirstRow:self];
    }
    if ([self.delegate respondsToSelector:@selector(pandingBottomOfContent:)]) {
        spacingBottom = [self.delegate pandingBottomOfContent:self];
    }
    isDidScroll = false;
    
    if ([self.dataSource respondsToSelector:@selector(contentGuide:showPullToRefreshAtPosition:)]) {
        if (timerPullRefresh) {
            [timerPullRefresh invalidate];
            timerPullRefresh = nil;
        }
        isShowPullRefresh = YES;
        timerPullRefresh = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delaySetShowsPullToRefresh) userInfo:nil repeats:NO];
        
        if ([self.dataSource respondsToSelector:@selector(contentGuide:textForSVPullToRefreshWithState:)]) {
            [self.contentScrollView.pullToRefreshView setTitle:[self.dataSource contentGuide:self textForSVPullToRefreshWithState:SVPullToRefreshStateStopped] forState:SVPullToRefreshStateStopped];
            [self.contentScrollView.pullToRefreshBottomView setTitle:[self.dataSource contentGuide:self textForSVPullToRefreshWithState:SVPullToRefreshStateStopped] forState:SVPullToRefreshStateStopped];
            
            [self.contentScrollView.pullToRefreshView setTitle:[self.dataSource contentGuide:self textForSVPullToRefreshWithState:SVPullToRefreshStateTriggered] forState:SVPullToRefreshStateTriggered];
            [self.contentScrollView.pullToRefreshBottomView setTitle:[self.dataSource contentGuide:self textForSVPullToRefreshWithState:SVPullToRefreshStateTriggered] forState:SVPullToRefreshStateTriggered];
        }
    }
    
    // 1) Remove all current subviews
    [self removeOldSubviews];
    
    // 2) Remove all dequeueds
    [self removeDequeueds];
    
    // 3) Reload layout metrics
    [self loadLayoutMetrics];
    
    // 4) Add TopCustomView
    [self _layOutForTopCustomView];
    
    // 5) Rebuild visible subviews
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self layoutSubviews];
    [CATransaction commit];
}
- (void)delaySetShowsPullToRefresh{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(contentGuide:showPullToRefreshAtPosition:)]) {
        [self.contentScrollView setShowsPullToRefresh:[self.dataSource contentGuide:self showPullToRefreshAtPosition:SVPullToRefreshPositionTop]];
        [self.contentScrollView setShowsPullToRefreshBottom:[self.dataSource contentGuide:self showPullToRefreshAtPosition:SVPullToRefreshPositionBottom]];
    }
}
-(void) changeToSize:(CGSize) newSize{
    [self setFrame:SET_WIDTH_HEIGHT_FRAME(newSize.width, newSize.height, self.frame)];
    [self reloadData];
}
- (void) removeDequeueds
{
    [dequeuedCells removeAllObjects];
    [dequeuedRowHeaderCells removeAllObjects];
    [dequeuedRowPosterCells removeAllObjects];
}
- (void) removeOldSubviews
{
    for (UIView *subView in [self.contentScrollView subviews]) {
        if (![subView isKindOfClass:[SVPullToRefreshView class]]) {
            [subView removeFromSuperview];
        }
    }
    [[self.emptyView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (void) loadLayoutMetrics
{
    self.contentScrollView.frame = SET_X_Y_FRAME(0, 0, self.frame);
    self.emptyView.frame = SET_X_Y_FRAME(0, 0, self.frame);
    self.beginVisibleRowsIndex=-1;
    CGFloat totalGuideWidth = self.frame.size.width;
    CGFloat totalGuideHeight = 0;
    for(int i = 0; i < _numberRows; i++)
    {
        totalGuideHeight += [self.delegate heightForContentGuideViewRow:self atRowIndex:i];
    }
    self.contentScrollView.contentSize = CGSizeMake(totalGuideWidth, MAX(totalGuideHeight + offsetYOfFirstRow + spacingBottom, self.contentScrollView.frame.size.height + (isShowPullRefresh?2:0)));
    if (_numberRows == 0 && [self.dataSource respondsToSelector:@selector(emptyViewForContentGuideView:withParentFrame:)]) {
        [self.emptyView setHidden:NO];
        UIView *emptyV = [self.dataSource emptyViewForContentGuideView:self withParentFrame:self.emptyView.frame];
        if (emptyV)[self.emptyView addSubview:emptyV];
    }else{
        [self.emptyView setHidden:YES];
        if ([self.delegate respondsToSelector:@selector(shouldHideEmptyViewForContentGuideView:)]) {
            [self.delegate shouldHideEmptyViewForContentGuideView:self];
        }
    }
}

- (ContentGuideViewRow*)getVisibleViewRowAtIndex:(NSUInteger) index{
    for (ContentGuideViewRow *row in self.visibleRows) {
        if ([row rowIndex] == index) {
            return row;
        }
    }
    return nil;
}

- (ContentGuideViewRowCarouselViewPosterView*)getVisiblePosterViewAtRow:(NSUInteger) rowIndex
                                                        withPosterIndex:(NSInteger) index{
    ContentGuideViewRow *row = [self getVisibleViewRowAtIndex:rowIndex];
    if (row) {
        for (ContentGuideViewRowCarouselViewPosterView *poster in row.visiblePosters) {
            if (poster.index == index) {
                return poster;
            }
        }
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    isDidScroll = true;
    [self layoutSubviews];
}

#pragma mark - ContentGuideViewRowDataSource methods
- (NSUInteger) numberOfPostersInCarousel:(ContentGuideViewRow*) viewRow{
    if ([self.dataSource respondsToSelector:@selector(numberOfPostersInCarousel:atRowIndex:)]) {
        return [self.dataSource numberOfPostersInCarousel:self atRowIndex:[viewRow rowIndex]];
    }
    return 0;
}

- (ContentGuideViewRowHeader*) headerForRow:(ContentGuideViewRow*) viewRow{
    if ([self.dataSource respondsToSelector:@selector(contentGuide:rowHeaderForRowIndex:)]) {
        return [self.dataSource contentGuide:self rowHeaderForRowIndex:[viewRow rowIndex]];
    }
    return nil;
}

- (ContentGuideViewRowCarouselViewPosterView*)contentGuide:(ContentGuideViewRow*) viewRow
                                           posterViewIndex:(NSUInteger)index{
    if ([self.dataSource respondsToSelector:@selector(contentGuide:posterViewForRowIndex:posterViewIndex:)]) {
        ContentGuideViewRowCarouselViewPosterView *view = [self.dataSource contentGuide:self posterViewForRowIndex:[viewRow rowIndex] posterViewIndex:index];
        [view setFrame:[self framePosterView:viewRow posterViewIndex:index]];
        return view;
    }
    return nil;
}
- (CGRect)framePosterView:(ContentGuideViewRow*) viewRow posterViewIndex:(NSUInteger)index{
    CGRect frame = CGRectZero;
    if ([self.delegate respondsToSelector:@selector(heightForContentGuideViewRow:atRowIndex:)]) {
        frame.origin.x = index * ([self.delegate widthForContentGuideViewRowCarouselViewPosterView:self atRowIndex:[viewRow rowIndex]] + [self spaceBetweenCarouselViewPosterViews:viewRow]) + [self spaceBetweenCarouselViewPosterViews:viewRow];
        frame.size.width = [self widthForContentGuideViewRowCarouselViewPosterView:viewRow];
        frame.size.height = [self.delegate heightForContentGuideViewRow:self atRowIndex:[viewRow rowIndex]] - [self heightForContentGuideViewRowHeader:viewRow] - [self pandingTopOfRowHeader:viewRow] - [self pandingBottomOfRowHeader:viewRow] - [self pandingBottomOfPosterView:viewRow];
    }
    return frame;
}
- (NSUInteger)beginVisiblePosterIndex:(ContentGuideViewRow*) viewRow{
    if (beginVisiblePosterAtRows && beginVisiblePosterAtRows.count > [viewRow rowIndex]) {
        return [beginVisiblePosterAtRows[[viewRow rowIndex]] intValue];
    }
    return 0;
}

- (UIImage*) imageCenterButtonForPosterView:(ContentGuideViewRow*) viewRow{
    if ([self.dataSource respondsToSelector:@selector(contentGuide:imageCenterButtonForPosterView:)]) {
        return [self.dataSource contentGuide:self imageCenterButtonForPosterView:viewRow];
    }
    return nil;
}

- (UIImage*) imageBackgroundBottomPosterView:(ContentGuideViewRow*) viewRow{
    if ([self.dataSource respondsToSelector:@selector(contentGuide:imageBackgroundBottomPosterView:)]) {
        return [self.dataSource contentGuide:self imageBackgroundBottomPosterView:viewRow];
    }
    return nil;
}
- (BOOL) showWating:(ContentGuideViewRow *)viewRow{
    if ([self.dataSource respondsToSelector:@selector(contentGuide:showWating:)]) {
        return [self.dataSource contentGuide:self showWating:viewRow];
    }
    return NO;
}

#pragma mark - ContentGuideViewRowDelegate methods

- (CGFloat)heightForContentGuideViewRowHeader:(ContentGuideViewRow*) viewRow{
    if ([self.delegate respondsToSelector:@selector(heightForContentGuideViewRowHeader:atRowIndex:)]) {
        return [self.delegate heightForContentGuideViewRowHeader:self atRowIndex:[viewRow rowIndex]];
    }
    return 0;
}

- (CGFloat)widthForContentGuideViewRowCarouselViewPosterView:(ContentGuideViewRow*) viewRow{
    if ([self.delegate respondsToSelector:@selector(widthForContentGuideViewRowCarouselViewPosterView:atRowIndex:)]) {
        return [self.delegate widthForContentGuideViewRowCarouselViewPosterView:self atRowIndex:[viewRow rowIndex]];
    }
    return 0;
}

- (CGFloat)spaceBetweenCarouselViewPosterViews:(ContentGuideViewRow*) viewRow{
    if ([self.delegate respondsToSelector:@selector(spaceBetweenCarouselViewPosterViews:atRowIndex:)]) {
        return [self.delegate spaceBetweenCarouselViewPosterViews:self atRowIndex:[viewRow rowIndex]];
    }
    return 0;
}

- (CGFloat)pandingBottomOfPosterView:(ContentGuideViewRow*) viewRow{
    if ([self.delegate respondsToSelector:@selector(pandingBottomOfPosterView:atRowIndex:)]) {
        return [self.delegate pandingBottomOfPosterView:self atRowIndex:[viewRow rowIndex]];
    }
    return 0;
}

- (CGFloat)pandingTopOfRowHeader:(ContentGuideViewRow*) viewRow{
    if ([self.delegate respondsToSelector:@selector(pandingTopOfRowHeader:atRowIndex:)]) {
        return [self.delegate pandingTopOfRowHeader:self atRowIndex:[viewRow rowIndex]];
    }
    return 0;
}
-(CGFloat)pandingBottomOfRowHeader:(ContentGuideViewRow *)viewRow{
    if ([self.delegate respondsToSelector:@selector(pandingBottomOfRowHeader:atRowIndex:)]) {
        return [self.delegate pandingBottomOfRowHeader:self atRowIndex:[viewRow rowIndex]];
    }
    return 0;
}
- (void)         contentGuideViewRow:(ContentGuideViewRow*) viewRow
          didSelectPosterViewAtIndex:(NSUInteger) posterIndex{
    if ([self.delegate respondsToSelector:@selector(contentGuide:didSelectPosterViewAtRowIndex:posterIndex:)]) {
        [self.delegate contentGuide:self didSelectPosterViewAtRowIndex:[viewRow rowIndex] posterIndex:posterIndex];
    }
}

- (void)      contentGuideViewRow:(ContentGuideViewRow*) viewRow
    didScrollToVisibleposterIndex:(NSUInteger) posterIndex
                    withDirection:(CarouselViewScrollDirection) direction{
    if ([self.delegate respondsToSelector:@selector(contentGuide:didScrollToVisibleposterIndex:atViewRow:withDirection:)]) {
        [self.delegate contentGuide:self didScrollToVisibleposterIndex:posterIndex atViewRow:viewRow withDirection:direction];
    }
}

- (void) headerViewRemoved:(ContentGuideViewRowHeader*)headerView fromContentGuideViewRow:(ContentGuideViewRow*)viewRow{
    if (headerView) [dequeuedRowHeaderCells addObject:headerView];
}

- (void)posterViewRemoved:(ContentGuideViewRowCarouselViewPosterView*)posterView fromContentGuideViewRow:(ContentGuideViewRow*)viewRow{
    if (posterView) [dequeuedRowPosterCells addObject:posterView];
}

- (void) didChangedBeginVisiblePosterIndex:(ContentGuideViewRow*) viewRow toIndex:(NSUInteger)index{
    [beginVisiblePosterAtRows replaceObjectAtIndex:[viewRow rowIndex] withObject:@(index)];
}
- (void) didTapBtOpen:(ContentGuideViewRow*) viewRow{
    if ([self.delegate respondsToSelector:@selector(contentGuide:didTapBtOpen:)]) {
        [self.delegate contentGuide:self didTapBtOpen:viewRow];
    }
}
- (void)actionClickView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapGestureContentGuide:)]) {
        [self.delegate didTapGestureContentGuide:self];
    }
}
@end
