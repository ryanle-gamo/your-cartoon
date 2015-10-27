//
//  ViewController.m
//  CartoonCollector
//
//  Created by Binh Le on 5/23/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

#import "ConfigurationObj.h"
#import "PLObject.h"
#import "VideoObject.h"

#import "ContentGuideView.h"
#import "AppDelegate.h"
#import "DataManager.h"

#import "GridViewController.h"
#import "DetailViewController.h"
#import "WebAPI.h"
#import "AP_SDK.h"

#define MAX_RESULT 20

@interface ViewController() <ContentGuideViewDataSource, ContentGuideViewDelegate, MPAdViewDelegate> {
    ContentGuideView *contentGuideView;
    FavoriteView *favoriteView;
    MBProgressHUD *hud;
}

@property (nonatomic) NSInteger playlistCount;
@property (nonatomic, strong) NSString *nextPlaylistPageToken;
@property (nonatomic, strong) NSMutableArray *playlists;

@property (nonatomic, weak) IBOutlet UIView *viewHeader;
@property (nonatomic, weak) IBOutlet UISegmentedControl *sgmBar;


@property (nonatomic, weak) IBOutlet UIView *viewContent;
@property (nonatomic, weak) IBOutlet UIView *viewAll;
@property (nonatomic, weak) IBOutlet UIView *viewContentGuiView;
@property (nonatomic, weak) IBOutlet UIView *viewFavourite;

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, retain) MPAdView *adView;
@property (nonatomic, weak) IBOutlet UIView *viewAd1;

@property (nonatomic, strong) STABannerView* bannerView;
@property (nonatomic, weak) IBOutlet UIView *viewAd2;

@property (nonatomic, weak) IBOutlet GADBannerView *viewAdmob;


@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation ViewController
@synthesize viewContent=_viewContent;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    [self.viewHeader setBackgroundColor:HEADER_COLOR];
    [self.viewContent setBackgroundColor:BACKGROUND_COLOR];
    [self.viewAll setBackgroundColor:[UIColor clearColor]];
    [self.viewFavourite setBackgroundColor:[UIColor clearColor]];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.nextPlaylistPageToken = @"";
    self.playlists = [[NSMutableArray alloc] init];
    
    if (![self checkNetworkStatus]) {
        UIAlertView *thisAlert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Check your connection and try again!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [thisAlert show];
    }
    self.requestOperationManager = [AFHTTPRequestOperationManager manager];
    self.requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
}

