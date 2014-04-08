//
//  GameLayer.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 3/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "cocos2d.h"
#import "BlockBuilder.h"
#import "Crane.h"
#import "SpaceManager.h"
#import "cpShapeNode.h"
#import "cpCCSprite.h"
#import "cpConstraintNode.h"
#import "cpConstraint.h"
#import "GamePopUp.h"
#import "Level.h"
#import "TouchEffect.h"
#import "UserProfile.h"
#import "CCArray.h"
#import "OFAchievement.h"
#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"

//Typedef for the possible movement directions of the crane
typedef enum
{
	bbRight,
	bbLeft,
	bbUp,
	bbDown,
	bbNon
}bbMovement;

@interface TutorialLayer : CCLayer <UIAccelerometerDelegate,GamePopUpDelegate,UIApplicationDelegate>
{		
	NSMutableDictionary *settingsDictionary;
	
	AVAudioPlayer *countrysideSound;
	AVAudioPlayer *engineSound;
	AVAudioPlayer *engineGrind;
	
	float lastSoundTime;
	CGPoint lastHitPoint;
	
	float setWindSpeed;
	bbWindDirection setWindDirection;
	
	//Alert popup for when something that shouldn't be touched (buidlings or lake) has been touched
	CCLabel *alertPopup;
	
	//Current user playing the level
	UserProfile *currentUser;
	
	//Current level being played
	NSString *currentLevel;
	
	//Popup for when level has completed
	GamePopUp *popUpManager;
	
	//Space
	SpaceManager* smgr;
	
	//Pause Menu
	CCSprite *pauseMenu;
	BOOL isPaused;
	
	//Temp storage for the level's file location
	NSString *tempLevelLoc;
	
	//Wrecking Ball
	cpCCSprite *ballNode;
	cpConstraint *joint;
	
	//Crane
	Crane *crane;
	
	//Labels to display the windspeed and game timer
	CCLabel *theWindSpeed;
	CCLabel *theGameTimer;
	
	
	//TrollyClone for tracking purposes
	cpCCSprite *trollyClone;
	
	//If suggested time has passed or not.
	BOOL suggestedTimePassed;
	
	//Game timer
	float gameTimer;
	
	//Suggested time
	float suggestedTime;
		
	//Previous time for temp var for one of the methods to calulate force limitations
	int prevTime;
	int prevHCTime;
	
	//Height bar for level
	cpCCSprite *bar;
	
	//All the blocks for the level
	CCArray *blocks;
	
	//If a game has been completed or not
	BOOL gameComplete;
	
	//Pivot constraint
	cpConstraint *pivotLeft;
	
	bbMovement activeDirection;
	
	////////////////////////////WRECKING BALL FORCE LIMITATIONS//////////////////////////////////
	//Current moving direction of trolley
	bbMovement direction;
	//Last direction moved of the trolley
	bbMovement lastDirection;
	
	//Time since the ball has made contact with a block going the direction
	float timerSinceRightContact;
	float timerSinceLeftContact;
	
	float timerSinceUpContact;
	float timerSinceDownContact;
	
	//If the crane can move trolley in a given direction
	BOOL canMoveRight;
	BOOL canMoveLeft;
	
	BOOL canMoveUp;
	BOOL canMoveDown;
	
	//Time since "freeze" call
	float timeSinceCall;
	
	//Time since last contact
	float timeSinceLastContact;
	/////////////////////////////////////////////////////////////////////////////////////////////
	
}
@property (nonatomic, retain) UserProfile *currentUser;

//Loads a level from a file
-(void)loadLevelWithFile:(NSString *)levelFile;

//Show or display pause menu
-(void)showPause;
-(void)hidePause;

//Handles collisions with ball and blocks
-(void)handleCollisionWithBall:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
//Handles collisions with ball and bombs
-(void)handleCollisionWithBomb:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;

//Adds a block to the level
-(void)addBlock:(bbBlockType)blockType weight:(bbWeight)blockWeight position:(CGPoint)blockPosition rotation:(float)blockRotation;
//Called to increase gametimer
-(void)timePass;
//Gets hieghest point of any of the blocks
-(float)highestPoint;
//trolly movement
-(void)right;
-(void)left;
-(void)raise;
-(void)lower;

//Called to return to main menu
-(void)returnToMenu;

//Game completed
-(void)gameCompleted;

//Gets the level's location
-(NSString*)getLevelLoc;

@end
