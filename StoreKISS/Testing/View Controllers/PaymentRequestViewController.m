//
//  StoreKISSPaymentRequestViewController.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/28/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "PaymentRequestViewController.h"
#import "PaymentRequestView.h"
#import "StoreKISSDataRequest.h"
#import "StoreKISSPaymentRequest.h"

NSString * const paymentRequestNonConsumableProductId1 = @"com.redigion.storekiss.nonconsumable1";
NSString * const paymentRequestStatusNA = @"N/A";
NSString * const paymentRequestStatusSuccess = @"Success";
NSString * const paymentRequestStatusExecuting = @"Executing";
NSString * const paymentRequestStatusFailure = @"Failure";
NSString * const paymentRequestNotificationStatusNA = @"N/A";
NSString * const paymentRequestNotificationStatusSuccess = @"Success";
NSString * const paymentRequestNotificationStatusFailure = @"Failure";

@interface PaymentRequestViewController ()

@property (unsafe_unretained, nonatomic) PaymentRequestView *paymentRequestView;
@property (strong, nonatomic) SKProduct *skProduct;
@property (strong, nonatomic) StoreKISSDataRequest *dataRequest;
@property (strong, nonatomic) StoreKISSPaymentRequest *paymentRequest;

@end

@implementation PaymentRequestViewController

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
	if (self)
    {
		self.dataRequest = [[StoreKISSDataRequest alloc] init];
		self.paymentRequest = [[StoreKISSPaymentRequest alloc] init];
		
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(didReceivePaymentRequestNotification:)
		 name:StoreKISSNotificationPaymentRequestStarted
		 object:nil];
        
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(didReceivePaymentRequestNotification:)
		 name:StoreKISSNotificationPaymentRequestPurchasing
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
	
	self.paymentRequestView.statusLabel.text = paymentRequestStatusNA;
	self.paymentRequestView.statusLabel.textColor = [UIColor blackColor];
	
	self.paymentRequestView.notificationStatusLabel.text = paymentRequestNotificationStatusNA;
	self.paymentRequestView.notificationStatusLabel.textColor = [UIColor blackColor];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

#pragma mark - Events

- (void)launchButtonOnTouchUpInside:(id)sender
{
	void (^failure)(NSError *) = ^(NSError *error)
    {
		self.paymentRequestView.statusLabel.text = paymentRequestStatusFailure;
		self.paymentRequestView.statusLabel.textColor = [UIColor redColor];
		
		[self log:@"Finished with error"];
		[self log:[NSString stringWithFormat:@"%@", error.localizedDescription]];
	};
    
	self.paymentRequestView.statusLabel.text = paymentRequestStatusExecuting;
	self.paymentRequestView.statusLabel.textColor = [UIColor blackColor];
	
	self.paymentRequestView.notificationStatusLabel.text = paymentRequestNotificationStatusNA;
	self.paymentRequestView.notificationStatusLabel.textColor = [UIColor blackColor];
	
	[self log:[NSString stringWithFormat:@"Requesting data for Product ID %@...", paymentRequestNonConsumableProductId1]];
	
	[self.dataRequest
	 requestDataForItemWithProductId:paymentRequestNonConsumableProductId1
	 success:^(StoreKISSDataRequest *currentRequest)
     {
		 if (currentRequest.skResponse.products.count != 1)
         {
			 NSError *error = [NSError
							   errorWithDomain:@"com.redigion.storekiss.error.test"
							   code:0
							   userInfo:[NSDictionary
										 dictionaryWithObject:@"No products received."
										 forKey:NSLocalizedDescriptionKey]];
			 failure(error);
			 return;
		 }
         
		 self.skProduct = [currentRequest.skResponse.products objectAtIndex:0];
		 [self log:[NSString stringWithFormat:@"Received data for %@...", self.skProduct.productIdentifier]];
		 [self log:[NSString stringWithFormat:@"Trying to buy %@...", self.skProduct.productIdentifier]];
         
		 [self.paymentRequest
		  makePaymentWithSKProduct:self.skProduct
		  success:^(StoreKISSPaymentRequest *request)
          {
			  NSString *result = [NSString stringWithFormat:@"%@ %@",
								  paymentRequestStatusSuccess,
								  paymentRequestNonConsumableProductId1];
			  
			  self.paymentRequestView.statusLabel.text = result;
			  self.paymentRequestView.statusLabel.textColor = [UIColor greenColor];
			  
			  [self log:@"Finished with success"];
		  } failure:failure];
	 } failure:failure];
}

- (void)didReceivePaymentRequestNotification:(NSNotification *)notification
{
	self.paymentRequestView.notificationStatusLabel.text = NSLocalizedString(notification.name, @"");
	if ([notification.name isEqualToString:StoreKISSNotificationPaymentRequestSuccess])
    {
		self.paymentRequestView.notificationStatusLabel.textColor = [UIColor greenColor];
	} else if ([notification.name isEqualToString:StoreKISSNotificationPaymentRequestFailure])
    {
		self.paymentRequestView.notificationStatusLabel.textColor = [UIColor redColor];
	} else {
		self.paymentRequestView.notificationStatusLabel.textColor = [UIColor blackColor];
	}
}

#pragma mark - Misc

- (void)log:(NSString *)message
{
	self.paymentRequestView.logTextView.text = [self.paymentRequestView.logTextView.text
												stringByAppendingFormat:@"%@\r\n\r\n", message];
}

@end
