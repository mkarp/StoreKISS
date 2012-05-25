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

@synthesize launchButton,
			statusLabel,
			logTextView;

- (id)init
{
	self = [super init];
	if (self) {
		self.launchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		self.launchButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self.launchButton setTitle:NSLocalizedString(@"Launch", @"") forState:UIControlStateNormal];
		[self addSubview:self.launchButton];
		
		self.statusLabel = [[UILabel alloc] init];
		self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self addSubview:self.statusLabel];
		
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
	self.launchButton.frame = CGRectMake(20.0f, 20.0f, self.frame.size.width - 20.0f * 2.0f, 44.0f);
	self.statusLabel.frame = CGRectMake(20.0f, 84.0f, self.frame.size.width - 20.0f * 2.0f, 44.0f);
	self.logTextView.frame = CGRectMake(20.0f, 148.0f, self.frame.size.width - 20.0f * 2.0f, self.frame.size.height - 148.0f - 20.0f);
}

@end
