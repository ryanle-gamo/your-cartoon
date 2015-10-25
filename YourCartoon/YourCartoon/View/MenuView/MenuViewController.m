//
//  MenuViewController.m
//  HowToMakeClay
//
//  Created by Binh Le on 7/9/15.
//  Copyright (c) 2015 gamo. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"

#import "PLObject.h"

@interface MenuViewController ()
@property (nonatomic, weak) IBOutlet UILabel *headerLabel;
@property (nonatomic, weak) IBOutlet UIView *viewHeader;
@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, weak) IBOutlet UITableView *tblMenu;
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withData:(NSMutableArray *)array {
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.menuArray = array;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view from its nib.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.viewHeader setBackgroundColor:MENU_HEADER_COLOR];
    [self.headerLabel setTextColor:TITLE_COLOR];
    int positionY = self.navigationController.navigationBar.frame.size.height + 20;
    CGRect theFrame = self.view.frame;
    theFrame.origin.y = positionY;
    theFrame.size.width = self.view.frame.size.width;
    theFrame.size.height = self.view.frame.size.height - positionY;
    [self.tblMenu setFrame:theFrame];
    [self.tblMenu reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchCancel:(id)sender {
    if ([self.menuDelegate respondsToSelector:@selector(touchCancel)]) {
        [self.menuDelegate touchCancel];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.menuArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (IS_IPAD) {
        return 114;
    }
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CELL_IDENTIFIER";
    MenuTableViewCell *tableViewCell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!tableViewCell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        tableViewCell = [topLevelObjects objectAtIndex:0];
    }
    PLObject *playlist = [self.menuArray objectAtIndex:indexPath.row];
    [tableViewCell initCellWithData:playlist];
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PLObject *playlist = [self.menuArray objectAtIndex:indexPath.row];
    if ([self.menuDelegate respondsToSelector:@selector(touchMenu:)]) {
        [self.menuDelegate touchMenu:playlist];
    }
}

@end
