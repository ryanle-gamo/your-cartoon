//
//  DetailViewController.m
//  HowToMakeClay
//
//  Created by Binh Le on 7/6/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import "DetailViewController.h"

#import "AppDelegate.h"
#import "DataManager.h"

#import "ConfigurationObj.h"
#import "VideoObject.h"
#import "PLObject.h"

@interface DetailViewController ()<MPAdViewDelegate> {
    MBProgressHUD *hud;
}

@property (nonatomic, strong) IBOutlet UIView *viewHeader;
@property (nonatomic, strong) IBOutlet UIButton *btnBack;
@property (nonatomic, strong) IBOutlet MarqueeLabel *lblDetailTitle;
@property (nonatomic, strong) IBOutlet UIButton *btnFavorite;
@property (nonatomic, strong) IBOutlet UIButton *btnFavorite4s;

@property (nonatomic, strong) IBOutlet UIView *viewContent;
@property (nonatomic, strong) IBOutlet UIView *viewContentVideo;
@property (nonatomic, strong) IBOutlet UIWebView *webViewVideo;
@property (nonatomic, strong) IBOutlet UIButton *videoPreviousButton;
@property (nonatomic, strong) IBOutlet UIButton *videoNextButton;

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) PLObject *selectedPlaylist;
@property (nonatomic, strong) VideoObject *selectedVideo;
@property (nonatomic, strong) AppDelegate *appDelegate;

@property (nonatomic, retain) MPAdView *adView;
@property (nonatomic, weak) IBOutlet UIView *viewAd1;

@property (nonatomic, strong) STABannerView* bannerView;
@property (nonatomic, weak) IBOutlet UIView *viewAd2;

