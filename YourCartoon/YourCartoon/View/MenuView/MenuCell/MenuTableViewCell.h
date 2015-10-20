//
//  MenuTableViewCell.h
//  HowToMakeClay
//
//  Created by Binh Le on 6/30/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLObject;
@interface MenuTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *imgvItemThumbnail;
@property (nonatomic, weak) IBOutlet UILabel *lblItemTitle;
@property (nonatomic, weak) IBOutlet UILabel *lblItemCount;
- (void)initCellWithData:(PLObject *)object;
@end
