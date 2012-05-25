//
//  StoreKISSDataRequestView.h
//  StoreKISS
//
//  Created by Misha Karpenko on 5/25/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreKISSDataRequestView : UIView

@property (strong, nonatomic) UIButton *launchSingleButton;
@property (strong, nonatomic) UIButton *launchBulkButton;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UILabel *notificationStatusLabel;
@property (strong, nonatomic) UITextView *logTextView;

@end
