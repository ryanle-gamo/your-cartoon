//
//  Constants.h
//  CartoonCollector
//
//  Created by Binh Le on 5/31/15.
//  Copyright (c) 2015 Binh Le. All rights reserved.
//

#ifndef Orgit_Constants_h
#define Orgit_Constants_h

#define YOUTUBE_PLAYLIST_URL @"https://www.googleapis.com/youtube/v3/playlists?%@part=snippet&channelId=%@&maxResults=%d&key=%@"
#define YOUTUBE_PLAYLIST_ITEMS_URL @"https://www.googleapis.com/youtube/v3/playlistItems?%@part=snippet&maxResults=%d&playlistId=%@&key=%@"
#define YOUTUBE_VIDEO_URL @"https://www.googleapis.com/youtube/v3/videos?id=%@&part=contentDetails&key=%@"

#define MOPUB_BANNER_ID @"f6c7a56d69a34f78b1b01b22baae368a"
#define AIRPUSH_ID @"289138"
#define STARTAPP_APP_ID @"206835170"
#define STARTAPP_DEV_ID @"101443341"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_HEIGHT == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_WIDTH == 375)
#define IS_IPHONE_6_PLUS (IS_IPHONE && [[UIScreen mainScreen] bounds].size.width == 414)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)

#define RATIO_SCALE_IPHONE ((float)(IS_IPHONE_6?375:(IS_IPHONE_6_PLUS?414:320))/(float)320)
#define _COLOR_TITLE_ITEM_BAR_ UIColorFromRGB(0x61E3F0)
#define _COLOR_TITLE_DISABLE_ITEM_BAR_ UIColorFromRGB(0x929292)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/***************** MAKE CLAY *****************/
#define URL_CONFIGURATION       @"https://raw.githubusercontent.com/ryanle-gamo/crazy_data/master/yourcartoon/yourcartoon_configuration.json"
/***************** MAKE CLAY *****************/

/*
 ** START - CONSTANT OF CONTENT GUIDE VIEWS
 */
#define BACKGROUND_COLOR_ROWHEADER [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]
#define BACKGROUND_COLOR_CONTENTGUIDEVIEW [UIColor colorWithRed:25.0f/255.0f green:38.0f/255.0f blue:44.0f/255.0f alpha:1.0f]
#define PANDING_LEFT_CONTENT_GUIDE_ROW_HEADER_DEFAULT 10
#define PANDING_TOP_OF_ROW_HEADER_DEFAULT 10
#define HEIGHT_TITLE_POSTER_DEFAULT 20
#define HEIGHT_SUB_TITLE_POSTER_DEFAULT 15
#define TEXT_COLOR_TITLE_POSTER_DEFAULT [UIColor colorWithRed:220.0f/255.0f green:198.0f/255.0f blue:152.0f/255.0f alpha:1.0f]
#define TEXT_COLOR_RIGHT_LABEL_POSTER_DEFAULT [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]
#define FONT_TITLE_POSTER_DEFAULT [UIFont fontWithName:@"Arial-BoldMT" size:12.0f]
#define FONT_SUB_TITLE_POSTER_DEFAULT [UIFont fontWithName:@"Arial" size:12.0f]
#define FONT_RIGHT_LABEL_POSTER_DEFAULT [UIFont fontWithName:@"ArialMT" size:16.0f]
#define TIME_AUTO_SCROLLING_PROMOSLIDES_DEFAULT 8
#define _NUMBER_PHOTOS_ITEM_OF_ROW_ (IS_IPAD ? 5 : 3)
#define _NUMBER_ALBUMS_ITEM_OF_ROW_ (IS_IPAD ? 4 : 2.4)
#define _NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_ (IS_IPAD ? 3 : 2)
#define _HEIGHT_HEADER_ALBUMS_OF_ROW_ 30
#define _COLOR_TITLE_CAROUSEL_HEADER_ UIColorFromRGB(0x464B58)
/*
 ** END - CONSTANT OF CONTENT GUIDE VIEWS
 */

/*
 ** START - MAKE CLAY
 */
