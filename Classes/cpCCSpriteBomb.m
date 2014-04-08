//
//  cpCCSpriteBomb.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/31/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "cpCCSpriteBomb.h"
#import "ParticleExplosion.h"
#import "SmokeSystem.h"

#import "SimpleAudioEngine.h"

@implementation cpCCSpriteBomb

#pragma mark -
#pragma mark Init Method(s)
-(id)init
{
	self = [super init];
	
	if(self!=nil)
	{
		
	}
	
	return self;
}

#pragma mark -
#pragma mark Bomb Method
-(void)bombAtPoint:(CGPoint)point spritesAffected:(CCArray *)blocks layer:(CCLayer*)layer
{
	[[SimpleAudioEngine sharedEngine]playEffect:@"Explosion.caf"];
	AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
	
	//Distance affected
	int distance = 100;
	//Force from intitial blast
	int force = 750;
		
	//Loops through every block
	for(cpCCSpriteBlock *block in blocks)
	{
		//If it is within distance
		if(cpvnear(cpv(point.x,point.y), block.shape->body->p, distance))
		{
			//Calculate force based on distance away from blast and position from the blast
			cpVect temp = cpvsub(block.shape->body->p, cpv(point.x,point.y));
			temp = cpvclamp(temp, distance-cpvlength(temp));
			temp = cpvmult(temp, force);
			cpBodyApplyImpulse(block.shape->body, temp, cpvzero);
		}
	}
	
	//Creates a particle blast effect
	ParticleExplosion *exp = [ParticleExplosion node];
	exp.position = ccp(self.position.x,self.position.y);
	[layer addChild:exp];
	
	//Creates a post blast smoke effect
	SmokeSystem *smk = [SmokeSystem node];
	smk.position = ccp(self.position.x,self.position.y);
	[layer addChild:smk];
	
}

#pragma mark -
#pragma mark cleanup
-(void)dealloc
{
	[super dealloc];
}

@end
