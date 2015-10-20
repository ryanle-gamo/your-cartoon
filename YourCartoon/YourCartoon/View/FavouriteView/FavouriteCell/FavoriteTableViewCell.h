//
//  FavoriteTableViewCell.h
//  HowToMakeClay
//
//  Created by Binh Le on 7/10/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoObject;
@interface FavoriteTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imgViewThumbnail;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblCategory;
@property (nonatomic, weak) IBOutlet UILabel *lblStep;
- (void)initCellWithData:(VideoObject *)item;
@end
