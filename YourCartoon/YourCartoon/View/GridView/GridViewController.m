//
//  GridViewController.m
//  HowToMakeClay
//
//  Created by Binh Le on 7/6/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import "GridViewController.h"
#import "AppDelegate.h"

#import "PLObject.h"
#import "VideoObject.h"
#import "ConfigurationObj.h"

#import "DetailViewController.h"

#import "DataManager.h"

#define MAX_RESULT 50
#define _HEIGHT_TOP_VIEW_ 120*RATIO_SCALE_IPHONE

@interface GridViewController ()<MPAdViewDelegate>

@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, strong) ContentGuideView *contentGuideView;
@property (nonatomic, strong) PLObject *playlist;
@property (nonatomic, strong) NSString *nextPlaylistPageToken;
@property (nonatomic, strong) NSMutableArray *videos;

@property (nonatomic, strong) IBOutlet UIView *viewHeader;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet MarqueeLabel *lblCategoryTitle;

@property (nonatomic, strong) IBOutlet UIView *viewContent;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, retain) MPAdView *adView;
@property (nonatomic, weak) IBOutlet UIView *viewAd1;

@property (nonatomic, strong) STABannerView* bannerView;
@property (nonatomic, weak) IBOutlet UIView *viewAd2;

@property (nonatomic, weak) IBOutlet GADBannerView *viewAdmob;

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;
@end

@implementation GridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(PLObject *)plObject {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.playlist = plObject;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view from its nib.
    [self.lblCategoryTitle setTextColor:TITLE_COLOR];
    [self.lblCategoryTitle setText:self.playlist.plName];
    self.lblCategoryTitle.marqueeType = MLLeftRight;
    self.lblCategoryTitle.rate = 30.0f;
    self.lblCategoryTitle.fadeLength = 10.0f;
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    [self.viewHeader setBackgroundColor:HEADER_COLOR];
    [self.viewContent setBackgroundColor:BACKGROUND_COLOR];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.requestOperationManager = [AFHTTPRequestOperationManager manager];
    self.requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.nextPlaylistPageToken = @"";
    self.isFirstLoad = YES;
    
    UISwipeGestureRecognizer * swipeRightToLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRightToLeft:)];
    swipeRightToLeft.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightToLeft];
    
    [self loadAds1];
    [self loadAds2];
    [self loadAds3];
    [self loadAdmob];
}

- (void)swipeRightToLeft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.contentGuideView) {
        self.contentGuideView = [[ContentGuideView alloc] initWithFrame:self.viewContent.bounds];
        [self.contentGuideView setBackgroundColor:BACKGROUND_COLOR];
        [self.contentGuideView setDataSource:self];
        [self.contentGuideView setDelegate:self];
        [self.viewContent addSubview:self.contentGuideView];
        [self loadYoutubeVideo];
    } else {
        [self updateContentGuideViewFrame];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self setTitle:self.playlist.plName];
}

- (void)showHudLoading {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.hud show:YES];
}

- (void)hideHudLoading {
    [self.hud hide:YES];
}

- (void)loadYoutubeVideo {
    [self showHudLoading];
    if (self.nextPlaylistPageToken) {
        self.nextPlaylistPageToken = [NSString stringWithFormat:@"pageToken=%@&",self.nextPlaylistPageToken];
    }
    NSString *videoUrl = [NSString stringWithFormat:YOUTUBE_PLAYLIST_ITEMS_URL, self.nextPlaylistPageToken, MAX_RESULT, self.playlist.plId, self.appDelegate.configuration.authentication_key];
    [self.requestOperationManager GET:videoUrl parameters:nil
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  self.nextPlaylistPageToken = [responseObject valueForKey:@"nextPageToken"];
                                  self.videos = [VideoObject arrayFromDictionary:responseObject];
                                  [self cookVideos];
                                  if (self.isFirstLoad)
                                  {
                                      [self setIsFirstLoad:NO];
                                      self.playlist.videoArray = self.videos;
                                  }
                                  else
                                  {
                                      [self.playlist.videoArray addObjectsFromArray:self.videos];
                                  }
                                  [self.contentGuideView holdPositionReloadData];
                                  [self hideHudLoading];
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [self hideHudLoading];
                              }];
}

