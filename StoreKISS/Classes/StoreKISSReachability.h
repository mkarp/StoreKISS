//
//  StoreKISSReachability.h
//  StoreKISS
//
//  Created by Misha Karpenko on 2/11/13.
//  Copyright (c) 2013 Redigion. All rights reserved.
//


#import "StoreKISSShared.h"


/** A default reachability implementation if you don't need a custom one. It is a simple wrapper for included
 [Reachability](https://github.com/tonymillion/Reachability) library. */
@interface StoreKISSReachability : NSObject<StoreKISSReachabilityProtocol>

@end
