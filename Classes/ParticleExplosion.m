//
//  ParticleExplosion.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/31/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "ParticleExplosion.h"


@implementation ParticleExplosion
#pragma mark -
#pragma mark Init Method(s)
-(id) init
{
	return [self initWithTotalParticles:700];
}

-(id) initWithTotalParticles:(int)p
{
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
	// duration
	duration = 0.1f;
	
	// gravity
	self.gravity = ccp(0,-50);
	
	// angle
	angle = 90;
	angleVar = 360;
	
	// speed of particles
	self.speed = 140;
	self.speedVar = 80;
	
	// radial
	self.radialAccel = 1;
	self.radialAccelVar = 0;
	
	// tagential
	self.tangentialAccel = 0;
	self.tangentialAccelVar = 0;
	
	// emitter position
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	self.position = ccp(winSize.width/2, winSize.height/2);
	posVar = CGPointZero;
	
	// life of particles
	life = .2f;
	lifeVar = .2;
	
	// size, in pixels
	startSize = 2.0f;
	startSizeVar = 1.0f;
	endSize = kParticleStartSizeEqualToEndSize;
	
	// emits per second
	emissionRate = totalParticles/duration;
	
	// color of particles
	startColor.r = 1.0f;
	startColor.g = 1.0f;
	startColor.b = 1.0f;
	startColor.a = 1.0f;
	startColorVar.r = 0.1f;
	startColorVar.g = 0.1f;
	startColorVar.b = 0.1f;
	startColorVar.a = 0.1f;
	endColor.r = 0.0f;
	endColor.g = 0.0f;
	endColor.b = 0.0f;
	endColor.a = 0.0f;
	endColorVar.r = 0.0f;
	endColorVar.g = 0.0f;
	endColorVar.b = 0.0f;
	endColorVar.a = 0.0f;
	
	self.texture = [[CCTextureCache sharedTextureCache] addImage: @"explosionParticle.png"];
	
	// additive
	self.blendAdditive = NO;
	
	return self;
}
@end
