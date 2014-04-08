//
//  TutorialLayer.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 7/23/10.
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
#import "TutorialScene.h"

//Typedef for the possible movement directions of the crane
typedef enum
{
	bbRightTut,
	bbLeftTut,
	bbUpTut,
	bbDownTut,
	bbNonTut
}bbMovementTut;

@interface TutorialLayer : CCLayer <UIAccelerometerDelegate,UIApplicationDelegate>
{		
	//For seeing if a user moved in all possible directions
	BOOL rightDone;
	BOOL leftDone;
	BOOL upDone;
	BOOL downDone;
	
	//Buttons for showing where to touch on a screen
	CCSprite *buttons;
	
	//Current progress within the tutorial
	int currentStep;
	
	//Universal Audio Settings
	NSMutableDictionary *settingsDictionary;
	
	//Abmiet Sound
	AVAudioPlayer *countrysideSound;
	
	//SFX
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
	
	//Current active direction the crane is moving in
	bbMovementTut activeDirection;
	
	////////////////////////////WRECKING BALL FORCE LIMITATIONS//////////////////////////////////
	//Current moving direction of trolley
	bbMovementTut direction;
	//Last direction moved of the trolley
	bbMovementTut lastDirection;
	
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
	
	//Time since last contact
	float timeSinceLastContact;
	/////////////////////////////////////////////////////////////////////////////////////////////
	
	CCLabel *tutorialDirections;	
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

//Move ahead in the tutorial
-(void)stepAhead;

@end
