//
//  StoreKISSPaymentRequest.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/28/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//


#import "StoreKISSPaymentRequest.h"
#import "StoreKISSReachability.h"


NSString * const StoreKISSNotificationPaymentRequestStarted =
    @"com.redigion.storekiss.notification.paymentRequest.started";
NSString * const StoreKISSNotificationPaymentRequestSuccess =
    @"com.redigion.storekiss.notification.paymentRequest.success";
NSString * const StoreKISSNotificationPaymentRequestPurchasing =
    @"com.redigion.storekiss.notification.paymentRequest.purchasing";
NSString * const StoreKISSNotificationPaymentRequestFailure =
    @"com.redigion.storekiss.notification.PaymentRequest.failure";


@interface StoreKISSPaymentRequest ()

@property (strong, nonatomic) id strongSelf;

@property (copy, nonatomic) StoreKISSPaymentRequestSuccessBlock success;
@property (copy, nonatomic) StoreKISSPaymentRequestFailureBlock failure;

@end


@implementation StoreKISSPaymentRequest


@synthesize status = _status;
@synthesize skPayment = _skPayment;
@synthesize skTransactions = _skTransactions;
@synthesize skTransaction = _skTransaction;
@synthesize error = _error;
@synthesize reachability = _reachability;


- (id)init
{
	if ((self = [super init]))
    {
		_status = StoreKISSPaymentRequestStatusNew;
	}
	return self;
}


- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Getters Overwriting
// ------------------------------------------------------------------------------------------
- (id<StoreKISSReachabilityProtocol>)reachability
{
    if (_reachability == nil)
    {
        self.reachability = [[StoreKISSReachability alloc] init];
    }
    
    return _reachability;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Checking payment possibility
// ------------------------------------------------------------------------------------------
- (BOOL)canMakePayments
{
	return [SKPaymentQueue canMakePayments];
}


- (void)checkIfCanMakePayments
{
    if ([self canMakePayments] == NO)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"In-App Purchasing is disabled."};
		_error = [NSError errorWithDomain:StoreKISSErrorDomain
                                     code:0
                                 userInfo:userInfo];
	}
}


- (void)checkIfHasReachableInternetConnection
{
    if ([self.reachability hasReachableInternetConnection] == NO)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"No internet connection.", @"")};
		_error = [NSError errorWithDomain:StoreKISSErrorDomain
                                     code:0
                                 userInfo:userInfo];
	}
}


- (void)checkIfValidSKProduct:(SKProduct *)skProduct
{
    if (skProduct == nil)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"SKProduct should not be nil."};
		_error = [NSError errorWithDomain:StoreKISSErrorDomain
                                     code:0
                                 userInfo:userInfo];
	}
}


// ------------------------------------------------------------------------------------------
#pragma mark - Making payment
// ------------------------------------------------------------------------------------------
- (void)makePaymentWithSKProduct:(SKProduct *)skProduct
						 success:(StoreKISSPaymentRequestSuccessBlock)success
						 failure:(StoreKISSPaymentRequestFailureBlock)failure
{
	if ([self isExecuting])
    {
		return;
	}
    
    self.success = success;
	self.failure = failure;
	
	[self checkIfCanMakePayments];
    [self checkIfHasReachableInternetConnection];
    [self checkIfValidSKProduct:skProduct];
    
    if (self.error)
    {
        [self finish];
        return;
    }

	_skPayment = [SKPayment paymentWithProduct:skProduct];
	
	[self start];
}


