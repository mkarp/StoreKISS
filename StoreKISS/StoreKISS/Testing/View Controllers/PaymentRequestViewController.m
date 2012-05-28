//
//  StoreKISSPaymentRequestViewController.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/28/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "PaymentRequestViewController.h"
#import "PaymentRequestView.h"
#import "StoreKISSPaymentRequest.h"

NSString * const nonConsumableProductIdentifier1 = @"com.redigion.storekiss.nonconsumable1";
NSString * const statusNA = @"N/A";
NSString * const statusSuccess = @"Success";
NSString * const statusExecuting = @"Executing";
NSString * const statusFailure = @"Failure";
NSString * const notificationStatusNA = @"N/A";
NSString * const notificationStatusSuccess = @"Success";
NSString * const notificationStatusFailure = @"Failure";

@interface PaymentRequestViewController ()

@property (unsafe_unretained, nonatomic) PaymentRequestView *paymentRequestView;
@property (strong, nonatomic) StoreKISSPaymentRequest *request;

@end

@implementation PaymentRequestViewController

@synthesize paymentRequestView,
			request;

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:StoreKISSNotificationPaymentRequestStarted
	 object:nil];
	
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:StoreKISSNotificationPaymentRequestSuccess
	 object:nil];
	
	[[NSNotificationCenter defaultCenter]
	 removeObserver:self
	 name:StoreKISSNotificationPaymentRequestFailure
	 object:nil];
}

- (id)init
{
	self = [super init];
	if (self) {
		self.request = [[StoreKISSPaymentRequest alloc] init];
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(didReceivePaymentRequestNotification:)
		 name:StoreKISSNotificationPaymentRequestStarted
		 object:nil];
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(didReceivePaymentRequestNotification:)
		 name:StoreKISSNotificationPaymentRequestSuccess
		 object:nil];
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(didReceivePaymentRequestNotification:)
		 name:StoreKISSNotificationPaymentRequestFailure
		 object:nil];
	}
	return self;
}

#pragma mark - View Lifecycle

- (void)loadView
{
	[super loadView];
	
	self.view = [[PaymentRequestView alloc] init];
	self.paymentRequestView = (PaymentRequestView *)self.view;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.title = NSLocalizedString(NSStringFromClass([self class]), @"");
	
	[self.paymentRequestView.launchButton
	 addTarget:self
	 action:@selector(launchButtonOnTouchUpInside:)
	 forControlEvents:UIControlEventTouchUpInside];
	
	self.paymentRequestView.statusLabel.text = statusNA;
	self.paymentRequestView.statusLabel.textColor = [UIColor blackColor];
	
	self.paymentRequestView.notificationStatusLabel.text = notificationStatusNA;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

@end
