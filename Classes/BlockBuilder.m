//
//  BlockBuilder.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/1/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "BlockBuilder.h"
#import "WBManager.h"

//Predefined Mass
#define smallBlockMass 125
#define mediumBlockMass 225
#define largeBlockMass 325
#define xtraLargeBlockMass 425

#define staightIMass 125
#define staightIIMass 225
#define staightIIIMass 325
#define staightIVMass 425

#define heavyBlockMultiplier 2

//Predefined friction
#define kFriction 1.0f

#pragma mark -
#pragma mark Private Category

//Private category to exstend the methods of BlockBuilder
@interface BlockBuilder(/*Private*/)

//Class method to convert radian for the given rotation
+(float)getAngleForRotation:(float)rotation;

@end

@implementation BlockBuilder

#pragma mark -
#pragma mark Angle Conversion
+(float)getAngleForRotation:(float)rotation
{
	//Convert to radians to use with Chipmunk Physics
	return (rotation * M_PI / 180);
}

#pragma mark -
#pragma mark Block Creation Methods
#pragma mark -
#pragma mark Blocks Straigt
//Convert the rotation
//Get the proper mass
//Create the shape with the specified information
//Adds the proper friction value
//Applies the proper texture based on blocktype
+(cpCCSpriteBlock *)buildStraightIForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass;
	
	if(blockMass == bbStatic)theMass = STATIC_MASS;
	else if(blockMass == bbLight)theMass = staightIMass;
	else if(blockMass == bbHeavy)theMass = staightIMass * heavyBlockMultiplier;
	
	cpShape *shape = [space addRectAt:position mass:theMass width:7 height:21 rotation:angle];
	shape->collision_type = kBlockCollision;
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	if(weight == bbLight)
	{
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"smallBlock.png"] type: bbStraightI weight:weight rotation:rotation];
	}
	
	else
	{
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"smallBlockHeavy.png"] type: bbStraightI weight:weight rotation:rotation];
	}
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	
	block.rotation = rotation;
	return block;
}

+(cpCCSpriteBlock *)buildStraightIIForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass;
	
	if(blockMass == bbStatic)theMass = STATIC_MASS;
	else if(blockMass == bbLight)theMass = staightIIMass;
	else if(blockMass == bbHeavy)theMass = staightIIMass * heavyBlockMultiplier;
	
	cpShape *shape = [space addRectAt:position mass:theMass width:7 height:42 rotation:angle];
	shape->collision_type = kBlockCollision;
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	if(weight == bbLight)
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"mediumBlock.png"] type: bbStraightII weight:weight rotation:rotation];
	else
	{
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"mediumBlockHeavy.png"] type: bbStraightII weight:weight rotation:rotation];
	}
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	block.rotation = rotation;
	return block;
}

+(cpCCSpriteBlock *)buildStraightIIIForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass;
	
	if(blockMass == bbStatic)theMass = STATIC_MASS;
	else if(blockMass == bbLight)theMass = staightIIIMass;
	else if(blockMass == bbHeavy)theMass = staightIIIMass * heavyBlockMultiplier;
	
	cpShape *shape = [space addRectAt:position mass:theMass width:7 height:63 rotation:angle];
	shape->collision_type = kBlockCollision;
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	if(weight == bbLight)
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"largeBlock.png"] type: bbStraightIII weight:weight rotation:rotation];
	else
	{
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"largeBlockHeavy.png"] type: bbStraightIII weight:weight rotation:rotation];
	}
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	block.rotation = rotation;
	return block;
}

+(cpCCSpriteBlock *)buildStraightIVForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass;
	
	if(blockMass == bbStatic)theMass = STATIC_MASS;
	else if(blockMass == bbLight)theMass = staightIVMass;
	else if(blockMass == bbHeavy)theMass = staightIVMass * heavyBlockMultiplier;
	
	cpShape *shape = [space addRectAt:position mass:theMass width:7 height:84 rotation:angle];
	shape->u = kFriction;
	shape->collision_type = kBlockCollision;
	
	cpCCSpriteBlock *block;
	
	if(weight == bbLight)
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"xtraLargeBlock.png"] type: bbStraightIV weight:weight rotation:rotation];
	else
	{
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"xtraLargeBlockHeavy.png"] type: bbStraightIV weight:weight rotation:rotation];
	}
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	block.rotation = rotation;
	return block;
}

