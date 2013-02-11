//
//  StoreKISSDataRequest.h
//  StoreKISS
//
//  Created by Misha Karpenko on 5/24/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "StoreKISSShared.h"
#import "StoreKISSReachabilityProtocol.h"


@class StoreKISSDataRequest;


typedef enum {
	StoreKISSDataRequestStatusNew = 0,
	StoreKISSDataRequestStatusStarted,
	StoreKISSDataRequestStatusFinished
} StoreKISSDataRequestStatus;

typedef void (^StoreKISSDataRequestSuccessBlock)(StoreKISSDataRequest *request);
typedef void (^StoreKISSDataRequestFailureBlock)(NSError *error);


extern NSString * const StoreKISSNotificationDataRequestStarted;
extern NSString * const StoreKISSNotificationDataRequestSuccess;
extern NSString * const StoreKISSNotificationDataRequestFailure;


#define StoreKISSNotificationDataRequestSuccessResponseKey @"StoreKISSNotificationDataRequestSuccessResponseKey"
#define StoreKISSNotificationDataRequestFailureErrorKey @"StoreKISSNotificationDataRequestFailureErrorKey"


/** Class for fetching payment data from iTunesConnect using Product IDs.
 
 There are two methods to accomplish that:
 
 - `requestDataForItemWithProductId:success:failure:` for a single product;
 - `requestDataForItemsWithProductIds:success:failure:` for a bulk request.
 
 As soon as the request finishes either success or failure block will be called.
 
 Success block will be called with the request itself and `SKProductsResponse` object in the parameters.
 
 Failure block will contain only the `NSError` object in the parameters.
 
 You can also track request execution using notifications. Each notification is a `NSNotification` instance and 
 you can get the `StoreKISSDataRequest` object by accessing its `- object` property.
 
 Here are notification types:
 
 - `StoreKISSNotificationDataRequestStarted` &mdash; request started;
 - `StoreKISSNotificationDataRequestSuccess` &mdash; request finished with success, the `SKProductsResponse` object 
    can be accessed in `userInfo` dictionary by `StoreKISSNotificationDataRequestSuccessResponseKey` key;
 - `StoreKISSNotificationDataRequestFailure` &mdash; request finished with failure, the `NSError` object 
    can be accessed in `userInfo` dictionary by `StoreKISSNotificationDataRequestFailureErrorKey` key. */
@interface StoreKISSDataRequest : NSObject<SKProductsRequestDelegate>

///-----------------
/// @name Properties
///-----------------

/** Status of the request. */
@property (assign, nonatomic) StoreKISSDataRequestStatus status;

/** StoreKIT's SKProductsRequest object.
 Will be nil before the start of request. */
@property (strong, nonatomic) SKProductsRequest *skRequest;

/** StoreKIT's SKProductsResponse object.
 Will be nil until request is successfully finished. */
@property (strong, nonatomic) SKProductsResponse *skResponse;

/** Error if failed. */
@property (strong, nonatomic) NSError *error;

///-------------------
/// @name Dependencies
///-------------------

/** Reachability dependency. Assign one of yours if needed. See `StoreKISSReachabilityProtocol` documentation. 
 `StoreKISSReachability` instance will be used by default. */
@property (strong, nonatomic) id<StoreKISSReachabilityProtocol> reachability;

/** Notification center dependency. Assign one of yours if needed. `[NSNotificationCenter defaultCenter]` 
 will be used by default. */
@property (weak, nonatomic) NSNotificationCenter *notificationCenter;

///----------------------
/// @name Requesting data
///----------------------

/** Requests payment data from iTunesConnect for the item with a concrete Product ID.
 
 @param productId Product ID of the item for which payment data is fetched.
 @param success Success block.
 @param failure Failure block. */
- (void)requestDataForItemWithProductId:(NSString *)productId
								success:(StoreKISSDataRequestSuccessBlock)success
								failure:(StoreKISSDataRequestFailureBlock)failure;

/** Requests payment data from iTunesConnect for items with a set of Product IDs.
 
 @param productIds Set of Product IDs of the items for which payment data is fetched.
 @param success Success block.
 @param failure Failure block. */
- (void)requestDataForItemsWithProductIds:(NSSet *)productIds
								  success:(StoreKISSDataRequestSuccessBlock)success
								  failure:(StoreKISSDataRequestFailureBlock)failure;

/** Requests payment data from iTunesConnect for the item with a concrete Product ID. 
 A shortcut to use with notifications.
 
 @param productId Product ID of the item for which payment data is fetched. */
- (void)requestDataForItemWithProductId:(NSString *)productId;

/** Requests payment data from iTunesConnect for items with a set of Product IDs. 
 A shortcut to use with notifications.
 
 @param productIds Set of Product IDs of the items for which payment data is fetched. */
- (void)requestDataForItemsWithProductIds:(NSSet *)productIds;

@end
