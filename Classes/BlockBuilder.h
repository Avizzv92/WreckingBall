//
//  BlockBuilder.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/1/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cpCCSpriteBlock.h"

#import "SpaceManager.h"
#import "cpShapeNode.h"
#import "cpCCSprite.h"
#import "cpConstraintNode.h"
#import "cpConstraint.h"
#import "cpCCSpriteBomb.h"

#define kBlockCollision 2
#define kBombCollision 3


@interface BlockBuilder : NSObject 
{
	
}

//Block creation class methods

//Straight
+(cpCCSpriteBlock *)buildStraightIForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildStraightIIForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildStraightIIIForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildStraightIVForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;

//Angle
+(cpCCSpriteBlock *)buildAngleIBlockForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildAngleIIBlockForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildAngleIIIBlockForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildAngleIVBlockForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;

//Square
+(cpCCSpriteBlock *)buildSmallSquareForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildMediumSquareForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildLargeSquareForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildXtraLargeSquareForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;

//Triangle
+(cpCCSpriteBlock *)buildSmallTriangleForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildMediumTriangleForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildLargeTriangleForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;
+(cpCCSpriteBlock *)buildXtraLargeTriangleForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;

//Bomb
+(cpCCSpriteBlock *)buildBombForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass;

@end
