//
//  StoreKISSDataRequestTestViewController.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/25/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "DataRequestViewController.h"
#import "DataRequestView.h"
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

@interface DataRequestViewController ()

@property (unsafe_unretained, nonatomic) DataRequestView *dataRequestView;
@property (strong, nonatomic) StoreKISSDataRequest *request;

@end

@implementation DataRequestViewController

@synthesize dataRequestView,
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
	
	self.view = [[DataRequestView alloc] init];
	self.dataRequestView = (DataRequestView *)self.view;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(NSStringFromClass([self class]), @"");
	
	[self.dataRequestView.launchSingleButton
	 addTarget:self
	 action:@selector(launchButtonOnTouchUpInside:)
	 forControlEvents:UIControlEventTouchUpInside];
	
	[self.dataRequestView.launchBulkButton
	 addTarget:self
	 action:@selector(launchBulkButtonOnTouchUpInside:)
	 forControlEvents:UIControlEventTouchUpInside];
	
	self.dataRequestView.statusLabel.text = statusNA;
	self.dataRequestView.statusLabel.textColor = [UIColor blackColor];
	
	self.dataRequestView.notificationStatusLabel.text = notificationStatusNA;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

#pragma mark - Events

- (void)launchButtonOnTouchUpInside:(id)sender
{
	self.dataRequestView.statusLabel.text = statusExecuting;
	self.dataRequestView.statusLabel.textColor = [UIColor blackColor];
	
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
		 
		 self.dataRequestView.statusLabel.text = result;
		 self.dataRequestView.statusLabel.textColor = [UIColor greenColor];
		 
		 [self log:@"Finished with success"];
		 [self log:[NSString stringWithFormat:@"Products %@", response.products]];
		 [self log:[NSString stringWithFormat:@"InvalidProductIdentifiers %@", response.invalidProductIdentifiers]];
	 } failure:^(NSError *error) {
		 self.dataRequestView.statusLabel.text = statusFailure;
		 self.dataRequestView.statusLabel.textColor = [UIColor redColor];
		 
		 [self log:@"Finished with error"];
		 [self log:[NSString stringWithFormat:@"%@", error.localizedDescription]]; 
	 }];
}

- (void)launchBulkButtonOnTouchUpInside:(id)sender
{
	self.dataRequestView.statusLabel.text = statusExecuting;
	self.dataRequestView.statusLabel.textColor = [UIColor blackColor];
	
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
		 
		 self.dataRequestView.statusLabel.text = result;
		 self.dataRequestView.statusLabel.textColor = [UIColor greenColor];
		 
		 [self log:@"Finished with success"];
		 [self log:[NSString stringWithFormat:@"Products %@", response.products]];
		 [self log:[NSString stringWithFormat:@"InvalidProductIdentifiers %@", response.invalidProductIdentifiers]];
	 } failure:^(NSError *error) {
		 self.dataRequestView.statusLabel.text = statusFailure;
		 self.dataRequestView.statusLabel.textColor = [UIColor redColor];
		 
		 [self log:@"Finished with error"];
		 [self log:[NSString stringWithFormat:@"%@", error.localizedDescription]]; 
	 }];
}

- (void)didReceiveDataRequestNotification:(NSNotification *)notification
{
	self.dataRequestView.notificationStatusLabel.text = notification.name;
	if ([notification.name isEqualToString:StoreKISSNotificationDataRequestSuccess]) {
		self.dataRequestView.notificationStatusLabel.textColor = [UIColor greenColor];
	} else if ([notification.name isEqualToString:StoreKISSNotificationDataRequestFailure]) {
		self.dataRequestView.notificationStatusLabel.textColor = [UIColor redColor];
	} else {
		self.dataRequestView.notificationStatusLabel.textColor = [UIColor blackColor];
	}
}

#pragma mark - Misc

- (void)log:(NSString *)message
{
	self.dataRequestView.logTextView.text = [self.dataRequestView.logTextView.text 
										 stringByAppendingFormat:@"%@\r\n\r\n", message];
}

@end
