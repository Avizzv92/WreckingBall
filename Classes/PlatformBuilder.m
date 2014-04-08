//
//  PlatformBuilder.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/19/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "PlatformBuilder.h"

//Predefined friction value
#define kFriction 1.0f

@implementation PlatformBuilder

#pragma mark -
#pragma mark Platform Creation Methods

//Create the platform with a level angle at proper location for the given space.

//This platform used for the default, and countryside location
+(cpCCSprite *)buildFlatPlatformForSpace:(SpaceManager *)space position:(cpVect)position
{
	float angle = 0.0f * M_PI / 180;
	cpShape *shape = [space addRectAt:position mass:STATIC_MASS width:680 height:1 rotation:angle];
	shape->u = kFriction;
	shape->e = .7f;
		
	cpCCSprite *coupler = [cpCCSprite spriteWithShape:shape file:@"coupler.png"];
	return coupler;
}

//This platform used for the wilderness location
+(cpCCSprite *)buildLakePlatformForSpace:(SpaceManager *)space position:(cpVect)position
{
	float angle = 0.0f * M_PI / 180;
	cpShape *shape = [space addPolyAt:position mass:STATIC_MASS rotation:angle numPoints:5 points: cpv(-338.4f, -146.8f),
					  cpv(144.5f, -146.8f),
					  cpv(157.0f, -158.5f),
					  cpv(-338.4f, -158.5f),
					  cpv(-338.4f, -146.8f)];	
	shape->u = kFriction;
	shape->e = .7f;
	
	//Shape used for collision detection with blocks. It is the actual "lake".
	cpShape *lake = [space addPolyAt:ccp(240,161) mass:STATIC_MASS rotation:angle numPoints:5 points: cpv(149.2f, -147.6f),
					 cpv(339.2f, -143.7f),
					 cpv(336.8f, -155.4f),
					 cpv(165.6f, -154.6f),
					 cpv(150.7f, -148.4f)];	
	lake->u = kFriction;
	lake->e = .7f;
	lake->collision_type = kLakeCollision;
	
	cpCCSprite *coupler = [cpCCSprite spriteWithShape:shape file:@"coupler.png"];
	return coupler;
}

+(cpCCSprite *)buildCityPlatformForSpace:(SpaceManager *)space position:(cpVect)position
{
	float angle = 0.0f * M_PI / 180;
	cpShape *shape = [space addRectAt:position mass:STATIC_MASS width:680 height:1 rotation:angle];
	shape->u = kFriction;
	shape->e = .7f;
	
	cpShape *building = [space addPolyAt:ccp(240,161) mass:STATIC_MASS rotation:angle numPoints:5 points: cpv(186.0f, -145.0f),
						 cpv(183.0f, 151.0f),
						 cpv(239.0f, 152.0f),
						 cpv(238.0f, -147.0f),
						 cpv(186.0f, -145.0f)];	
	building->u = kFriction;
	building->e = .7f;
	building->collision_type = kSkyscraperCollision;

	cpCCSprite *coupler = [cpCCSprite spriteWithShape:shape file:@"coupler.png"];
	return coupler;
}

@end
