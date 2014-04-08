//
//  AltVisLayer.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/23/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "AltVisLayer.h"
#import "MenuScene.h"
#import "TouchEffect.h"

@implementation AltVisLayer

#pragma mark -
#pragma mark init method

-(id)init
{
	self = [super init];
	
	if(self!=nil)
	{
		self.isTouchEnabled = YES;
		
		//Adds touch effect
		[self addChild:[TouchEffect node]];
	}
	
	return self;
}

#pragma mark -
#pragma mark touch methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	//CT load
	if(point.x > 95 && point.x < 225 && point.y > 90 && point.x < 222)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		NSString *iTunesLink = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=353234223&mt=8";
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
	}
	
	//CT Lite load
	if(point.x > 95 && point.x < 255 && point.y > 270 && point.x < 399)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		NSString *iTunesLink = @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=368380893&mt=8";
		
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
	}
	
	//Website load
	if(point.x > 12 && point.x < 39 && point.y > 124 && point.x < 363)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		NSURL *url = [NSURL URLWithString:@"http://alternativevisuals.com"];
		[[UIApplication sharedApplication]openURL:url];
	}
	
	//Back to menu
	if(point.x > 12 && point.x < 39 && point.y > 18 && point.x < 87)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
	}
}

#pragma mark -
#pragma mark CLEANUP

-(void)dealloc
{
	[super dealloc];
}
	
@end
