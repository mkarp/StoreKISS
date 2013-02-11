//
//  StoreKISSPaymentRequest.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/28/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "StoreKISSPaymentRequest.h"


NSString * const StoreKISSNotificationPaymentRequestStarted =
    @"com.redigion.storekiss.notification.paymentRequest.started";
NSString * const StoreKISSNotificationPaymentRequestSuccess =
    @"com.redigion.storekiss.notification.paymentRequest.success";
NSString * const StoreKISSNotificationPaymentRequestPurchasing =
    @"com.redigion.storekiss.notification.paymentRequest.purchasing";
NSString * const StoreKISSNotificationPaymentRequestFailure =
    @"com.redigion.storekiss.notification.PaymentRequest.failure";


@interface StoreKISSPaymentRequest ()

@property (copy, nonatomic) StoreKISSPaymentRequestSuccessBlock success;
@property (copy, nonatomic) StoreKISSPaymentRequestFailureBlock failure;

@end


@implementation StoreKISSPaymentRequest


- (void)dealloc
{
	[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


- (id)init
{
	if ((self = [super init]))
    {
		self.status = StoreKISSPaymentRequestStatusNew;
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	return self;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Getters Overwriting
// ------------------------------------------------------------------------------------------
- (NSNotificationCenter *)notificationCenter
{
    if (_notificationCenter == nil)
    {
        _notificationCenter = [NSNotificationCenter defaultCenter];
    }
    
    return _notificationCenter;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Checking payment possibility
// ------------------------------------------------------------------------------------------
- (BOOL)canMakePayments
{
	return [SKPaymentQueue canMakePayments];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Making payment
// ------------------------------------------------------------------------------------------
- (void)makePaymentWithSKProduct:(SKProduct *)skProduct
						 success:(StoreKISSPaymentRequestSuccessBlock)successBlock
						 failure:(StoreKISSPaymentRequestFailureBlock)failureBlock
{
	if ([self isExecuting])
    {
		return;
	}
	
	if ([self canMakePayments] == NO)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Can not make payments."};
		self.error = [NSError errorWithDomain:StoreKISSErrorDomain
                                         code:0
                                     userInfo:userInfo];
		[self finish];
		return;
	}
	
	if (skProduct == nil)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"SKProduct should not be nil."};
		self.error = [NSError errorWithDomain:StoreKISSErrorDomain
                                         code:0
                                     userInfo:userInfo];
		[self finish];
		return;
	}

	self.skPayment = [SKPayment paymentWithProduct:skProduct];
	
	self.success = successBlock;
	self.failure = failureBlock;
	
	[self start];
}


- (void)makePaymentWithSKProduct:(SKProduct *)skProduct
{
	[self makePaymentWithSKProduct:skProduct
                           success:nil
                           failure:nil];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Execution control
// ------------------------------------------------------------------------------------------
- (void)start
{
	[[SKPaymentQueue defaultQueue] addPayment:self.skPayment];
	
	self.status = StoreKISSPaymentRequestStatusStarted;
	[self.notificationCenter postNotificationName:StoreKISSNotificationPaymentRequestStarted
                                           object:self];
}


- (void)finish
{
	self.status = StoreKISSPaymentRequestStatusFinished;

	if (self.skTransaction && self.error == nil)
    {
        NSDictionary *userInfo = @{StoreKISSNotificationPaymentRequestSuccessTransactionKey: self.skTransaction};
		[self.notificationCenter postNotificationName:StoreKISSNotificationPaymentRequestSuccess
                                               object:self
                                             userInfo:userInfo];
		if (self.success)
        {
			self.success(self);
		}
	}
    else
    {
        NSDictionary *userInfo = @{StoreKISSNotificationPaymentRequestFailureErrorKey: self.error};
		[self.notificationCenter postNotificationName:StoreKISSNotificationPaymentRequestFailure
                                               object:self
                                             userInfo:userInfo];
		if (self.failure)
        {
			self.failure(self.error);
		}
	}
	
	[[SKPaymentQueue defaultQueue] finishTransaction:self.skTransaction];
}


- (BOOL)isExecuting
{
	return self.status == StoreKISSPaymentRequestStatusStarted;
}


// ------------------------------------------------------------------------------------------
#pragma mark - SKPaymentTransactionObserver
// ------------------------------------------------------------------------------------------
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions 
{
	// Find transaction with our payment
	for (SKPaymentTransaction *updatedTransaction in transactions)
    {
		if ([updatedTransaction.payment isEqual:self.skPayment])
        {
			self.skTransaction = updatedTransaction;
		}
	}
	
	if (self.skTransaction == nil)
    {
		return;
	}
	
	switch (self.skTransaction.transactionState)
    {
		case SKPaymentTransactionStatePurchasing: {
            NSDictionary *userInfo =
                @{StoreKISSNotificationPaymentRequestSuccessTransactionKey: self.skTransaction};
			[self.notificationCenter postNotificationName:StoreKISSNotificationPaymentRequestPurchasing
                                                   object:self
                                                 userInfo:userInfo];
			break;
        }
	
		case SKPaymentTransactionStatePurchased: {
			[self finish];
			break;
        }
			
		case SKPaymentTransactionStateRestored: {
			[self finish];
			break;
        }
            
		case SKPaymentTransactionStateFailed: {
			self.error = self.skTransaction.error;
			[self finish];
			break;
        }
	}
}


- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions 
{	
}


- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{	
}


- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{	
}


@end
