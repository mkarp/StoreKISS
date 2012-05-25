//
//  StoreKISSDataRequestView.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/25/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "StoreKISSDataRequestView.h"

@interface StoreKISSDataRequestView ()

@end

@implementation StoreKISSDataRequestView

@synthesize launchSingleButton,
launchBulkButton,
statusLabel,
notificationStatusLabel,
logTextView;

- (id)init
{
	self = [super init];
	if (self) {
		self.launchSingleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		self.launchSingleButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.launchSingleButton
		 setTitle:NSLocalizedString(@"Launch single", @"")
		 forState:UIControlStateNormal];
		[self addSubview:self.launchSingleButton];
		
		self.launchBulkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		self.launchBulkButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.launchBulkButton
		 setTitle:NSLocalizedString(@"Launch bulk", @"")
		 forState:UIControlStateNormal];
		[self addSubview:self.launchBulkButton];
		
		self.statusLabel = [[UILabel alloc] init];
		self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self addSubview:self.statusLabel];
		
		self.notificationStatusLabel = [[UILabel alloc] init];
		self.notificationStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
	self.launchSingleButton.frame = CGRectMake(20.0f, 20.0f, self.frame.size.width - 20.0f * 2.0f, 44.0f);
	self.launchBulkButton.frame = CGRectMake(20.0f, 84.0f, self.frame.size.width - 20.0f * 2.0f, 44.0f);
	
	CGFloat labelWidth = (self.frame.size.width - 20.0f * 3.0f) / 2.0f;
	self.statusLabel.frame = CGRectMake(20.0f, 148.0f, labelWidth, 44.0f);
	self.notificationStatusLabel.frame = CGRectMake(20.0f + labelWidth + 20.0f, 148.0f, labelWidth, 44.0f);
	
	self.logTextView.frame = CGRectMake(20.0f, 202.0f, self.frame.size.width - 20.0f * 2.0f, self.frame.size.height - 202.0f - 20.0f);
}

@end
