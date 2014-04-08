//
//  UserProfile.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/27/10.
//  Copyright 2010 Home. All rights reserved.
//

//Type for desired difficulties

#import "GameCard.h"

typedef enum
{
	bbEasy,
	bbMedium,
	bbHard
}bbDifficulty;

@interface UserProfile : NSObject <NSCoding>
{
	int versionNumber;
	
	//ID's itself for which profile it is taking 1,2,3,or 4
	int profileNumber;
	
	//Username
	NSString *name;
	//User difficulty
	bbDifficulty difficulty;
	
	//Array of game scores for each level
	NSMutableArray *gameScores;
	
	//Yes for unlocked no for locked.
	BOOL level1;
	BOOL level2;
	BOOL level3;
	BOOL level4;
	BOOL level5;
	BOOL level6;
	BOOL level7;
	BOOL level8;
	BOOL level9;
	BOOL level10;
	
	BOOL level11;
	BOOL level12;
	BOOL level13;
	BOOL level14;
	BOOL level15;
	BOOL level16;
	BOOL level17;
	BOOL level18;
	BOOL level19;
	BOOL level20;
	
	BOOL level21;
	BOOL level22;
	BOOL level23;
	BOOL level24;
	BOOL level25;
	BOOL level26;
	BOOL level27;
	BOOL level28;
	BOOL level29;
	BOOL level30;
	
	//Intially yes to show tutorial, then NO to never show tutorial again
	BOOL shouldShowTutorial;
}
@property (nonatomic, retain) NSMutableArray *gameScores;
@property (readwrite) int profileNumber;
@property (nonatomic,retain) NSString *name;
@property (readwrite) bbDifficulty difficulty;
@property (readwrite) BOOL level1,level2,level3,level4,level5,level6,level7,level8,level9,level10,
						   level11,level12,level13,level14,level15,level16,level17,level18,level19,level20,
						   level21,level22,level23,level24,level25,level26,level27,level28,level29,level30;
@property (readwrite) BOOL shouldShowTutorial;

-(int)versionNumber;

//Returns a int representing percentage of levels complete for this user
-(double)getPercentDone;

//Adds a score for specific level for the user.
-(void)addGameCardWithScore:(int)score time:(int)time height:(int)height forLevel:(int)level didCheat:(BOOL)cheatingStatus;

//Gets the score for a specific level
-(GameCard *)getGameCardForLevel:(int)level;

//Returns YES if the given location is complete (all 10 worksites finished)
-(BOOL)countrysideDone;
-(BOOL)wildernessDone;
-(BOOL)cityDone;

@end
