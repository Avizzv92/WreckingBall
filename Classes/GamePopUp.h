//
//  GamePopUp.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/22/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "cocos2d.h"
#import "OFAchievement.h"
#import "OFHighScore.h"
#import "OFHighScoreService.h"
#import "SimpleAudioEngine.h"

//Protocol for the delegate of GamePopUp
@protocol GamePopUpDelegate <NSObject>

@required
//Turns on and of touch enabled
-(void)setIsTouchEnabled:(BOOL)state;
-(BOOL)isTouchEnabled;
//Called when the delegate needs to return to main menu
-(void)returnToMenu;
-(NSString*)getLevelLoc;
-(void)saveSettings;
-(void)endSound;

@end

@interface GamePopUp : CCLayer 
{
	BOOL popupAnimationDone;
	
	//Back image
	CCSprite *gameComplete;
	
	//Level failed popup
	CCSprite *levelFailed;
	
	//Labels for scoring imformation
	CCLabel *finalHeight;
	CCLabel *fuelLeft;
	CCLabel *timeLeft;
	CCLabel *finalScore;
	
	//The delegate
	id <GamePopUpDelegate> delegate;
	
	//If either of the popups have been shown yet
	BOOL gameCompletePopup;
	BOOL gameFailedPopup;
}
//Delegate comforms to GamePopUpDelegate
@property(nonatomic,assign) id <GamePopUpDelegate> delegate;

//Shows the game complete screen based on the given parameters
-(void)showGameCompleteWithHeight:(NSString *)height fuelLeft:(NSString *)fuel timeLeft:(NSString *)time hits:(NSString *)hits finalScore:(NSString *)score didCheat:(BOOL)hasCheated;
//Show level failed popup
-(void)showLevelFailed;

-(int)getLevelNumber;
@end
