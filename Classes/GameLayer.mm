//
//  GameLayer.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 3/17/10.
//  Copyright 2010 Home. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>

#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"

#import "GameLayer.h"
#import "GameScene.h"
#import "SpaceManager.h"
#import "PlatformBuilder.h"
#import "cpCCSpriteBlock.h"
#import "cpCCSpriteBomb.h"
#import "MenuScene.h"
#import "Level.h"
#import "EditorBlock.h"
#import "WBManager.h"
#import "Clouds.h"
#import "GameScene.h"
#import "OpenFeint.h"
#import "Fish.h"

#import "LevelMenu1Scene.h"
#import "LevelMenu2Scene.h"
#import "LevelMenu3Scene.h"

#import "OFAchievementService.h"
#import "OFDefines.h"

#define kUfoTag 5683726

#define EARTH 0
#define MOON 1

#define kGravity(x) x == EARTH ? -100 : -17

//MAX FORCE LIMITATIONS//25
#define MaxForce 25.0f

//Time interval length
#define timeStep .5f

//Collision Type
#define kWreckingBallCollision 1

#define kRopeLengthMin 30.0f
#define kRopeLengthMax 245.0f

//Difficulty calculations
#define calculateForEasy(x) x*1.5
#define calculateForHard(x) x/1.5

#define kCloudTag 1644

#define kBallMass 50.0

@implementation GameLayer
@synthesize currentUser;

#pragma mark -
#pragma mark init methods

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{		
		gravityForLocation = EARTH;
		
		oldVolume = [[SimpleAudioEngine sharedEngine] effectsVolume];	
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationWillResignActiveNotification object:nil];
		codeFieldActive = NO;
		hasCheated = NO;
		
		theWorksiteLocation = bbCountrySide;
		
		directionButtonActive = NO;
		activeDirection = bbNon;
		
		//Gets the documents directory for iPhone/iPod Touch
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory=[paths objectAtIndex:0];		
		NSString *settingsPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"GameSettings"]];
		
		settingsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
		
		NSURL *sound = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Engine" ofType:@"caf"]];
		engineSound = [[AVAudioPlayer alloc]initWithContentsOfURL:sound error:nil];
		[engineSound setNumberOfLoops:-1];
		[engineSound setVolume:[[settingsDictionary objectForKey:@"SfxVolume"]floatValue]];
		
		NSURL *grind = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"grind" ofType:@"caf"]];
		engineGrind = [[AVAudioPlayer alloc]initWithContentsOfURL:grind error:nil];
		[engineGrind setNumberOfLoops:-1];
		[engineGrind setVolume:[[settingsDictionary objectForKey:@"SfxVolume"]floatValue]-.15f];
		
		lastSoundTime = 0;
		lastHitPoint = CGPointZero;

		//Water Touched
		waterTouched = NO;
		
		//
		buidlingTouched = NO;
		
		//Default game not complete
		gameComplete = NO;
		
		//Blocks array
		blocks = [[NSMutableArray alloc]init];
		
		//Height bar creation
		bar = [CCSprite spriteWithFile:@"heightBar.png"];
		bar.position = ccp(240,160);
		bar.scaleX = 1.2f;
		[self addChild:bar];
		
		//Pause menu creation
		pauseMenu = [CCSprite spriteWithFile:@"PauseMenu.png"];
		pauseMenu.position = ccp(240,-100);
		[self addChild:pauseMenu z:4];
		//Default is game not paused
		isPaused = NO;
		
		//Sets acceleromete delegate to self
		[[UIAccelerometer sharedAccelerometer] setDelegate:self];
		
		//Game popup for level complete
		popUpManager = [GamePopUp node];
		popUpManager.delegate = self;
		[self addChild:popUpManager z:5];
		
		//Adds the touch effect
		[self addChild:[TouchEffect node] z:6];
		
		//touch enabled
		self.isTouchEnabled = YES;

		//Creates a chipmunk space
		smgr = [[SpaceManager alloc] init];
		//NEEDED?
		smgr.constantDt = 1.0f/60.0f;
		//Graivty in space
		smgr.gravity = cpv(0, kGravity(gravityForLocation));
		smgr.damping = .85f;
		
		//Starts space manager at 60 FPS
		//:1.0/60.0];
		
		//Creates a crane sprite
		crane = [Crane spriteWithFile:@"Crane.png"];
		crane.position = ccp(240,160);
		[self addChild:crane];
		
		//Wrecking ball
		cpShape *ball = [smgr addCircleAt:cpv(125, 279-kRopeLengthMin) mass:kBallMass radius:8.5];
		ball->collision_type = kWreckingBallCollision;
		ballNode = [cpCCSprite spriteWithShape:ball file:@"ball.png"];
		ballNode.autoFreeShape = YES;
		ballNode.scale = .7f;
		ballNode.spaceManager = smgr;
		[self addChild:ballNode];
		
		//Sets collisions imformation
		[smgr addCollisionCallbackBetweenType:kWreckingBallCollision 
									otherType:kBlockCollision 
									   target:self 
									 selector:@selector(handleCollisionWithBall:arbiter:space:)];
		
		[smgr addCollisionCallbackBetweenType:kWreckingBallCollision 
									otherType:kBombCollision 
									   target:self 
									 selector:@selector(handleCollisionWithBombFromBall:arbiter:space:)];
		
		[smgr addCollisionCallbackBetweenType:kBlockCollision 
									otherType:kBombCollision 
									   target:self 
									 selector:@selector(handleCollisionWithBomb:arbiter:space:)];
		
		[smgr addCollisionCallbackBetweenType:kBlockCollision 
									otherType:kLakeCollision 
									   target:self 
									 selector:@selector(handleCollisionWithLake:arbiter:space:)];
		
		[smgr addCollisionCallbackBetweenType:kBombCollision 
									otherType:kLakeCollision 
									   target:self 
									 selector:@selector(handleCollisionWithLake:arbiter:space:)];
		
		[smgr addCollisionCallbackBetweenType:kBlockCollision 
									otherType:kSkyscraperCollision 
									   target:self 
									 selector:@selector(handleCollisionWithBuilding:arbiter:space:)];
		
		[smgr addCollisionCallbackBetweenType:kWreckingBallCollision 
									otherType:kSkyscraperCollision 
									   target:self 
									 selector:@selector(handleCollisionWithBuilding:arbiter:space:)];
		
		[smgr addCollisionCallbackBetweenType:kBombCollision 
									otherType:kSkyscraperCollision 
									   target:self 
									 selector:@selector(handleCollisionWithBuilding:arbiter:space:)];
		
		
		//Trolly clone for connection of rope based on trolly position
		cpShape *trollyPoint = [smgr addCircleAt:cpv(125,279) mass:STATIC_MASS radius:1.0f];
		trollyClone = [cpCCSprite spriteWithShape:trollyPoint file:@"ball.png"];
		trollyClone.autoFreeShape = YES;
		trollyClone.spaceManager = smgr;
		[trollyClone setVisible:NO];
		[self addChild:trollyClone z: -1];
		
		joint = [smgr addSlideToBody:trollyClone.shape->body fromBody:ballNode.shape->body toBodyAnchor:cpv(0,0) fromBodyAnchor:cpv(0,7.5) minLength:kRopeLengthMin maxLength:kRopeLengthMax];
		cpConstraintNode *jointNode = [cpConstraintNode nodeWithConstraint:joint];
		jointNode.autoFreeConstraint = YES;
		jointNode.color = ccWHITE;
		jointNode.spaceManager = smgr;
		[self addChild:jointNode];
		cpSlideJointSetMax(joint, kRopeLengthMin);
		
		//Faux JOINT "Friction" for the ball/rope
	
		cpConstraint *node = [smgr addMotorToBody:trollyPoint->body fromBody:ballNode.shape->body rate:0];
		node->maxForce = .02f;//.02
		cpConstraintNode *motor = [cpConstraintNode nodeWithConstraint:node];
		motor.autoFreeConstraint = YES;
		motor.spaceManager = smgr;
		motor.color = ccWHITE;
		[self addChild:motor];
		
		//Defaults for timer
		suggestedTime = 0.0f;
		gameTimer = 0.0f;
		
		//Sets default crane fuel amount
		[crane setFuel:-1];
		
		//Suggested time has not been passed
		suggestedTimePassed = NO;
		
		self.currentUser = nil;
		if([[WBManager sharedManager] loadWithGameLevel])self.currentUser = [[WBManager sharedManager] currentUser];
		
		//Gets a level and loads it from file
		if([[WBManager sharedManager]getLevelFile]!=nil)
		{
			tempLevelLoc = [[[WBManager sharedManager]getLevelFile]retain];
			[self loadLevelWithFile:[[WBManager sharedManager]getLevelFile]];
		}
			
		//Default prev time
		prevTime = 0;
		prevHCTime = 0;
		
		//WRECKING BALL FORCE LIMITATIONS//
		canMoveLeft = YES;
		canMoveRight = YES;
		canMoveUp = YES;
		canMoveDown = YES;
				
		lastDirection = bbRight;
		direction = bbNon;
		
		timeSinceLastContact = 0.0f;
		///////////////////////////////////
	}
	
	return self;
}

