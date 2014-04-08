//
//  EditorLayer.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/1/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "EditorLayer.h"
#import "CustomLevelsScene.h"
#import "WBManager.h"

#define kBGTag 10

@implementation EditorLayer

#pragma mark -
#pragma mark init methods
@synthesize screenshot;
-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		//Touch effect
		[self addChild:[TouchEffect node] z:4];
		
		//Grid view creation
		grid = [CCSprite spriteWithFile:@"LEgrid.png"];
		grid.position = ccp(240,160);
		[self addChild:grid z:1];
				
		//Is grid visible? YES by default
		gridVisible = YES;
		
		//Save succesfully?
		successOnSave = NO;
		
		//Height bar for determining height of demolished building
		heightBar = [CCSprite spriteWithFile:@"heightBar.png"];
		heightBall = [CCSprite spriteWithFile:@"sliderCircle.png"];
		
		heightBall.position = ccp(464,100);
		
		heightBar.position = ccp(-201,11);
		heightBar.opacity = 120.0f;
		
		heightBarTouched = NO;
		
		//[self addChild:heightBar];
		[self addChild:heightBall z:1 tag:99];
		[heightBall addChild:heightBar];
		
		//Add save menu layer
		theSaveMenu = [SaveMenu node];
		theSaveMenu.delegate = self;
		[self addChild:theSaveMenu z:3];
		
		//Creates a chipmunk space
		smgr = [[SpaceManager alloc] init];
		//NEEDED?
		smgr.constantDt = 1.0/60.0;
		//Graivty in space
		smgr.gravity = cpv(0, -100);
		smgr.damping = 0.00f;
		//[smgr start];
		
		self.isTouchEnabled = YES;
		
		//Stores all the blocks for the level
		blocks = [[NSMutableArray alloc]init];
		
		//Sets the default to the menu not being loaded
		defaulMenuLoaded = NO;
		otherMenuLoaded = NO;
		miscMenuLoaded = NO;
		
		//Two submenus for block options
		bar1 = [CCSprite spriteWithFile:@"editorSideBar1.png"];
		bar1.position = ccp(-60,160);
		[self addChild:bar1 z:2];
		
		bar2 = [CCSprite spriteWithFile:@"editorSideBar2.png"];
		bar2.position = ccp(-60,160);
		[self addChild:bar2 z:2];
		
		bar3 = [CCSprite spriteWithFile:@"editorSideBar3.png"];
		bar3.position = ccp(-60,160);
		[self addChild:bar3 z:2];
		
		//Sets default block type to large straight and light
		currentSelection = bbStraightIII;
		currentSelectionWeight = bbLight;
		
		//Sets the other editing options to a default of NO
		deleteOption = NO;
		rotateOption = NO;
		pointerOption = NO;
		
		//Sets the default selected block to nil (there isnt one)
		selectedBlock = nil;
		
		//Default current location
		currenLocation = bbCountrySide;

		//Loads the level from file if one should be loaded
		if([[WBManager sharedManager]loadWithEditor]==YES)
		{
			if([[WBManager sharedManager]getLevelFile]!=nil)
				[self loadLevelWithFile:[[WBManager sharedManager]getLevelFile]];
		}
		
		//rectIntersected = NO;
		//selectedRect = CGRectMake(0,0,0,0);
			
		//Editor BG UI
		CCSprite *bg = [CCSprite spriteWithFile:@"WBbg_Editor.png"];
		bg.position = ccp(240,160);
		[self addChild: bg z:1 tag:-1];
		
		//DPad image for placing blocks exactly.
		dPad = [CCSprite spriteWithFile:@"DPad.png"];
		dPad.position = ccp(405,245);
		[self addChild:dPad z:5];
		[dPad setVisible:NO];
	}
	
	return self;
}

