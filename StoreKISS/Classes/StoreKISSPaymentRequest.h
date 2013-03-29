//
//  StoreKISSPaymentRequest.h
//  StoreKISS
//
//  Created by Misha Karpenko on 5/28/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//


#import "StoreKISSShared.h"


@class StoreKISSPaymentRequest;


typedef enum {
	StoreKISSPaymentRequestStatusNew = 0,
	StoreKISSPaymentRequestStatusStarted,
	StoreKISSPaymentRequestStatusFinished
} StoreKISSPaymentRequestStatus;

typedef enum {
    StoreKISSNotificationPaymentRequestSuccessResultPurchased = 0,
    StoreKISSNotificationPaymentRequestSuccessResultRestored
} StoreKISSNotificationPaymentRequestSuccessResult;

typedef void (^StoreKISSPaymentRequestSuccessBlock)(StoreKISSPaymentRequest *request);
typedef void (^StoreKISSPaymentRequestFailureBlock)(NSError *error);


extern NSString * const StoreKISSNotificationPaymentRequestStarted;
extern NSString * const StoreKISSNotificationPaymentRequestPurchasing;
extern NSString * const StoreKISSNotificationPaymentRequestSuccess;
extern NSString * const StoreKISSNotificationPaymentRequestFailure;
extern NSString * const StoreKISSNotificationPaymentRequestTransactionRemoved;


#define StoreKISSNotificationPaymentRequestTransactionKey @"StoreKISSNotificationPaymentRequestTransactionKey"
#define StoreKISSNotificationPaymentRequestSuccessResultKey @"StoreKISSNotificationPaymentRequestSuccessResultKey"
#define StoreKISSNotificationPaymentRequestErrorKey @"StoreKISSNotificationPaymentRequestErrorKey"


/** Class for making In-App Purchase payments.
 
 Payment is executed using `makePaymentWithSKProduct:success:failure` method which you should provide with 
 a `SKProduct` object.
 
 As soon as the request finishes either success or failure block will be called.
 
 Success block will be called with the request itself and `SKPaymentTransaction` object in the parameters.
 
 Failure block will contain only the `NSError` object in the parameters.
 
 You can also track request execution using notifications. Each notification is a `NSNotification` instance 
 and you can get the `StoreKISSPaymentRequest` object by accessing its `- object` property.
 
 Here are notification types:
 
 - `StoreKISSNotificationPaymentRequestStarted` &mdash; request started;
 - `StoreKISSNotificationPaymentRequestPurchasing` &mdash; `SKPaymentTransactionStatePurchasing` status 
    was received;
 - `StoreKISSNotificationPaymentRequestSuccess` &mdash; request finished with success, `userInfo` of the
    notification will contain:
    
   - `StoreKISSNotificationPaymentRequestSuccessTransactionKey` &mdash; `SKPaymentTransaction` object;
   - `StoreKISSNotificationPaymentRequestSuccessResultKey` &mdash; `NSNumber` with purchased or restored status,
     please see `StoreKISSNotificationPaymentRequestSuccessResult` in the header file for more information;
 
 - `StoreKISSNotificationPaymentRequestFailure` &mdash; request finished with failure, the `NSError` object 
    can be accessed in `userInfo` dictionary by `StoreKISSNotificationPaymentRequestFailureErrorKey` key. */
@interface StoreKISSPaymentRequest : NSObject<SKPaymentTransactionObserver>

///-----------------
/// @name Properties
///-----------------

/** Status of the request. */
@property (assign, nonatomic, readonly) StoreKISSPaymentRequestStatus status;

/** Payment which will be sent to Apple.
 Will be nil before the request is started. */
@property (strong, nonatomic, readonly) SKPayment *skPayment;

/** All received transactions. Multiple transaction can be in the result of restoring payments. */
@property (strong, nonatomic, readonly) NSArray *skTransactions;

/** Received transaction for current SKProduct. */
@property (strong, nonatomic, readonly) SKPaymentTransaction *skTransaction;

/** Error if a single transaction failed. */
@property (strong, nonatomic, readonly) NSError *error;

///-------------------
/// @name Dependencies
///-------------------

/** Reachability dependency. Assign one of yours if needed. See `StoreKISSReachabilityProtocol` documentation.
 `StoreKISSReachability` instance will be used by default. */
@property (strong, nonatomic) id<StoreKISSReachabilityProtocol> reachability;

///-----------------------------------
/// @name Checking payment possibility
///-----------------------------------

/** Check whether payment execution is possible.
 
 For more information see `SKPaymentQueue` `-canMakePayments` method documentation. */
- (BOOL)canMakePayments;

///----------------------
/// @name Making payments
///----------------------

/** Make payment with SKProduct.
 
 @param skProduct SKProduct you've received from StoreKit's API.
 @param success Block that will be called after successful ending of the operation.
 @param failure Block that will be called in case of error. */
- (void)makePaymentWithSKProduct:(SKProduct *)skProduct
						 success:(StoreKISSPaymentRequestSuccessBlock)success
						 failure:(StoreKISSPaymentRequestFailureBlock)failure;

/** Make payment with SKProduct. A shortcut to use with notifications.
 
 @param skProduct SKProduct you've received from StoreKit's API. */
- (void)makePaymentWithSKProduct:(SKProduct *)skProduct;

///-------------------------
/// @name Restoring payments
///-------------------------

/** Restore your already completed payments.
 
 @param success Block that will be called after successful ending of the operation.
 @param failure Block that will be called in case of error. */
- (void)restorePaymentsWithSuccess:(StoreKISSPaymentRequestSuccessBlock)success
                           failure:(StoreKISSPaymentRequestFailureBlock)failure;

/** Restore payments. A shortcut to use with notifications. */
- (void)restorePayments;

@end
