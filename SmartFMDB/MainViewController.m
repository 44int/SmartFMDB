//
//  MainViewController.m
//  SmartFMDB
//
//  Created by 進藤こだま on 2013/05/20.
//  Copyright (c) 2013年 kodam. All rights reserved.
//

#import "MainViewController.h"
#import "EditViewController.h"

@interface MainViewController()
- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.tableList = [SmartFMDB query:@"SELECT * FROM books DESC"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.tableList count];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *item = [self.tableList objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [item objectForKey:@"title"];
	cell.detailTextLabel.text = [item objectForKey:@"auth_name"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    // Update Cell
    [self updateCell:cell atIndexPath:indexPath];
	
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(editingStyle == UITableViewCellEditingStyleDelete){
		NSDictionary *item = [self.tableList objectAtIndex:indexPath.row];
		NSString *query = [NSString stringWithFormat:@"DELETE FROM books WHERE book_id='%@'",[item objectForKey:@"book_id"]];
		[SmartFMDB query:query];
		
		[self reloadTable];
	}
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [[segue identifier] isEqualToString:@"editSegue"] ) {
        EditViewController *vc = [segue destinationViewController];
		vc.parent = self;
    }
}

- (void)reloadTable
{
	self.tableList = [SmartFMDB query:@"SELECT * FROM books DESC"];
	[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
				  withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)trancate:(id)sender
{
	[SmartFMDB truncateTable:@"books"];

	[self reloadTable];
}

@end
