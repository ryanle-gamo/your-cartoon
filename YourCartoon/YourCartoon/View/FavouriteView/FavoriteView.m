//
//  FavoriteView.m
//  HowToMakeClay
//
//  Created by Binh Le on 6/30/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import "FavoriteView.h"
#import "FavoriteTableViewCell.h"
#import "VideoObject.h"

@interface FavoriteView()
@property (nonatomic, strong) NSMutableArray *favoriteArray;
@property (nonatomic, strong) UITableView *tblFavorite;
@end

@implementation FavoriteView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tblFavorite = [[UITableView alloc] initWithFrame:self.bounds];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.tblFavorite setBackgroundView:nil];
        [self.tblFavorite setBackgroundColor:[UIColor clearColor]];
        [self.tblFavorite setSeparatorColor:MENU_HEADER_COLOR];
    }
    return self;
}

- (void)initUIWithData:(NSMutableArray *)data {
    self.favoriteArray = data;
    if (!self.favoriteArray) {
        self.favoriteArray = [[NSMutableArray alloc] init];
    }
    [self addSubview:self.tblFavorite];
    
    [self.tblFavorite setDelegate:self];
    [self.tblFavorite setDataSource:self];
    [self.tblFavorite reloadData];
}

- (void)reloadTableView {
    [self.tblFavorite setFrame:self.bounds];
    [self.tblFavorite reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.favoriteArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IPAD) {
        return 115;
    }
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CELL_IDENTIFIER";
    FavoriteTableViewCell *tableViewCell = (FavoriteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!tableViewCell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FavoriteTableViewCell" owner:self options:nil];
        tableViewCell = [topLevelObjects objectAtIndex:0];
    }
    VideoObject *theItem = [self.favoriteArray objectAtIndex:indexPath.row];
    [tableViewCell initCellWithData:theItem];
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VideoObject *theItem = [self.favoriteArray objectAtIndex:indexPath.row];
    if ([self.favoriteDelegate respondsToSelector:@selector(touchFavorite:)]) {
        [self.favoriteDelegate touchFavorite:theItem];
    }
}
@end
