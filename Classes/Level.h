//
//  Level.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/7/10.
//  Copyright 2010 Home. All rights reserved.
//
#import "EditorBlock.h"

//Typdef location of level and wind direction
typedef enum {bbCountrySide, bbWilderness, bbCity, bbLunar}bbLocation;
typedef enum {bbEast, bbWest}bbWindDirection;

//Confirms to the NSCoding protocol
@interface Level : NSObject <NSCoding>
{
	//Level name
	NSString *name;
	//Max height the demolished bulding can be to pass the level
	int maxHeight;
	//Time limite for level
	int timeLimit;
	//hit limite, amount of times the ball can hit a block
	int hitLimit;
	//Crane fuel, amount of fuel a crane has to start the level
	int craneFuel;
	//Wind speed
	int windSpeed;
	
	//Location of level
	bbLocation location;
	
	//direction the wind is blowing for a level
	bbWindDirection windDirection;
	
	//Stores all the blocks being used for the level
	NSMutableArray *blocks;
	
	//Screenshot of level
	UIImage *screenshot;
}
//Properties for all the level information
@property (nonatomic,retain) NSString *name;
@property (readwrite) int maxHeight, timeLimit, craneFuel,hitLimit;
@property (readwrite) int windSpeed;
@property (readwrite) bbLocation location;
@property (readwrite) bbWindDirection windDirection;
@property (nonatomic, retain) UIImage *screenshot;

//Adds a block to the array
-(void)addBlock:(EditorBlock *)theBlock;
//Gets the array of blocks
-(NSMutableArray *)getBlocksArray;

//NSCoding methods for archiving
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;

@end
