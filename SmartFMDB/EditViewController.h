//
//  EditViewController.h
//  SmartFMDB
//
//  Created by 進藤こだま on 2013/05/21.
//  Copyright (c) 2013年 kodam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SmartFMDB.h"

@interface EditViewController : UIViewController
<UITextFieldDelegate>
- (IBAction)save:(id)sender;
- (IBAction)close:(id)sender;
@property(nonatomic,strong) IBOutlet UITextField *title_field;
@property(nonatomic,strong) IBOutlet UITextField *author_field;
@property(nonatomic,weak) MainViewController *parent;
@end