-(void)setLocation:(bbLocation)location
{
	//Gets the location then sets the BG image accordinaly 
	
	if(location == bbCountrySide)
	{
		CCSprite *bg = [CCSprite spriteWithFile:@"countrySideBG.png"];
		bg.position = ccp(240,160);
		[self addChild:bg z:-1 tag:kBGTag];
		currenLocation = bbCountrySide;
	}
	
	else if(location == bbWilderness)
	{
		CCSprite *bg = [CCSprite spriteWithFile:@"wildernessBG.png"];
		bg.position = ccp(240,160);
		[self addChild:bg z:-1 tag:kBGTag];
		currenLocation = bbWilderness;
	}
	
	else if(location == bbCity)
	{
		CCSprite *bg = [CCSprite spriteWithFile:@"cityBG.png"];
		bg.position = ccp(240,160);
		[self addChild:bg z:-1 tag:kBGTag];
		currenLocation = bbCity;
	}
	
	else if(location == bbLunar)
	{
		CCSprite *bg = [CCSprite spriteWithFile:@"MoonBG.png"];
		bg.position = ccp(240,160);
		[self addChild:bg z:-1 tag:kBGTag];
		currenLocation = bbLunar;
	}
}

-(void)loadLevelWithFile:(NSString *)levelFile
{
	
	//Gets the documents directory for iPhone/iPod Touch
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	//Gets the fulls path with appending the file to be created. 
	NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
	//Filemanager
	NSFileManager *fm = [[NSFileManager alloc]init];
	
	//Loads a custom level from file and updates all the proper imformation
	
	NSString *filePath = [customLevelsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.arch",levelFile]];
		
	Level *customLevel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
		
	[self setLocation:customLevel.location];
	
	NSMutableArray *blocksInLevel = [customLevel getBlocksArray];
	
	for(EditorBlock *block in blocksInLevel)
	{
		[self addBlock:[block getBlockType] weight:[block getWeight] position:[[CCDirector sharedDirector]convertToGL:[block getPosition]] rotation:[block getRotation]];
	}
	
	heightBall.position = ccp(heightBall.position.x,customLevel.maxHeight);
	[theSaveMenu setLevelName:customLevel.name timeLimit:customLevel.timeLimit craneFuel:customLevel.craneFuel hitLimit:customLevel.hitLimit windSpeed: customLevel.windSpeed windDirection: customLevel.windDirection];
	
	[fm release];
}

#pragma mark -
#pragma mark Touch Methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	//**************************//
	//Throughout the touch checks if any occur on a menu item the dpad will be hidden and the selected blocks grid guide will be hidden.
	//**************************//
	
	//Default heightbar is not being touched
	heightBarTouched = NO;
	//Height bar slightly transparent when not being touched
	heightBar.opacity = 120.0f;
	
	//Hide grid at end of touch for any block being touched
	if(selectedBlock != nil)[selectedBlock hideGridGuide];
	//rectIntersected = NO;
	
	//Used for the Dpad control option within the editor for moving blocks one pixel at a time
	if(selectedBlock != nil)
	{
		//Up
		if(point.x > 270 && point.x < 317 && point.y > 388 && point.y < 440)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			selectedBlock.position = ccp(selectedBlock.position.x, selectedBlock.position.y + 1);
			return;
		}
	
		//Right
		if(point.x > 232 && point.x < 277 && point.y > 430 && point.y < 473)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			selectedBlock.position = ccp(selectedBlock.position.x + 1, selectedBlock.position.y);
			return;
		}
	
		//Down
		if(point.x > 191 && point.x < 240 && point.y > 388 && point.y < 440)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			selectedBlock.position = ccp(selectedBlock.position.x, selectedBlock.position.y - 1);
			return;
		}
	
		//Left
		if(point.x > 232 && point.x < 277 && point.y > 353 && point.y < 400)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			selectedBlock.position = ccp(selectedBlock.position.x-1, selectedBlock.position.y);
			return;
		}
	}
	
	//Rotates a block by 45 degree increments
	if(rotateOption)
	{
		//Calculate how far a touch has moved since it started. If it moved less then 16 pixels then it will continue with rotation of block
		float difX = fabs(startTouchPoint.x - point.x);
		float difY = fabs(startTouchPoint.y - point.y);
		
		if(difX < 16 && difY < 16)
		{
			if(selectedBlock!=nil)
				[selectedBlock stepRotate];
		}
	}
	
	//If one of the 3 menu for object selection is visible
	if(defaulMenuLoaded || otherMenuLoaded || miscMenuLoaded)
	{
		//Select the desired light block
		if(defaulMenuLoaded)
		{
			if(point.x > 252 && point.x < 273 && point.y > 0 && point.y < 22)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbStraightI;
				currentSelectionWeight = bbLight;
				return;
			}
				
			if(point.x > 244 && point.x < 280 && point.y > 23 && point.y < 45)
			{		
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelectionWeight = bbLight;
				currentSelection = bbStraightII;
				return;
			}
			
			if(point.x > 238 && point.x < 290 && point.y > 46 && point.y < 68)
			{		
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelectionWeight = bbLight;
				currentSelection = bbStraightIII;
				return;
			}
			
			if(point.x > 228 && point.x < 300 && point.y > 69 && point.y < 89)
			{		
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbStraightIV;
				currentSelectionWeight = bbLight;
				return;
			}
			
			if(point.x > 148 && point.x < 190 && point.y > 0 && point.y < 22)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbAngleI;
				currentSelectionWeight = bbLight;
				return;
			}
			
			if(point.x > 136 && point.x < 200 && point.y > 23 && point.y < 45)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbAngleII;
				currentSelectionWeight = bbLight;
				return;
			}
			
			if(point.x > 126 && point.x < 211 && point.y > 46 && point.y < 68)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbAngleIII;
				currentSelectionWeight = bbLight;
				return;
			}
			
			if(point.x > 115 && point.x < 225 && point.y > 69 && point.y < 89)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbAngleIV;
				currentSelectionWeight = bbLight;
				return;
			}
			
		}
		
		//select the desired heavy block
		else if(otherMenuLoaded)
		{
			if(point.x > 252 && point.x < 273 && point.y > 0 && point.y < 22)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbStraightI;
				currentSelectionWeight = bbHeavy;
				return;
			}
			
			if(point.x > 244 && point.x < 280 && point.y > 23 && point.y < 35)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelectionWeight = bbHeavy;
				currentSelection = bbStraightII;
				return;
			}
			
			if(point.x > 238 && point.x < 290 && point.y > 46 && point.y < 68)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelectionWeight = bbHeavy;
				currentSelection = bbStraightIII;
				return;
			}
			
			if(point.x > 228 && point.x < 300 && point.y > 69 && point.y < 89)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbStraightIV;
				currentSelectionWeight = bbHeavy;
				return;
			}
			
			if(point.x > 148 && point.x < 190 && point.y > 0 && point.y < 22)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbAngleI;
				currentSelectionWeight = bbHeavy;
				return;
			}
			
			if(point.x > 136 && point.x < 200 && point.y > 23 && point.y < 45)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbAngleII;
				currentSelectionWeight = bbHeavy;
				return;
			}
			
			if(point.x > 126 && point.x < 211 && point.y > 46 && point.y < 68)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbAngleIII;
				currentSelectionWeight = bbHeavy;
				return;
			}
			
			if(point.x > 115 && point.x < 225 && point.y > 69 && point.y < 89)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbAngleIV;
				currentSelectionWeight = bbHeavy;
				return;
			}
			 
		}
		
		//If misc menu allow for selection of basic shapes
		else if(miscMenuLoaded)
		{
			//
			if(point.x > 256 && point.x < 283 && point.y > 64 && point.y < 94)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbSquareS;
				currentSelectionWeight = bbLight;
				return;
			}
			
			//
			if(point.x > 196 && point.x < 238 && point.y > 52 && point.y < 91)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelectionWeight = bbLight;
				currentSelection = bbSquareM;
				return;
			}
			
			//
			if(point.x > 196 && point.x < 243 && point.y > 0 && point.y < 50)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelectionWeight = bbLight;
				currentSelection = bbSquareL;
				return;
			}
			
			//
			if(point.x > 246 && point.x < 300 && point.y > 0 && point.y < 61)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbSquareXL;
				currentSelectionWeight = bbLight;
				return;
			}
			
			//
			if(point.x > 140 && point.x < 177 && point.y > 65 && point.y < 90)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbTriangleS;
				currentSelectionWeight = bbLight;
				return;
			}
			
			//
			if(point.x > 80 && point.x < 120 && point.y > 52 && point.y < 95)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbTriangleM;
				currentSelectionWeight = bbLight;
				return;
			}
			
			//
			if(point.x > 80 && point.x < 126 && point.y > 0 && point.y < 51)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbTriangleL;
				currentSelectionWeight = bbLight;
				return;
			}
			
			//
			if(point.x > 132 && point.x < 191 && point.y > 0 && point.y < 64)
			{
				[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

				currentSelection = bbTriangleXL;
				currentSelectionWeight = bbLight;
				return;
			}
		}
		
	}
	
	//show default
	if(point.y > 0 && point.y < 50 && point.x > 0 && point.x < 50 && !defaulMenuLoaded && !otherMenuLoaded && !miscMenuLoaded)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		deleteOption = NO;
		pointerOption = NO;
		rotateOption = NO;
		[self showDefaultMenu];
		
		[dPad setVisible:NO];
		if(selectedBlock != nil)[selectedBlock hideGridGuide];
		return;
	}
	
	//hide default //xy was reversed
	else if(point.y > 10 && point.y < 82 && point.x > 8 && point.x < 36 && (defaulMenuLoaded || otherMenuLoaded || miscMenuLoaded))
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		if(defaulMenuLoaded)[self hideDefaultMenu];
		if(otherMenuLoaded)[self hideOtherMenu];
		if(miscMenuLoaded)[self hideMiscMenu];
		
		deleteOption = NO;
		pointerOption = NO;
		rotateOption = NO;
		
		[dPad setVisible:NO];
		if(selectedBlock != nil)[selectedBlock hideGridGuide];
		return;
	}
	
	//When the options is pressed to switch menus from within one of the meus
	else if(point.x > 77 && point.x < 109 && point.y > 16 && point.y < 76 && (defaulMenuLoaded || otherMenuLoaded))
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		if(defaulMenuLoaded)
		{
			[self hideDefaultMenu];
			[self showOtherMenu];
		}
		
		else if(otherMenuLoaded)
		{
			[self hideOtherMenu];
			[self showDefaultMenu];
		}
		
		[dPad setVisible:NO];
		if(selectedBlock != nil)[selectedBlock hideGridGuide];
		return;
	}
	
	else if(point.x > 40 && point.x < 70 && point.y > 10 && point.y < 82)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		if(defaulMenuLoaded || otherMenuLoaded)
		{
			if(defaulMenuLoaded)[self hideDefaultMenu];
			if(otherMenuLoaded)[self hideOtherMenu];
			
			[self showMiscMenu];
			
			[dPad setVisible:NO];
			if(selectedBlock != nil)[selectedBlock hideGridGuide];
			return;
		}
		
		else if(miscMenuLoaded)
		{
			[self hideMiscMenu];
			[self showDefaultMenu];
			
			[dPad setVisible:NO];
			if(selectedBlock != nil)[selectedBlock hideGridGuide];
			return;
		}
	}
	
	//Called when pause button is pressed
	if(point.x > 0 && point.x < 31 && point.y > 442 && point.y < 480)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		//If present hides the sub menus
		if(defaulMenuLoaded || otherMenuLoaded || miscMenuLoaded)
		{
			if(defaulMenuLoaded)[self hideDefaultMenu];
			if(otherMenuLoaded)[self hideOtherMenu];
			if(miscMenuLoaded)[self hideMiscMenu];
			
			[self performSelector:@selector(delaySaveMenu) withObject:nil afterDelay:.8];
			
			[dPad setVisible:NO];
			if(selectedBlock != nil)[selectedBlock hideGridGuide];
			return;
		}
		
		//displays save menu
		[theSaveMenu show];
		
		[dPad setVisible:NO];
		if(selectedBlock != nil)[selectedBlock hideGridGuide];
		return;
	}

	//Grid Selection
	if(point.x > 245 && point.x < 280 && point.y > 0 && point.y < 35 && !(defaulMenuLoaded||otherMenuLoaded||miscMenuLoaded))
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		if(gridVisible)
			[self hideGrid];
		else
			[self showGrid];
		
		[dPad setVisible:NO];
		if(selectedBlock != nil)[selectedBlock hideGridGuide];
		return;
	}
	
	//Select Delete
	if(point.x > 198 && point.x < 231 && point.y > 0 && point.y < 35)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		deleteOption = YES;
		pointerOption = NO;
		rotateOption = NO;
		
		[dPad setVisible:NO];
		if(selectedBlock != nil)[selectedBlock hideGridGuide];
		return;
	}
	
	//Select Rotate
	if(point.x > 146 && point.x < 183 && point.y > 0 && point.y < 35)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		deleteOption = NO;
		pointerOption = NO;
		rotateOption = YES;
		
		[dPad setVisible:NO];
		if(selectedBlock != nil)[selectedBlock hideGridGuide];
		return;
	}
	
	//Select Pointer
	if(point.x > 95 && point.x < 132 && point.y > 0 && point.y < 35)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		deleteOption = NO;
		pointerOption = YES;
		rotateOption = NO;
		
		[dPad setVisible:NO];
		if(selectedBlock != nil)[selectedBlock hideGridGuide];
		return;
	}
	
	//Select TNT
	if(point.x > 45 && point.x < 82 && point.y > 0 && point.y < 35)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		deleteOption = NO;
		pointerOption = NO;
		rotateOption = NO;
		
		currentSelection = bbBomb;
		currentSelectionWeight = bbLight;
		
		[dPad setVisible:NO];
		if(selectedBlock != nil)[selectedBlock hideGridGuide];
		return;
	}
	
	//Hide dPad
	if(selectedBlock == nil)[dPad setVisible:NO];
	
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	//Stores the touches start point
	startTouchPoint = point;
	
	//Gets a block if one is being selected
	if( dPad.visible == NO || (!(point.x > 232 && point.x < 277 && point.y > 353 && point.y < 400)&&!(point.x > 191 && point.x < 240 && point.y > 388 && point.y < 440)&&!(point.x > 232 && point.x < 277 && point.y > 430 && point.y < 473)&&!(point.x > 270 && point.x < 317 && point.y > 388 && point.y < 440)))
		selectedBlock = [self blockForTouch:touch];
	
	//If selected block exists
	if(selectedBlock != nil)
	{
		//Show it's grid guide
		[selectedBlock showGridGuide];
		//Show the dPad if delete option not selected
		if(!(deleteOption && selectedBlock != nil))[dPad setVisible:YES];
	}
	
	/*
	if(selectedBlock!=nil)
	{
		selectedRect = CGRectMake(selectedBlock.position.x - (selectedBlock.contentSize.width/2),selectedBlock.position.y - (selectedBlock.contentSize.height/2), selectedBlock.contentSize.width, selectedBlock.contentSize.height);
	}
	 */
	
	//If height bar selected increase it's opacity and then indicate it's being touched with heightBarTouched variable
	CGPoint touchLocation =[[CCDirector sharedDirector] convertToGL: point];
	CGPoint local = [heightBall convertToNodeSpace:touchLocation];
	CGRect r = [heightBall textureRect];
	
	if( CGRectContainsPoint( r, local ))
	{
		heightBarTouched = YES;
		heightBar.opacity = 255.0f;
		return;
	}
	
	//If correct conditions met add the block to the level
	if(point.x > 0 && point.x < 320 && point.y > 0 && point.y < 580 && selectedBlock == nil && !(defaulMenuLoaded || otherMenuLoaded || miscMenuLoaded))
	{
		if(!(point.x > 45 && point.x < 82 && point.y > 0 && point.y < 35) 
		   && !(point.x > 95 && point.x < 132 && point.y > 0 && point.y < 35) 
		    && !(point.x > 146 && point.x < 183 && point.y > 0 && point.y < 35) 
		     && !(point.x > 0 && point.x < 31 && point.y > 442 && point.y < 480)
			  && !(point.x > 0 && point.x < 50 && point.y > 0 && point.y < 50)
			   && !(point.x > 198 && point.x < 231 && point.y > 0 && point.y < 35)
				&& !(point.x > 245 && point.x < 280 && point.y > 0 && point.y < 35))
		{
			if(!deleteOption && !pointerOption && !rotateOption)
			{
				[self addBlock:currentSelection weight:currentSelectionWeight position:point rotation:90.0f];
			}
			return;
		}
	}
	
	//If there is a selected block and delete option is on, remove that block
	if(deleteOption && selectedBlock != nil)
	{
		[self removeBlockWithPoint:touch];
		return;
	}
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	//Adjust height
	if(heightBarTouched)
	{
		CGPoint newPoint = [[CCDirector sharedDirector] convertToGL: point];
		
		if(newPoint.y <= 290 && newPoint.y >= 31)
			heightBall.position = ccp(heightBall.position.x, newPoint.y);
	}
	
	//If there is a selected block and not delete option or rotate then move the block
	if(selectedBlock != nil && !deleteOption && !rotateOption)
	{
		//if(rectIntersected == NO)
		{
			CGPoint newPoint = [[CCDirector sharedDirector] convertToGL: point];			
			selectedBlock.position = ccp(newPoint.x,newPoint.y);
		}
		
		/*
		for(cpCCSpriteBlock *block in blocks)
		{
			if(block != selectedBlock)
			{
			
			CGRect blockRect = CGRectMake(block.position.x - (block.contentSize.width/2),block.position.y - (block.contentSize.height/2), block.contentSize.width, block.contentSize.height);
				
			
			if(CGRectIntersectsRect(selectedRect, blockRect))
			{
				rectIntersected = YES;
			}
			
			//else rectIntersected = NO;
			}
		}
		 */
	}
	
	//If there is a selected block and rotate option on, rotate block
	if(rotateOption && selectedBlock != nil)
	{
		//convert point cocos2d cord.
		CGPoint newPoint = [[CCDirector sharedDirector] convertToGL: point];
		
		//Block x,y location
		float blockX = selectedBlock.position.x;
		float blockY = selectedBlock.position.y;
		
		//Touch x,y location
		float touchX = newPoint.x;
		float touchY = newPoint.y;
		
		//Length of side A and B between the touch and the block
		float sideA = (blockY - touchY);
		float sideB = (blockX - touchX);
		
		//Gets the angle the block should be based on the position of the touch in regards to the block. 
		float angle = atan(sideB/sideA);
		
		//Converts the angle into radiants
		float rotation = (angle * 180 / M_PI);
		
		//If the touch is located in III or IV quadrent then add 180 degrees.
		if(touchY > blockY)
			rotation = (rotation) + 180.0f;
		
		//If the touch is located in the IV quadrent add 360 degrees.
		if(touchY < blockY && blockX < touchX)
			rotation = (rotation) + 360.0f;
		
		//Rotate the block
		selectedBlock.rotation = rotation;
	}
}