- (void)cookVideos
{
    for (NSInteger i = 0; i < self.videos.count; i++) {
        VideoObject *video = [self.videos objectAtIndex:i];
        if ([video.videoName isEqualToString:DELETED_VIDEO])
        {
            [self.videos removeObjectAtIndex:i];
            i -= 1;
        }
        else
        {
            video.plName = self.playlist.plName;
        }
    }
}

- (void)updateContentGuideViewFrame {
    if (IS_IPAD) {
        CGRect frame = self.contentGuideView.frame;
        if (frame.size.height != self.viewContent.frame.size.height) {
            frame.size.width = self.viewContent.frame.size.width;
            frame.size.height = self.viewContent.frame.size.height;
            [self.contentGuideView setFrame:frame];
            [self.contentGuideView reloadData];
        }
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [self.adView rotateToOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    CGSize size = [self.adView adContentViewSize];
    CGFloat centeredX = (self.view.bounds.size.width - size.width) / 2;
    CGFloat bottomAlignedY = self.view.bounds.size.height - size.height;
    self.adView.frame = CGRectMake(centeredX, bottomAlignedY, size.width, size.height);
    
    [self updateContentGuideViewFrame];
}

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)loadAds1 {
    if (self.appDelegate.configuration.mopub_banner_id.length > 0)
    {
        if (IS_IPAD) {
            self.adView = [[MPAdView alloc] initWithAdUnitId:self.appDelegate.configuration.mopub_banner_id_ipad size:MOPUB_LEADERBOARD_SIZE];
        } else {
            self.adView = [[MPAdView alloc] initWithAdUnitId:self.appDelegate.configuration.mopub_banner_id size:MOPUB_BANNER_SIZE];
        }
        self.adView.delegate = self;
        CGRect frame = self.adView.frame;
        CGSize size = [self.adView adContentViewSize];
        frame.origin.y = self.viewAd1.frame.size.height - size.height;
        self.adView.frame = frame;
        [self.viewAd1 addSubview:self.adView];
        [self.adView loadAd];
    }
}

- (void)loadAds2 {
    if (self.bannerView == nil) {
        if (IS_IPAD) {
            self.bannerView = [[STABannerView alloc] initWithSize:STA_PortraitAdSize_768x90 autoOrigin:STAAdOrigin_Top
                                                         withView:self.viewAd2 withDelegate:nil];
        } else {
            self.bannerView = [[STABannerView alloc] initWithSize:STA_AutoAdSize autoOrigin:STAAdOrigin_Top
                                                         withView:self.viewAd2 withDelegate:nil];
        }
        [self.viewAd2 addSubview:self.bannerView];
    }
}

- (void)loadAdmob {
    self.viewAdmob.adUnitID = self.appDelegate.configuration.admob_banner_id;
    self.viewAdmob.rootViewController = self;
    if (IS_IPAD) {
        self.viewAdmob.adSize = kGADAdSizeLeaderboard;
    } else {
        self.viewAdmob.adSize = kGADAdSizeSmartBannerPortrait;
    }
    [self.viewAdmob loadRequest:[GADRequest request]];
}

- (void)loadAds3 {
    [AP_SDK showAdWithViewController:self withPlacementId:1 isTestMode:NO];
}

#pragma mark ***** ACTION *****
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ContentGuideViewDataSource methods
- (NSUInteger) numberOfPostersInCarousel:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    NSUInteger numberPostAtBottomRow = self.playlist.videoArray.count%_NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_;
    BOOL isBottomRow = contentGuide.numberRows - 1== rowIndex;
    return (isBottomRow && numberPostAtBottomRow > 0) ? numberPostAtBottomRow : _NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_;
}
- (NSUInteger) numberOfRowsInContentGuide:(ContentGuideView*) contentGuide{
    BOOL moreRowAtBottom = (self.playlist.videoArray.count%_NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_) > 0;
    NSUInteger numberRow = moreRowAtBottom?(self.playlist.videoArray.count/_NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_ + 1) : (self.playlist.videoArray.count/_NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_);
    return numberRow;
}
- (ContentGuideViewRow*) contentGuide:(ContentGuideView*) contentGuide
                       rowForRowIndex:(NSUInteger)rowIndex{
    static NSString *identifier = @"ContentGuideViewRowStyleDefault";
    ContentGuideViewRow *row = [contentGuide dequeueReusableRowWithIdentifier:identifier];
    if (!row) {
        row = [[ContentGuideViewRow alloc] initWithStyle:ContentGuideViewRowStyleDefault reuseIdentifier:identifier];
    }
    return row;
}

