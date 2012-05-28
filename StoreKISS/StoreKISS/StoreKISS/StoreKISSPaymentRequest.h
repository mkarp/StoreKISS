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
	StoreKISSPaymentRequestStatusNew,
	StoreKISSPaymentRequestStatusStarted,
	StoreKISSPaymentRequestStatusFinished
} StoreKISSPaymentRequestStatus;

typedef void (^PaymentRequestSuccessBlock)(StoreKISSPaymentRequest *request,
										   SKPaymentTransaction *transaction);
typedef void (^PaymentRequestFailureBlock)(NSError *error);

/**
 Notification that a certain payment request did start.
 */
extern NSString * const StoreKISSNotificationPaymentRequestStarted;

/**
 Notification identifier that a certain data request did finish with success.
 Notification will contain SKProductsResponse in userInfo.
 */
extern NSString * const StoreKISSNotificationPaymentRequestSuccess;

/**
 Key for SKPaymentTransaction in userInfo of the StoreKISSNotificationPaymentRequestSuccess notification.
 */
extern NSString * const StoreKISSNotificationPaymentRequestSuccessTransactionKey;

/**
 Notification identifier that a certain data request did finish with failure.
 Notification will contain error in userInfo.
 */
extern NSString * const StoreKISSNotificationPaymentRequestFailure;

/**
 Key for error in userInfo of the StoreKISSNotificationPaymentRequestFailure notification.
 */
extern NSString * const StoreKISSNotificationPaymentRequestFailureErrorKey;


/**
 Class for making In-App Purchase payments.
 */
@interface StoreKISSPaymentRequest : NSObject<SKPaymentTransactionObserver>

/**
 Status of the request.
 */
@property (nonatomic) StoreKISSPaymentRequestStatus status;

///---------------------
/// @name Making payment
///---------------------

/**

 */
- (void)makePaymentWithSKProduct:(SKProduct *)skProduct
						 success:(PaymentRequestSuccessBlock)success
						 failure:(PaymentRequestFailureBlock)failure;

@end
