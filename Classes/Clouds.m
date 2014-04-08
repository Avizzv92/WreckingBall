//
//  Clouds.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/6/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "Clouds.h"


@implementation Clouds

#pragma mark -
#pragma mark init methods

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		//Creates the 3 clouds
		cloud1 = [CCSprite spriteWithFile:@"cloud.png"];
		cloud2 = [CCSprite spriteWithFile:@"cloud.png"];
		cloud3 = [CCSprite spriteWithFile:@"cloud.png"];
		cloud4 = [CCSprite spriteWithFile:@"cloud.png"];
		cloud5 = [CCSprite spriteWithFile:@"cloud.png"];
		cloud6 = [CCSprite spriteWithFile:@"cloud.png"];
		
		[self addChild: cloud1];
		[self addChild: cloud2];
		[self addChild: cloud3];
		[self addChild: cloud4];
		[self addChild: cloud5];
		[self addChild: cloud6];
		
		cloud1.position = ccp(-70,-199);
		cloud2.position = ccp(-70,-199);
		cloud3.position = ccp(-70,-199);
		cloud4.position = ccp(-70,-199);
		cloud5.position = ccp(-70,-199);
		cloud6.position = ccp(-70,-199);
		
		currentDirection = bbEast;
		
		currentSpeed = 60.0f;
		duration = abs((.42f*currentSpeed)-50.0f);
		
		step = duration/4.0f;
			
		[self performSelector:@selector(reset:) withObject:cloud1 afterDelay:0.0f];
		[self performSelector:@selector(reset:) withObject:cloud2 afterDelay:step*1];
		[self performSelector:@selector(reset:) withObject:cloud3 afterDelay:step*2];
		[self performSelector:@selector(reset:) withObject:cloud4 afterDelay:step*3];
		[self performSelector:@selector(reset:) withObject:cloud5 afterDelay:step*4];
		
		[self schedule:@selector(resetAll) interval:step*5];
	}
	
	return self;
}

-(id)initWithSpeed:(float)speed direction:(bbWindDirection)direction
{
	self = [super init];
	
	if(self != nil)
	{
		//Creates the 3 clouds
		cloud1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"cloud.png"]];
		cloud2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"cloud.png"]];
		cloud3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"cloud.png"]];
		cloud4 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"cloud.png"]];
		cloud5 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"cloud.png"]];
		cloud6 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"cloud.png"]];
		
		[self addChild: cloud1];
		[self addChild: cloud2];
		[self addChild: cloud3];
		[self addChild: cloud4];
		[self addChild: cloud5];
		[self addChild: cloud6];
		
		if(direction == bbEast)
		{
			cloud1.position = ccp(-70,-199);
			cloud2.position = ccp(-70,-199);
			cloud3.position = ccp(-70,-199);
			cloud4.position = ccp(-70,-199);
			cloud5.position = ccp(-70,-199);
			cloud6.position = ccp(-70,-199);
		}
		
		else if(direction == bbWest)
		{
			cloud1.position = ccp(550,-199);
			cloud2.position = ccp(550,-199);
			cloud3.position = ccp(550,-199);
			cloud4.position = ccp(550,-199);
			cloud5.position = ccp(550,-199);
			cloud6.position = ccp(550,-199);
		}
		
		//sets direction and wind speed, then runs them
		currentDirection = direction;
		
		[self setWindSpeed:speed];
		duration = abs((.42f*currentSpeed)-50.0f);
		
		step = duration/4.0f;
				
		[self performSelector:@selector(reset:) withObject:cloud1 afterDelay:0.0f];
		[self performSelector:@selector(reset:) withObject:cloud2 afterDelay:step*1];
		[self performSelector:@selector(reset:) withObject:cloud3 afterDelay:step*2];
		[self performSelector:@selector(reset:) withObject:cloud4 afterDelay:step*3];
		[self performSelector:@selector(reset:) withObject:cloud5 afterDelay:step*4];
		
		[self schedule:@selector(resetAll) interval:step*5];
	}
	
	return self;
}

+(id)cloudsWithSpeed:(float)speed direction:(bbWindDirection)direction
{
	//Calulates clouds for windspeed and direction
	return [[[Clouds alloc] initWithSpeed:speed direction:direction]autorelease];
}


#pragma mark -
#pragma mark cloud reset methods
-(void)resetAll
{
	//reset clouds position
	[self performSelector:@selector(reset:) withObject:cloud1 afterDelay:0.0f];
	[self performSelector:@selector(reset:) withObject:cloud2 afterDelay:step*1];
	[self performSelector:@selector(reset:) withObject:cloud3 afterDelay:step*2];
	[self performSelector:@selector(reset:) withObject:cloud4 afterDelay:step*3];
	[self performSelector:@selector(reset:) withObject:cloud5 afterDelay:step*4];
}

-(void)reset:(CCSprite*)cloud
{	
	if(currentDirection == bbEast)
	{
		//Generates random values within a range for location, duration, and delay
		float randomStartY = 250 +(arc4random() % 50 + 1); //returns a number between 1 and 19
		float randomDuration = duration;
	
		//Scales the cloud by random values
		cloud.scaleY = .8f + ((arc4random() % 7 + 1)/10);
		cloud.scaleX = .8f + ((arc4random() % 7 + 1)/10);
			
		//Positions the cloud
		cloud.position = ccp(-70,randomStartY);
		
		//runs the action
		id action = [CCMoveTo actionWithDuration:randomDuration position:ccp(550,cloud.position.y)];
		[cloud runAction:[CCRepeatForever actionWithAction:action]];
	}
	
	else if(currentDirection == bbWest)
	{
		//Generates random values within a range for location, duration, and delay
		float randomStartY = 250 +(arc4random() % 50 + 1); //returns a number between 1 and 19
		float randomDuration = duration;
		
		//Scales the cloud by random values
		cloud.scaleY = .8f + ((arc4random() % 7 + 1)/10);
		cloud.scaleX = .8f + ((arc4random() % 7 + 1)/10);
		
		//Positions the cloud
		cloud.position = ccp(550,randomStartY);
		
		//runs the action
		id action = [CCMoveTo actionWithDuration:randomDuration position:ccp(-70,cloud.position.y)];
		[cloud runAction:[CCRepeatForever actionWithAction:action]];
	}
}

#pragma mark -
#pragma mark cloud properties method
-(void)setDirection:(bbWindDirection)direction
{
	//Sets the cloud's direction
	currentDirection = direction;
}

-(void)setWindSpeed:(int)speed
{
	//Sets the cloud's windspeed
	currentSpeed = speed;
	
	if(currentSpeed > 100)currentSpeed=100;
	if(currentSpeed < 10)currentSpeed=10;
	
	duration = abs((.42f*currentSpeed)-50.0f);
	step = duration/4.0f;
}

#pragma mark -
#pragma mark cleanup

-(void)dealloc
{
	[super dealloc];
}

@end
