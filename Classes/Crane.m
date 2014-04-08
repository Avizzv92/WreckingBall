//
//  Crane.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 3/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "Crane.h"

@implementation Crane
@synthesize trolly;

#define fuelMultiplier 20

#pragma mark -
#pragma mark init methods

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		//Trolly creation
		trolly = [CCSprite spriteWithFile:@"trolly.png"];
		trolly.position = ccp(123,278);
		[self addChild: trolly];
				
		//Default fuel is unlimited 
		fuel = -1;
		originalFuel = -1;
		
		//Creates the gasgauge spite for displaying fuel levels
		//gauge = [GasGauge spriteWithFile:@"gauge.png"];
		//gauge.position = ccp(452,289);//281
		//[self addChild:gauge];
		fuelLeft = [CCLabel labelWithString:@"Fuel Left 100%" fontName:@"Chalkduster" fontSize:14];
		fuelLeft.position = ccp(240,313);
		[self addChild:fuelLeft];
		
		//Creates a label to appear when fuel runs out.
		outOfFuel = [CCLabel labelWithString:@"Out Of Fuel" fontName:@"Chalkduster" fontSize:36];
		outOfFuel.position = ccp(240,160);
		outOfFuel.scale = 0.01f;
		outOfFuel.opacity = 0.0f;
		[self addChild:outOfFuel];
	}
	
	return self;
}

#pragma mark -
#pragma mark Fuel methods

-(void)fuelOut
{
	//Creates the animations
	id action = [CCFadeIn actionWithDuration:.6f];
	id action1 = [CCScaleTo actionWithDuration:.6f scale: 1.0f];
	id action3 = [CCMoveTo actionWithDuration:.7f position:ccp(outOfFuel.position.x,outOfFuel.position.y)];
	id action2 = [CCFadeOut actionWithDuration:.6f];
	
	//Displays the "Out of Fuel" label with the animation
	[outOfFuel runAction:action];
	[outOfFuel runAction:[CCSequence actions:action1,action3,action2,nil]];
}

-(void)setFuel:(int)amount
{
	//If fuel not equal to -1 sets fuel amount
	if(amount!=-1)
	{
		//Sets orgininal amount
		originalFuel = amount;
		
		//Creates a larger number based on the multiplication by the fuelMultiplier and amount for the purpose of calculations
		fuel = amount*fuelMultiplier;
		
		[fuelLeft setString:[NSString stringWithFormat:@"Fuel Left %i%%",(int)[self percentageOfFuelRemaining]]];
	}
}

#pragma mark -
#pragma mark Trolly Movement Methods

//Trolly move right so long as it does not go to far.
-(BOOL)trollyRight
{	
	//If not out of fuel
	if(![self isOutOfFuel])
	{
		if(trolly.position.x < 437)
		{
			trolly.position = ccp(trolly.position.x+1, trolly.position.y);
			//Use fuel
			[self decreaseFuel];
			
			return YES;
		}
	}
	
	return NO;
}

//Trolly move left so long as it does not go to far.
-(BOOL)trollyLeft
{	
	//If not out of fuel
	if(![self isOutOfFuel])
	{
		if(trolly.position.x > 122)
		{
			trolly.position = ccp(trolly.position.x-1, trolly.position.y);
			//Use fuel
			[self decreaseFuel];
			
			return YES;
		}
	}
	
	return NO;
}

-(BOOL)isOutOfFuel
{
	//If fuel equals -1 it's never out
	if(fuel == -1) return NO;
	//If fuel greater then 0 its not out
	else if(fuel > 0) return NO;
	//Fuel must be out
	else return YES;
}

-(void)decreaseFuel
{
	//If fuel greater then 0 decrease it
	if(fuel > 0)
		fuel--;
	
	//If fuel equals zero call fuel out
	if(fuel == 0)
		[self fuelOut];
	
	//Set the gauge to display the new amount remaining based on the percentage
	//[gauge setPercentage:[self percentageOfFuelRemaining]];
	[fuelLeft setString:[NSString stringWithFormat:@"Fuel Left %i%%",(int)[self percentageOfFuelRemaining]]];
}

//Returns the amount with the orginial ratio (by dividing by fuelMultiplier)
-(double)getFuelAmount
{
	double amountToReturn;
	
	amountToReturn = (fuel/fuelMultiplier);
	
	return amountToReturn;
}

-(double)percentageOfFuelRemaining
{
	//If fuel not -1 return the percent remaining
	if(fuel != -1)return ([self getFuelAmount]/originalFuel)*100;
	//If fuel equals -1 then it's always 100% remaining
	else return 100;
}

#pragma mark -
#pragma mark cleanup

-(void)dealloc
{
	[self removeChild:trolly cleanup:YES];
	[super dealloc];
}

@end
