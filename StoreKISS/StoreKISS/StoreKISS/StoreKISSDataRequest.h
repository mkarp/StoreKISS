//
//  StoreKISSDataRequest.h
//  StoreKISS
//
//  Created by Misha Karpenko on 5/24/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "StoreKISSShared.h"

@class StoreKISSDataRequest;

// Types
typedef enum {
	StoreKISSDataRequestStatusNew,
	StoreKISSDataRequestStatusStarted,
	StoreKISSDataRequestStatusFinished
} StoreKISSDataRequestStatus;

typedef void (^DataRequestSuccessBlock)(StoreKISSDataRequest *request, SKProductsResponse *response);
typedef void (^DataRequestFailureBlock)(NSError *error);

/**
 Notification that a certain data request did start.
 */
extern NSString * const StoreKISSNotificationDataRequestStarted;

/**
 Notification identifier that a certain data request did finish with success.
 Notification will contain SKProductsResponse in userInfo.
 */
extern NSString * const StoreKISSNotificationDataRequestSuccess;

/**
 Key for SKProductsResponse in userInfo of the StoreKISSNotificationDataRequestSuccess notification.
 */
extern NSString * const StoreKISSNotificationDataRequestSuccessResponseKey;

/**
 Notification identifier that a certain data request did finish with failure.
 Notification will contain error in userInfo.
 */
extern NSString * const StoreKISSNotificationDataRequestFailure;

/**
 Key for error in userInfo of the StoreKISSNotificationDataRequestFailure notification.
 */
extern NSString * const StoreKISSNotificationDataRequestFailureErrorKey;

/**
 Class for fetching payment data from iTunesConnect using Product IDs.
 */
@interface StoreKISSDataRequest : NSObject<SKProductsRequestDelegate>

/**
 Status of the request.
 */
@property (nonatomic) StoreKISSDataRequestStatus status;

///----------------------
/// @name Requesting data
///----------------------

/**
 Requests payment data from iTunesConnect for the item with a concrete Product ID.
 
 @param productId Product ID of the item for which payment data is fetched.
 @param success Success block.
 @param failure Failure block.
 */
- (void)requestDataForItemWithProductId:(NSString *)productId
								success:(DataRequestSuccessBlock)success
								failure:(DataRequestFailureBlock)failure;

/**
 Requests payment data from iTunesConnect for items with a set of Product IDs.
 
 @param productIds Set of Product IDs of the items for which payment data is fetched.
 @param success Success block.
 @param failure Failure block.
 */
- (void)requestDataForItemsWithProductIds:(NSSet *)productIds
								  success:(DataRequestSuccessBlock)success
								  failure:(DataRequestFailureBlock)failure;

@end