- (BOOL)checkNetworkStatus {
    NetworkStatus internetConectionStatus = [[MPReachability reachabilityForInternetConnection] currentReachabilityStatus];
    if (internetConectionStatus == NotReachable){
        return NO;
    }
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!contentGuideView) {
        contentGuideView = [[ContentGuideView alloc] initWithFrame:self.viewContentGuiView.bounds];
        [contentGuideView setBackgroundColor:BACKGROUND_COLOR];
        [contentGuideView setBackground:nil];
        [contentGuideView setDataSource:self];
        [contentGuideView setDelegate:self];
        [self.viewContentGuiView addSubview:contentGuideView];
        [self loadConfiguration];
    }
    
    if (!favoriteView) {
        favoriteView = [[FavoriteView alloc] initWithFrame:self.viewFavourite.bounds];
        favoriteView.favoriteDelegate = self;
        [self.viewFavourite addSubview:favoriteView];
    } else {
        [self loadFavoriteData];
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [AP_SDK stopLoadingAd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadConfiguration {
    [self showHudLoading];
    hud.labelText = @"Loading video...";
    [[WebAPI getShared] loadConfiguration:^(NSError *error) {
        NSLog(@"ERROR IN GETTING CONFIGURATION");
        [self hideHudLoading];
    } onDone:^(NSError *error, id obj) {
        NSDictionary *configureDict = [NSJSONSerialization JSONObjectWithData:obj options:NSJSONReadingAllowFragments error:nil];
        [self.appDelegate.configuration parseFromJsonDictionary:configureDict];
        
        [self loadAdmob];
        [self loadAds1];
        [self loadAds2];
        [self loadAds3];
        
        NSString * currentVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        if (![currentVersion isEqualToString:self.appDelegate.configuration.latest_version]) {
            [self hideHudLoading];
            UIAlertView *thisAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Please download latest version to have best quality videos!"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            [thisAlert show];
        } else {
            [self loadYoutubePlaylist];
        }
        NSLog(@"FINISHED");
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appDelegate.configuration.itune_url]];
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [self.adView rotateToOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    CGSize size = [self.adView adContentViewSize];
    CGFloat centeredX = (self.view.bounds.size.width - size.width) / 2;
    CGFloat bottomAlignedY = self.view.bounds.size.height - size.height;
    self.adView.frame = CGRectMake(centeredX, bottomAlignedY, size.width, size.height);
}

#pragma mark - <MPAdViewDelegate>
- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)loadAds1 {
    if (IS_IPAD) {
        self.adView = [[MPAdView alloc] initWithAdUnitId:MOPUB_BANNER_ID_IPAD size:MOPUB_LEADERBOARD_SIZE];
    } else {
        self.adView = [[MPAdView alloc] initWithAdUnitId:MOPUB_BANNER_ID size:MOPUB_BANNER_SIZE];
    }
    self.adView.delegate = self;
    CGRect frame = self.adView.frame;
    CGSize size = [self.adView adContentViewSize];
    frame.origin.y = self.viewAd1.frame.size.height - size.height;
    self.adView.frame = frame;
    [self.viewAd1 addSubview:self.adView];
    [self.adView loadAd];
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

- (void)loadAds3 {
    [AP_SDK showAdWithViewController:self withPlacementId:1 isTestMode:NO];
}

- (void)loadYoutubePlaylist {
    if (self.nextPlaylistPageToken) {
        self.nextPlaylistPageToken = [NSString stringWithFormat:@"pageToken=%@&",self.nextPlaylistPageToken];
    }
    NSString *youtubeUrl = [NSString stringWithFormat:YOUTUBE_PLAYLIST_URL, self.nextPlaylistPageToken, self.appDelegate.configuration.channel_id, MAX_RESULT, self.appDelegate.configuration.authentication_key];
    [self.requestOperationManager GET:youtubeUrl parameters:nil
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          self.nextPlaylistPageToken = [responseObject valueForKey:@"nextPageToken"];
          self.playlists = [PLObject arrayFromDictionary:responseObject];
          self.playlistCount = 0;
          for (PLObject *playlistObject in self.playlists) {
              [self loadYoutubeVideoWithPlaylistId:playlistObject.plId];
          }
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [self hideHudLoading];
      }];
}

- (void)loadYoutubeVideoWithPlaylistId:(NSString *)playlistId {
    NSString *videoUrl = [NSString stringWithFormat:YOUTUBE_PLAYLIST_ITEMS_URL, @"", MAX_RESULT, playlistId, self.appDelegate.configuration.authentication_key];
    [self.requestOperationManager GET:videoUrl parameters:nil
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  NSMutableArray *videos = [VideoObject arrayFromDictionary:responseObject];
                                  // get playlist ID of current thread, just need to get first video in this result array
                                  VideoObject *firstObject = (VideoObject*)[videos firstObject];
                                  PLObject *playlist = [self getPlaylistWithId:firstObject.plId];
                                  self.playlistCount += 1;
                                  if (playlist) {
                                      NSUInteger currentIndex = [self.playlists indexOfObject:playlist];
                                      // get exact playlist in playlist array
                                      PLObject *thePlaylist = ((PLObject*)self.playlists[currentIndex]);
                                      thePlaylist.videoArray = videos;
                                      if (self.playlistCount == self.playlists.count) {
                                          [self cookVideos];
                                          [self.appDelegate.youtubeVideos addObjectsFromArray:thePlaylist.videoArray];
                                          [self.appDelegate.youtubePlaylists addObjectsFromArray:self.playlists];
                                          [contentGuideView holdPositionReloadData];
                                          [self hideHudLoading];
                                      }
                                  }
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [self hideHudLoading];
                              }];
}

- (PLObject *)getPlaylistWithId:(NSString *)playlistId {
    for (PLObject *playlist in self.playlists) {
        if ([playlist.plId isEqualToString:playlistId]) {
            return playlist;
        }
    }
    return nil;
}

- (void)cookVideos
{
    for (PLObject *playlist in self.playlists) {
        NSMutableArray *videos = playlist.videoArray;
        for (VideoObject *video in videos) {
            video.plName = playlist.plName;
        }
    }
}

- (void)loadFavoriteData {
    NSMutableArray *theArray = [[DataManager getSharedInstance] getFavoriteArray];
    [favoriteView initUIWithData:theArray];
}

- (void)showHudLoading {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
}

- (void)hideHudLoading {
    [hud hide:YES];
}

- (void)dismissController {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)touchMenu:(PLObject *)plObject {
    [self dismissController];
    GridViewController *viewController = [[GridViewController alloc] initWithNibName:@"GridViewController"
                                                                              bundle:nil
                                                                            withData:plObject];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)touchFavorite:(VideoObject *)videoObject {
    DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController"
                                                                                  bundle:nil
                                                                           selectedVideo:videoObject];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)touchCancel {
    [self dismissController];
}