-(void)loadLevelWithFile:(NSString *)levelFile
{
	
	NSString *filePath = nil;
	NSFileManager *fm = nil;
	
	//If .arch not found it means it's a custom level loading... not a premade level
	NSRange range =[levelFile rangeOfString:@".arch"];
	
	//Means the .arch is not present which means the entire location still needs to be created
	if(range.length == 0 && [[WBManager sharedManager]loadWithGameLevel]==NO)
	{
		//Gets the documents directory for iPhone/iPod Touch
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory=[paths objectAtIndex:0];
		//Gets the fulls path with appending the file to be created. 
		NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
		//Filemanager
		fm = [[NSFileManager alloc]init];
	
		filePath = [customLevelsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.arch",levelFile]];
	}
	
	//filePath is the paremeter that is levelFile
	else 
	{
		filePath = levelFile;
	}
		
	//Loads level from file
	Level *customLevel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];//filePath
	
	//Creates a platform (for now it's the basic flat but will be based on level file)
	if(customLevel.location == bbCountrySide)
	{		
		gravityForLocation = EARTH;
		theWorksiteLocation = bbCountrySide;
		
		NSURL *sound = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Countryside" ofType:@"caf"]];
		countrysideSound = [[AVAudioPlayer alloc]initWithContentsOfURL:sound error:nil];
		[countrysideSound setNumberOfLoops:-1];
		[countrysideSound setVolume:[[settingsDictionary objectForKey:@"SfxVolume"]floatValue]];
		[countrysideSound play];
		
		float angle = 0.0f * M_PI / 180;
		cpShape *shape = [smgr addRectAt:cpv(240,13) mass:100000 width:480 height:1 rotation:angle];
		platFormCoupler = [cpCCSprite spriteWithShape:shape file:@"coupler.png"];
		
		
		[PlatformBuilder buildFlatPlatformForSpace:smgr position:cpv(240,12)];
		[self addChild:platFormCoupler];
	}
	
	if(customLevel.location == bbLunar)
	{		
		gravityForLocation = MOON;
		
		theWorksiteLocation = bbLunar;
		
		[self addChild:[Ufo node] z:4 tag:kUfoTag];
		/*
		NSURL *sound = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Countryside" ofType:@"caf"]];
		countrysideSound = [[AVAudioPlayer alloc]initWithContentsOfURL:sound error:nil];
		[countrysideSound setNumberOfLoops:-1];
		[countrysideSound setVolume:[[settingsDictionary objectForKey:@"SfxVolume"]floatValue]];
		[countrysideSound play];
		*/
		
		float angle = 0.0f * M_PI / 180;
		cpShape *shape = [smgr addRectAt:cpv(240,13) mass:100000 width:480 height:1 rotation:angle];
		platFormCoupler = [cpCCSprite spriteWithShape:shape file:@"coupler.png"];
		
		
		[PlatformBuilder buildFlatPlatformForSpace:smgr position:cpv(240,12)];
		[self addChild:platFormCoupler];
	}
	
	//Creates a platform (for now it's the basic flat but will be based on level file)
	else if(customLevel.location == bbWilderness)
	{
		gravityForLocation = EARTH;
		
		theWorksiteLocation = bbWilderness;
		
		NSURL *sound = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Forrest" ofType:@"caf"]];
		wildernessSound = [[AVAudioPlayer alloc]initWithContentsOfURL:sound error:nil];
		[wildernessSound setNumberOfLoops:-1];
		[wildernessSound setVolume:[[settingsDictionary objectForKey:@"SfxVolume"]floatValue]];
		[wildernessSound play];
		
		//Creates the alert popup with default string and sets it's opacity location scale. 
		alertPopup = [CCLabel labelWithString:@"Water Contamination!" fontName:@"Chalkduster" fontSize:30];
		alertPopup.position = ccp(265,160);
		alertPopup.scale = 0.01f;
		alertPopup.opacity = 0.0f;
		[self addChild:alertPopup z:8];
		
		[self addChild:[Fish node]];
		
		float angle = 0.0f * M_PI / 180;
		
		cpShape *shape = [smgr addPolyAt:cpv(240,161) mass:100000 rotation:angle numPoints:5 points: cpv(-338.4f, -146.8f),
						  cpv(144.5f, -146.8f),
						  cpv(157.0f, -158.5f),
						  cpv(-338.4f, -158.5f),
						  cpv(-338.4f, -146.8f)];	
		
		platFormCoupler = [cpCCSprite spriteWithShape:shape file:@"coupler.png"];
		
		[PlatformBuilder buildLakePlatformForSpace:smgr position:cpv(240,149.3)];
		[self addChild:platFormCoupler];
	}
	
	else if(customLevel.location == bbCity)
	{
		gravityForLocation = EARTH;
		theWorksiteLocation = bbCity;
		
		NSURL *sound = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"City-Traffic" ofType:@"caf"]];
		citySound = [[AVAudioPlayer alloc]initWithContentsOfURL:sound error:nil];
		[citySound setNumberOfLoops:-1];
		[citySound setVolume:[[settingsDictionary objectForKey:@"SfxVolume"]floatValue]];
		[citySound play];
		
		//Creates the alert popup with default string and sets it's opacity location scale. 
		alertPopup = [CCLabel labelWithString:@"Secondary Damage!" fontName:@"Chalkduster" fontSize:30];
		alertPopup.position = ccp(255,160);
		alertPopup.scale = 0.01f;
		alertPopup.opacity = 0.0f;
		[self addChild:alertPopup z:8];
		
		float angle = 0.0f * M_PI / 180;
		cpShape *shape = [smgr addRectAt:cpv(240,13) mass:100000 width:480 height:1 rotation:angle];
		platFormCoupler = [cpCCSprite spriteWithShape:shape file:@"coupler.png"];
		
		[PlatformBuilder buildCityPlatformForSpace:smgr position:cpv(240,12)];
		[self addChild:platFormCoupler];
	}	
	
	//Gets the string representation of the wind direction for displaying
	NSString *directionAsString = nil;
	
	if(customLevel.location != bbLunar)
	{
		
	switch(customLevel.windDirection)
	{
		case bbEast:
			directionAsString = @"E";
			break;
		case bbWest:
			directionAsString = @"W";
			break;
	}
	
	}
	
	else {
		directionAsString = @"-";
	}

	//Creates the wind speed and direction label
	theWindSpeed = [CCLabel labelWithString:[NSString stringWithFormat:@"%@ @ %i mph", directionAsString,customLevel.windSpeed] fontName:@"Chalkduster" fontSize:14];
	theWindSpeed.position = ccp(400,313);
	[self addChild:theWindSpeed];
	
	//Creates the game timer label
	theGameTimer = [CCLabel labelWithString:[NSString stringWithFormat:@"0' 0\""] dimensions:CGSizeMake(75,16) alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:14];
	theGameTimer.position = ccp(66,313);
	[self addChild:theGameTimer];
				
	//Adds the blocks tothe level
	NSMutableArray *blocksInLevel = [customLevel getBlocksArray];
	
	for(EditorBlock *block in blocksInLevel)
	{
		[self addBlock:[block getBlockType] weight:[block getWeight] position:[[CCDirector sharedDirector]convertToGL:[block getPosition]] rotation:[block getRotation]];
	}
	
	//Sets the level imformation based on user's difficulty setting
	if(currentUser == nil) suggestedTime = customLevel.timeLimit * 1.00;
	else if(currentUser.difficulty == bbEasy) suggestedTime = customLevel.timeLimit * 1.25;
	else if(currentUser.difficulty == bbMedium) suggestedTime = customLevel.timeLimit * 1.00;
	else if(currentUser.difficulty == bbHard) suggestedTime = customLevel.timeLimit * .75;
	
	if(currentUser == nil) [crane setFuel:customLevel.craneFuel*1.0];
	else if(currentUser.difficulty == bbEasy)[crane setFuel:customLevel.craneFuel*1.5];
	else if(currentUser.difficulty == bbMedium)[crane setFuel:customLevel.craneFuel*1.0];
	else if(currentUser.difficulty == bbHard)[crane setFuel:customLevel.craneFuel*.75];
		
	//Adds clouds based on windspeed and direction
	[self addChild:[Clouds cloudsWithSpeed:customLevel.windSpeed direction:customLevel.windDirection] z:4 tag:kCloudTag];
	setWindSpeed = customLevel.windSpeed;
	setWindDirection = customLevel.windDirection;
	
    if([customLevel.name isEqualToString:@"Level27"])
    {
        setWindSpeed = 15;
        [theWindSpeed setString:@"E 15 mph"];
    }
    
	//Alters gravity for "wind" effect
	if(customLevel.windDirection == bbEast) smgr.gravity = cpv(setWindSpeed/2,kGravity(gravityForLocation));
	else if(customLevel.windDirection == bbWest) smgr.gravity = cpv(-1*(setWindSpeed/2),kGravity(gravityForLocation));
	
	//Sets height bar position .8
	if(currentUser == nil) bar.position = ccp(bar.position.x,customLevel.maxHeight*1.0);
	else if(currentUser.difficulty == bbEasy)bar.position = ccp(bar.position.x,customLevel.maxHeight*1.25);
	else if(currentUser.difficulty == bbMedium)bar.position = ccp(bar.position.x,customLevel.maxHeight*1.0);
	else if(currentUser.difficulty == bbHard)bar.position = ccp(bar.position.x,customLevel.maxHeight*.8);
		
	//Current level by string name
	currentLevel = [[NSString alloc]initWithString:customLevel.name];
	
	[fm release];
	
	if(customLevel.location == bbLunar)[self removeChildByTag:kCloudTag cleanup:YES];
	
	if(theWorksiteLocation == bbLunar)
	{
		Ufo *ufo = (Ufo *)[self getChildByTag:kUfoTag];
		ufo.blocks = blocks;
	}
	
	if(theWorksiteLocation == bbLunar)
	{
		Ufo *ufo = (Ufo *)[self getChildByTag:kUfoTag];
		
		[ufo flyBy];
	}
}