- (void)makePaymentWithSKProduct:(SKProduct *)skProduct
{
	[self makePaymentWithSKProduct:skProduct success:nil failure:nil];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Restoring payments
// ------------------------------------------------------------------------------------------
- (void)restorePaymentsWithSuccess:(StoreKISSPaymentRequestSuccessBlock)success
                           failure:(StoreKISSPaymentRequestFailureBlock)failure
{
    if ([self isExecuting])
    {
		return;
	}
    
    self.success = success;
	self.failure = failure;
    
    [self checkIfCanMakePayments];
    [self checkIfHasReachableInternetConnection];
    
    if (self.error)
    {
        [self finish];
        return;
    }
    
    [self startPaymentsRestoring];
}


- (void)restorePayments
{
    [self restorePaymentsWithSuccess:nil failure:nil];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Execution control
// ------------------------------------------------------------------------------------------
- (void)start
{
    self.strongSelf = self;

    _status = StoreKISSPaymentRequestStatusStarted;
	[[NSNotificationCenter defaultCenter] postNotificationName:StoreKISSNotificationPaymentRequestStarted
                                                        object:self];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	[[SKPaymentQueue defaultQueue] addPayment:self.skPayment];
}


- (void)startPaymentsRestoring
{
    self.strongSelf = self;
    
    _status = StoreKISSPaymentRequestStatusStarted;
    [[NSNotificationCenter defaultCenter] postNotificationName:StoreKISSNotificationPaymentRequestStarted
                                                        object:self];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


- (void)finish
{
	_status = StoreKISSPaymentRequestStatusFinished;
    
    if (self.error != nil)
    {
        if (self.failure != nil)
        {
            self.failure(self.error);
        }
    }
    else
    {
        if (self.success != nil)
        {
            self.success(self);
        }
    }
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    self.strongSelf = nil;
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
    _skTransactions = transactions;
    
    BOOL allTransactionsOnTheQueueAreFinished = YES;
    
    for (SKPaymentTransaction *skTransaction in self.skTransactions)
    {
        // Search for skPayment if needed
        if (self.skPayment != nil)
        {
            if ([skTransaction.payment isEqual:self.skPayment])
            {
                _skTransaction = skTransaction;
            }
        }
        
        switch (skTransaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
            {
                NSDictionary *userInfo = @{StoreKISSNotificationPaymentRequestTransactionKey: skTransaction};
                [[NSNotificationCenter defaultCenter] postNotificationName:
                    StoreKISSNotificationPaymentRequestPurchasing
                                                                    object:self
                                                                  userInfo:userInfo];
                allTransactionsOnTheQueueAreFinished = NO;
                break;
            }
                
            case SKPaymentTransactionStatePurchased:
            {
                NSNumber *successResultValue = [NSNumber numberWithInt:
                                                    StoreKISSNotificationPaymentRequestSuccessResultPurchased];
                NSDictionary *userInfo =
                    @{StoreKISSNotificationPaymentRequestTransactionKey: skTransaction,
                      StoreKISSNotificationPaymentRequestSuccessResultKey: successResultValue};
                [[NSNotificationCenter defaultCenter] postNotificationName:
                    StoreKISSNotificationPaymentRequestSuccess
                                                                    object:self
                                                                  userInfo:userInfo];
                [[SKPaymentQueue defaultQueue] finishTransaction:skTransaction];
                break;
            }
                
            case SKPaymentTransactionStateRestored:
            {
                NSNumber *successResultValue = [NSNumber numberWithInt:
                                                    StoreKISSNotificationPaymentRequestSuccessResultRestored];
                NSDictionary *userInfo =
                    @{StoreKISSNotificationPaymentRequestTransactionKey: skTransaction,
                      StoreKISSNotificationPaymentRequestSuccessResultKey: successResultValue};
                [[NSNotificationCenter defaultCenter] postNotificationName:
                    StoreKISSNotificationPaymentRequestSuccess
                                                                    object:self
                                                                  userInfo:userInfo];
                [[SKPaymentQueue defaultQueue] finishTransaction:skTransaction];
                break;
            }
                
            case SKPaymentTransactionStateFailed:
            {
                if (self.skTransaction != nil)
                {
                    _error = self.skTransaction.error;
                }
                else
                {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Multiple transactions processed, "
                                                "please see transactions array property for errors."};
                    _error = [NSError errorWithDomain:StoreKISSErrorDomain
                                                 code:0
                                             userInfo:userInfo];
                }
                
                NSDictionary *userInfo = @{StoreKISSNotificationPaymentRequestTransactionKey: skTransaction,
                                           StoreKISSNotificationPaymentRequestErrorKey: skTransaction.error};
                [[NSNotificationCenter defaultCenter] postNotificationName:
                    StoreKISSNotificationPaymentRequestFailure
                                                                    object:self
                                                                  userInfo:userInfo];
                [[SKPaymentQueue defaultQueue] finishTransaction:skTransaction];
                break;
            }
        }
    }
    
    if (allTransactionsOnTheQueueAreFinished)
    {
        [self finish];
    }
}


- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions 
{
	DLog(@"removedTransactions");
}


- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    if (self.status != StoreKISSPaymentRequestStatusFinished)
    {
        _error = error;
        [self finish];
    }
}


- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    if (self.status != StoreKISSPaymentRequestStatusFinished)
    {
        [self finish];
    }
}


@end
