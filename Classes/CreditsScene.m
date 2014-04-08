//
//  CreditsScene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 7/7/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "CreditsScene.h"
#import "Credits.h"

@implementation CreditsScene
-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		CCSprite *bg = [CCSprite spriteWithFile:@"WBbgBlank.png"];
		bg.position = ccp(240, 160);
		[self addChild:bg];
		
		Credits *layer = [Credits node];
		[self addChild:layer];
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end