#define FONT_TITLE_ROW_HEADER_DEFAULT [UIFont fontWithName:@"Arial-BoldMT" size:14.0f]
#define TITLE_COLOR [UIColor colorWithRed:253.0f/255.0f green:253.0f/255.0f blue:253.0f/255.0f alpha:1.0f]
#define SUB_TITLE_COLOR [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f]
#define BACKGROUND_COLOR [UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:29.0f/255.0f alpha:1.0f]
#define HEADER_COLOR [UIColor colorWithRed:27.0f/255.0f green:27.0f/255.0f blue:27.0f/255.0f alpha:1.0f]
#define MENU_HEADER_COLOR [UIColor colorWithRed:89.0f/255.0f green:89.0f/255.0f blue:89.0f/255.0f alpha:1.0f]
#define USERDEFAULT_FAVORITE @"USERDEFAULT_FAVORITE"        //format: categoryId_animeId$$categoryId_animeId
#define USERDEFAULT_DOWNLOADED @"USERDEFAULT_DOWNLOADED"    //format: categoryId_animeId$$categoryId_animeId
#define USERDEFAULT_VERSION @"USERDEFAULT_VERSION"
#define YOUTUBE_THUMBNAIL_IMAGE @"https://img.youtube.com/vi/%@/sddefault.jpg"
/*
 ** END - MAKE CLAY
 */

/*
 ** START - FRAME CUSTOM
 */
#define SET_X_Y_FRAME(_x_, _y_, frameUpdate)   CGRectMake(_x_, _y_, frameUpdate.size.width, frameUpdate.size.height)
#define SET_X_FRAME(_x_, frameUpdate)     CGRectMake(_x_, frameUpdate.origin.y, frameUpdate.size.width, frameUpdate.size.height)
#define SET_Y_FRAME(_y_, frameUpdate)     CGRectMake(frameUpdate.origin.x, _y_, frameUpdate.size.width, frameUpdate.size.height)
#define SET_WIDTH_HEIGHT_FRAME(_width_, _height_, frameUpdate)     CGRectMake(frameUpdate.origin.x, frameUpdate.origin.y, _width_, _height_)
#define SET_WIDTH_FRAME(_width_, frameUpdate)     CGRectMake(frameUpdate.origin.x, frameUpdate.origin.y, _width_, frameUpdate.size.height)
#define SET_HEIGHT_FRAME(_height_, frameUpdate)     CGRectMake(frameUpdate.origin.x, frameUpdate.origin.y, frameUpdate.size.width, _height_)
/*
 ** END - FRAME CUSTOM
 */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBAndAlpha(rgbValue,_alpha) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:_alpha]

#define TOOLBAR_CAMERA_DEFAULT_STYLE_FRAME(parentFrame) CGRectMake(0, parentFrame.size.height - 61*RATIO_SCALE_IPHONE, parentFrame.size.width, 61*RATIO_SCALE_IPHONE)
#define TOOLBAR_CAMERA_CAMERA_STYLE_FRAME(parentFrame) CGRectMake(0, parentFrame.size.height - 81*RATIO_SCALE_IPHONE, parentFrame.size.width, 81*RATIO_SCALE_IPHONE)
#define BOTTOMBAR_FRAME(parentFrame) CGRectMake(0, parentFrame.size.height - 44, parentFrame.size.width, 44)
#define IMPORTBAR_FRAME(parentFrame) CGRectMake(0, 0, parentFrame.size.width, 48)
#define RGBColor(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
/*
 ** START - CONSTANTS OF TRASH VIEW
 */
#define _TRASH_TXT_NOTHING_HERE_ @"Nothing Here!"
#define _TRASH_TXT_DESCRIPTION_1_ @"This is where we store the pictures and videos \n you delete in case you change your mind"
#define _TRASH_TXT_DESCRIPTION_2_ @"Pro tip:\nWhen browsing through pictures in full view,\nswipe up and send them directly here!"
#define _TRASH_TXT_NOTHING_HERE_FONT_ [UIFont fontWithName:@"Arial-BoldMT" size:20.0f]
#define _TRASH_DESCRIPTION_FONT_ [UIFont fontWithName:@"Arial-BoldMT" size:14.0f]
/*
 ** END - CONSTANTS OF TRASH VIEW
 */
/*
 ** START - CONSTANTS OF NAVIGATION BAR VIEW
 */
