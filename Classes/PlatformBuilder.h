//
//  PlatformBuilder.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/19/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpShapeNode.h"
#import "cpCCSprite.h"
#import "cpConstraintNode.h"
#import "cpConstraint.h"

#define kLakeCollision 4
#define kSkyscraperCollision 5

@interface PlatformBuilder : NSObject {

}

//Class method to create the given platform type.
+(cpCCSprite *)buildFlatPlatformForSpace:(SpaceManager *)space position:(cpVect)position;
+(cpCCSprite *)buildLakePlatformForSpace:(SpaceManager *)space position:(cpVect)position;
+(cpCCSprite *)buildCityPlatformForSpace:(SpaceManager *)space position:(cpVect)position;

@end