-(void)onEnter
{
	//Schedule time method
	[self schedule:@selector(timePass) interval:timeStep];
	//Schedule height checking method
	[self schedule:@selector(heightCheck) interval:1.5f];
	[smgr start];
	[super onEnter];
}

#pragma mark -
#pragma mark pause menu methods

-(void)showPause
{
	//Show pause menu and stop any timers
	[self unschedule:@selector(right)];
	[self unschedule:@selector(left)];
	[self unschedule:@selector(raise)];
	[self unschedule:@selector(lower)];
	[smgr stop];
	id action = [CCMoveTo actionWithDuration:0.7f position:ccp(240,85)];
	[pauseMenu runAction:action];
	isPaused = YES;
}

-(void)hidePause
{
	//Hides pause and restarts
	[smgr start:1.0f/60.0f];
	smgr.constantDt=1.0f/60.0f;
	id action = [CCMoveTo actionWithDuration:0.7f position:ccp(240,-100)];
	[pauseMenu runAction:action];
	isPaused = NO;
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

#pragma mark -
#pragma mark Physics collision methods
-(void)handleCollisionWithLake:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{	
	//Ignores any blocks that could collide with the lake body.
	if(cpArbiterIsFirstContact(arb))
	{
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:oldVolume];
		[[SimpleAudioEngine sharedEngine]playEffect:@"WaterSplash.caf"];
	}
	
	cpArbiterIgnore(arb);
	
	//If water not previously touched and game not paused
	if(!waterTouched &&!isPaused)
	{
		//Sets the alert popup
		[alertPopup setString:@"Water Contamination!"];
		
		//Water has been touched 
		waterTouched = YES;
		
		//Creates the animations
		id action = [CCFadeIn actionWithDuration:.6f];
		id action1 = [CCScaleTo actionWithDuration:.6f scale: 1.0f];
		id action3 = [CCMoveTo actionWithDuration:2.0f position:ccp(alertPopup.position.x,alertPopup.position.y)];
		id action2 = [CCFadeOut actionWithDuration:.6f];
		id action4 = [CCCallFunc actionWithTarget:self selector:@selector(callLevelFailed)];
		
		//Displays the "Alert" label with the animation
		[alertPopup runAction:action];
		[alertPopup runAction:[CCSequence actions:action1,action3,action2,action4,nil]];
	}
}

