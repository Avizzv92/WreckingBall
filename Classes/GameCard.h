//
//  GameCard.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 6/30/10.
//  Copyright 2010 Home. All rights reserved.
//

@interface GameCard : NSObject <NSCoding>
{
	int versionNumber;
	
	//Worksite information
	int score;
	int time;
	int height;
	
	BOOL didCheat;
}
@property (readwrite) int score, time, height;
@property (readwrite) BOOL didCheat;

-(int)versionNumber;

//Creates a game card with given information
-(id)initWithScore:(int)score time:(int)time height:(int)height cheated:(BOOL)cheatStatus;
@end
