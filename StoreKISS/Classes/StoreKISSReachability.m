//
//  StoreKISSReachability.m
//  StoreKISS
//
//  Created by Misha Karpenko on 2/11/13.
//  Copyright (c) 2013 Redigion. All rights reserved.
//

#import "StoreKISSReachability.h"
#import "Reachability.h"


@implementation StoreKISSReachability


// ------------------------------------------------------------------------------------------
#pragma mark - StoreKISSReachabilityProtocol
// ------------------------------------------------------------------------------------------
- (BOOL)hasReachableInternetConnection
{
    return [[Reachability reachabilityForInternetConnection] isReachable];
}


@end
