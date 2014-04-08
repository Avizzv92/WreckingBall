//
//  Clouds.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/6/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Level.h"

@interface Clouds : CCLayer 
{
	//The clouds
	CCSprite *cloud1;
	CCSprite *cloud2;
	CCSprite *cloud3;
	CCSprite *cloud4;
	CCSprite *cloud5;
	CCSprite *cloud6;
	
	//Direction
	bbWindDirection currentDirection;
	//Wind spped
	float currentSpeed;
	//Duration of the cloud animation
	float duration;
	
	float step;
}
//Clouds with a speed and direction
+(id)cloudsWithSpeed:(float)speed direction:(bbWindDirection)direction;

//Resets cloud location
-(void)reset:(CCSprite*)cloud1;

//Set direction
-(void)setDirection:(bbWindDirection)direction;
//Set windspeed
-(void)setWindSpeed:(int)speed;

@end
