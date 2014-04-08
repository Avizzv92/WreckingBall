//
//  EditorLayer.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/1/10.
//  Copyright 2010 Home. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TouchEffect.h"
#import "Level.h"
#import "EditorBlock.h"
#import "SaveMenu.h"
#import "BlockBuilder.h"
#import "Crane.h"
#import "SpaceManager.h"
#import "cpShapeNode.h"
#import "cpCCSprite.h"
#import "cpConstraintNode.h"
#import "cpConstraint.h"
#import "SimpleAudioEngine.h"

@interface EditorLayer : CCLayer <WBSaveMenuDelegate>
{
	//Start point of a touch
	CGPoint startTouchPoint;
	
	//Space manager
	SpaceManager* smgr;
	
	//Dpad
	CCSprite *dPad;
	
	//The save menu to be displayed when saving a level (UI elements)
	SaveMenu *theSaveMenu;
	
	//Grid view
	CCSprite *grid;
	
	//Side bars for menu options
	CCSprite *bar1;
	CCSprite *bar2;
	CCSprite *bar3;
	
	//Displaying height requirement UI
	CCSprite *heightBar;
	CCSprite *heightBall;
	
	//See if a given menu is being displayed
	BOOL defaulMenuLoaded;
	BOOL otherMenuLoaded;
	BOOL miscMenuLoaded;
	
	//Currently selected block and it's weight
	bbBlockType currentSelection;
	bbWeight currentSelectionWeight;
	
	//Array of all the blocks on the editor
	NSMutableArray *blocks;
	
	//The currently selceted block
	cpCCSpriteBlock *selectedBlock;
	
	//Determines if a given option has been chosen
	BOOL deleteOption;
	BOOL rotateOption;
	BOOL pointerOption;
	
	//If the height bar was touched
	BOOL heightBarTouched;
	
	//Creates a screenshot of the level when saving
	UIImage *screenshot;
	
	//To see if a level has saved correctly or not
	BOOL successOnSave;
	
	//Grid is visible
	BOOL gridVisible;
	
	//Location
	bbLocation currenLocation;
}

@property(nonatomic, retain)UIImage *screenshot;

//Loading a previous custom level
-(void)loadLevelWithFile:(NSString *)levelFile;

//Set Location
-(void)setLocation:(bbLocation)location;

//Grid methods
-(void)showGrid;
-(void)hideGrid;

//Menu methods
-(void)showDefaultMenu;
-(void)hideDefaultMenu;
-(void)showOtherMenu;
-(void)hideOtherMenu;
-(void)showMiscMenu;
-(void)hideMiscMenu;
-(void)delaySaveMenu;

//Add a block to the editor
-(void)addBlock:(bbBlockType)blockType weight:(bbWeight)blockWeight position:(CGPoint)blockPosition rotation:(float)blockRotation;
//Remove a block from editor
-(void)removeBlockWithPoint:(UITouch *)theTouch;
//Gets the block that has been touched for the given touch
-(cpCCSpriteBlock *)blockForTouch:(UITouch *)touch;

//Called to save a level
-(void)saveLevel;

@end
