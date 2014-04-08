//
//  LevelMenu2Scene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "LevelMenu2Scene.h"
#import "LevelMenu2.h"

@implementation LevelMenu2Scene

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		CCSprite *bg = [CCSprite spriteWithFile:@"LevelMenu2.png"];
		bg.position = ccp(240, 160);
		[self addChild:bg];
		
		[self addChild:[LevelMenu2 node]];
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end