-(void)handleCollisionWithBombFromBall:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{	
	//When collision begins
	if(COLLISION_POSTSOLVE)
	{
		cpShape *a, *b; 
		cpArbiterGetShapes(arb, &a, &b);
		
		cpVect n = cpArbiterGetNormal(arb, 0);
		float impact = cpfabs(cpvdot(cpvsub(a->body->v, b->body->v), n));
		
		if(impact > 100.0f)
		{
			cpCCSpriteBomb *closest = nil;
			
			//Gets the bomb for the given colision
			for(cpCCSpriteBomb *bomb in blocks)
			{
				if(bomb.shape == b)
					closest = bomb;
			}
			
			//Creates explosion
			[closest bombAtPoint:closest.position spritesAffected:blocks layer:self];
			//removes the bomb
			[blocks removeObject:closest];
			[self removeChild:closest cleanup:YES];
		}
		
	}	
}

-(void)handleCollisionWithBomb:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{	
	//When collision begins
	if(COLLISION_POSTSOLVE)
	{
		cpShape *a, *b; 
		cpArbiterGetShapes(arb, &a, &b);
		
		cpVect n = cpArbiterGetNormal(arb, 0);
		float impact = cpfabs(cpvdot(cpvsub(a->body->v, b->body->v), n));
		
		if(impact > 40.0f)
		{
			cpCCSpriteBomb *closest = nil;
		
			//Gets the bomb for the given colision
			for(cpCCSpriteBomb *bomb in blocks)
			{
				if(bomb.shape == b)
					closest = bomb;
			}
		
			//Creates explosion
			[closest bombAtPoint:closest.position spritesAffected:blocks layer:self];
			//removes the bomb
			[blocks removeObject:closest];
			[self removeChild:closest cleanup:YES];
		}
			
	}	
}

-(void)handleCollisionWithBall:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{	
	CGPoint contactPoint = arb->contacts->p;
	CGPoint ballPoint = ballNode.position;
	int difX = ballPoint.x - contactPoint.x;
	int difY = ballPoint.y - contactPoint.y;
	
	if(moment == COLLISION_PRESOLVE)
	{
		cpShape *a, *b; 
		cpArbiterGetShapes(arb, &a, &b);
		
		cpVect n = cpArbiterGetNormal(arb, 0);
		
		float impact = cpfabs(cpvdot(cpvsub(a->body->v, b->body->v), n));
		
		//If joint is more then MaxForce
		if(impact > 5.0f) 
		{
			if(fabs(difX) >= fabs(difY))
			{
				if(difX < 0)
				{
					canMoveRight = NO;//right
					canMoveUp = YES;
					canMoveLeft = YES;
				}
				
				else if(difX > 0)
				{
					canMoveLeft = NO;//left
					canMoveUp = YES;
					canMoveRight = YES;
				}
				//Deal with X
			}
			
			if(fabs(difY) > fabs(difX))
			{
				//Deal with Y
				if(difY < 0)
				{
					canMoveUp = NO;//Up
					canMoveDown = YES;
					canMoveLeft = YES;
				}
				//else if(difY > 0)canMoveDown = NO;//Down
			}
		}
		
		timeSinceLastContact = 0;
	}
	
	//When collision begins
	if(moment == COLLISION_POSTSOLVE)
	{
		cpShape *a, *b; 
		cpArbiterGetShapes(arb, &a, &b);
		
		cpVect n = cpArbiterGetNormal(arb, 0);
		float impact = cpfabs(cpvdot(cpvsub(a->body->v, b->body->v), n));
		
		if(impact > 5.0f && (gameTimer - lastSoundTime) >= 1.0f)//10.0f
		{			
			lastSoundTime = gameTimer;
			
			float newVolume = impact/100.0f;
			newVolume += .1f;
			
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:newVolume];
			[[SimpleAudioEngine sharedEngine] playEffect:@"BlockHit.caf"];
			
			//if(impact > 10.0f)AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
		}
	}
	
	//Collision ends
	if(moment == COLLISION_SEPARATE)
	{
		//Time since last contact 0
		timeSinceLastContact = 0;
	}
		
	//prevTime is now the current time
	prevTime = gameTimer;
}

-(void)handleCollisionWithBuilding:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	if(COLLISION_POSTSOLVE)
	{
		cpShape *a, *b; 
		cpArbiterGetShapes(arb, &a, &b);
		
		cpVect n = cpArbiterGetNormal(arb, 0);
		float impact = cpfabs(cpvdot(cpvsub(a->body->v, b->body->v), n));
		
		if(impact >10.0f)
		{
			float newVolume = impact/100.0f;
			newVolume += .1f;
			
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:newVolume];
			[[SimpleAudioEngine sharedEngine] playEffect:@"BlockHit.caf"];
		}
	}
			
	//When collision begins
	if(moment == COLLISION_BEGIN)
	{
		if(!buidlingTouched && !isPaused)
		{
			//Sets the alert popup
			[alertPopup setString:@"Secondary Damage!"];
			
			//Water has been touched 
			buidlingTouched = YES;
			
			//Creates the animations
			id action = [CCFadeIn actionWithDuration:.6f];
			id action1 = [CCScaleTo actionWithDuration:.6f scale: 1.0f];
			id action3 = [CCMoveTo actionWithDuration:2.0f position:ccp(alertPopup.position.x,alertPopup.position.y)];
			id action2 = [CCFadeOut actionWithDuration:.6f];
			id action4 = [CCCallFunc actionWithTarget:self selector:@selector(callLevelFailed)];
			
			//Displays the "Alert" label with the animation
			[alertPopup runAction:action];
			[alertPopup runAction:[CCSequence actions:action1,action3,action2,action4,nil]];
		}
	}
}

#pragma mark -
#pragma mark time method
-(void)timePass
{	   
	lastHitPoint = ballNode.position;
	
	//Updates the game timer label
	//Coverts the seconds into mins & seconds
		int mins = (int)(gameTimer-.5) / 60;
		int secs = (int)(gameTimer-.5) % 60;
	
		[theGameTimer setString:[NSString stringWithFormat:@"%i' %i\"",mins,secs]];
	
	//If game not paused
	if(!isPaused)
	{
		//time since last contact increase
		timeSinceLastContact += timeStep;
		
		//If time since last contact bigger then 1 second
		if(timeSinceLastContact >= 1.0f)//1.0f
		{
			//Can now move freely
			canMoveLeft = YES;
			canMoveRight = YES;
			canMoveUp = YES;
			canMoveDown = YES;
		}
		
		//Increase game timer
		gameTimer += timeStep;
		//If game timer more then suggested time then it has been passed
		if((int)gameTimer > suggestedTime) suggestedTimePassed = YES;
	}
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
	[blocks addObject:block];
	[self addChild:block];
}

