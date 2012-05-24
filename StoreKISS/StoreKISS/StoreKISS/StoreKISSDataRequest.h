//
//  StoreKISSDataRequest.h
//  StoreKISS
//
//  Created by Misha Karpenko on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "StoreKISS.h"

@class StoreKISSDataRequest;

// Types
typedef void (^DataRequestSuccessBlock)(StoreKISSDataRequest *request);
typedef void (^DataRequestFailureBlock)(NSError *error);

// Errors
//extern NSString * const StoreKISSErrorProductIdIsNil;

/**
 TODO Add locks
 */
@interface StoreKISSDataRequest : NSObject<SKProductsRequestDelegate>

///----------------------
/// @name Requesting data
///----------------------

/**

 */
- (void)requestDataForItemWithProductId:(NSString *)productId
								success:(DataRequestSuccessBlock)success
								failure:(DataRequestFailureBlock)failure;

/**
 
 */
- (void)requestDataForItemsWithProductIds:(NSSet *)productIds
								  success:(DataRequestSuccessBlock)success
								  failure:(DataRequestFailureBlock)failure;

@end
