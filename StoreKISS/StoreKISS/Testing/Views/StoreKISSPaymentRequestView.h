//
//  StoreKISSPaymentRequestView.h
//  StoreKISS
//
//  Created by Misha Karpenko on 5/28/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreKISSPaymentRequestView : UIView

@property (strong, nonatomic) UIButton *launchButton;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UILabel *notificationStatusLabel;
@property (strong, nonatomic) UITextView *logTextView;

@end