#pragma mark -
#pragma mark Accelerometer Methods

//Handles accelerometer movement
#define kFilterFactor .8//.5
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	if(acceleration.x > 2.0f || acceleration.y > 2.0f || acceleration.z > 2.0f)
		if(!isPaused && !gameComplete)[self showCheatCodeField];
	
	//Calculates thes force to apply on the ball based on accelromete movement
	static float prevX=0, prevY=0;
	
	float accelX = acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
		
	cpVect v = cpv(-accelY, accelX);
	
	//Apply that force to the wrecking ball.
	[ballNode applyImpulse:ccpMult(v, 1000)];
}

#pragma mark -
#pragma mark Touch Methods

//Handles touches
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	Ufo *ufo = (Ufo *)[self getChildByTag:kUfoTag];
	
	if(!isPaused && [ufo canVaporize] == NO)
	{
		//Show pause
		if(point.x > 0 && point.x < 31 && point.y > 442 && point.y < 480 && !gameComplete)
		{
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:oldVolume];
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
			
			[self showPause];
			
			[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
			
			return;
		}
			
		//Moves trolly right
		if(point.y > 240 && point.x > 106 && point.x < 212 && activeDirection == bbNon && directionButtonActive == NO)
		{
			directionButtonActive = YES;
			if(![crane isOutOfFuel])[engineSound play];
			[self schedule:@selector(right) interval:0.01f];
			return;
		}
		
		//Moves trolly left
		else if(point.y < 240 && point.x > 106 && point.x < 212 && activeDirection == bbNon && directionButtonActive == NO)
		{	
			directionButtonActive = YES;
			if(![crane isOutOfFuel])[engineSound play];
			[self schedule:@selector(left) interval:0.01f];
			return;
		}
	
		//Lowers the ball
		else if(point.x < 106 && activeDirection == bbNon && directionButtonActive == NO)
		{
			directionButtonActive = YES;
			if(![crane isOutOfFuel])[engineSound play];
			[self schedule:@selector(lower) interval:0.01f];
			return;
		}
		
		//Raises the ball
		else if(point.x > 212 && activeDirection == bbNon && directionButtonActive == NO)
		{
			directionButtonActive = YES;
			if(![crane isOutOfFuel])[engineSound play];
			[self schedule:@selector(raise) interval:0.01f];
			return;
		}
	}
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//if(codeFieldActive)[self hideCheatCodeField];
	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
		
	activeDirection = bbNon;
	directionButtonActive = NO;
	
	//???
	[self highestPoint];
	
	//End all events when touch ends
	[self unschedule:@selector(right)];
	[self unschedule:@selector(left)];
	[self unschedule:@selector(raise)];
	[self unschedule:@selector(lower)];
	
	[engineSound stop];
	[engineGrind stop];
	
	//If game paused
	if(isPaused && pauseMenu.position.x == 240 && pauseMenu.position.y == 85)
	{
		//Resume
		if(point.x > 25 && point.x < 65 && point.y > 311 && point.y < 477)
		{
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:oldVolume];
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			[self hidePause];
			return;
		}
		
		//Restarts the level
		if(point.x > 25 && point.x < 65 && point.y > 148 && point.y < 278)
		{
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:oldVolume];
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
			
			[self saveSettings];
			
			//Play the custom level, singleton gets the filepath and it's settings are set.
			[[WBManager sharedManager] setLoadWithEditor:NO];
			[[WBManager sharedManager] setLevelFile:tempLevelLoc];
			
			NSString *filePath = nil;
			NSFileManager *fm = nil;
			
			//If .arch not found it means it's a custom level loading... not a premade level
			NSRange range =[tempLevelLoc rangeOfString:@".arch"];
			
			if(range.length == 0)
			{
				//Gets the documents directory for iPhone/iPod Touch
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory=[paths objectAtIndex:0];
				//Gets the fulls path with appending the file to be created. 
				NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
				//Filemanager
				fm = [[NSFileManager alloc]init];
				
				filePath = [customLevelsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.arch",tempLevelLoc]];
			}
			
			else 
			{
				filePath = tempLevelLoc;
			}
			
			GameScene *scene = [GameScene node];
			Level *customLevel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];//filePath
			[scene setLocation: customLevel.location];
			[[CCDirector sharedDirector] replaceScene:scene];
			
			[fm release];
			
			return;
		}
		
		//Quit
		if(point.x > 25 && point.x < 65 && point.y > 26 && point.y < 110)
		{
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:oldVolume];
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			[self returnToMenu];
			return;
		}
		
		//OF
		if(point.x > 86 && point.x < 137 && point.y > 415 && point.y < 468)
		{
			[[SimpleAudioEngine sharedEngine] setEffectsVolume:oldVolume];
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			[OpenFeint launchDashboard];
			return;
		}
		
	}
}

#pragma mark -
#pragma mark Crane Methods

//Move the crane trolly and trolly cone aswell right
-(void)right
{	
	if(waterTouched || buidlingTouched)return;
	
	if(canMoveRight)
	{
		//Sets direction and if it can move left
		direction = bbRight;
		canMoveLeft = YES;
		canMoveUp = YES;
		canMoveDown = YES;
		
		activeDirection = bbRight;
		
		if([crane trollyRight])
		{
			[engineGrind stop];
			[engineSound play];
			trollyClone.position = cpv(crane.trolly.position.x+2,crane.trolly.position.y+1);
		}
		
		else {
			if(![crane isOutOfFuel])[engineGrind play];
			[engineSound stop];
		}
	}
	
	else if(!canMoveRight && ![crane isOutOfFuel])
	{
		[engineSound stop];
		[engineGrind play];
	}
	
	else {
		[engineGrind stop];
		[engineSound stop];
	}
}

//Move the crane trolly and trolly cone aswell left
-(void)left
{	
	if(waterTouched || buidlingTouched)return;
	
	if(canMoveLeft)
	{
		//Sets direction and if it can move right
		direction = bbLeft;
		canMoveRight = YES;
		canMoveUp = YES;
		canMoveDown = YES;
		
		activeDirection = bbLeft;
		
		if([crane trollyLeft])
		{
			[engineGrind stop];
			[engineSound play];
			trollyClone.position = cpv(crane.trolly.position.x+2,crane.trolly.position.y+1);
		}
		
		else {
			if(![crane isOutOfFuel])[engineGrind play];
			[engineSound stop];
		}
	}
	
	else if(!canMoveLeft && ![crane isOutOfFuel])
	{
		[engineSound stop];
		[engineGrind play];
	}
	
	else {
		[engineGrind stop];
		[engineSound stop];
	}
}

