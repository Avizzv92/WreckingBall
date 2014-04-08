//
//  UserProfileScene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "UserProfileScene.h"
#import "UserProfileMenu.h"

@implementation UserProfileScene
-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		CCSprite *bg = [CCSprite spriteWithFile:@"userProfileMenu.png"];
		bg.position = ccp(240, 160);
		[self addChild:bg];
		
		[self addChild:[UserProfileMenu node]];
	}
	
	return self;
}

-(void)dealloc
{
	[super dealloc];
}

@end
