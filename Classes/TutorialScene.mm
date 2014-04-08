//
//  TutorialScene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 7/23/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "TutorialScene.h"


@implementation TutorialScene

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		[self addChild:[TutorialLayer node]];
		[self setLocation:bbCountrySide];
	}
	
	return self;
}

-(void)setLocation:(bbLocation)location
{	
	if(location == bbCountrySide)
	{
		if([self getChildByTag:10]!=nil)[self removeChildByTag:10 cleanup:YES];
		CCSprite *bg = [CCSprite spriteWithFile:@"countrySideBG.png"];
		bg.position = ccp(240,160);
		[self addChild:bg z:-1 tag:10];
	}
}

-(void)dealloc
{
	[super dealloc];
}

@end
