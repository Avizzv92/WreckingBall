//
//  AltVisScene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/23/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "AltVisScene.h"
#import "AltVisLayer.h"

@implementation AltVisScene
-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		CCSprite *backGround = [CCSprite spriteWithFile:@"AltVisMenu.png"];
		backGround.position = ccp(240, 160);
		[self addChild: backGround];
		[self addChild:[AltVisLayer node]];
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end
