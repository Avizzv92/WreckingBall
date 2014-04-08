//
//  Credits.h
//  Cat Trap
//
//  Created by Aaron Vizzini on 10/16/09.
//  Copyright 2009 Alternative Visuals. All rights reserved.
//
//  Website:
//  http://www.alternativevisuals.com
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface Credits : CCLayer 
{
	UIButton *cheatCodes;
	
	CCSprite *credits;
	
	CCSprite *button;
	
	//Current y position of credits
	int y;
	
	//Stores start point of touch
	CGPoint touchStartPoint;
}
//@property (nonatomic, retain) Sprite  *credits, *button;

@end