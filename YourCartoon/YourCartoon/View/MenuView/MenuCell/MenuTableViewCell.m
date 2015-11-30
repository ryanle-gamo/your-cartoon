//
//  MenuTableViewCell.m
//  HowToMakeClay
//
//  Created by Binh Le on 6/30/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import "MenuTableViewCell.h"
#import "PLObject.h"
#import "VideoObject.h"
#import "ConfigurationObj.h"
#import "UIImageView+AFNetworking.h"
#import "Constants.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.lblItemTitle setFont:FONT_TITLE_ROW_HEADER_DEFAULT];
    [self.lblItemCount setFont:FONT_SUB_TITLE_MENU_CELL];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected sta te
}

- (void)initCellWithData:(PLObject *)object {
    VideoObject *video = [object.videoArray firstObject];
    [self.imgvItemThumbnail setImageWithURL:[NSURL URLWithString:video.videoThumbnail]
                           placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
    [self.imgvItemThumbnail setContentMode:UIViewContentModeScaleAspectFit];
    [self.lblItemTitle setText:object.plName];
    if (IS_IPAD)
    {
        [self.lblItemCount setText:[NSString stringWithFormat:@"%d+ videos", (int)object.videoArray.count]];
    }
}

@end