@property (nonatomic, weak) IBOutlet GADBannerView *viewAdmob;
@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
        selectedIndex:(NSInteger )selectedIndex
             playlist:(id)playlist {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.selectedIndex = selectedIndex;
    self.selectedPlaylist = playlist;
    self.selectedVideo = [self.selectedPlaylist.videoArray objectAtIndex:self.selectedIndex];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil selectedVideo:(VideoObject *)video {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.selectedVideo = video;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    [self.viewHeader setBackgroundColor:HEADER_COLOR];
    [self.viewContent setBackgroundColor:BACKGROUND_COLOR];
    if (!IS_IPHONE_4_OR_LESS) {
        [self.btnFavorite4s setEnabled:NO];
        [self.btnFavorite4s setHidden:YES];
    }

    [self.lblDetailTitle setTextColor:TITLE_COLOR];
    self.lblDetailTitle.marqueeType = MLLeftRight;
    self.lblDetailTitle.rate = 30.0f;
    self.lblDetailTitle.fadeLength = 10.0f;
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BOOL isFavorited = [[DataManager getSharedInstance] isExistedInFavoriteArrayForObject:self.selectedVideo];
    [self markFavorite:isFavorited];
    
    if (self.selectedPlaylist) {
        if (self.selectedIndex == 0) {
            [self.videoPreviousButton setEnabled:NO];
            [self.videoNextButton setEnabled:YES];
        }
        else if (self.selectedIndex == [self.selectedPlaylist.videoArray count] - 1) {
            [self.videoPreviousButton setEnabled:YES];
            [self.videoNextButton setEnabled:NO];
        }
    } else {
        [self.videoPreviousButton setEnabled:NO];
        [self.videoNextButton setEnabled:NO];
    }
    
    [self loadAdmob];
    [self loadAds1];
    [self loadAds2];
    [self playYoutubeVideo];
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playYoutubeVideo {
    [self.lblDetailTitle setText:self.selectedVideo.videoName];
    NSString *embbedLink = [NSString stringWithFormat:@"https://www.youtube.com/embed/%@",self.selectedVideo.videoId];
    NSString *videoHTML = [NSString stringWithFormat:@"\
                           <html>\
                           <head>\
                           <style type=\"text/css\">\
                           iframe {position:absolute;}\
                           body {background-color:#000; margin:0;}\
                           </style>\
                           </head>\
                           <body>\
                           <iframe width=\"100%%\" height=\"280px\" src=\"%@\" frameborder=\"0\"></iframe>\
                           </body>\
                           </html>", embbedLink];
    
    [self.webViewVideo loadHTMLString:videoHTML baseURL:nil];
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
    self.adView = [[MPAdView alloc] initWithAdUnitId:MOPUB_BANNER_ID size:MOPUB_BANNER_SIZE];
    self.adView.delegate = self;
    CGRect frame = self.adView.frame;
    CGSize size = [self.adView adContentViewSize];
    frame.origin.y = self.viewAd1.frame.size.height - size.height;
    self.adView.frame = frame;
    [self.viewAd1 addSubview:self.adView];
    [self.adView loadAd];
}

- (void)loadAds2 {
    STAStartAppSDK* sdk = [STAStartAppSDK sharedInstance];
    sdk.appID = self.appDelegate.configuration.startapp_app_id;
    if (self.bannerView == nil) {
        self.bannerView = [[STABannerView alloc] initWithSize:STA_AutoAdSize autoOrigin:STAAdOrigin_Top
                                                     withView:self.viewAd2 withDelegate:nil];
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

- (void)showHudLoading {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud show:YES];
}

- (void)hideHudLoading {
    [hud hide:YES];
}

- (void)markFavorite:(BOOL)value {
    if (!IS_IPHONE_4_OR_LESS) {
        if (value) {
            [self.btnFavorite setBackgroundImage:[UIImage imageNamed:@"btn_favourite.png"] forState:UIControlStateNormal];
            [self.btnFavorite setTag:1];
        } else {
            [self.btnFavorite setBackgroundImage:[UIImage imageNamed:@"btn_unfavourite.png"] forState:UIControlStateNormal];
            [self.btnFavorite setTag:0];
        }
    } else {
        if (value) {
            [self.btnFavorite4s setBackgroundImage:[UIImage imageNamed:@"btn_favourite.png"] forState:UIControlStateNormal];
            [self.btnFavorite4s setTag:1];
        } else {
            [self.btnFavorite4s setBackgroundImage:[UIImage imageNamed:@"btn_unfavourite.png"] forState:UIControlStateNormal];
            [self.btnFavorite4s setTag:0];
        }
    }
}

- (IBAction)favoriteAction:(id)sender {
    if (!IS_IPHONE_4_OR_LESS) {
        if (self.btnFavorite.tag == 1) {
            [self.btnFavorite setTag:0];
            [[DataManager getSharedInstance] removeFavoriteWithObject:self.selectedVideo];
        } else {
            [self.btnFavorite setTag:1];
            [[DataManager getSharedInstance] addFavoriteWithObject:self.selectedVideo];
        }
        [self markFavorite:self.btnFavorite.tag];
    } else {
        if (self.btnFavorite4s.tag == 1) {
            [self.btnFavorite4s setTag:0];
            [[DataManager getSharedInstance] removeFavoriteWithObject:self.selectedVideo];
        } else {
            [self.btnFavorite4s setTag:1];
            [[DataManager getSharedInstance] addFavoriteWithObject:self.selectedVideo];
        }
        [self markFavorite:self.btnFavorite4s.tag];
    }
}

- (IBAction)videoPreviousAction:(id)sender {
    NSInteger index = self.selectedIndex - 1;
    if (index >= 0) {
        self.selectedIndex = index;
        if (self.selectedIndex == 0) {
            [self.videoPreviousButton setEnabled:NO];
        }
        [self.videoNextButton setEnabled:YES];
        self.selectedVideo = [self.selectedPlaylist.videoArray objectAtIndex:self.selectedIndex];
        BOOL isFavorited = [[DataManager getSharedInstance] isExistedInFavoriteArrayForObject:self.selectedVideo];
        [self markFavorite:isFavorited];
        [self playYoutubeVideo];
    }
}

- (IBAction)videoNextAction:(id)sender {
    NSInteger index = self.selectedIndex + 1;
    if (index < [self.selectedPlaylist.videoArray count]) {
        self.selectedIndex = index;
        if (self.selectedIndex == ([self.selectedPlaylist.videoArray count] - 1)) {
            [self.videoNextButton setEnabled:NO];
        }
        [self.videoPreviousButton setEnabled:YES];
        self.selectedVideo = [self.selectedPlaylist.videoArray objectAtIndex:self.selectedIndex];
        BOOL isFavorited = [[DataManager getSharedInstance] isExistedInFavoriteArrayForObject:self.selectedVideo];
        [self markFavorite:isFavorited];
        [self playYoutubeVideo];
    }
}

#pragma mark ***** ACTION *****
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
