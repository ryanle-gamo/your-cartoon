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


////######## YOUCARTOON #######
//#define URL_CONFIGURATION @"https://raw.githubusercontent.com/ryanle-gamo/crazy_data/master/youcartoon/youcartoon_configuration.json"
//#define AIRPUSH_ID @"289138"
//#define STARTAPP_APP_ID @"206835170"
//#define STARTAPP_DEV_ID @"101443341"
//
//#define TITLE_COLOR [UIColor colorWithRed:253.0f/255.0f green:253.0f/255.0f blue:253.0f/255.0f alpha:1.0f]
//#define SUB_TITLE_COLOR [UIColor colorWithRed:161.0f/255.0f green:161.0f/255.0f blue:161.0f/255.0f alpha:1.0f]
//#define BACKGROUND_COLOR [UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:29.0f/255.0f alpha:1.0f]
//#define HEADER_COLOR [UIColor colorWithRed:27.0f/255.0f green:27.0f/255.0f blue:27.0f/255.0f alpha:1.0f]
//#define MENU_HEADER_COLOR [UIColor colorWithRed:89.0f/255.0f green:89.0f/255.0f blue:89.0f/255.0f alpha:1.0f]
//#define TEXT_STATUS_COLOR 1
//
//#define BACKGROUND_COLOR_ROWHEADER [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]
////######## END YOUCARTOON #######

//######## ENGLISH VIDEOS #######
#define URL_CONFIGURATION @"https://raw.githubusercontent.com/ryanle-gamo/crazy_data/master/englishvideos/englishvideos_configuration.json"
#define AIRPUSH_ID @"289138"
#define STARTAPP_APP_ID @"206835170"
#define STARTAPP_DEV_ID @"101443341"

#define TITLE_COLOR [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f]
#define SUB_TITLE_COLOR [UIColor colorWithRed:120.0f/255.0f green:127.0f/255.0f blue:133.0f/255.0f alpha:1.0f]
#define BACKGROUND_COLOR [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]
#define HEADER_COLOR [UIColor colorWithRed:249.0f/255.0f green:249.0f/255.0f blue:249.0f/255.0f alpha:1.0f]
#define MENU_HEADER_COLOR [UIColor colorWithRed:249.0f/255.0f green:249.0f/255.0f blue:249.0f/255.0f alpha:1.0f]
#define STATUS_BAR_COLOR_INDEX 0

#define BACKGROUND_COLOR_ROWHEADER [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]
//######## END ENGLISH VIDEOS #######

#define FONT_TITLE_ROW_HEADER_DEFAULT [UIFont fontWithName:@"Helvetica" size:14.0f]
#define IPAD_FONT_TITLE_ROW_HEADER_DEFAULT [UIFont fontWithName:@"Helvetica" size:16.0f]
#define FONT_TITLE_POSTER_DEFAULT [UIFont fontWithName:@"Helvetica" size:12.0f]
#define FONT_SUB_TITLE_POSTER_DEFAULT [UIFont fontWithName:@"Helvetica-Light" size:12.0f]
#define IPAD_FONT_TITLE_POSTER_DEFAULT [UIFont fontWithName:@"Helvetica" size:14.0f]
#define IPAD_FONT_SUB_TITLE_POSTER_DEFAULT [UIFont fontWithName:@"Helvetica-Light" size:14.0f]

#define PANDING_LEFT_CONTENT_GUIDE_ROW_HEADER_DEFAULT 10
#define HEIGHT_TITLE_POSTER_DEFAULT 20
#define HEIGHT_SUB_TITLE_POSTER_DEFAULT 15

#define _NUMBER_ALBUMS_ITEM_OF_ROW_ (IS_IPAD ? 4 : 2.4)
#define _NUMBER_DETAIL_ALBUM_ITEM_OF_ROW_ (IS_IPAD ? 3 : 2)
#define _HEIGHT_HEADER_ALBUMS_OF_ROW_ 30

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
#define RGBColor(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define _msg_pull_to_refresh_ @"Pull to refresh"
#define _msg_release_to_refresh_ @"Release to refresh"
#define DELETED_VIDEO @"Deleted video"
#define USERDEFAULT_FAVORITE @"USERDEFAULT_FAVORITE"
#define USERDEFAULT_DOWNLOADED @"USERDEFAULT_DOWNLOADED"
#define USERDEFAULT_VERSION @"USERDEFAULT_VERSION"
#define YOUTUBE_THUMBNAIL_IMAGE @"https://img.youtube.com/vi/%@/sddefault.jpg"
#endif

