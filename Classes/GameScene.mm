//
//  GameScene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 3/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		[self addChild:[GameLayer node]];
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
	
	else if(location == bbWilderness)
	{
		if([self getChildByTag:10]!=nil)[self removeChildByTag:10 cleanup:YES];
		CCSprite *bg = [CCSprite spriteWithFile:@"wildernessBG.png"];
		bg.position = ccp(240,160);
		[self addChild:bg z:-1 tag:10];
	}
	
	else if(location == bbCity)
	{
		if([self getChildByTag:10]!=nil)[self removeChildByTag:10 cleanup:YES];
		CCSprite *bg = [CCSprite spriteWithFile:@"cityBG.png"];
		bg.position = ccp(240,160);
		[self addChild:bg z:-1 tag:10];
	}
	
	else if(location == bbLunar)
	{
		if([self getChildByTag:10]!=nil)[self removeChildByTag:10 cleanup:YES];
		CCSprite *bg = [CCSprite spriteWithFile:@"MoonBG.png"];
		bg.position = ccp(240,160);
		[self addChild:bg z:-1 tag:10];
	}
}

-(void)dealloc
{
	[super dealloc];
}

@end
