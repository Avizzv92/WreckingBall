//
//  LevelMenu1Scene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "LevelMenu1Scene.h"
#import "LevelMenu1.h"

@implementation LevelMenu1Scene

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		CCSprite *bg = [CCSprite spriteWithFile:@"LevelMenu1.png"];
		bg.position = ccp(240, 160);
		[self addChild:bg];
		
		[self addChild:[LevelMenu1 node]];
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end
