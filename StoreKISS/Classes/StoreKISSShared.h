//
//  StoreKISSSettings.h
//  StoreKISS
//
//  Created by Misha Karpenko on 5/25/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "StoreKISSReachabilityProtocol.h"


#define StoreKISSErrorDomain @"com.redigion.storekiss.error"

typedef NS_ENUM(NSInteger, StoreKISSError)
{
    StoreKISSErrorIAPDisabled = 0,
    StoreKISSErrorNoInternetConnection,
    StoreKISSErrorInvalidSKProduct,
    StoreKISSErrorTransactionFailed
};
