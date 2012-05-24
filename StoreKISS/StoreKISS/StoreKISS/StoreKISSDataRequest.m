//
//  StoreKISSDataRequest.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreKISSDataRequest.h"

//NSString * const StoreKISSErrorProductIdIsNil = @"storekiss.error.product_id_is_nil";

@interface StoreKISSDataRequest ()

@property (strong, nonatomic) SKProductsRequest *request;
@property (strong, nonatomic) SKProductsResponse *response;
@property (strong, nonatomic) NSError *error;
@property (strong, nonatomic) DataRequestSuccessBlock success;
@property (strong, nonatomic) DataRequestFailureBlock failure;

@end

@implementation StoreKISSDataRequest

@synthesize request,
			response,
			error;

#pragma mark - Requesting data

- (void)requestDataForItemWithProductId:(NSString *)productId
								success:(DataRequestSuccessBlock)success
								failure:(DataRequestFailureBlock)failure
{
	[self
	 requestDataForItemsWithProductIds:[NSSet setWithObject:productId]
	 success:success
	 failure:failure];
}

- (void)requestDataForItemsWithProductIds:(NSSet *)productIds
								  success:(DataRequestSuccessBlock)success 
								  failure:(DataRequestFailureBlock)failure
{
	self.success = success;
	self.failure = failure;

	self.request = [[SKProductsRequest alloc]
					initWithProductIdentifiers:productIds];
	self.request.delegate = self;
	
	[self start];
}

#pragma mark - Misc

- (void)start
{
	[self.request start];
}

- (void)finish
{
	if (self.error) {
		if (self.failure) {
			
		}
	} else {
		
	}
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request
	 didReceiveResponse:(SKProductsResponse *)aResponse
{
	self.response = aResponse;
}

@end
