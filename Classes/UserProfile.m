//
//  UserProfile.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/27/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "UserProfile.h"


@implementation UserProfile
@synthesize name,difficulty,profileNumber,gameScores;
@synthesize level1,level2,level3,level4,level5,level6,level7,level8,level9,level10,
			level11,level12,level13,level14,level15,level16,level17,level18,level19,level20,
			level21,level22,level23,level24,level25,level26,level27,level28,level29,level30;
@synthesize shouldShowTutorial;

#pragma mark -
#pragma mark Init Method(s)
-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		versionNumber = 2;
		
		shouldShowTutorial = YES;
		
		//Default set to level being unbeaten 
		self.level1 = NO;
		self.level2 = NO;
		self.level3 = NO;
		self.level4 = NO;
		self.level5 = NO;
		self.level6 = NO;
		self.level7 = NO;
		self.level8 = NO;
		self.level9 = NO;
		self.level10 = NO;
		self.level11 = NO;
		self.level12 = NO;
		self.level13 = NO;
		self.level14 = NO;
		self.level15 = NO;
		self.level16 = NO;
		self.level17 = NO;
		self.level18 = NO;
		self.level19 = NO;
		self.level20 = NO;
		self.level21 = NO;
		self.level22 = NO;
		self.level23 = NO;
		self.level24 = NO;
		self.level25 = NO;
		self.level26 = NO;
		self.level27 = NO;
		self.level28 = NO;
		self.level29 = NO;
		self.level30 = NO;
		
		//Creates an array of game scores then adds default values of 0 for each level score
		NSMutableArray *array = [[NSMutableArray alloc]init];
		self.gameScores = array;
		[array release];
		
		for (int i = 0; i<=30; i++) 
		{
			GameCard *card = [[GameCard alloc]initWithScore:0 time:0 height:0 cheated:NO];
			[self.gameScores insertObject:card atIndex:i];
			[card release];
		}
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
	[encoder encodeObject:self.name forKey:@"Name"];
	[encoder encodeInt:self.difficulty forKey:@"Difficulty"];
	[encoder encodeInt:self.profileNumber forKey:@"ProfileNumber"];
	[encoder encodeObject:self.gameScores forKey:@"GameScores"];
	
	[encoder encodeBool: self.shouldShowTutorial forKey:@"Tutorial"];
	
	[encoder encodeBool: self.level1 forKey:@"Level1"];
	[encoder encodeBool: self.level2 forKey:@"Level2"];
	[encoder encodeBool: self.level3 forKey:@"Level3"];
	[encoder encodeBool: self.level4 forKey:@"Level4"];
	[encoder encodeBool: self.level5 forKey:@"Level5"];
	[encoder encodeBool: self.level6 forKey:@"Level6"];
	[encoder encodeBool: self.level7 forKey:@"Level7"];
	[encoder encodeBool: self.level8 forKey:@"Level8"];
	[encoder encodeBool: self.level9 forKey:@"Level9"];
	[encoder encodeBool: self.level10 forKey:@"Level10"];
	
	[encoder encodeBool: self.level11 forKey:@"Level11"];
	[encoder encodeBool: self.level12 forKey:@"Level12"];
	[encoder encodeBool: self.level13 forKey:@"Level13"];
	[encoder encodeBool: self.level14 forKey:@"Level14"];
	[encoder encodeBool: self.level15 forKey:@"Level15"];
	[encoder encodeBool: self.level16 forKey:@"Level16"];
	[encoder encodeBool: self.level17 forKey:@"Level17"];
	[encoder encodeBool: self.level18 forKey:@"Level18"];
	[encoder encodeBool: self.level19 forKey:@"Level19"];
	[encoder encodeBool: self.level20 forKey:@"Level20"];
	
	[encoder encodeBool: self.level21 forKey:@"Level21"];
	[encoder encodeBool: self.level22 forKey:@"Level22"];
	[encoder encodeBool: self.level23 forKey:@"Level23"];
	[encoder encodeBool: self.level24 forKey:@"Level24"];
	[encoder encodeBool: self.level25 forKey:@"Level25"];
	[encoder encodeBool: self.level26 forKey:@"Level26"];
	[encoder encodeBool: self.level27 forKey:@"Level27"];
	[encoder encodeBool: self.level28 forKey:@"Level28"];
	[encoder encodeBool: self.level29 forKey:@"Level29"];
	[encoder encodeBool: self.level30 forKey:@"Level30"];

}