#define bufferSize 20

#pragma mark -
#pragma mark Block Touch Method

-(cpCCSpriteBlock *)blockForTouch: (UITouch *) touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	
	//Goes through each block currently placed in the level
	for( cpCCSpriteBlock* item in blocks) 
	{
		//Converts the touchLocation to a point in the block's space
		CGPoint local = [item convertToNodeSpace:touchLocation];
		
		//Gets and edits the rect of the texture for the block sprite
		CGRect r = [item textureRect];
		CGSize size = r.size;
		CGRect newRect = CGRectMake(r.origin.x - (bufferSize/2) , r.origin.y - (bufferSize/2), size.width+bufferSize, size.height+bufferSize);
		
		//Normalize point for moving object where touch begins? AnchorPoint 0-1.0
		//Something to do with normalize
		
		//if the touch location local is in newRect then that block is being touched.
		if( CGRectContainsPoint( newRect, local ) )
		{
			//Return the block being touched
			return item;
		}
	}
	//If no block being touched return nil
	return nil;
}

#pragma mark -
#pragma mark Save Menu Methods

-(void)delaySaveMenu
{
	//Shows save menu
	[theSaveMenu show];
}

#pragma mark -
#pragma mark Menu Methods

-(void)showDefaultMenu
{
	//Shows default menu for block selection
	defaulMenuLoaded = YES;
	id action = [CCMoveTo actionWithDuration:.7f position:ccp(67,160)];
	[bar1 runAction:action];
}

