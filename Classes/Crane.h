//
//  Crane.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 3/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GasGauge.h"

@interface Crane : CCSprite 
{
	//Trolly Sprite
	CCSprite *trolly;
	
	//Fuel ivar
	int fuel;
	int originalFuel;
	
	//Gas gauge
	//GasGauge *gauge;
	CCLabel *fuelLeft;
	
	//Fuel label
	CCLabel *outOfFuel;
}
//Accessing the trolly sprite mainly for locational purposes
@property(readonly) CCSprite *trolly;

//Moves the trolly right or left.
-(BOOL)trollyRight;
-(BOOL)trollyLeft;

//Fuel methods//
//returns YES if out of fuel
-(BOOL)isOutOfFuel;
//Decreases fuel amount
-(void)decreaseFuel;
//Sets fuel amount
-(void)setFuel:(int)amount;
//Returns fuel amount
-(double)getFuelAmount;
//Returns the percentage of the total gas remaining
-(double)percentageOfFuelRemaining;
//Called when fuel runs out
-(void)fuelOut;
@end