- (ContentGuideViewRowCarouselViewPosterView*)contentGuide:(ContentGuideView*) contentGuide
                                     posterViewForRowIndex:(NSUInteger)rowIndex
                                           posterViewIndex:(NSUInteger)index{
    static NSString *identifier = @"ContentGuideViewRowCarouselViewPosterViewStyleDefault";
    ContentGuideViewRowCarouselViewPosterView *posterView = [contentGuide dequeueReusablePosterViewWithIdentifier:identifier];
    if (!posterView) {
        posterView = [[ContentGuideViewRowCarouselViewPosterView alloc] initWithStyle:ContentGuideViewRowCarouselViewPosterViewStyleTwoTitles reuseIdentifier:identifier];
    }

    VideoObject *videoObject = [self.playlist.videoArray objectAtIndex:index + rowIndex*_NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_];
    [posterView setTextSubTitlePoster:[NSString stringWithFormat:@"%@ views", videoObject.viewCount]];
    
    [posterView setURLImagePoster:[NSURL URLWithString:videoObject.videoThumbnail] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
    [posterView setTextTitlePoster:videoObject.videoName];
    [posterView setColorTitlePoster:TITLE_COLOR];
    [posterView setColorSubTitlePoster:SUB_TITLE_COLOR];
    return posterView;
}
- (UIView*) topCustomViewForContentGuideView:(ContentGuideView*) contentGuide{
    return nil;
}
-(UIView *)emptyViewForContentGuideView:(ContentGuideView *)contentGuide withParentFrame:(CGRect)parentFrame{
    return nil;
}
- (BOOL)        contentGuide:(ContentGuideView*) contentGuide
 showPullToRefreshAtPosition:(SVPullToRefreshPosition) position{
    switch (position) {
        case SVPullToRefreshPositionTop:
            return NO;
        case SVPullToRefreshPositionBottom:
            return YES;
    }
    return NO;
}
- (NSString*)       contentGuide:(ContentGuideView*) contentGuide
 textForSVPullToRefreshWithState:(SVPullToRefreshState) state{
    switch (state) {
        case SVPullToRefreshStateStopped:
            return _msg_pull_to_refresh_;
        default:
            return _msg_release_to_refresh_;
    }
}
#pragma mark - ContentGuideViewDelegate methods
- (UIColor*)backgroundColorContentRowView:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return BACKGROUND_COLOR;
}
- (CGFloat)heightForContentGuideViewRow:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return contentGuide.frame.size.width/_NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_ - 6;
}
- (CGFloat)widthForContentGuideViewRowCarouselViewPosterView:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return (contentGuide.frame.size.width - (_NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_ + 1)*6)/_NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_;
}
-(CGFloat)pandingTopOfRowHeader:(ContentGuideView *)contentGuide atRowIndex:(NSUInteger)rowIndex{
    return 12;
}
-(CGFloat)spaceBetweenCarouselViewPosterViews:(ContentGuideView *)contentGuide atRowIndex:(NSUInteger)rowIndex{
    return 6;
}
-(CGFloat)offsetYOfFirstRow:(ContentGuideView *)contentGuide{
    return 0;
}
- (void)         contentGuide:(ContentGuideView*) contentGuide
didSelectPosterViewAtRowIndex:(NSUInteger) rowIndex
                  posterIndex:(NSUInteger) index{
    NSInteger selectedIndex = rowIndex*_NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_ + index;
    DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController"
                                                                                  bundle:nil
                                                                           selectedIndex:selectedIndex
                                                                                playlist:self.playlist];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)     contentGuide:(ContentGuideView*) contentGuide
 shouldRefreshCarouselsAt:(SVPullToRefreshPosition) position{
    [self loadYoutubeVideo];
}
- (void)      contentGuide:(ContentGuideView*) contentGuide
didScrollToVisibleRowIndex:(NSUInteger) rowIndex
             withDirection:(ContentGuideViewScrollDirection) direction{
//    NSInteger offset = contentGuide.numberRows;
//    if (offset == rowIndex + 1 &&
//        _album.isLoadMore &&
//        !isLoadingPhotos) {
//        isLoadingPhotos = YES;
//        [self.view addSubview:self.loading];
//        [self.view setUserInteractionEnabled:NO];
//        [self loadMorePhotosWith:_album];
//    }
}

@end
