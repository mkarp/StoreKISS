//
//  RootViewController.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/25/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "RootViewController.h"
#import "DataRequestViewController.h"
#import "PaymentRequestViewController.h"

@interface RootViewController ()

@property (strong, nonatomic) NSArray *rows;

@end

@implementation RootViewController

@synthesize rows;

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = NSLocalizedString(NSStringFromClass([self class]), @"");
	self.rows = [NSArray arrayWithObjects:
				 @"DataRequestViewController",
				 @"PaymentRequestViewController",
				 nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"CellIdentifier";
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
				initWithStyle:UITableViewCellStyleDefault
				reuseIdentifier:cellIdentifier];
    }
	cell.textLabel.text = NSLocalizedString([self.rows objectAtIndex:indexPath.row], @"");
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.rows.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	Class class = NSClassFromString([self.rows objectAtIndex:indexPath.row]);
	UIViewController *controller = [[class alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
}

@end
