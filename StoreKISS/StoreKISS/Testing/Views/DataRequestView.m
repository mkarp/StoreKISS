//
//  StoreKISSDataRequestView.m
//  StoreKISS
//
//  Created by Misha Karpenko on 5/25/12.
//  Copyright (c) 2012 Redigion. All rights reserved.
//

#import "DataRequestView.h"

@interface DataRequestView ()

@end

@implementation DataRequestView

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
	
	CGFloat buttonWidth = (self.frame.size.width - 20.0f * 3.0f) / 2.0f;
	self.launchSingleButton.frame = CGRectMake(20.0f, 20.0f, buttonWidth, 40.0f);
	self.launchBulkButton.frame = CGRectMake(20.0f + buttonWidth + 20.0f, 20.0f, buttonWidth, 40.0f);
	
	self.statusLabel.frame = CGRectMake(20.0f, 80.0f, self.frame.size.width - 20.0f * 2.0f, 50.0f);
	self.notificationStatusLabel.frame = CGRectMake(20.0f, 140.0f, self.frame.size.width - 20.0f * 2.0f, 50.0f);
	
	self.logTextView.frame = CGRectMake(20.0f, 210.0f, self.frame.size.width - 20.0f * 2.0f, self.frame.size.height - 202.0f - 20.0f);
}

@end
