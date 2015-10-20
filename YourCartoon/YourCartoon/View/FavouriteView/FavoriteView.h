//
//  FavoriteView.h
//  HowToMakeClay
//
//  Created by Binh Le on 6/30/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoObject;

@protocol FavoriteViewDelegate <NSObject>
- (void)touchFavorite:(VideoObject *)item;
@end

@interface FavoriteView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id<FavoriteViewDelegate> favoriteDelegate;
- (void)initUIWithData:(NSMutableArray *)data;
@end
