//
//  LevelMenuScene3.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "LevelMenu3Scene.h"
#import "LevelMenu3.h"

@implementation LevelMenu3Scene

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		CCSprite *bg = [CCSprite spriteWithFile:@"LevelMenu3.png"];
		bg.position = ccp(240, 160);
		[self addChild:bg];
		
		[self addChild:[LevelMenu3 node]];
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end
