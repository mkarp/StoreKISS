//
//  StoreKISSPaymentRequestViewController.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/28/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "StoreKISSPaymentRequestViewController.h"
#import "StoreKISSPaymentRequestView.h"
#import "StoreKISSPaymentRequest.h"

@interface StoreKISSPaymentRequestViewController ()

@property (unsafe_unretained, nonatomic) StoreKISSPaymentRequestView *requestView;
@property (strong, nonatomic) StoreKISSPaymentRequest *request;

@end

@implementation StoreKISSPaymentRequestViewController

@synthesize requestView,
			request;

@end
