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

@property (strong, nonatomic) SKProductsRequest *request;
@property (strong, nonatomic) SKProductsResponse *response;
@property (strong, nonatomic) NSError *error;
@property (copy, nonatomic) StoreKISSDataRequestSuccessBlock success;
@property (copy, nonatomic) StoreKISSDataRequestFailureBlock failure;

@end

@implementation StoreKISSDataRequest

@synthesize status;
@synthesize request,
			response,
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
	
	self.request = [[SKProductsRequest alloc]
					initWithProductIdentifiers:productIds];
	self.request.delegate = self;
	
	[self start];
}

#pragma mark - Execution control

- (void)start
{
	[self.request start];

	self.status = StoreKISSDataRequestStatusStarted;
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:StoreKISSNotificationDataRequestStarted
	 object:self];
}

- (void)finish
{
	self.status = StoreKISSDataRequestStatusFinished;
	
	if ( ! self.error && self.response) {
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:StoreKISSNotificationDataRequestSuccess
		 object:self
		 userInfo:[NSDictionary
				   dictionaryWithObject:self.response
				   forKey:StoreKISSNotificationDataRequestSuccessResponseKey]];
		
		if (self.success) {
			self.success(self, self.response);
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
	self.response = receivedResponse;
	[self finish];
}

@end