-(void)raise
{	
	if(waterTouched || buidlingTouched)return;
	
	//if crane not out of fuel
	if(![crane isOutOfFuel]&&canMoveUp)
	{
		//raise the cord
		if(cpSlideJointGetMax(joint) >= kRopeLengthMin)
		{
			direction = bbUp;
			canMoveDown = YES;
			canMoveLeft = YES;
			canMoveRight = YES;
			
			activeDirection = bbUp;
			
			[engineGrind stop];
			[engineSound play];

			cpSlideJointSetMax(joint, cpSlideJointGetMax(joint)-.6f);
			[crane decreaseFuel];
		}
		
		else {
			if(![crane isOutOfFuel])[engineGrind play];
			[engineSound stop];
		}
	}
	
	else if(!canMoveUp && ![crane isOutOfFuel])
	{
		[engineSound stop];
		[engineGrind play];
	}
	
	else {
		[engineGrind stop];
		[engineSound stop];
	}
}

-(void)lower
{
	if(waterTouched || buidlingTouched)return;
	
	//if crane not out of fuel
	if(![crane isOutOfFuel]&&canMoveDown)
	{
		//lower the cord
		if(cpSlideJointGetMax(joint) <= kRopeLengthMax)
		{
			direction = bbDown;
			canMoveUp = YES;
			canMoveLeft = YES;
			canMoveRight = YES;
			
			activeDirection = bbDown;
			
			[engineGrind stop];
			[engineSound play];

			cpSlideJointSetMax(joint, cpSlideJointGetMax(joint)+.6);
			[crane decreaseFuel];
		}
		
		else {
			if(![crane isOutOfFuel]);
			[engineSound stop];
		}
	}
	
	else 
	{
		[engineGrind stop];
		[engineSound stop];
	}
}

#pragma mark -
#pragma mark height methods

-(float)highestPoint
{	
	//default heighest point
	float point = 0.0f;
		
	//goes through each block
	for(cpCCSpriteBlock *block in blocks)
	{
		//Gets the shape and bounding box of the shape
		cpShape *theShape = block.shape;
		cpBB bb = theShape->bb;

		//gets the top of bounding box
		float t = bb.t;

		//if top higher or is as high as heighest point, it's the new heighest point
		if(t >= point)
		{
			point = t;
		}
	}
	
	//Returns heightest point
	return point;
}

-(void)heightCheck
{
	//If game not complete
	if(!gameComplete && !waterTouched && !buidlingTouched && !isPaused)
	{
		//If heighest  point less then height bar
		if([self highestPoint] <= bar.position.y)
		{
			//Game complete
			gameComplete = YES;
			
			[self performSelector:@selector(gameCompleted) withObject:nil afterDelay:3.0f];
		}
	}
}

#pragma mark -
#pragma mark Game Completed & Failed Method
-(void)gameCompleted
{
	//Game is now "paused"
	isPaused = YES;
	
	//Stop all timers
	[self unschedule:@selector(right)];
	[self unschedule:@selector(left)];
	[self unschedule:@selector(raise)];
	[self unschedule:@selector(lower)];
	[engineSound stop];
	[engineGrind stop];
	
	//Remainging time if suggestedTime is greater then gameTimer get the difference else return 0
	int remainingTime = suggestedTime >= gameTimer ? (suggestedTime-gameTimer) : 0;
	
	//Creates strings with the final level imformation
	NSString *finalHeight = [NSString stringWithFormat:@"%i",(int)[self highestPoint]];
	NSString *fuelLeft = [NSString stringWithFormat:@"%i",(int)[crane getFuelAmount]];
	NSString *timeLeft = [NSString stringWithFormat:@"%i",remainingTime];
	
	//Calculates final score and creates a string
	double part1 = (((int)bar.position.y - (int)[self highestPoint])*2.0);
	double part2 = (int)[crane getFuelAmount]*2.0;
	double part3 = (int)(remainingTime/5);
	
	//Final score
	int theFinalScore = 100+(part1 + part2 + part3);
	
	//Score altered by difficulty setting of the user
	if(currentUser.difficulty == bbEasy)theFinalScore = theFinalScore * 1.0;
	else if(currentUser.difficulty == bbMedium)theFinalScore = theFinalScore * 1.2;
	else if(currentUser.difficulty == bbHard)theFinalScore = theFinalScore * 1.4;
	
	//Worse case scenerio check to prevent negatives
	if(theFinalScore < 0) theFinalScore = 0;
	
	NSString *finalScore = [NSString stringWithFormat:@"%i",theFinalScore];
	
	if([[WBManager sharedManager]loadWithGameLevel])
	{
		if([currentLevel isEqualToString:@"Level1"])currentUser.level1=YES;
		else if([currentLevel isEqualToString:@"Level2"])currentUser.level2=YES;
		else if([currentLevel isEqualToString:@"Level3"])currentUser.level3=YES;
		else if([currentLevel isEqualToString:@"Level4"])currentUser.level4=YES;
		else if([currentLevel isEqualToString:@"Level5"])currentUser.level5=YES;
		else if([currentLevel isEqualToString:@"Level6"])currentUser.level6=YES;
		else if([currentLevel isEqualToString:@"Level7"])currentUser.level7=YES;
		else if([currentLevel isEqualToString:@"Level8"])currentUser.level8=YES;
		else if([currentLevel isEqualToString:@"Level9"])currentUser.level9=YES;
		else if([currentLevel isEqualToString:@"Level10"])currentUser.level10=YES;
		
		else if([currentLevel isEqualToString:@"Level11"])currentUser.level11=YES;
		else if([currentLevel isEqualToString:@"Level12"])currentUser.level12=YES;
		else if([currentLevel isEqualToString:@"Level13"])currentUser.level13=YES;
		else if([currentLevel isEqualToString:@"Level15"])currentUser.level14=YES;
		else if([currentLevel isEqualToString:@"Level16"])currentUser.level15=YES;
		else if([currentLevel isEqualToString:@"Level17"])currentUser.level16=YES;
		else if([currentLevel isEqualToString:@"Level18"])currentUser.level17=YES;
		else if([currentLevel isEqualToString:@"Level14"])currentUser.level18=YES;
		else if([currentLevel isEqualToString:@"Level19"])currentUser.level19=YES;
		else if([currentLevel isEqualToString:@"Level20"])currentUser.level20=YES;
		
		else if([currentLevel isEqualToString:@"Level21"])currentUser.level21=YES;
		else if([currentLevel isEqualToString:@"Level22"])currentUser.level22=YES;
		else if([currentLevel isEqualToString:@"Level23"])currentUser.level23=YES;
		else if([currentLevel isEqualToString:@"Level24"])currentUser.level24=YES;
		else if([currentLevel isEqualToString:@"Level25"])currentUser.level25=YES;
		else if([currentLevel isEqualToString:@"Level26"])currentUser.level26=YES;
		else if([currentLevel isEqualToString:@"Level27"])currentUser.level27=YES;
		else if([currentLevel isEqualToString:@"Level28"])currentUser.level28=YES;
		else if([currentLevel isEqualToString:@"Level29"])currentUser.level29=YES;
		else if([currentLevel isEqualToString:@"Level30"])currentUser.level30=YES;
		
		int levelAsInt = 1;
		
		if([currentLevel isEqualToString:@"Level1"])levelAsInt = 1;
		else if([currentLevel isEqualToString:@"Level2"])levelAsInt = 2;
		else if([currentLevel isEqualToString:@"Level3"])levelAsInt = 3;
		else if([currentLevel isEqualToString:@"Level4"])levelAsInt = 4;
		else if([currentLevel isEqualToString:@"Level5"])levelAsInt = 5;
		else if([currentLevel isEqualToString:@"Level6"])levelAsInt = 6;
		else if([currentLevel isEqualToString:@"Level7"])levelAsInt = 7;
		else if([currentLevel isEqualToString:@"Level8"])levelAsInt = 8;
		else if([currentLevel isEqualToString:@"Level9"])levelAsInt = 9;
		else if([currentLevel isEqualToString:@"Level10"])levelAsInt = 10;
		
		else if([currentLevel isEqualToString:@"Level11"])levelAsInt = 11;
		else if([currentLevel isEqualToString:@"Level12"])levelAsInt = 12;
		else if([currentLevel isEqualToString:@"Level13"])levelAsInt = 13;
		else if([currentLevel isEqualToString:@"Level15"])levelAsInt = 14;
		else if([currentLevel isEqualToString:@"Level16"])levelAsInt = 15;
		else if([currentLevel isEqualToString:@"Level17"])levelAsInt = 16;
		else if([currentLevel isEqualToString:@"Level18"])levelAsInt = 17;
		else if([currentLevel isEqualToString:@"Level14"])levelAsInt = 18;
		else if([currentLevel isEqualToString:@"Level19"])levelAsInt = 19;
		else if([currentLevel isEqualToString:@"Level20"])levelAsInt = 20;
		
		else if([currentLevel isEqualToString:@"Level21"])levelAsInt = 21;
		else if([currentLevel isEqualToString:@"Level22"])levelAsInt = 22;
		else if([currentLevel isEqualToString:@"Level23"])levelAsInt = 23;
		else if([currentLevel isEqualToString:@"Level24"])levelAsInt = 24;
		else if([currentLevel isEqualToString:@"Level25"])levelAsInt = 25;
		else if([currentLevel isEqualToString:@"Level26"])levelAsInt = 26;
		else if([currentLevel isEqualToString:@"Level27"])levelAsInt = 27;
		else if([currentLevel isEqualToString:@"Level28"])levelAsInt = 28;
		else if([currentLevel isEqualToString:@"Level29"])levelAsInt = 29;
		else if([currentLevel isEqualToString:@"Level30"])levelAsInt = 30;
		
		[currentUser addGameCardWithScore:theFinalScore time:gameTimer height:[self highestPoint] forLevel:levelAsInt didCheat:hasCheated];
		
	}
	
	//Gets the documents directory for iPhone/iPod Touch
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	//Gets the fulls path with appending the file to be created. 
	NSString *profiles = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"Profiles"]];
	NSString *profileFileName = nil;
	
	//Creates the file path for the profile to be saved
	if(self.currentUser.profileNumber == 1)profileFileName=[profiles stringByAppendingPathComponent: @"profile1.arch"];
	else if(self.currentUser.profileNumber == 2)profileFileName=[profiles stringByAppendingPathComponent: @"profile2.arch"];
	else if(self.currentUser.profileNumber == 3)profileFileName=[profiles stringByAppendingPathComponent: @"profile3.arch"];
	else if(self.currentUser.profileNumber == 4)profileFileName=[profiles stringByAppendingPathComponent: @"profile4.arch"];
	
	//Archives File
	[NSKeyedArchiver archiveRootObject: self.currentUser toFile: profileFileName];
	
	//Shows the level complete popup with the specified strings
	[popUpManager showGameCompleteWithHeight:finalHeight fuelLeft:fuelLeft timeLeft:timeLeft hits:0 finalScore:finalScore didCheat:hasCheated];
}

