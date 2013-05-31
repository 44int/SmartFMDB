//
//  MainViewController.h
//  SmartFMDB
//
//  Created by 進藤こだま on 2013/05/20.
//  Copyright (c) 2013年 kodam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartFMDB.h"

@interface MainViewController : UITableViewController
<UITableViewDataSource,UITableViewDelegate>
- (void)reloadTable;
- (IBAction)trancate:(id)sender;
@property(nonatomic,strong) NSArray *tableList;
@end
