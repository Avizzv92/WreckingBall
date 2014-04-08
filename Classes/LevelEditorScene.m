//
//  LevelEditorScene.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/1/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "LevelEditorScene.h"
#import "EditorLayer.h"


@implementation LevelEditorScene

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		/*
		CCSprite *bg = [CCSprite spriteWithFile:@"WBbg_Editor.png"];
		bg.position = ccp(240,160);
		[self addChild: bg];
		 */
		layer = [EditorLayer node];
		[self addChild:layer];
	}
	
	return self;
}

-(EditorLayer *)getLayer
{
	return layer;
}

-(void)dealloc
{
	[super dealloc];
}

@end