#define _NAV_CENTER_TITLE_FONT_ [UIFont fontWithName:@"Arial-BoldMT" size:20.0f]
#define _NAV_ABOVE_TITLE_FONT_ [UIFont fontWithName:@"Arial-BoldMT" size:18.0f]
#define _NAV_BELOW_TITLE_FONT_ [UIFont fontWithName:@"ArialMT" size:12.0f]
#define _NAV_BUTTON_TITLE_FONT_ [UIFont fontWithName:@"ArialMT" size:17.0f]
#define _NAV_BACKGROUND_COLOR_ UIColorFromRGB(0x464b58)
#define _NAV_TITLE_CENTER_COLOR_ UIColorFromRGB(0xFFFFFF)
/*
 ** END - CONSTANTS OF NAVIGATION BAR VIEW
 */
#define _BG_COLOR_COMMON_VIEW_ UIColorFromRGB(0xc8c8c8)

#define _ADD_TO_ALBUM_COUNT_ITEMS_FONT_ [UIFont fontWithName:@"ArialMT" size:17.0f]
#define _ADD_TO_ALBUM_TITLE_FONT_ [UIFont fontWithName:@"ArialMT" size:20.0f]
/*
 ** START - CONSTANTS OF CAMERA BAR VIEW
 */
#define _CAMERA_BAR_TITLE_FONT_ [UIFont fontWithName:@"ArialMT" size:12.0f]
#define _BG_CONTROL_ITEM_CAMERA_ [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:.8f]
/*
 ** END - CONSTANTS OF CAMERA BAR VIEW
 */
/*
 ** START - CONSTANTS OF BOTTOM TOOL BAR VIEW
 */
#define _BOTTOM_BAR_BACKGROUND_COLOR_ UIColorFromRGB(0x464b58)
/*
 ** END - CONSTANTS OF BOTTOM TOOL BAR VIEW
 */
/*
 ** START - CONSTANTS OF BOTTOM TOOL BAR VIEW
 */
#define _IMPORT_BAR_BACKGROUND_COLOR_ UIColorFromRGB(0xffffff)
/*
 ** END - CONSTANTS OF BOTTOM TOOL BAR VIEW
 */
/*
 
 ** START - CONSTANTS OF ALBUM DETAIL VIEW
 */
#define _ALBUM_DETAIL_BACKGROUD_IMAGE_DEFAULT_ [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]
#define _ALBUM_DETAIL_SHARED_TITLE_FONT_ [UIFont fontWithName:@"ArialMT" size:25.0f]
#define _ALBUM_DETAIL_BUTTON_FONT_ [UIFont fontWithName:@"ArialMT" size:18.0f]
/*
 ** END - CONSTANTS OF ALBUM DETAIL VIEW
 */
/*
 ** START - CONSTANTS OF Action sheet VIEW
 */
#define _ACTION_SHEET_ITEM_TEXT_COLOR_ [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f]
#define _ACTION_SHEET_BAR_ITEM_TEXT_COLOR_ UIColorFromRGB(0x61E3F0)
#define _ACTION_SHEET_ITEMS_FONT_ [UIFont fontWithName:@"ArialMT" size:18.0f]
/*
 ** END - CONSTANTS OF Action sheet VIEW
 */
/*
 ** START - CONSTANTS OF Tutorial VIEW
 */
#define _TUTORIAL_TINT_COLOR_PAGE_CONTROL_ UIColorFromRGBAndAlpha(0x61E3F0,0.3f)
#define _TUTORIAL_COLOR_PAGE_CONTROL_ UIColorFromRGB(0x61E3F0)
/*
 ** END - CONSTANTS OF Tutorial VIEW
 */

/*
 ** START - CONSTANTS OF Empty album VIEW
 */
#define _EMPTY_ALBUM_CENTER_TITLE_FONT_ [UIFont fontWithName:@"Arial-BoldMT" size:25.0f]
#define _EMPTY_ALBUM_CENTER_TITLE_COLOR_ UIColorFromRGB(0x464B58)
/*
 ** END - CONSTANTS OF Empty album VIEW
 */
#define _INICATOR_COLOL_CONTROL_ UIColorFromRGB(0x61E3F0)

#define _msg_pull_to_refresh_ @"Pull to refresh"
#define _msg_release_to_refresh_ @"Release to refresh"
#define _msg_pull_to_load_more_ @"Pull to load more"
#define _msg_release_to_load_more @"Release to load more"
#endif

