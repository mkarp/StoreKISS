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

typedef void (^StoreKISSPaymentRequestSuccessBlock)(StoreKISSPaymentRequest *request);
typedef void (^StoreKISSPaymentRequestFailureBlock)(NSError *error);


extern NSString * const StoreKISSNotificationPaymentRequestStarted;
extern NSString * const StoreKISSNotificationPaymentRequestPurchasing;
extern NSString * const StoreKISSNotificationPaymentRequestSuccess;
extern NSString * const StoreKISSNotificationPaymentRequestFailure;


#define StoreKISSNotificationPaymentRequestSuccessTransactionKey @"StoreKISSNotificationPaymentRequestSuccessTransactionKey"
#define StoreKISSNotificationPaymentRequestFailureErrorKey @"StoreKISSNotificationPaymentRequestFailureErrorKey"


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
 - `StoreKISSNotificationPaymentRequestSuccess` &mdash; request finished with success, the `SKPaymentTransaction` 
    object can be accessed in `userInfo` dictionary by `StoreKISSNotificationPaymentRequestSuccessTransactionKey` key;
 - `StoreKISSNotificationPaymentRequestFailure` &mdash; request finished with failure, the `NSError` object 
    can be accessed in `userInfo` dictionary by `StoreKISSNotificationPaymentRequestFailureErrorKey` key. */
@interface StoreKISSPaymentRequest : NSObject<SKPaymentTransactionObserver>

///-----------------
/// @name Properties
///-----------------

/** Status of the request. */
@property (assign, nonatomic) StoreKISSPaymentRequestStatus status;

/** Payment which will be sent to Apple.
 Will be nil before the request is started. */
@property (strong, nonatomic) SKPayment *skPayment;

/** Received transaction.
 Will be nil until request is finished. */
@property (strong, nonatomic) SKPaymentTransaction *skTransaction;

/** Error if failed. */
@property (strong, nonatomic) NSError *error;

///-------------------
/// @name Dependencies
///-------------------

/** Notification center dependency. Assign one of yours if needed. `[NSNotificationCenter defaultCenter]`
 will be used by default. */
@property (weak, nonatomic) NSNotificationCenter *notificationCenter;

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

@end
