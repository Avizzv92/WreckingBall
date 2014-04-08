//
//  MenuScene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 3/23/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "MenuScene.h"
#import "MenuLayer.h"
#import "CustomLevels.h"


@implementation MenuScene

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		CCSprite *backGround = [CCSprite spriteWithFile:@"mainMenu.png"];
		backGround.position = ccp(240, 160);
		[self addChild: backGround];
		[self addChild:[MenuLayer node]];
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end
