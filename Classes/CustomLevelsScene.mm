//
//  CustomLevelsScene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/15/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "CustomLevelsScene.h"
#import "CustomLevels.h"

@implementation CustomLevelsScene

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		CCSprite *backGround = [CCSprite spriteWithFile:@"CustomLevels.png"];
		backGround.position = ccp(240, 160);
		[self addChild: backGround];
		[self addChild:[CustomLevels node]];
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end
