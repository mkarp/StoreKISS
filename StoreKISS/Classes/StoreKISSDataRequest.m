//
//  StoreKISSDataRequest.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/24/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "StoreKISSDataRequest.h"
#import "StoreKISSReachability.h"


NSString * const StoreKISSNotificationDataRequestStarted =
@"com.redigion.storekiss.notification.dataRequest.started";
NSString * const StoreKISSNotificationDataRequestSuccess =
@"com.redigion.storekiss.notification.dataRequest.success";
NSString * const StoreKISSNotificationDataRequestFailure =
@"com.redigion.storekiss.notification.dataRequest.failure";


@interface StoreKISSDataRequest ()

@property (strong, nonatomic) id strongSelf;

@property (copy, nonatomic) StoreKISSDataRequestSuccessBlock success;
@property (copy, nonatomic) StoreKISSDataRequestFailureBlock failure;

@end


@implementation StoreKISSDataRequest


@synthesize skRequest = _skRequest;
@synthesize skResponse = _skResponse;
@synthesize reachability = _reachability;
@synthesize notificationCenter = _notificationCenter;


- (id)init
{
	if ((self = [super init]))
    {
		self.status = StoreKISSDataRequestStatusNew;
	}
	return self;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Getters Overwriting
// ------------------------------------------------------------------------------------------
- (id<StoreKISSReachabilityProtocol>)reachability
{
    if (_reachability == nil)
    {
        _reachability = [[StoreKISSReachability alloc] init];
    }
    
    return _reachability;
}


- (NSNotificationCenter *)notificationCenter
{
    if (_notificationCenter == nil)
    {
        _notificationCenter = [NSNotificationCenter defaultCenter];
    }
    
    return _notificationCenter;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Requesting Data
// ------------------------------------------------------------------------------------------
- (void)requestDataForItemWithProductId:(NSString *)productId
								success:(StoreKISSDataRequestSuccessBlock)successBlock
								failure:(StoreKISSDataRequestFailureBlock)failureBlock
{
	[self requestDataForItemsWithProductIds:[NSSet setWithObject:productId]
                                    success:successBlock
                                    failure:failureBlock];
}


- (void)requestDataForItemsWithProductIds:(NSSet *)productIds
								  success:(StoreKISSDataRequestSuccessBlock)successBlock
								  failure:(StoreKISSDataRequestFailureBlock)failureBlock
{
	if ([self isExecuting])
    {
		return;
	}
	
	self.success = successBlock;
	self.failure = failureBlock;
	
	if ([self.reachability hasReachableInternetConnection] == NO)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"No internet connection.", @"")};
		self.error = [NSError errorWithDomain:StoreKISSErrorDomain
                                         code:0
                                     userInfo:userInfo];
		[self finish];
		return;
	}
	
	_skRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIds];
	self.skRequest.delegate = self;
	
	[self start];
}


- (void)requestDataForItemWithProductId:(NSString *)productId
{
	[self requestDataForItemWithProductId:productId
                                  success:nil
                                  failure:nil];
}


- (void)requestDataForItemsWithProductIds:(NSSet *)productIds
{
	[self requestDataForItemsWithProductIds:productIds
                                    success:nil
                                    failure:nil];
}


// ------------------------------------------------------------------------------------------
#pragma mark - Execution Management
// ------------------------------------------------------------------------------------------
- (void)start
{
    self.strongSelf = self;
    
	[self.skRequest start];
    
	self.status = StoreKISSDataRequestStatusStarted;
	[self.notificationCenter postNotificationName:StoreKISSNotificationDataRequestStarted
                                           object:self];
}


- (void)finish
{
	self.status = StoreKISSDataRequestStatusFinished;
	
	if (self.skResponse && self.error == nil)
    {
        NSDictionary *userInfo = @{StoreKISSNotificationDataRequestSuccessResponseKey: self.skResponse};
		[self.notificationCenter postNotificationName:StoreKISSNotificationDataRequestSuccess
                                               object:self
                                             userInfo:userInfo];
		if (self.success)
        {
			self.success(self);
		}
	}
    else
    {
        NSDictionary *userInfo = @{StoreKISSNotificationDataRequestFailureErrorKey: self.error};
		[self.notificationCenter postNotificationName:StoreKISSNotificationDataRequestFailure
                                               object:self
                                             userInfo:userInfo];
		if (self.failure)
        {
			self.failure(self.error);
		}
	}
    
    self.strongSelf = nil;
}


- (BOOL)isExecuting
{
	return self.status == StoreKISSDataRequestStatusStarted;
}


// ------------------------------------------------------------------------------------------
#pragma mark - SKProductsRequestDelegate
// ------------------------------------------------------------------------------------------
- (void)productsRequest:(SKProductsRequest *)request
	 didReceiveResponse:(SKProductsResponse *)receivedResponse
{
	_skResponse = receivedResponse;
	[self finish];
}


@end