-(id)initWithCoder:(NSCoder *)decoder
{
	//Decodes the properties
	self.name = [decoder decodeObjectForKey:@"Name"];
	self.difficulty = [decoder decodeIntForKey:@"Difficulty"];
	self.profileNumber = [decoder decodeIntForKey:@"ProfileNumber"];
	self.gameScores = [decoder decodeObjectForKey:@"GameScores"];
	
	self.shouldShowTutorial = [decoder decodeBoolForKey:@"Tutorial"];
	
	self.level1 = [decoder decodeBoolForKey:@"Level1"];
	self.level2 = [decoder decodeBoolForKey:@"Level2"];
	self.level3 = [decoder decodeBoolForKey:@"Level3"];
	self.level4 = [decoder decodeBoolForKey:@"Level4"];
	self.level5 = [decoder decodeBoolForKey:@"Level5"];
	self.level6 = [decoder decodeBoolForKey:@"Level6"];
	self.level7 = [decoder decodeBoolForKey:@"Level7"];
	self.level8 = [decoder decodeBoolForKey:@"Level8"];
	self.level9 = [decoder decodeBoolForKey:@"Level9"];
	self.level10 = [decoder decodeBoolForKey:@"Level10"];
	
	self.level11 = [decoder decodeBoolForKey:@"Level11"];
	self.level12 = [decoder decodeBoolForKey:@"Level12"];
	self.level13 = [decoder decodeBoolForKey:@"Level13"];
	self.level14 = [decoder decodeBoolForKey:@"Level14"];
	self.level15 = [decoder decodeBoolForKey:@"Level15"];
	self.level16 = [decoder decodeBoolForKey:@"Level16"];
	self.level17 = [decoder decodeBoolForKey:@"Level17"];
	self.level18 = [decoder decodeBoolForKey:@"Level18"];
	self.level19 = [decoder decodeBoolForKey:@"Level19"];
	self.level20 = [decoder decodeBoolForKey:@"Level20"];
	
	self.level21 = [decoder decodeBoolForKey:@"Level21"];
	self.level22 = [decoder decodeBoolForKey:@"Level22"];
	self.level23 = [decoder decodeBoolForKey:@"Level23"];
	self.level24 = [decoder decodeBoolForKey:@"Level24"];
	self.level25 = [decoder decodeBoolForKey:@"Level25"];
	self.level26 = [decoder decodeBoolForKey:@"Level26"];
	self.level27 = [decoder decodeBoolForKey:@"Level27"];
	self.level28 = [decoder decodeBoolForKey:@"Level28"];
	self.level29 = [decoder decodeBoolForKey:@"Level29"];
	self.level30 = [decoder decodeBoolForKey:@"Level30"];
	
	return self;
}

#pragma mark -
#pragma mark User info method
-(double)getPercentDone;
{
	//Counts levels complete
	int levelsCompleted = 0;
	
	if(self.level1)levelsCompleted++;
	if(self.level2)levelsCompleted++;
	if(self.level3)levelsCompleted++;
	if(self.level4)levelsCompleted++;
	if(self.level5)levelsCompleted++;
	if(self.level6)levelsCompleted++;
	if(self.level7)levelsCompleted++;
	if(self.level8)levelsCompleted++;
	if(self.level9)levelsCompleted++;
	if(self.level10)levelsCompleted++;
	if(self.level11)levelsCompleted++;
	if(self.level12)levelsCompleted++;
	if(self.level13)levelsCompleted++;
	if(self.level14)levelsCompleted++;
	if(self.level15)levelsCompleted++;
	if(self.level16)levelsCompleted++;
	if(self.level17)levelsCompleted++;
	if(self.level18)levelsCompleted++;
	if(self.level19)levelsCompleted++;
	if(self.level20)levelsCompleted++;
	if(self.level21)levelsCompleted++;
	if(self.level22)levelsCompleted++;
	if(self.level23)levelsCompleted++;
	if(self.level24)levelsCompleted++;
	if(self.level25)levelsCompleted++;
	if(self.level26)levelsCompleted++;
	if(self.level27)levelsCompleted++;
	if(self.level28)levelsCompleted++;
	if(self.level29)levelsCompleted++;
	if(self.level30)levelsCompleted++;
	
	//Return percentage done
	float value = (levelsCompleted/30.0f);
	double value2 = value * 100;
	return value2;
}

-(void)addGameCardWithScore:(int)score time:(int)time height:(int)height forLevel:(int)level didCheat:(BOOL)cheatingStatus
{
	GameCard *oldCard = [self.gameScores objectAtIndex:level-1];
	
	int bestScore = 0;
	int bestTime = 0;
	int bestHeight = 0;
	
	if(oldCard.score <= score || oldCard.score == 0 || oldCard.didCheat)bestScore = score;
	else bestScore = oldCard.score;
		
	if(oldCard.time >= time || oldCard.time == 0 || oldCard.didCheat)bestTime = time;
	else bestTime = oldCard.time;
	
	if(oldCard.height <= height || oldCard.height == 0 || oldCard.didCheat)bestHeight = height;
	else bestHeight = oldCard.height;
	
	//Replaces the score for a given level with the new score if the new score is larger
	GameCard *card = [[GameCard alloc]initWithScore:bestScore time:bestTime height:bestHeight cheated:cheatingStatus]; 
	
	[self.gameScores replaceObjectAtIndex:level-1 withObject:card];
	
	[card release];
}

-(GameCard *)getGameCardForLevel:(int)level
{
	//returns games score for a level
	return [self.gameScores objectAtIndex:level];
}

-(BOOL)countrysideDone
{
	if(self.level1 && self.level2 && self.level3 && self.level4 && self.level5 && self.level6 && self.level7 && self.level8 && self.level9 && self.level10)return YES;
	else return NO;
}

-(BOOL)wildernessDone
{
	if(self.level11 && self.level12 && self.level13 && self.level14 && self.level15 && self.level16 && self.level17 && self.level18 && self.level19 && self.level20)return YES;
	else return NO;
}

-(BOOL)cityDone
{
	if(self.level21 && self.level22 && self.level23 && self.level24 && self.level25 && self.level26 && self.level27 && self.level28 && self.level29 && self.level30)return YES;
	else return NO;
}

#pragma mark -
#pragma mark Init cleanup
-(void)dealloc
{
	[gameScores release];
	[name release];
	[super dealloc];
}

@end
