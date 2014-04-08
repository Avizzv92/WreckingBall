//
//  MenuLayer.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 3/23/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpShapeNode.h"
#import "cpCCSprite.h"
#import "cpConstraintNode.h"
#import "cpConstraint.h"

#import "TouchEffect.h"

#import "AltVisScene.h"

#import "OFAchievementService.h"
#import "OFDefines.h"
#import "OFAchievement.h"

#import "SimpleAudioEngine.h"

@interface MenuLayer : CCLayer <UIAccelerometerDelegate, UIApplicationDelegate>
{
	//Space
	SpaceManager* smgr;
	cpCCSprite *logo;
	
	cpShape *pointBlank;
	
	BOOL canContinue;
}

-(void)loadGame;
@end
