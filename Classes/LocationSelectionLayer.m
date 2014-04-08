//
//  LocationSelectionLayer.m
//  Wrecking Ball
//
//  Created by Aaron Vizziin on 6/6/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "LocationSelectionLayer.h"


@implementation LocationSelectionLayer

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		//Adds touch effect
		[self addChild:[TouchEffect node]];
		self.isTouchEnabled = YES;
	}
	
	return self;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	//Countryside
	if(point.y > 27 && point.y < 153 && point.x > 114 && point.x < 200)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
		
		LevelEditorScene *scene = [LevelEditorScene node];
		[[scene getLayer]setLocation:bbCountrySide];
		[[CCDirector sharedDirector]replaceScene:scene];
	}
	
	//Wilderness
	if(point.y > 173&& point.y < 303 && point.x > 114 && point.x < 200)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
		
		LevelEditorScene *scene = [LevelEditorScene node];
		[[scene getLayer]setLocation:bbCity];
		[[CCDirector sharedDirector]replaceScene:scene];
	}
	
	//City
	if(point.y > 323 && point.y < 453 && point.x > 114 && point.x < 200)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
		
		LevelEditorScene *scene = [LevelEditorScene node];
		[[scene getLayer]setLocation:bbWilderness];
		[[CCDirector sharedDirector]replaceScene:scene];
	}
	
	/*
	//Lunar
	if(point.y > 173&& point.y < 303 && point.x > 57 && point.x < 143)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
		
		LevelEditorScene *scene = [LevelEditorScene node];
		[[scene getLayer]setLocation:bbLunar];
		[[CCDirector sharedDirector]replaceScene:scene];
	}*/
	
	//main menu
	if(point.x > 11 && point.x < 36 && point.y > 13 && point.y < 114) 
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
	}
}

-(void)dealloc
{
	[super dealloc];
}

@end