-(void)hideDefaultMenu
{
	//Hides default menu for block selection
	defaulMenuLoaded = NO;
	id action = [CCMoveTo actionWithDuration:.7f position:ccp(-60,160)];
	[bar1 runAction:action];
}

-(void)showOtherMenu
{
	//Displays the alternate submenu (heavy blocks)
	otherMenuLoaded = YES;
	id action = [CCMoveTo actionWithDuration:.7f position:ccp(67,160)];
	[bar2 runAction:action];
}

-(void)hideOtherMenu
{
	//Hides the alernate submenu (heavy blocks)
	otherMenuLoaded = NO;
	id action = [CCMoveTo actionWithDuration:.7f position:ccp(-60,160)];
	[bar2 runAction:action];
}

-(void)showMiscMenu
{
	//Displays the alternate submenu (heavy blocks)
	miscMenuLoaded = YES;
	id action = [CCMoveTo actionWithDuration:.7f position:ccp(67,160)];
	[bar3 runAction:action];
}

-(void)hideMiscMenu
{
	//Hides the alernate submenu (heavy blocks)
	miscMenuLoaded = NO;
	id action = [CCMoveTo actionWithDuration:.7f position:ccp(-60,160)];
	[bar3 runAction:action];
}

#pragma mark -
#pragma mark Block Creation and Removal Methods

