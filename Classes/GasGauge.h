//
//  GasGauge.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/19/10.
//  Copyright 2010 Home. All rights reserved.
//
#import "cocos2d.h"

//**CLASS NOT USED IN GAME**//
//Use of this sprite deprecated, 
//text indication used instead
//**************************//

@interface GasGauge : CCSprite 
{
	//Gas gauge needle
	CCSprite *needle;
}

//Sets percentage remaining for needle display
-(void)setPercentage:(double)percent;

@end
