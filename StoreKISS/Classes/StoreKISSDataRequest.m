//
//  StoreKISSDataRequest.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/24/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "StoreKISSDataRequest.h"
#import "Reachability.h"

NSString * const StoreKISSNotificationDataRequestStarted = @"com.redigion.storekiss.notification.dataRequest.started";
NSString * const StoreKISSNotificationDataRequestSuccess = @"com.redigion.storekiss.notification.dataRequest.success";
NSString * const StoreKISSNotificationDataRequestSuccessResponseKey = @"com.redigion.storekiss.notification.dataRequest.success.response";
NSString * const StoreKISSNotificationDataRequestFailure = @"com.redigion.storekiss.notification.dataRequest.failure";
NSString * const StoreKISSNotificationDataRequestFailureErrorKey = @"com.redigion.storekiss.notification.dataRequest.failure.error";

@interface StoreKISSDataRequest ()

@property (copy, nonatomic) StoreKISSDataRequestSuccessBlock success;
@property (copy, nonatomic) StoreKISSDataRequestFailureBlock failure;

@end

@implementation StoreKISSDataRequest

@synthesize status;
@synthesize skRequest,
			skResponse,
			error,
			success,
			failure;

- (id)init
{
	self = [super init];
	if (self) {
		self.status = StoreKISSDataRequestStatusNew;
	}
	return self;
}

#pragma mark - Requesting data

- (void)requestDataForItemWithProductId:(NSString *)productId
								success:(StoreKISSDataRequestSuccessBlock)successBlock
								failure:(StoreKISSDataRequestFailureBlock)failureBlock
{
	[self
	 requestDataForItemsWithProductIds:[NSSet setWithObject:productId]
	 success:successBlock
	 failure:failureBlock];
}

- (void)requestDataForItemsWithProductIds:(NSSet *)productIds
								  success:(StoreKISSDataRequestSuccessBlock)successBlock 
								  failure:(StoreKISSDataRequestFailureBlock)failureBlock
{
	if ([self isExecuting]) {
		return;
	}
	
	self.success = successBlock;
	self.failure = failureBlock;
	
	if ( ! [[Reachability reachabilityForInternetConnection] isReachable]) {
		self.error = [NSError
					  errorWithDomain:StoreKISSErrorDomain
					  code:0
					  userInfo:[NSDictionary
								dictionaryWithObject:@"No internet connection."
								forKey:NSLocalizedDescriptionKey]];
		[self finish];
		return;
	}
	
	self.skRequest = [[SKProductsRequest alloc]
					  initWithProductIdentifiers:productIds];
	self.skRequest.delegate = self;
	
	[self start];
}

- (void)requestDataForItemWithProductId:(NSString *)productId
{
	[self
	 requestDataForItemWithProductId:productId
	 success:nil
	 failure:nil];
}

- (void)requestDataForItemsWithProductIds:(NSSet *)productIds
{
	[self
	 requestDataForItemsWithProductIds:productIds
	 success:nil
	 failure:nil];
}

#pragma mark - Execution control

- (void)start
{
	[self.skRequest start];

	self.status = StoreKISSDataRequestStatusStarted;
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:StoreKISSNotificationDataRequestStarted
	 object:self];
}

- (void)finish
{
	self.status = StoreKISSDataRequestStatusFinished;
	
	if ( ! self.error && self.skResponse) {
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:StoreKISSNotificationDataRequestSuccess
		 object:self
		 userInfo:[NSDictionary
				   dictionaryWithObject:self.skResponse
				   forKey:StoreKISSNotificationDataRequestSuccessResponseKey]];
		
		if (self.success) {
			self.success(self);
		}
	} else {
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:StoreKISSNotificationDataRequestFailure
		 object:self
		 userInfo:[NSDictionary
				   dictionaryWithObject:self.error
				   forKey:StoreKISSNotificationDataRequestFailureErrorKey]];
		
		if (self.failure) {
			self.failure(self.error);
		}
	}
}

- (BOOL)isExecuting
{
	return self.status == StoreKISSDataRequestStatusStarted;
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request
	 didReceiveResponse:(SKProductsResponse *)receivedResponse
{
	self.skResponse = receivedResponse;
	[self finish];
}

@end
