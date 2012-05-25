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