#pragma mark -
#pragma mark Angles
+(cpCCSpriteBlock *)buildAngleIBlockForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	angle = angle + 45 * M_PI / 180;
	
	float theMass;
	
	if(blockMass == bbStatic)theMass = STATIC_MASS;
	else if(blockMass == bbLight)theMass = smallBlockMass;
	else if(blockMass == bbHeavy)theMass = smallBlockMass * heavyBlockMultiplier;
	
	cpShape *shape = [space addPolyAt:position mass:theMass rotation:angle numPoints:5 points: cpv(3.0f, -19.4f),
					  cpv(-3.0f, -15.0f),
					  cpv(-3.0f, 14.3f),
					  cpv(3.0f, 18.6f),
					  cpv(3.0f, -19.4f)];	
	shape->collision_type = kBlockCollision;
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	if(weight == bbLight)
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"smallAngleBlock.png"] type: bbAngleI weight:weight rotation:rotation];
	else
	{
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"smallAngleHeavy.png"] type: bbAngleI weight:weight rotation:rotation];
	}
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	block.rotation = rotation;
	return block;
}

+(cpCCSpriteBlock *)buildAngleIIBlockForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	angle = angle + 45 * M_PI / 180;
	
	float theMass;
	
	if(blockMass == bbStatic)theMass = STATIC_MASS;
	else if(blockMass == bbLight)theMass = mediumBlockMass;
	else if(blockMass == bbHeavy)theMass = mediumBlockMass * heavyBlockMultiplier;
	
	cpShape *shape = [space addPolyAt:position mass:theMass rotation:angle numPoints:5 points: cpv(3.0f, -34.5f),
					  cpv(-3.0f, -29.0f),
					  cpv(-3.0f, 29.7f),
					  cpv(3.0f, 34.7f),
					  cpv(3.0f, -33.7f)];
	shape->collision_type = kBlockCollision;
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	if(weight == bbLight)
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"mediumAngleBlock.png"] type: bbAngleII weight:weight rotation:rotation];
	else
	{
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"mediumAngleHeavy.png"] type: bbAngleII weight:weight rotation:rotation];
	}
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	block.rotation = rotation;
	return block;
}

+(cpCCSpriteBlock *)buildAngleIIIBlockForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	angle = angle + 45 * M_PI / 180;
	
	float theMass;
	
	if(blockMass == bbStatic)theMass = STATIC_MASS;
	else if(blockMass == bbLight)theMass = largeBlockMass;
	else if(blockMass == bbHeavy)theMass = largeBlockMass * heavyBlockMultiplier;
		
	cpShape *shape = [space addPolyAt:position mass:theMass rotation:angle numPoints:5 points: cpv(3.0f, -49.7f),
					  cpv(-3.0f, -44.7f),
					  cpv(-3.0f, 44.7f),
					  cpv(3.0f, 49.7f),
					  cpv(3.0f, -49.7f)];	
	shape->collision_type = kBlockCollision;
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	if(weight == bbLight)
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"largeAngleBlock.png"] type: bbAngleIII weight:weight rotation:rotation];
	else
	{
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"largeAngleHeavy.png"] type: bbAngleIII weight:weight rotation:rotation];
	}
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	block.rotation = rotation;
	return block;	
}

+(cpCCSpriteBlock *)buildAngleIVBlockForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	angle = angle + 45 * M_PI / 180;
	
	float theMass;
	
	if(blockMass == bbStatic)theMass = STATIC_MASS;
	else if(blockMass == bbLight)theMass = xtraLargeBlockMass;
	else if(blockMass == bbHeavy)theMass = xtraLargeBlockMass * heavyBlockMultiplier;

	
	cpShape *shape = [space addPolyAt:position mass:theMass rotation:angle numPoints:5 points: cpv(3.0f, -64.0f),//2.5
					  cpv(-3.0f, -59.4f),//-2.1
					  cpv(-3.0f, 58.0f),//-1.8
					  cpv(3.0f, 62.6f),//2.5
					  cpv(3.0f, -63.3f)];//2.5
	
	shape->collision_type = kBlockCollision;
	
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	if(weight == bbLight)
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"xtraLargeAngle.png"] type: bbAngleIV weight:weight rotation:rotation];
	else
	{
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"xtraLargeAngleHeavy.png"] type: bbAngleIV weight:weight rotation:rotation];
	}
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	block.rotation = rotation;
	return block;	
}

#pragma mark -
#pragma mark Squares

+(cpCCSpriteBlock *)buildSmallSquareForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass = smallBlockMass;
	
	cpShape *shape = [space addRectAt:position mass:theMass width:21 height:21 rotation:angle];
	shape->collision_type = kBlockCollision;
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"smallSquare.png"] type: bbSquareS weight:weight rotation:rotation];
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	
	block.rotation = rotation;
	return block;
}

+(cpCCSpriteBlock *)buildMediumSquareForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass = mediumBlockMass;
	
	cpShape *shape = [space addRectAt:position mass:theMass width:42 height:42 rotation:angle];
	shape->collision_type = kBlockCollision;
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"mediumSquare.png"] type: bbSquareM weight:weight rotation:rotation];
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	
	block.rotation = rotation;
	return block;
}

