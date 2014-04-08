//
//  GasGauge.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/19/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "GasGauge.h"


@implementation GasGauge

#pragma mark -
#pragma mark Init Method(s)

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		//Creates needle
		needle = [CCSprite spriteWithFile:@"needle.png"];
		needle.scaleX = .7f;
		needle.scaleY = .8f;
		needle.anchorPoint = ccp(.5,.2);
		needle.rotation = 45.0f;
		needle.position = ccp(29,22);
		[self addChild:needle];
	}
	
	return self;
}

-(void)setPercentage:(double)percent
{
	//Updates the needle's rotation based on fuel remaining
	needle.rotation = ((percent/100.0f)*90.0f) - 45.0f;
}

#pragma mark -
#pragma mark cleanup
-(void)dealloc
{
	[super dealloc];
}

@end
