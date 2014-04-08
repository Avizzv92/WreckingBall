//
//  OptionsScene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "OptionsScene.h"
#import "OptionsLayer.h"

@implementation OptionsScene

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{	
		CCSprite *backGround = [CCSprite spriteWithFile:@"optionsMenu.png"];
		backGround.position = ccp(240, 160);
		[self addChild: backGround];
		[self addChild:[OptionsLayer node]];
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end
