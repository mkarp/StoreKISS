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
NSString * const notificationStatusNA = @"N/A";
NSString * const notificationStatusSuccess = @"Success";
NSString * const notificationStatusFailure = @"Failure";

@interface StoreKISSDataRequestTestViewController ()

@property (unsafe_unretained, nonatomic) StoreKISSDataRequestView *requestView;
@property (strong, nonatomic) StoreKISSDataRequest *request;

@end

@implementation StoreKISSDataRequestTestViewController

@synthesize requestView,
request;

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:StoreKISSNotificationDataRequestStarted
	 object:nil];
	
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:StoreKISSNotificationDataRequestSuccess
	 object:nil];
	
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:StoreKISSNotificationDataRequestFailure
	 object:nil];
}

- (id)init
{
	self = [super init];
	if (self) {
		self.request = [[StoreKISSDataRequest alloc] init];
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(didReceiveDataRequestNotification:)
		 name:StoreKISSNotificationDataRequestStarted
		 object:nil];
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(didReceiveDataRequestNotification:)
		 name:StoreKISSNotificationDataRequestSuccess
		 object:nil];
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(didReceiveDataRequestNotification:)
		 name:StoreKISSNotificationDataRequestFailure
		 object:nil];
	}
	return self;
}

#pragma mark - View Lifecycle

- (void)loadView
{
	[super loadView];
	
	self.view = [[StoreKISSDataRequestView alloc] init];
	self.requestView = (StoreKISSDataRequestView *)self.view;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(NSStringFromClass([self class]), @"");
	
	[self.requestView.launchSingleButton
	 addTarget:self
	 action:@selector(launchButtonOnTouchUpInside:)
	 forControlEvents:UIControlEventTouchUpInside];
	
	[self.requestView.launchBulkButton
	 addTarget:self
	 action:@selector(launchBulkButtonOnTouchUpInside:)
	 forControlEvents:UIControlEventTouchUpInside];
	
	self.requestView.statusLabel.text = statusNA;
	self.requestView.statusLabel.textColor = [UIColor blackColor];
	
	self.requestView.notificationStatusLabel.text = notificationStatusNA;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

#pragma mark - Events

- (void)launchButtonOnTouchUpInside:(id)sender
{
	self.requestView.statusLabel.text = statusExecuting;
	self.requestView.statusLabel.textColor = [UIColor blackColor];
	
	[self log:[NSString stringWithFormat:@"Requesting data for Product ID %@...", nonConsumableProductIdentifier1]];
	
	[self.request
	 requestDataForItemWithProductId:nonConsumableProductIdentifier1
	 success:^(StoreKISSDataRequest *request,
			   SKProductsResponse *response) {
		 NSString *result = statusSuccess;
		 if (response.products.count == 1) {
			 result = [result stringByAppendingFormat:@" %@",
					   ((SKProduct *)[response.products objectAtIndex:0]).productIdentifier];
		 }
		 
		 self.requestView.statusLabel.text = result;
		 self.requestView.statusLabel.textColor = [UIColor greenColor];
		 
		 [self log:@"Finished with success"];
		 [self log:[NSString stringWithFormat:@"Products %@", response.products]];
		 [self log:[NSString stringWithFormat:@"InvalidProductIdentifiers %@", response.invalidProductIdentifiers]];
	 } failure:^(NSError *error) {
		 self.requestView.statusLabel.text = statusFailure;
		 self.requestView.statusLabel.textColor = [UIColor redColor];
		 
		 [self log:@"Finished with error"];
		 [self log:[NSString stringWithFormat:@"%@", error.localizedDescription]]; 
	 }];
}

- (void)launchBulkButtonOnTouchUpInside:(id)sender
{
	self.requestView.statusLabel.text = statusExecuting;
	self.requestView.statusLabel.textColor = [UIColor blackColor];
	
	[self log:[NSString stringWithFormat:@"Requesting data for Product IDs...", nonConsumableProductIdentifier1]];
	
	[self.request
	 requestDataForItemsWithProductIds:[NSSet setWithObjects:
										nonConsumableProductIdentifier1, 
										nonConsumableProductIdentifier2, 
										nil]
	 success:^(StoreKISSDataRequest *request,
			   SKProductsResponse *response) {
		 NSString *result = statusSuccess;
		 if (response.products.count == 2) {
			 result = [result stringByAppendingFormat:@" %@ %@",
					   ((SKProduct *)[response.products objectAtIndex:0]).productIdentifier,
					   ((SKProduct *)[response.products objectAtIndex:1]).productIdentifier];
		 }
		 
		 self.requestView.statusLabel.text = result;
		 self.requestView.statusLabel.textColor = [UIColor greenColor];
		 
		 [self log:@"Finished with success"];
		 [self log:[NSString stringWithFormat:@"Products %@", response.products]];
		 [self log:[NSString stringWithFormat:@"InvalidProductIdentifiers %@", response.invalidProductIdentifiers]];
	 } failure:^(NSError *error) {
		 self.requestView.statusLabel.text = statusFailure;
		 self.requestView.statusLabel.textColor = [UIColor redColor];
		 
		 [self log:@"Finished with error"];
		 [self log:[NSString stringWithFormat:@"%@", error.localizedDescription]]; 
	 }];
}

- (void)didReceiveDataRequestNotification:(NSNotification *)notification
{
	self.requestView.notificationStatusLabel.text = notification.name;
	if ([notification.name isEqualToString:StoreKISSNotificationDataRequestSuccess]) {
		self.requestView.notificationStatusLabel.textColor = [UIColor greenColor];
	} else if ([notification.name isEqualToString:StoreKISSNotificationDataRequestFailure]) {
		self.requestView.notificationStatusLabel.textColor = [UIColor redColor];
	} else {
		self.requestView.notificationStatusLabel.textColor = [UIColor blackColor];
	}
}

#pragma mark - Misc

- (void)log:(NSString *)message
{
	self.requestView.logTextView.text = [self.requestView.logTextView.text 
										 stringByAppendingFormat:@"%@\r\n\r\n", message];
}

@end
