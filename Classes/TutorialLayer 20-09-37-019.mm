//
//  GameLayer.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 3/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"

#import "TutorialLayer.h"
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

#import "OFAchievementService.h"
#import "OFDefines.h"

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

@implementation TutorialLayer
@synthesize currentUser;

#pragma mark -
#pragma mark init methods

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{		
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
		smgr.gravity = cpv(0, -100);
		smgr.damping = .85f;
		
		//Starts space manager at 60 FPS
		//:1.0/60.0];
		
		//Creates a crane sprite
		crane = [Crane spriteWithFile:@"Crane.png"];
		crane.position = ccp(240,160);
		[self addChild:crane];
		
		//Wrecking ball
		cpShape *ball = [smgr addCircleAt:cpv(125, 279-kRopeLengthMin) mass:50.0 radius:8.5];
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
									 selector:@selector(handleCollisionWithBomb:arbiter:space:)];
		[smgr addCollisionCallbackBetweenType:kBlockCollision 
									otherType:kBombCollision 
									   target:self 
									 selector:@selector(handleCollisionWithBomb:arbiter:space:)];
		
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
		
		timeSinceCall = gameTimer;
		
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
		//[[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"Countryside.caf"];
		
		NSURL *sound = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Countryside" ofType:@"caf"]];
		countrysideSound = [[AVAudioPlayer alloc]initWithContentsOfURL:sound error:nil];
		[countrysideSound setNumberOfLoops:-1];
		[countrysideSound setVolume:[[settingsDictionary objectForKey:@"SfxVolume"]floatValue]];
		[countrysideSound play];
		
		[PlatformBuilder buildFlatPlatformForSpace:smgr position:cpv(240,13)];
	}
	
	//Gets the string representation of the wind direction for displaying
	NSString *directionAsString = nil;
	
	switch(customLevel.windDirection)
	{
		case bbEast:
			directionAsString = @"E";
			break;
		case bbWest:
			directionAsString = @"W";
			break;
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
	
	//Alters gravity for "wind" effect
	if(customLevel.windDirection == bbEast) smgr.gravity = cpv(customLevel.windSpeed/2,-100);
	else if(customLevel.windDirection == bbWest) smgr.gravity = cpv(-1*(customLevel.windSpeed/2),-100);
	
	//Sets height bar position .8
	if(currentUser == nil) bar.position = ccp(bar.position.x,customLevel.maxHeight*1.0);
	else if(currentUser.difficulty == bbEasy)bar.position = ccp(bar.position.x,customLevel.maxHeight*1.25);
	else if(currentUser.difficulty == bbMedium)bar.position = ccp(bar.position.x,customLevel.maxHeight*1.0);
	else if(currentUser.difficulty == bbHard)bar.position = ccp(bar.position.x,customLevel.maxHeight*.8);
		
	//Current level by string name
	currentLevel = [[NSString alloc]initWithString:customLevel.name];
	
	[fm release];
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
-(void)handleCollisionWithBomb:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{	
	//When collision begins
	if(COLLISION_POSTSOLVE)
	{
		cpShape *a, *b; 
		cpArbiterGetShapes(arb, &a, &b);
		
		cpVect n = cpArbiterGetNormal(arb, 0);
		float impact = cpfabs(cpvdot(cpvsub(a->body->v, b->body->v), n));
		
		if(impact >130.0f)
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
	//When collision begins
	if(moment == COLLISION_BEGIN)
	{
		if ((gameTimer - lastSoundTime) > 1.0f && (cpvdist(ballNode.position,lastHitPoint) > 5.0f || CGPointEqualToPoint(lastHitPoint, CGPointZero))) 
		{
			[[SimpleAudioEngine sharedEngine] playEffect:@"BlockHit.caf"];
			lastSoundTime = gameTimer;
		}
		
		//Time since last contact is 0
		timeSinceLastContact = 0;
		
		cpSlideJoint *jointNew = (cpSlideJoint *)joint;
			  
		//If joint is more then MaxForce
		if(fabs(jointNew->jnAcc) > MaxForce) 
		{
			//If going in right direction and it's been atleast 3 seconds or the last direction is right
			if(direction == bbRight && (((gameTimer - timeSinceCall) >= 3.0f) || lastDirection==bbRight))
			{
				//Last direction is now right
				lastDirection = bbRight;
				
				//Time since call is now current time
				timeSinceCall = gameTimer;
				
				//It can no longer move right
				canMoveRight=NO;
			}
			
			//If going in left direction and it's been atleast 3 seconds or the last direction is left
			else if(direction == bbLeft && (((gameTimer - timeSinceCall) >= 3.0f) || lastDirection==bbLeft))
			{
				//Last direction is now left
				lastDirection = bbLeft;
				
				//Time since call is now current time
				timeSinceCall = gameTimer;
				
				//Can't move right
				canMoveLeft=NO;
			}
			
			else if(direction == bbUp && (((gameTimer - timeSinceCall) >= 3.0f) || lastDirection==bbUp))
			{
				//Last direction is now left
				lastDirection = bbUp;
				
				//Time since call is now current time
				timeSinceCall = gameTimer;
				
				//Can't move right
				canMoveUp=NO;
			}
		}
	}
	
	//Before collision ends
	if(moment == COLLISION_PRESOLVE)
	{
		//Time since last contact 0
		timeSinceLastContact = 0;
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
		if(timeSinceLastContact >= 1.0f)
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
#define kFilterFactor .5
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
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
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	if(!isPaused)
	{
		//Show pause
		if(point.x > 0 && point.x < 31 && point.y > 442 && point.y < 480)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
			
			[self showPause];
			
			[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
			
			return;
		}
		
		//Moves trolly right
		if(point.y > 240 && point.x > 106 && point.x < 212 && activeDirection == bbNon)
		{
			if(![crane isOutOfFuel])[engineSound play];
			[self schedule:@selector(right) interval:0.01f];
		}
		
		//Moves trolly left
		if(point.y < 240 && point.x > 106 && point.x < 212 && activeDirection == bbNon)
		{	
			if(![crane isOutOfFuel])[engineSound play];
			[self schedule:@selector(left) interval:0.01f];
		}
	
		//Lowers the ball
		if(point.x < 106 && activeDirection == bbNon)
		{
			if(![crane isOutOfFuel])[engineSound play];
			[self schedule:@selector(lower) interval:0.01f];
		}
		
		//Raises the ball
		if(point.x > 212 && activeDirection == bbNon)
		{
			if(![crane isOutOfFuel])[engineSound play];
			[self schedule:@selector(raise) interval:0.01f];
		}
	}
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
		
	activeDirection = bbNon;
	
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
	if(isPaused)
	{
		//Resume
		if(point.x > 25 && point.x < 65 && point.y > 311 && point.y < 477)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			[self hidePause];
			return;
		}
		
		//Restarts the level
		if(point.x > 25 && point.x < 65 && point.y > 148 && point.y < 278)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
			
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
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			[self returnToMenu];
			return;
		}
		
		//OF
		if(point.x > 86 && point.x < 137 && point.y > 415 && point.y < 468)
		{
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
			if(![crane isOutOfFuel]);//[engineGrind play];
			[engineSound stop];
		}
	}
	
	else if(!canMoveDown && ![crane isOutOfFuel])
	{
		//[engineSound stop];
		//[engineGrind play];
	}
	
	else {
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
	if(!gameComplete)
	{
		//If heighest  point less then height bar
		if([self highestPoint] <= bar.position.y)
		{
			//Game complete
			gameComplete = YES;
		}
	}
}

#pragma mark -
#pragma mark Game Completed & Failed Method
-(void)gameCompleted
{
	//Shows the level complete popup with the specified strings
//	[popUpManager showGameCompleteWithHeight:finalHeight fuelLeft:fuelLeft timeLeft:timeLeft hits:0 finalScore:finalScore];
}

#pragma mark -
#pragma mark cleanup
-(void)onExit
{
	[self unschedule:@selector(timePass)];
	[smgr stop];
	[super onExit];
}

-(void)returnToMenu
{
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
	if([[WBManager sharedManager]loadWithGameLevel]==YES)[[CCDirector sharedDirector]replaceScene:[LevelMenu1Scene node]];
	else[[CCDirector sharedDirector]replaceScene:[MenuScene node]];
}

//Get level location
-(NSString*)getLevelLoc
{
	return tempLevelLoc;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
	[smgr stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[smgr start];
	smgr.constantDt=1.0f/60.0f;
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	//Clouds *clouds = (Clouds *)[self getChildByTag:kCloudTag];
	//[clouds reset];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
	[smgr stop];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[smgr start];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

//Cleanup
-(void)dealloc
{	
	if(engineGrind!=nil)
	{
		[engineGrind stop];
		[engineGrind release];
	}
	
	if(engineSound!=nil)
	{
		[engineSound stop];
		[engineSound release];
	}
	
	if(countrysideSound!=nil)
	{
		[countrysideSound stop];
		[countrysideSound release];
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
