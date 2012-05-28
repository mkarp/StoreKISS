//
//  StoreKISSPaymentRequestView.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/28/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "StoreKISSPaymentRequestView.h"

@implementation StoreKISSPaymentRequestView

@synthesize launchSingleButton,
launchBulkButton,
statusLabel,
notificationStatusLabel,
logTextView;

- (id)init
{
	self = [super init];
	if (self) {
		self.launchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		self.launchButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.launchButton
		 setTitle:NSLocalizedString(@"Launch", @"")
		 forState:UIControlStateNormal];
		[self addSubview:self.launchButton];
		
		self.statusLabel = [[UILabel alloc] init];
		self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.statusLabel.numberOfLines = 0;
		self.statusLabel.minimumFontSize = 10.0f;
		self.statusLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview:self.statusLabel];
		
		self.notificationStatusLabel = [[UILabel alloc] init];
		self.notificationStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.notificationStatusLabel.numberOfLines = 0;
		self.notificationStatusLabel.minimumFontSize = 10.0f;
		self.notificationStatusLabel.adjustsFontSizeToFitWidth = YES;
		[self addSubview:self.notificationStatusLabel];
		
		self.logTextView = [[UITextView alloc] init];
		self.logTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
		UIViewAutoresizingFlexibleHeight;
		[self addSubview:self.logTextView];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.launchButton.frame = CGRectMake(20.0f, 20.0f, self.frame.size.width - 20.0f * 2.0f, 40.0f);
	
	self.statusLabel.frame = CGRectMake(20.0f, 80.0f, self.frame.size.width - 20.0f * 2.0f, 50.0f);
	self.notificationStatusLabel.frame = CGRectMake(20.0f, 140.0f, self.frame.size.width - 20.0f * 2.0f, 50.0f);
	
	self.logTextView.frame = CGRectMake(20.0f, 210.0f, self.frame.size.width - 20.0f * 2.0f, self.frame.size.height - 202.0f - 20.0f);
}

@end
