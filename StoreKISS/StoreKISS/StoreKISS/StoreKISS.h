//
//  StoreKISS.h
//  StoreKISS
//
//  Created by Misha Karpenko on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

/**
 Drafting with documentation and idead here.
 
 Docs and readme will be built with make and appledoc.

 Cover everything with tests.

 Lightweight wrapper for Apple's StoreKit framework created with "Keep It Simple, Stupid" concept and love ❤.
 
 StoreKISS.h should be an inclide file for all project files.
 
 As a library user I want to:
 
 - make requests for product data by product ids from Apple with success/failure block - StoreKISSDataRequest;
 - make purchases by product ids/SKProduct with success/failure block;
 - make these receiving notifications.

 Uses ARC.
 
 Only for Consumable and Non-consumable products now. Subscriptions coming later (maybe).

 ##How To Use
 
 Add StoreKit framework to your project at Build Phases > Link Binary With Libraries.

 ##In-App Purchase Notes

 **Product ID** is a unique In-App Purchase product identifier of the item being purchased. It is usually stored locally in your application or at your server and should be assigned to a concrete In-App Purchase item at the iTunesConnect portal (https://itunesconnect.apple.com).
 */
 
extern NSString * const StoreKISSErrorDomain;

@interface StoreKISS : NSObject<SKPaymentTransactionObserver>

///----------------------
/// @name General methods
///----------------------

/**
 Tells whether you can make payments via In-App Purchase.
 */
- (BOOL)canMakePayments;

/**
 Restore In-App Purchases user has already made with current iTunes account.
 */
- (void)restorePurchases;

///------------------------------------------------------
/// @name Fetching payment data for In-App Purchase items
///------------------------------------------------------

/**
 Requests payment data from iTunesConnect for the item with a concrete Product ID.
 
 @param productId Product ID of the item for which payment data is fetched.
 @param success Success block.
 @param failure Failure block.
 */
- (void)requestDataForItemWithProductId:(NSString *)productId
								success:(void(^)())success
								failure:(void(^)(NSError *error))failure;

/**
 Requests payment data from iTunesConnect for the item with a concrete Product ID.
 
 @param productId Product ID of the item for which payment data is fetched.
 @param success Success block.
 @param failure Failure block.
 */
- (void)requestDataForItemsWithProductIds:(NSSet *)productIds
								  success:(void(^)())success
								  failure:(void(^)(NSError *error))failure;

///-------------------------
/// @name Purchasing an item
///-------------------------

/**
 Purchases an In-App Purchase item with a concrete Product ID.
 
 @param productId Product ID of the item which is being bought.
 @param success Success block.
 @param failure Failure block.
 */
- (void)purchaseItemWithProductId:(NSString *)productId
						  success:(void(^)())success
						  failure:(void(^)(NSError *error))failure;

@end
