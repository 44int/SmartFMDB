//
//  EditViewController.m
//  SmartFMDB
//
//  Created by 進藤こだま on 2013/05/21.
//  Copyright (c) 2013年 kodam. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    return YES;
}

- (IBAction)save:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{
		NSString *query = [NSString stringWithFormat:@"INSERT INTO books(title,auth_name,public_date) VALUES('%@','%@',NULL)"
						   ,self.title_field.text
						   ,self.author_field.text];
		[SmartFMDB query:query];
		
		if(self.parent){
			[self.parent reloadTable];
		}
	}];
}

- (IBAction)close:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
}

@end
