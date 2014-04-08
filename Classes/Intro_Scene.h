//
//  Intro_Scene.h
//  Cat Trap
//
//  Created by Aaron Vizzini on 10/16/09.
//  Copyright 2009 Alternative Visuals. All rights reserved.
//
//  Website:
//  http://www.alternativevisuals.com
//


#import <Foundation/Foundation.h>
#import "CCScene.h"
#import "CCSprite.h"
#import "cocos2d.h"

@interface Intro_Scene : CCScene 
{
	CCSprite *logo;
	CCLabel *label;
}
//@property (nonatomic, retain) Sprite *logo;
//@property (nonatomic, retain) Label *label;
-(void)changeScene;
@end
