//
//  TouchEffect.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "cocos2d.h"
#import "CCArray.h"

@interface TouchEffect : CCLayer 
{
	//Touch effect sprites
	CCSprite *circle;
	CCSprite *circle1;
	CCSprite *circle2;
	CCSprite *circle3;
	CCSprite *circle4;
	
	//Array of circle sprites
	CCArray *circleArray;
	
	//Touches for each finger present on screen (max 5) stored
	UITouch *circleTouch;
	UITouch *circleTouch1;
	UITouch *circleTouch2;
	UITouch *circleTouch3;
	UITouch *circleTouch4;
}

//Creates Touch at location with a given touch sprite
-(void)createCircleAtPoint:(CGPoint)thePoint circle: (CCSprite *)theCircle;
//Hide the correct touch sprite
-(void)hideCircle:(CCSprite *)theCircle;

@end
