//
//  Level.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/7/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "Level.h"


@implementation Level
@synthesize name, maxHeight, timeLimit, windSpeed, location, windDirection, craneFuel, hitLimit, screenshot;

#pragma mark -
#pragma mark init methods

-(id)init
{
	self = [super init];
	
	if(self!=nil)
	{
		//alloc init the array for storing the blocks
		blocks = [[NSMutableArray alloc]init];
	}
	
	return self;
}

#pragma mark -
#pragma mark Block Array Mutator Methods

-(void)addBlock:(EditorBlock *)theBlock
{
	//Add the block to the array
	[blocks addObject: theBlock];//[theBlock retain]]; addObject: retains a refereance itself.
}

-(NSMutableArray *)getBlocksArray
{
	//Returns the block array
	return blocks;
}

#pragma mark -
#pragma mark NSCoding Methods

-(void)encodeWithCoder:(NSCoder *)encoder
{
	//Encodes the properties
	[encoder encodeObject: self.name forKey:@"LevelName"];
	[encoder encodeInt: self.maxHeight forKey:@"MaxHeight"];
	[encoder encodeInt: self.timeLimit forKey:@"TimeLimit"];
	[encoder encodeInt: self.hitLimit forKey:@"HitLimit"];
	[encoder encodeInt: self.craneFuel forKey:@"CraneFuel"];
	[encoder encodeFloat: self.windSpeed forKey:@"WindSpeed"];
	[encoder encodeInt: self.location forKey:@"Location"];
	[encoder encodeInt: self.windDirection forKey:@"WindDirection"];
	[encoder encodeObject: self.screenshot forKey:@"ScreenShot"];
	[encoder encodeObject: blocks forKey:@"Blocks"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
	//Decodes the properties
	self.name = [decoder decodeObjectForKey:@"LevelName"];
	self.maxHeight = [decoder decodeIntForKey:@"MaxHeight"];
	self.timeLimit = [decoder decodeIntForKey:@"TimeLimit"];
	self.hitLimit = [decoder decodeIntForKey:@"HitLimit"];
	self.craneFuel = [decoder decodeIntForKey:@"CraneFuel"];
	self.windSpeed = [decoder decodeFloatForKey:@"WindSpeed"];
	self.location = [decoder decodeIntForKey:@"Location"];
	self.windDirection = [decoder decodeIntForKey:@"WindDirection"];
	self.screenshot = [decoder decodeObjectForKey:@"ScreenShot"];
	blocks = [[decoder decodeObjectForKey:@"Blocks"]retain];
	
	return self;
}

#pragma mark -
#pragma mark cleanup
	
-(void)dealloc
{
	[screenshot release];
	[blocks release];
	[name release];
	[super dealloc];
}

@end
