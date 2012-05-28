//
//  StoreKISS.h
//  StoreKISS
//
//  Created by Misha Karpenko on 5/24/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "StoreKISSShared.h"
#import "StoreKISSDataRequest.h"

/**
 Drafting with documentation and ideas here.
 
 Docs and readme will be built with make and appledoc.

 Cover everything with tests.

 Lightweight wrapper for Apple's StoreKit framework created with KISS concept and love ❤.
 
 StoreKISS.h should be an inclide file for all project files.
 
 As a library user I want to:
 
 - (DONE) make requests for product data by product ids from Apple with success/failure block - StoreKISSDataRequest;
 - make purchases by product ids/SKProduct with success/failure block;
 - make these receiving notifications.

 Uses ARC.
 
 Only for Consumable and Non-consumable products now. Subscriptions coming later (maybe).
 
 Requires Reachability.

 ##How To Use
 
 Add StoreKit framework to your project at Build Phases > Link Binary With Libraries.

 ##In-App Purchase Notes

 **Product ID** is a unique In-App Purchase product identifier of the item being purchased. It is usually stored locally in your application or at your server and should be assigned to a concrete In-App Purchase item at the iTunesConnect portal (https://itunesconnect.apple.com).
 */

//@interface StoreKISS : NSObject<SKPaymentTransactionObserver>

///----------------------
/// @name General methods
///----------------------

/**
 Tells whether you can make payments via In-App Purchase.
 */
//- (BOOL)canMakePayments;

/**
 Restore In-App Purchases user has already made with current iTunes account.
 */
//- (void)restorePurchases;

///-------------------------
/// @name Purchasing an item
///-------------------------

/**
 Purchases an In-App Purchase item with a concrete Product ID.
 
 @param productId Product ID of the item which is being bought.
 @param success Success block.
 @param failure Failure block.
 */
//- (void)purchaseItemWithProductId:(NSString *)productId
//						  success:(void(^)())success
//						  failure:(void(^)(NSError *error))failure;
//
//@end
