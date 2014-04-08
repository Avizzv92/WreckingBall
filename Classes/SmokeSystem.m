//
//  SmokeSystem.m
//
//  Created by Aaron Vizzini on 3/13/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SmokeSystem.h"

@implementation SmokeSystem

#pragma mark -
#pragma mark Init Method(s)

-(id) init
{
	return [self initWithTotalParticles:5];
}

-(id) initWithTotalParticles:(int)p
{
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
	// duration
	self.duration = 2.0f;
	
	// gravity
	self.gravity = ccp(-1,.5f);
	
	// angle
	self.angle = 90;
	self.angleVar = 360;
	
	// radial acceleration
	self.radialAccel = 0;
	self.radialAccelVar = 0;
	
	// emitter position
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	self.position = ccp(winSize.width/2, winSize.height/2);
	posVar = ccp(5, 5);
	
	// life of particles
	life = 2;
	lifeVar = 0;
	
	// speed of particles
	self.speed = 2;
	self.speedVar = 1;
	
	// size, in pixels
	startSize = 21.0f;
	startSizeVar = 5.0f;
	endSize = 27.0f;
	
	// emits per frame
	emissionRate = FLT_MAX;
	
	// color of particles
	startColor.r = 0.5f;
	startColor.g = 0.5f;
	startColor.b = 0.5f;
	startColor.a = .5f;
	startColorVar.r = 0.02f;
	startColorVar.g = 0.02f;
	startColorVar.b = 0.02f;
	startColorVar.a = 0.0f;
	endColor.r = 0.0f;
	endColor.g = 0.0f;
	endColor.b = 0.0f;
	endColor.a = 0.0f;
	endColorVar.r = 0.0f;
	endColorVar.g = 0.0f;
	endColorVar.b = 0.0f;
	endColorVar.a = 0.0f;
	
	self.texture = [[CCTextureCache sharedTextureCache] addImage: @"engineSmoke.png"];
	
	// additive
	self.blendAdditive = NO;
	
	return self;
}
@end