- (IBAction)menuAction:(id)sender {
    MenuViewController *menuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController"
                                                                                  bundle:nil
                                                                                withData:self.appDelegate.youtubePlaylists];
    menuViewController.menuDelegate = self;
    [self.navigationController presentViewController:menuViewController animated:YES completion:^{
    }];
}

- (IBAction)segmentChange:(id)sender {
    if (self.sgmBar.selectedSegmentIndex == 0) {
        [self.viewAll setHidden:NO];
        [self.viewFavourite setHidden:YES];
    } else {
        [self loadFavoriteData];
        [self.viewAll setHidden:YES];
        [self.viewFavourite setHidden:NO];
    }
}

#pragma mark - ContentGuideViewDataSource methods
- (NSUInteger) numberOfPostersInCarousel:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    PLObject *playlistObject = [self.appDelegate.youtubePlaylists objectAtIndex:rowIndex];
    return [playlistObject.videoArray count];
}
- (NSUInteger) numberOfRowsInContentGuide:(ContentGuideView*) contentGuide{
    return [self.appDelegate.youtubePlaylists count];
}
- (ContentGuideViewRowHeader*) contentGuide:(ContentGuideView*) contentGuide
                       rowHeaderForRowIndex:(NSUInteger)rowIndex{
    static NSString *identifier = @"ContentGuideViewRowHeaderStyleDefault";
    ContentGuideViewRowHeader *header = [contentGuide dequeueReusableRowHeaderWithIdentifier:identifier];
    if (!header) {
        header = [[ContentGuideViewRowHeader alloc] initWithStyle:ContentGuideViewRowHeaderStyleDefault reuseIdentifier:identifier];
    }
    
    PLObject *playlistObject = [self.appDelegate.youtubePlaylists objectAtIndex:rowIndex];
    
    [header prepareForReuse];
    [header setTextTitleRowHeader:playlistObject.plName];
    [header setColorTextTitleRowHeader:TITLE_COLOR];
    [header setBackground:nil];
    [header setBackgroundColor:BACKGROUND_COLOR];
    [header setTxtOpen:nil withIcon:[UIImage imageNamed:@"btn_open_gray.png"]];
    return header;
}
- (ContentGuideViewRow*) contentGuide:(ContentGuideView*) contentGuide
                       rowForRowIndex:(NSUInteger)rowIndex{
    static NSString *identifier = @"ContentGuideViewRowStyleDefault";
    ContentGuideViewRow *row = [contentGuide dequeueReusableRowWithIdentifier:identifier];
    if (!row) {
        row = [[ContentGuideViewRow alloc] initWithStyle:ContentGuideViewRowStyleDefault reuseIdentifier:identifier];
    }
    [row prepareForReuse];
    return row;
}

