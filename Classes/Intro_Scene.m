//
//  Intro_Scene.m
//  Cat Trap
//
//  Created by Aaron Vizzini on 10/16/09.
//  Copyright 2009 Alternative Visuals. All rights reserved.
//
//  Website:
//  http://www.alternativevisuals.com
//


#import "Intro_Scene.h"
#import "MenuScene.h"
#import "CCLabel.h"
#import "SimpleAudioEngine.h"

@implementation Intro_Scene
//@synthesize label, logo;

-(id) init
{
	self = [super init];
	
	if(self != nil)
	{
		[[SimpleAudioEngine sharedEngine] playEffect:@"Intro.caf"];
		
		//Load logo image and set position
		logo = [CCSprite spriteWithFile:@"AVlogo_1.png"];
		logo.position = ccp(-75, -10);
		logo.scale = 1.4f;
		logo.rotation = 360.0f;
		[self addChild: logo];
		
		//Creates 3 actions for the logo sprite
		id action0 = [CCMoveTo actionWithDuration:0 position:ccp(240,180)];
		id action1 = [CCFadeIn actionWithDuration:3];
		id action2 = [CCFadeOut actionWithDuration:3];
		id action3 = [CCCallFunc actionWithTarget:self selector:@selector(changeScene)];
		
		//Logo runs the actions
		[logo runAction: [CCSequence actions:action0,action1, action2, action3, nil]];
		
		//Creates a label and positions it, Alternative Visuals, not actions applied
		label = [CCLabel labelWithString:@"Alternative Visuals" fontName:@"Verdana" fontSize:22];
		label.position = ccp(240, 100);
		label.rotation = 360.0f;
		[self addChild:label];
		
	}
	
	return self;
}

//Method called at the end of the logo action array, called by action3
-(void)changeScene
{
	//Sets scene to the main menu.
	MenuScene *mainMenu = [MenuScene node];
	[[CCDirector sharedDirector] replaceScene:[CCFadeTransition transitionWithDuration:.4 scene: mainMenu]];
}

-(void)dealloc
{
	[self removeChild:logo cleanup:YES];
	[self removeChild:label cleanup:YES]; 
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[super dealloc];
}
@end
