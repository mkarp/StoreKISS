//
//  StoreKISS.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreKISS.h"

NSString * const StoreKISSErrorDomain = @"storekiss.error";

@implementation StoreKISS

- (id)init
{
	self = [super init];
	if (self) {
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	}
	return self;
}

@end
