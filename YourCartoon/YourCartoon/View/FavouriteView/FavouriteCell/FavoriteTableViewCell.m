//
//  FavoriteTableViewCell.m
//  HowToMakeClay
//
//  Created by Binh Le on 7/10/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import "FavoriteTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import "VideoObject.h"
#import "ConfigurationObj.h"
#import "Constants.h"

@implementation FavoriteTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    [self.lblTitle setBackgroundColor:[UIColor clearColor]];
    [self.lblTitle setTextColor:TITLE_COLOR];
    [self.lblTitle setFont:FONT_TITLE_POSTER_DEFAULT];
    [self.lblCategory setBackgroundColor:[UIColor clearColor]];
    [self.lblCategory setTextColor:SUB_TITLE_COLOR];
    [self.lblCategory setFont:FONT_SUB_TITLE_POSTER_DEFAULT];
    [self.lblStep setBackgroundColor:[UIColor clearColor]];
    [self.lblStep setTextColor:SUB_TITLE_COLOR];
    [self.lblStep setFont:FONT_SUB_TITLE_POSTER_DEFAULT];
    [self.imgViewThumbnail setContentMode:UIViewContentModeScaleToFill];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCellWithData:(VideoObject *)item {
    [self.lblTitle setText:item.videoName];
    [self.lblCategory setText:item.plName];
    [self.lblStep setText:[NSString stringWithFormat:@"%@ views", item.viewCount]];
    [self.imgViewThumbnail setImageWithURL:[NSURL URLWithString:item.videoThumbnail] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
}

@end