+(cpCCSpriteBlock *)buildLargeSquareForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass = largeBlockMass;
	
	cpShape *shape = [space addRectAt:position mass:theMass width:63 height:63 rotation:angle];
	shape->collision_type = kBlockCollision;
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"largeSquare.png"] type: bbSquareL weight:weight rotation:rotation];
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	
	block.rotation = rotation;
	return block;
}

+(cpCCSpriteBlock *)buildXtraLargeSquareForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass = xtraLargeBlockMass;
	
	cpShape *shape = [space addRectAt:position mass:theMass width:84 height:84 rotation:angle];
	shape->collision_type = kBlockCollision;
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"xtraLargeSquare.png"] type: bbSquareXL weight:weight rotation:rotation];
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	
	block.rotation = rotation;
	return block;
}

#pragma mark -
#pragma mark Triangles

+(cpCCSpriteBlock *)buildSmallTriangleForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass = smallBlockMass;
	
	cpShape *shape = [space addPolyAt:position mass:theMass rotation:angle numPoints:4 points: cpv(-9.5f, -9.5f),
					  cpv(-9.5f, 9.5f),
					  cpv(9.5f, 9.5f),
					  cpv(-9.5f, -9.5f)];
	shape->collision_type = kBlockCollision;
	
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
		block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"smallTriangle.png"] type: bbTriangleS weight:weight rotation:rotation];

	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	block.rotation = rotation;
	return block;	
}

+(cpCCSpriteBlock *)buildMediumTriangleForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass = mediumBlockMass;
	
	cpShape *shape = [space addPolyAt:position mass:theMass rotation:angle numPoints:4 points: cpv(-20.0f, 20.0f),
					  cpv(20.0f, 20.0f),
					  cpv(-20.0f, -20.0f),
					  cpv(-20.0f, 20.0f)];
	shape->collision_type = kBlockCollision;
	
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"mediumTriangle.png"] type: bbTriangleM weight:weight rotation:rotation];
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	block.rotation = rotation;
	return block;	
}


+(cpCCSpriteBlock *)buildLargeTriangleForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass = largeBlockMass;
	
	cpShape *shape = [space addPolyAt:position mass:theMass rotation:angle numPoints:4 points: cpv(-30.0f, -30.5f),
					  cpv(-29.7f, 30.7f),
					  cpv(30.7f, 30.0f),
					  cpv(-29.7f, -30.5f)];
	shape->collision_type = kBlockCollision;
	
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"largeTriangle.png"] type: bbTriangleL weight:weight rotation:rotation];
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	block.rotation = rotation;
	return block;	
}


+(cpCCSpriteBlock *)buildXtraLargeTriangleForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass = xtraLargeBlockMass/2;
	
	cpShape *shape = [space addPolyAt:position mass:theMass rotation:angle numPoints:4 points: cpv(-39.7f, -41.0f),
					  cpv(-38.5f, 40.7f),
					  cpv(41.2f, 40.5f),
					  cpv(-39.2f, -41.0f)];
	shape->collision_type = kBlockCollision;
	
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	block = [cpCCSpriteBlock spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"xtraLargeTriangle.png"] type: bbTriangleXL weight:weight rotation:rotation];
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	block.rotation = rotation;
	return block;	
}

#pragma mark -
#pragma mark Bomb

+(cpCCSpriteBlock *)buildBombForSpace:(SpaceManager *)space position:(cpVect)position rotation:(float)rotation type:(bbWeight)weight mass:(bbWeight)blockMass
{
	float angle = [self getAngleForRotation:rotation];
	
	float theMass = smallBlockMass;
	
	cpShape *shape = [space addPolyAt:position mass:theMass rotation:angle numPoints:6 points: cpv(-8.4f, -14.0f),
					  cpv(-8.4f, 4.1f),
					  cpv(-0.3f, 14.3f),
					  cpv(8.9f, 4.4f),
					  cpv(8.2f, -14.0f),
					  cpv(-8.0f, -14.0f)];
	
	shape->collision_type = kBombCollision;
	shape->u = kFriction;
	
	cpCCSpriteBlock *block;
	
	block = [cpCCSpriteBomb spriteWithShape:shape texture:[[CCTextureCache sharedTextureCache] addImage:@"bombWTnt.png"] type: bbBomb weight:weight rotation:rotation];
	
	if([[WBManager sharedManager]loadWithEditor]==NO)
	{
		block.autoFreeShape = YES;
		block.spaceManager = space;
	}
	
	block.rotation = rotation;
	return block;
}

@end
