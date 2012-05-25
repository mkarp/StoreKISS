//
//  StoreKISSDataRequestTestViewController.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/25/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "StoreKISSDataRequestTestViewController.h"
#import "StoreKISSDataRequestView.h"
#import "StoreKISSDataRequest.h"

NSString * const nonConsumableProductIdentifier1 = @"com.redigion.storekiss.nonconsumable1";
NSString * const nonConsumableProductIdentifier2 = @"com.redigion.storekiss.nonconsumable2";
NSString * const statusNA = @"N/A";
NSString * const statusSuccess = @"Success";
NSString * const statusExecuting = @"Executing";
NSString * const statusFailure = @"Failure";

@interface StoreKISSDataRequestTestViewController ()

@property (unsafe_unretained, nonatomic) StoreKISSDataRequestView *storeKISSDataRequestView;
@property (strong, nonatomic) StoreKISSDataRequest *request;

@end

@implementation StoreKISSDataRequestTestViewController

@synthesize storeKISSDataRequestView,
request;

- (id)init
{
	self = [super init];
	if (self) {
		self.request = [[StoreKISSDataRequest alloc] init];
	}
	return self;
}

#pragma mark - View Lifecycle

- (void)loadView
{
	[super loadView];
	
	self.view = [[StoreKISSDataRequestView alloc] init];
	self.storeKISSDataRequestView = (StoreKISSDataRequestView *)self.view;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(NSStringFromClass([self class]), @"");
	
	[self.storeKISSDataRequestView.launchSingleButton
	 addTarget:self
	 action:@selector(launchButtonOnTouchUpInside:)
	 forControlEvents:UIControlEventTouchUpInside];
	
	[self.storeKISSDataRequestView.launchBulkButton
	 addTarget:self
	 action:@selector(launchBulkButtonOnTouchUpInside:)
	 forControlEvents:UIControlEventTouchUpInside];
	
	self.storeKISSDataRequestView.statusLabel.text = NSLocalizedString(statusNA, @"");
	self.storeKISSDataRequestView.statusLabel.textColor = [UIColor blackColor];
}

#pragma mark - Events

- (void)launchButtonOnTouchUpInside:(id)sender
{
	self.storeKISSDataRequestView.statusLabel.text = NSLocalizedString(statusExecuting, @"");
	self.storeKISSDataRequestView.statusLabel.textColor = [UIColor blackColor];
	
	[self log:[NSString stringWithFormat:@"Requesting data for Product ID %@...", nonConsumableProductIdentifier1]];
	
	[self.request
	 requestDataForItemWithProductId:nonConsumableProductIdentifier1
	 success:^(StoreKISSDataRequest *request,
			   SKProductsResponse *response) {
		 NSString *result = NSLocalizedString(statusSuccess, @"");
		 if (response.products.count == 1) {
			 result = [result stringByAppendingFormat:@" %@",
					   ((SKProduct *)[response.products objectAtIndex:0]).productIdentifier];
		 }
		 
		 self.storeKISSDataRequestView.statusLabel.text = result;
		 self.storeKISSDataRequestView.statusLabel.textColor = [UIColor greenColor];
		 
		 [self log:@"Finished with success"];
		 [self log:[NSString stringWithFormat:@"Products %@", response.products]];
		 [self log:[NSString stringWithFormat:@"InvalidProductIdentifiers %@", response.invalidProductIdentifiers]];
	 } failure:^(NSError *error) {
		 self.storeKISSDataRequestView.statusLabel.text = NSLocalizedString(statusFailure, @"");
		 self.storeKISSDataRequestView.statusLabel.textColor = [UIColor redColor];
		 
		 [self log:@"Finished with error"];
		 [self log:[NSString stringWithFormat:@"%@", error.localizedDescription]]; 
	 }];
}

- (void)launchBulkButtonOnTouchUpInside:(id)sender
{
	self.storeKISSDataRequestView.statusLabel.text = NSLocalizedString(statusExecuting, @"");
	self.storeKISSDataRequestView.statusLabel.textColor = [UIColor blackColor];
	
	[self log:[NSString stringWithFormat:@"Requesting data for Product IDs...", nonConsumableProductIdentifier1]];
	
	[self.request
	 requestDataForItemsWithProductIds:[NSSet setWithObjects:
										nonConsumableProductIdentifier1, 
										nonConsumableProductIdentifier2, 
										nil]
	 success:^(StoreKISSDataRequest *request,
			   SKProductsResponse *response) {
		 NSString *result = NSLocalizedString(statusSuccess, @"");
		 if (response.products.count == 2) {
			 result = [result stringByAppendingFormat:@" %@ %@",
					   ((SKProduct *)[response.products objectAtIndex:0]).productIdentifier,
					   ((SKProduct *)[response.products objectAtIndex:1]).productIdentifier];
		 }
		 
		 self.storeKISSDataRequestView.statusLabel.text = result;
		 self.storeKISSDataRequestView.statusLabel.textColor = [UIColor greenColor];
		 
		 [self log:@"Finished with success"];
		 [self log:[NSString stringWithFormat:@"Products %@", response.products]];
		 [self log:[NSString stringWithFormat:@"InvalidProductIdentifiers %@", response.invalidProductIdentifiers]];
	 } failure:^(NSError *error) {
		 self.storeKISSDataRequestView.statusLabel.text = NSLocalizedString(statusFailure, @"");
		 self.storeKISSDataRequestView.statusLabel.textColor = [UIColor redColor];
		 
		 [self log:@"Finished with error"];
		 [self log:[NSString stringWithFormat:@"%@", error.localizedDescription]]; 
	 }];
}

#pragma mark - Misc

- (void)log:(NSString *)message
{
	self.storeKISSDataRequestView.logTextView.text = [self.storeKISSDataRequestView.logTextView.text 
													  stringByAppendingFormat:@"%@\r\n\r\n", message];
}

@end