-(void)callLevelFailed
{
	[self unschedule:@selector(right)];
	[self unschedule:@selector(left)];
	[self unschedule:@selector(raise)];
	[self unschedule:@selector(lower)];
	
	//Displays the level failed menyu
	[popUpManager showLevelFailed];
}

-(void)endSound
{	
	[engineSound stop];
	[engineGrind stop];
}

-(void)saveSettings
{
	//Gets the documents directory for iPhone/iPod Touch
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];		
	NSString *settingsPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"GameSettings"]];
	NSFileManager *fm = [[NSFileManager alloc]init];
	
	NSMutableDictionary *settingsDictionaryTemp = [[NSMutableDictionary alloc]initWithContentsOfFile:settingsPath];
	
	int games = 1 + [[settingsDictionaryTemp objectForKey:@"WorksitesAttempted"]intValue];
	
	[settingsDictionaryTemp setObject:[NSNumber numberWithInt:games] forKey:@"WorksitesAttempted"];
	[settingsDictionaryTemp setObject:[NSNumber numberWithInt:(int)gameTimer+[[settingsDictionary objectForKey:@"TotalTime"]intValue]] forKey:@"TotalTime"];
	
	int totalTimeForUser = [[settingsDictionaryTemp objectForKey:@"TotalTime"]intValue];
	
	if((totalTimeForUser/60) >= 30)[OFAchievementService unlockAchievement:LABORER];
	else if((totalTimeForUser/60) >= 120)[OFAchievementService unlockAchievement:FOREMAN];
	else if((totalTimeForUser/60) >= 240)[OFAchievementService unlockAchievement:ENGINEER];
	
	[fm removeItemAtPath:settingsPath error:nil];
	
	[settingsDictionaryTemp writeToFile:settingsPath atomically:YES];
	
	[settingsDictionaryTemp release];
	[fm release];
}

#pragma mark -
#pragma mark Other Methods

//Get level location
-(NSString*)getLevelLoc
{
	return tempLevelLoc;
}

#pragma mark -
#pragma mark Application Delegate Methods

- (void)applicationWillResignActive:(UIApplication *)application {
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
	[smgr stop];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[smgr start];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self hideCheatCodeField];
	return YES;
}

#pragma mark -
#pragma mark Cheat Methods