-(void)addBlock:(bbBlockType)blockType weight:(bbWeight)blockWeight position:(CGPoint)blockPosition rotation:(float)blockRotation
{
	//By default the block is nil
	cpCCSpriteBlock *block = nil; 
	
	//Gets a position in cocos2d cord. for the block to be placed at (based on touch location)
	blockPosition = [[CCDirector sharedDirector] convertToGL:blockPosition];
	
	//If block is light, add the desired block type
	if(blockWeight == bbLight)
	{
		switch (blockType) 
		{
			case bbStraightI:
				block = [BlockBuilder buildStraightIForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];
				break;
			case bbStraightII:
				block = [BlockBuilder buildStraightIIForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];
				break;
			case bbStraightIII:
				block = [BlockBuilder buildStraightIIIForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];	
				break;
			case bbStraightIV:
				block = [BlockBuilder buildStraightIVForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];	
				break;
			case bbAngleI:
				block = [BlockBuilder buildAngleIBlockForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];	
				break;
			case bbAngleII:
				block = [BlockBuilder buildAngleIIBlockForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];
				break;
			case bbAngleIII:
				block = [BlockBuilder buildAngleIIIBlockForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];	
				break;
			case bbAngleIV:
				block = [BlockBuilder buildAngleIVBlockForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];	
				break;
			case bbSquareS:
				block = [BlockBuilder buildSmallSquareForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];
				break;
			case bbSquareM:
				block = [BlockBuilder buildMediumSquareForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];
				break;
			case bbSquareL:
				block = [BlockBuilder buildLargeSquareForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];	
				break;
			case bbSquareXL:
				block = [BlockBuilder buildXtraLargeSquareForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];	
				break;
			case bbTriangleS:
				block = [BlockBuilder buildSmallTriangleForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];
				break;
			case bbTriangleM:
				block = [BlockBuilder buildMediumTriangleForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];
				break;
			case bbTriangleL:
				block = [BlockBuilder buildLargeTriangleForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];	
				break;
			case bbTriangleXL:
				block = [BlockBuilder buildXtraLargeTriangleForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];	
				break;
			case bbBomb:
				block = [BlockBuilder buildBombForSpace:smgr position:blockPosition rotation:blockRotation type: bbLight mass: bbLight];	
				break;
			default:
				break;
		}
	}
	
	//If block is heavy add the desired block type
	else if(blockWeight == bbHeavy)
	{
		switch (blockType) 
		{
			case bbStraightI:
				block = [BlockBuilder buildStraightIForSpace:smgr position:blockPosition rotation:blockRotation type: bbHeavy mass: bbLight];
				break;
			case bbStraightII:
				block = [BlockBuilder buildStraightIIForSpace:smgr position:blockPosition rotation:blockRotation type: bbHeavy mass: bbLight];
				break;
			case bbStraightIII:
				block = [BlockBuilder buildStraightIIIForSpace:smgr position:blockPosition rotation:blockRotation type: bbHeavy mass: bbLight];	
				break;
			case bbStraightIV:
				block = [BlockBuilder buildStraightIVForSpace:smgr position:blockPosition rotation:blockRotation type: bbHeavy mass: bbLight];	
				break;
			case bbAngleI:
				block = [BlockBuilder buildAngleIBlockForSpace:smgr position:blockPosition rotation:blockRotation type: bbHeavy mass: bbLight];	
				break;
			case bbAngleII:
				block = [BlockBuilder buildAngleIIBlockForSpace:smgr position:blockPosition rotation:blockRotation type: bbHeavy mass: bbLight];
				break;
			case bbAngleIII:
				block = [BlockBuilder buildAngleIIIBlockForSpace:smgr position:blockPosition rotation:blockRotation type: bbHeavy mass: bbLight];	
				break;
			case bbAngleIV:
				block = [BlockBuilder buildAngleIVBlockForSpace:smgr position:blockPosition rotation:blockRotation type: bbHeavy mass: bbLight];	
				break;
			default:
				break;
		}
	}
	
	//Add block to layer
	[self addChild:block z:1];
	
	//Add block to array of blocks	
	[blocks addObject:block];
}

