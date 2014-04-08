//
//  LocationSelectionScene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 6/6/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "LocationSelectionScene.h"
#import "LocationSelectionLayer.h"

@implementation LocationSelectionScene

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{	
		CCSprite *backGround = [CCSprite spriteWithFile:@"locationMenu.png"];
		backGround.position = ccp(240, 160);
		[self addChild: backGround];
		layer = [LocationSelectionLayer node];
		[self addChild:layer];
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end
