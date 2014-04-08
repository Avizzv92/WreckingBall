//
//  GameCard.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 6/30/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "GameCard.h"


@implementation GameCard
@synthesize score, time, height, didCheat;

#pragma mark -
#pragma mark Init Method

-(id)initWithScore:(int)theScore time:(int)theTime height:(int)theHeight cheated:(BOOL)cheatStatus
{
	self = [super init];
	if(self != nil)
	{
		versionNumber = 2;
	
		self.didCheat = cheatStatus;
		
		self.score = theScore;
		self.time = theTime;
		self.height = theHeight;
	}
	
	return self;
}

-(int)versionNumber
{
	return versionNumber;
}

#pragma mark -
#pragma mark NSCoding protocol methods
-(void)encodeWithCoder:(NSCoder *)encoder
{
	//Encodes the properties
	[encoder encodeInt:self.time forKey:@"Time"];
	[encoder encodeInt:self.score forKey:@"Score"];
	[encoder encodeInt:self.height forKey:@"Height"];
	
	[encoder encodeBool:self.didCheat forKey:@"Cheat"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
	//Decodes the properties
	self.time = [decoder decodeIntForKey:@"Time"];
	self.score = [decoder decodeIntForKey:@"Score"];
	self.height = [decoder decodeIntForKey:@"Height"];
	
	self.didCheat = [decoder decodeBoolForKey:@"Cheat"];
	
	return self;
}

@end
