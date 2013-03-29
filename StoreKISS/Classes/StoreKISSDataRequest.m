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


@synthesize status = _status;
@synthesize skRequest = _skRequest;
@synthesize skResponse = _skResponse;
@synthesize reachability = _reachability;
@synthesize error = _error;


- (id)init
{
	if ((self = [super init]))
    {
		_status = StoreKISSDataRequestStatusNew;
	}
	return self;
}


- (void)dealloc
{
    if (self.skRequest != nil)
    {
        self.skRequest.delegate = nil;
    }
}


// ------------------------------------------------------------------------------------------
#pragma mark - Getters Overwriting
// ------------------------------------------------------------------------------------------
- (id<StoreKISSReachabilityProtocol>)reachability
{
    if (_reachability == nil)
    {
        self.reachability = [[StoreKISSReachability alloc] init];
    }
    
    return _reachability;
}


// ------------------------------------------------------------------------------------------
#pragma mark - Requesting Data
// ------------------------------------------------------------------------------------------
- (void)requestDataForItemWithProductId:(NSString *)productId
								success:(StoreKISSDataRequestSuccessBlock)success
								failure:(StoreKISSDataRequestFailureBlock)failure
{
	[self requestDataForItemsWithProductIds:[NSSet setWithObject:productId]
                                    success:success
                                    failure:failure];
}


- (void)requestDataForItemsWithProductIds:(NSSet *)productIds
								  success:(StoreKISSDataRequestSuccessBlock)success
								  failure:(StoreKISSDataRequestFailureBlock)failure
{
	if ([self isExecuting])
    {
		return;
	}
	
	self.success = success;
	self.failure = failure;
	
	if ([self.reachability hasReachableInternetConnection] == NO)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"No internet connection.", @"")};
		_error = [NSError errorWithDomain:StoreKISSErrorDomain
                                     code:StoreKISSErrorNoInternetConnection
                                 userInfo:userInfo];
		[self finish];
		return;
	}
	
    _productIds = productIds;
	_skRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIds];
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
    
	_status = StoreKISSDataRequestStatusStarted;
	[[NSNotificationCenter defaultCenter] postNotificationName:StoreKISSNotificationDataRequestStarted
                                                        object:self];
}


- (void)finish
{
	_status = StoreKISSDataRequestStatusFinished;
	
	if (self.error != nil)
    {
        NSDictionary *userInfo = @{StoreKISSNotificationDataRequestErrorKey: self.error};
		[[NSNotificationCenter defaultCenter] postNotificationName:StoreKISSNotificationDataRequestFailure
                                                            object:self
                                                          userInfo:userInfo];
		if (self.failure)
        {
			self.failure(self.error);
		}
	}
    else
    {
        NSDictionary *userInfo = @{StoreKISSNotificationDataRequestResponseKey: self.skResponse};
		[[NSNotificationCenter defaultCenter] postNotificationName:StoreKISSNotificationDataRequestSuccess
                                                            object:self
                                                          userInfo:userInfo];
		if (self.success)
        {
			self.success(self);
		}
	}
    
    self.skRequest.delegate = nil;
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