- (ContentGuideViewRowCarouselViewPosterView*)contentGuide:(ContentGuideView*) contentGuide
                                     posterViewForRowIndex:(NSUInteger)rowIndex
                                           posterViewIndex:(NSUInteger)index{
    static NSString *identifier = @"ContentGuideViewRowCarouselViewPosterViewStyleDefault";
    ContentGuideViewRowCarouselViewPosterView *posterView = [contentGuide dequeueReusablePosterViewWithIdentifier:identifier];
    if (!posterView) {
        posterView = [[ContentGuideViewRowCarouselViewPosterView alloc] initWithStyle:ContentGuideViewRowCarouselViewPosterViewStyleDefault reuseIdentifier:identifier];
    }
    PLObject *playlistObject = [self.appDelegate.youtubePlaylists objectAtIndex:rowIndex];
    VideoObject *videoObject = [playlistObject.videoArray objectAtIndex:index];
    [posterView setURLImagePoster:[NSURL URLWithString:videoObject.videoThumbnail]
                 placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
    [posterView setTextTitlePoster:videoObject.videoName];
    [posterView setColorTitlePoster:SUB_TITLE_COLOR];
    return posterView;
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
- (UIView*) emptyViewForContentGuideView:(ContentGuideView*) contentGuide withParentFrame:(CGRect)parentFrame{
    return nil;
}
- (BOOL) contentGuide:(ContentGuideView*) contentGuide
           showWating:(ContentGuideViewRow*) viewRow{
    return NO;
}
#pragma mark - ContentGuideViewDelegate methods
- (UIColor*)backgroundColorContentRowView:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return BACKGROUND_COLOR;
}
- (CGFloat)heightForContentGuideViewRow:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return contentGuide.frame.size.width/_NUMBER_ALBUMS_ITEM_OF_ROW_ - PANDING_LEFT_CONTENT_GUIDE_ROW_HEADER_DEFAULT + _HEIGHT_HEADER_ALBUMS_OF_ROW_;
}
- (CGFloat)heightForContentGuideViewRowHeader:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return _HEIGHT_HEADER_ALBUMS_OF_ROW_;
}
- (CGFloat)widthForContentGuideViewRowCarouselViewPosterView:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return (contentGuide.frame.size.width - (PANDING_LEFT_CONTENT_GUIDE_ROW_HEADER_DEFAULT + 1)*_NUMBER_ALBUMS_ITEM_OF_ROW_)/_NUMBER_ALBUMS_ITEM_OF_ROW_;
}
-(CGFloat)spaceBetweenCarouselViewPosterViews:(ContentGuideView *)contentGuide atRowIndex:(NSUInteger)rowIndex{
    return PANDING_LEFT_CONTENT_GUIDE_ROW_HEADER_DEFAULT;
}
- (CGFloat)pandingBottomOfPosterView:(ContentGuideView*) contentGuide atRowIndex:(NSUInteger) rowIndex{
    return PANDING_LEFT_CONTENT_GUIDE_ROW_HEADER_DEFAULT/2;
}
- (CGFloat)pandingTopOfRowHeader:(ContentGuideView*) contentGuide  atRowIndex:(NSUInteger) rowIndex{
    return 0;
}
- (void)         contentGuide:(ContentGuideView*) contentGuide
didSelectPosterViewAtRowIndex:(NSUInteger) rowIndex
                  posterIndex:(NSUInteger) index{
    PLObject *playlistObject = [self.appDelegate.youtubePlaylists objectAtIndex:rowIndex];
    DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil selectedIndex:index playlist:playlistObject];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)  contentGuide:(ContentGuideView*) contentGuide
          didTapBtOpen:(ContentGuideViewRow*) viewRow{
    PLObject *playlistObject = [self.appDelegate.youtubePlaylists objectAtIndex:viewRow.rowIndex];
    GridViewController *viewController = [[GridViewController alloc] initWithNibName:@"GridViewController"
                                                                              bundle:nil
                                                                            withData:playlistObject];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)     contentGuide:(ContentGuideView*) contentGuide
 shouldRefreshCarouselsAt:(SVPullToRefreshPosition) position {
    [self showHudLoading];
    [self loadYoutubePlaylist];
}
-(void)didTapGestureContentGuide:(ContentGuideView *)contentGuide{
    [self.view endEditing:YES];
}
-(void)shouldHideEmptyViewForContentGuideView:(ContentGuideView *)contentGuide{
//    [self showOrHideEmptyAlbumView];
}

@end