-(void)removeBlockWithPoint:(UITouch *)theTouch
{
	//Gets a block for the touch location
	selectedBlock = [self blockForTouch: theTouch];
	
	//If there is a block for the touch location
	if(selectedBlock != nil)
	{
		[selectedBlock hideGridGuide];
		//Revmoe block from array of blocks
		[blocks removeObjectAtIndex:[blocks indexOfObject:selectedBlock]];
		//Remove block from layer
		[self removeChild:selectedBlock cleanup:YES];
		selectedBlock = nil;
	}
}

#pragma mark -
#pragma mark Grid Methods

-(void)showGrid
{
	//Shows grid BG in editor
	[grid setVisible:YES];
	gridVisible = YES;
}

-(void)hideGrid
{
	//Hides grid BG in editor
	[grid setVisible:NO];
	gridVisible = NO;
}

#pragma mark -
#pragma mark Save Level
-(void)saveLevel
{
	//Default no exceptions with saving a level
	BOOL exceptions = NO;
	
	//Level Object
	Level *customLevel = [[Level alloc]init];
		
	//Set Level Information
	
	//If anything is nil that shouldn't be there will be an exception
	if(theSaveMenu.getName  == nil || theSaveMenu.getTimeLimit == nil || theSaveMenu.getCraneFuel == nil)
		exceptions = YES;
	
	//if no exceptios
	if(!exceptions)
	{
		customLevel.name = theSaveMenu.getName;
		customLevel.maxHeight = heightBall.position.y;
		customLevel.timeLimit = [[theSaveMenu getTimeLimit]intValue];
		customLevel.hitLimit = 0;
		customLevel.craneFuel = [[theSaveMenu getCraneFuel]intValue];
		if(currenLocation != bbLunar)customLevel.windSpeed = [theSaveMenu getWindSpeed];
		else customLevel.windSpeed = 0;
		customLevel.location = currenLocation;
		customLevel.screenshot = self.screenshot;
		customLevel.windDirection = [theSaveMenu getWindDirection];
	
		//Add the blocks to the level object's array
		for(cpCCSpriteBlock *block in blocks)
		{			
			EditorBlock *saveBlock = [[EditorBlock alloc]initWithType:[block getType] weight:[block getWeight] rotation:block.rotation position:block.position];
			[customLevel addBlock:saveBlock];
			[saveBlock release];//addBlock retains saveBlock so it is safe to release
		}
	
		//Gets the documents directory for iPhone/iPod Touch
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory=[paths objectAtIndex:0];
		//Gets the fulls path with appending the file to be created. 
		NSString *customLevels = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
		NSString *customLevelFileName = [customLevels stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.arch",theSaveMenu.getName]];
	
		//Archives File
		if(![NSKeyedArchiver archiveRootObject: customLevel toFile: customLevelFileName])
		{
			//On Error
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Worksite could not be saved." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	
		else 
		{
			successOnSave = YES;
			//On Success
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Worksite successfully saved." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
	
	else 
	{
		//On Error
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Some information is missing." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	[customLevel release];
}

#pragma mark -
#pragma mark UIAlertView method

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{	
	//If saved worked go to cusotm level menu
	if(successOnSave)
		[[CCDirector sharedDirector]replaceScene:[CustomLevelsScene node]];
}

#pragma mark -
#pragma mark cleanup

-(void)dealloc
{
	[blocks release];
	[smgr release];
	[screenshot release];
	[super dealloc];
}

@end