-(void)showCheatCodeField
{	
	if(codeFieldActive)return;
	
	codeFieldActive = YES;
	
	codeField = [[UITextField alloc]initWithFrame:CGRectMake(400, 92, 300, 30)];
	codeField.backgroundColor = [UIColor blackColor]; 
	[codeField setPlaceholder:@"Cheaters should go to the credits."];
	[codeField setBorderStyle:UITextBorderStyleBezel];
	codeField.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
	codeField.textColor = [UIColor whiteColor];
	codeField.font = [UIFont fontWithName:[[WBManager sharedManager]getFont] size:[[WBManager sharedManager]getFontSizeForSize:14]];
	[codeField setDelegate:self];
	[[[CCDirector sharedDirector]openGLView]addSubview:codeField];
	
	[UIView beginAnimations:@"MediaAnimate" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	codeField.frame = CGRectMake(170, 92, 30, 300);
	
	[UIView commitAnimations];
}

-(void)hideCheatCodeField
{
	codeFieldActive = NO;

	NSString *codeFieldText = codeField.text;
	
	[codeField resignFirstResponder];
	[codeField removeFromSuperview];
	[codeField release];
	codeField = nil;
		
	if([codeFieldText isEqualToString: @""] != YES)
	{
		
	//Find out what code was entered, if any at all
	if([codeFieldText isEqualToString:[NSString stringWithFormat:@"Subterranean disturbance"]])
	{	
		hasCheated = YES;
		
		CGPoint couplerPoint = platFormCoupler.position;
		
		id earthRightA = [CCMoveTo actionWithDuration:.5f position:ccp(couplerPoint.x+10,couplerPoint.y)];
		id earthLeftA = [CCMoveTo actionWithDuration:.5f position:ccp(couplerPoint.x-20,couplerPoint.y)];
		id earthCenterA = [CCMoveTo actionWithDuration:.5f position:ccp(couplerPoint.x,couplerPoint.y)];
		
		CCSequence *seq1 = [CCSequence actions:earthRightA, earthLeftA, earthCenterA, nil];
		CCSequence *seq2 = [CCSequence actions:earthRightA, earthLeftA, earthCenterA, nil];
		
		[platFormCoupler runAction:[CCSequence actions:seq1,seq2,nil]];
	}
	
	else if([codeFieldText isEqualToString:[NSString stringWithFormat:@"Diesel by the gallons %i",[self numberValueForPosition:1 string:codeFieldText]]])
	{
		hasCheated = YES;
		
		[crane setFuel:[self numberValueForPosition:1 string:codeFieldText]*1.0];
	}
	
	else if ([codeFieldText isEqualToString:[NSString stringWithFormat:@"The winds are changing %i east",[self numberValueForPosition:1 string:codeFieldText]]])
	{
		hasCheated = YES;
		
		[theWindSpeed setString:[NSString stringWithFormat:@"%@ @ %i mph", @"E",[self numberValueForPosition:1 string:codeFieldText]]];

		smgr.gravity = cpv([self numberValueForPosition:1 string:codeFieldText]/2,kGravity(gravityForLocation));
		[self removeChildByTag:kCloudTag cleanup:YES];
		[self addChild:[Clouds cloudsWithSpeed:[self numberValueForPosition:1 string:codeFieldText] direction:bbEast] z:4 tag:kCloudTag];
	}
	
	else if ([codeFieldText isEqualToString:[NSString stringWithFormat:@"The winds are changing %i west",[self numberValueForPosition:1 string:codeFieldText]]])
	{		
		hasCheated = YES;
		
		[theWindSpeed setString:[NSString stringWithFormat:@"%@ @ %i mph", @"W",[self numberValueForPosition:1 string:codeFieldText]]];
		
		smgr.gravity = cpv(-1*([self numberValueForPosition:1 string:codeFieldText]/2),kGravity(gravityForLocation));
		[self removeChildByTag:kCloudTag cleanup:YES];
		[self addChild:[Clouds cloudsWithSpeed:[self numberValueForPosition:1 string:codeFieldText] direction:bbWest] z:4 tag:kCloudTag];
	}
	
	else if ([codeFieldText isEqualToString:[NSString stringWithFormat:@"Led weight %i",[self numberValueForPosition:1 string:codeFieldText]]])
	{
		if([self numberValueForPosition:1 string:codeFieldText] >= 1)
		{
			hasCheated = YES;
			
			ballNode.shape->body->m = (float)[self numberValueForPosition:1 string:codeFieldText];
			ballNode.shape->body->m_inv = 1.0f/(float)[self numberValueForPosition:1 string:codeFieldText];
		}
	}
		
	}
	
	if(theWorksiteLocation == bbLunar)[self removeChildByTag:kCloudTag cleanup:YES];
}

-(int)numberValueForPosition:(int)desiredInt string:(NSString *)stringValue
{
	unsigned int x = 0;
	int numbersFound = 0;
	NSMutableString *number = [NSMutableString stringWithString:@""];
	BOOL hasCounted = NO;

	while(x <= [stringValue length]-1)
	{
		char currentChar = [stringValue characterAtIndex:x];
		
		if(currentChar >= '0' && currentChar <= '9')
		{
			[number appendString:[NSString stringWithFormat:@"%c",currentChar]];
			hasCounted = NO;
		}
		
		else
	    {
			if(!hasCounted && ![number isEqualToString:@""])
			{
				hasCounted = YES;
				numbersFound++;
			}
			
			if(numbersFound == desiredInt)return [number intValue];
			else [number setString:@""];
		}
		
		x++;
	}
	
	if(![number isEqualToString:@""])return [number intValue];
	
	return -1;
}


#pragma mark -
#pragma mark cleanup
-(void)onExit
{
	//if(engineGrind!=nil)
	//{
		[engineGrind stop];
		[engineGrind release];
	//}
	
	//if(engineSound!=nil)
	//{
		[engineSound stop];
		[engineSound release];
	//}
	
	//if(countrysideSound!=nil)
	//{
		[countrysideSound stop];
		[countrysideSound release];
	//}
	
	//if(wildernessSound!=nil)
	//{
		[wildernessSound stop];
		[wildernessSound release];
	//}
	
	//if(citySound!=nil)
	//{
		[citySound stop];
		[citySound release];
	//}
	
	[self unschedule:@selector(timePass)];
	[smgr stop];
	[super onExit];
}

-(void)returnToMenu
{
	[[SimpleAudioEngine sharedEngine] setEffectsVolume:oldVolume];
	[self saveSettings];
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
	if([[WBManager sharedManager]loadWithGameLevel]==YES)
	{
		if(theWorksiteLocation == bbCountrySide)[[CCDirector sharedDirector]replaceScene:[LevelMenu1Scene node]];
		else if(theWorksiteLocation == bbWilderness)[[CCDirector sharedDirector]replaceScene:[LevelMenu2Scene node]];
		else if(theWorksiteLocation == bbCity)[[CCDirector sharedDirector]replaceScene:[LevelMenu3Scene node]];
	}
	
	else[[CCDirector sharedDirector]replaceScene:[MenuScene node]];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[smgr stop];
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[smgr start:1.0f/60.0f];
	smgr.constantDt=1.0f/60.0f;
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
}


//Cleanup
-(void)dealloc
{		
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
	
	if(codeField != nil)
	{
		[codeField removeFromSuperview];
		[codeField release];
	}
	
	[currentLevel release];
	[currentUser release];
	[tempLevelLoc release];
	[blocks release];
	[[CCTextureCache sharedTextureCache]removeUnusedTextures];
	[self removeAllChildrenWithCleanup:YES];
	[smgr release];
	[super dealloc];
}

@end
