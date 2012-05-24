//
//  StoreKISSDataRequestTests.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreKISSDataRequestTests.h"
#import "StoreKISSDataRequest.h"

@implementation StoreKISSDataRequestTests

- (void)testRequestDataForItemWithProductId
{
	StoreKISSDataRequest *dataRequest = [[StoreKISSDataRequest alloc] init];
	[dataRequest
	 requestDataForItemWithProductId:@"product1"
	 success:^{
		 
	 } failure:^(NSError *error) {
		 
	 }];
}

@end
