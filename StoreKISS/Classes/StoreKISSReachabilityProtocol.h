//
//  StoreKISSReachabilityProtocol.h
//  StoreKISS
//
//  Created by Misha Karpenko on 2/11/13.
//  Copyright (c) 2013 Redigion. All rights reserved.
//


/** A protocol needed to implement a reachability class injection. */
@protocol StoreKISSReachabilityProtocol <NSObject>

@required
    - (BOOL)hasReachableInternetConnection;

@end
