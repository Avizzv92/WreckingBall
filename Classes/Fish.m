//
//  Fish.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 6/21/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "Fish.h"


@implementation Fish

-(id)init
{
	self = [super init];
	if(self != nil)
	{
		//Creates the fish
		fish1 = [CCSprite spriteWithFile:@"fish.png"];
		fish1.position = ccp(495,6);
		fish1.scale = .8f;
		[self addChild:fish1];
		
		//Animates the fish
		[self animateFish1];
	}
	
	return self;
}

-(void)animateFish1
{
	//Random Y value for the start and finsih of the fish's movement
	float randYa = arc4random() % 6 + 3;
	float randYb = arc4random() % 6 + 3;
	
	//The fish will move from left to right flipping direction halfway through, then flipping directions again at the end.
	id action = [CCMoveTo actionWithDuration:4.5f position:ccp(410,randYa)];
	id action1 = [CCFlipX actionWithFlipX:YES];
	id action2 = [CCMoveTo actionWithDuration:4.5f position:ccp(495,randYb)];
	id action3 = [CCFlipX actionWithFlipX:NO];
	id action4 = [CCCallFunc actionWithTarget:self selector:@selector(animateFish1)];
	
	[fish1 runAction:[CCSequence actions: action, action1, action2, action3, action4, nil]];
}

-(void)dealloc
{
	[super dealloc];
}

@end
