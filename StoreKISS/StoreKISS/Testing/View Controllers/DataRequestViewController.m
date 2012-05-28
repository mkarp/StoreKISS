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

NSString * const dataRequestNonConsumableProductId1 = @"com.redigion.storekiss.nonconsumable1";
NSString * const dataRequestNonConsumableProductId2 = @"com.redigion.storekiss.nonconsumable2";
NSString * const dataRequestStatusNA = @"N/A";
NSString * const dataRequestStatusSuccess = @"Success";
NSString * const dataRequestStatusExecuting = @"Executing";
NSString * const dataRequestStatusFailure = @"Failure";
NSString * const dataRequestNotificationStatusNA = @"N/A";
NSString * const dataRequestNotificationStatusSuccess = @"Success";
NSString * const dataRequestNotificationStatusFailure = @"Failure";

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
	
	self.dataRequestView.statusLabel.text = dataRequestStatusNA;
	self.dataRequestView.statusLabel.textColor = [UIColor blackColor];
	
	self.dataRequestView.notificationStatusLabel.text = dataRequestNotificationStatusNA;
	self.dataRequestView.notificationStatusLabel.textColor = [UIColor blackColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

#pragma mark - Events

- (void)launchButtonOnTouchUpInside:(id)sender
{
	self.dataRequestView.statusLabel.text = dataRequestStatusExecuting;
	self.dataRequestView.statusLabel.textColor = [UIColor blackColor];
	
	self.dataRequestView.notificationStatusLabel.text = dataRequestNotificationStatusNA;
	self.dataRequestView.notificationStatusLabel.textColor = [UIColor blackColor];
	
	[self log:[NSString stringWithFormat:@"Requesting data for Product ID %@...", dataRequestNonConsumableProductId1]];
	
	[self.request
	 requestDataForItemWithProductId:dataRequestNonConsumableProductId1
	 success:^(StoreKISSDataRequest *request,
			   SKProductsResponse *response) {
		 NSString *result = dataRequestStatusSuccess;
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
		 self.dataRequestView.statusLabel.text = dataRequestStatusFailure;
		 self.dataRequestView.statusLabel.textColor = [UIColor redColor];
		 
		 [self log:@"Finished with error"];
		 [self log:[NSString stringWithFormat:@"%@", error.localizedDescription]]; 
	 }];
}

- (void)launchBulkButtonOnTouchUpInside:(id)sender
{
	self.dataRequestView.statusLabel.text = dataRequestStatusExecuting;
	self.dataRequestView.statusLabel.textColor = [UIColor blackColor];
	
	[self log:[NSString stringWithFormat:@"Requesting data for Product IDs...", dataRequestNonConsumableProductId1]];
	
	[self.request
	 requestDataForItemsWithProductIds:[NSSet setWithObjects:
										dataRequestNonConsumableProductId1, 
										dataRequestNonConsumableProductId2, 
										nil]
	 success:^(StoreKISSDataRequest *request,
			   SKProductsResponse *response) {
		 NSString *result = dataRequestStatusSuccess;
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
		 self.dataRequestView.statusLabel.text = dataRequestStatusFailure;
		 self.dataRequestView.statusLabel.textColor = [UIColor redColor];
		 
		 [self log:@"Finished with error"];
		 [self log:[NSString stringWithFormat:@"%@", error.localizedDescription]]; 
	 }];
}

- (void)didReceiveDataRequestNotification:(NSNotification *)notification
{
	self.dataRequestView.notificationStatusLabel.text = NSLocalizedString(notification.name, @"");
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
