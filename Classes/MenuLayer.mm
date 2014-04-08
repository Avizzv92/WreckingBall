//
//  MenuLayer.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 3/23/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "MenuLayer.h"
#import "UserProfileScene.h"
#import "GameScene.h"
#import "Clouds.h"
#import "Crane.h"
#import "CustomLevelsScene.h"
#import "WBManager.h"
#import "OpenFeint.h"
#import "OptionsScene.h"

@implementation MenuLayer

#pragma mark -
#pragma mark init methods

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		canContinue = YES;
		
		[OFAchievementService unlockAchievement:THANKS_FOR_THE_PURCHASE_];
		
		//No Longer Userprofile being used by default.
		[[WBManager sharedManager] setLoadWithGameLevel:NO];
		
		//Sets acceleromete delegate to self
		[[UIAccelerometer sharedAccelerometer] setDelegate:self];
		
		//Touch effect
		[self addChild:[TouchEffect node] z:4];
		
		//touch enabled
		self.isTouchEnabled = YES;
		
		//Clouds effect Layer
		[self addChild:[Clouds node] z:-1];
		
		//Crane Sprite
		CCSprite *crane = [CCSprite spriteWithFile:@"Crane.png"];
		crane.position = ccp(240,160);
		[self addChild:crane];
		
		//Creates a chipmunk space
		smgr = [[SpaceManager alloc] init];
		//NEEDED?
		smgr.constantDt = 1.0/60.0;

		//Graivty in space
		smgr.gravity = cpv(0, -100);
		smgr.damping = .85f;
		//Space at 60 FPS
		[smgr start];
		
		//Logo
		cpShape *logoShape = [smgr addRectAt:cpv(280,227) mass:100 width:357 height:46 rotation:0];
		logo = [cpCCSprite spriteWithShape:logoShape file:@"logo.png"];
		logo.autoFreeShape = YES;
		logo.spaceManager = smgr;
		[self addChild:logo];
		
		//Blank
		pointBlank = [smgr addRectAt:cpv(280,275) mass:STATIC_MASS width:135 height:1 rotation:0];
		pointBlank->e = 0.0f;

		//Joints For Logo
		cpConstraint *joint1 = [smgr addSlideToBody:logo.shape->body fromBody:pointBlank->body toBodyAnchor:cpv(165,-10) fromBodyAnchor:cpv(0,0) minLength:175 maxLength:175];
		cpConstraintNode *jointNode1 = [cpConstraintNode nodeWithConstraint:joint1];
		jointNode1.autoFreeConstraint = YES;
		jointNode1.spaceManager = smgr;
		jointNode1.color = ccWHITE;
		[jointNode1 setOpacity:200];
		[self addChild:jointNode1 z:-1];
		
		cpConstraint *joint2 = [smgr addSlideToBody:logo.shape->body fromBody:pointBlank->body toBodyAnchor:cpv(-165,-10) fromBodyAnchor:cpv(0,0) minLength:175 maxLength:175];
		cpConstraintNode *jointNode2 = [cpConstraintNode nodeWithConstraint:joint2];
		jointNode2.color = ccWHITE;
		[jointNode2 setOpacity:200];
		jointNode2.autoFreeConstraint = YES;
		jointNode2.spaceManager = smgr;
		[self addChild:jointNode2 z:-1];
	}
	
	return self;
}

#pragma mark -
#pragma mark accelerometer methods

#define kFilterFactor .5
-(void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	
	//Calculates the force to apply to the logo
	static float prevX=0, prevY=0;
	
	float accelX = acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	cpVect v = cpv( -accelY, accelX);
	
	//Applies the force to the logo
	[logo applyImpulse:ccpMult(v, 1000)];
}

#pragma mark -
#pragma mark touch methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	//Career
	if(point.y > 191 && point.y < 366 && point.x > 145 && point.x < 187 && canContinue)
	{
		canContinue = NO;
		
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[[WBManager sharedManager]setLoadWithEditor:NO];
		[self performSelector:@selector(loadGame) withObject:nil afterDelay:.0f];
	}
	
	//Custom
	if(point.y > 191 && point.y <366 && point.x > 88 && point.x < 134 && canContinue)
	{
		canContinue = NO;
		
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[[CCDirector sharedDirector] replaceScene:[CustomLevelsScene node]];
	}
	
	//Options
	if(point.y > 191 && point.y <366 && point.x > 37 && point.x < 79 && canContinue)
	{
		canContinue = NO;
		
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[[CCDirector sharedDirector] replaceScene:[OptionsScene node]];
	}
	
	//Openfeint
	if(point.y > 385 && point.y < 430 && point.x > 57 && point.x < 110 && canContinue)
	{	
		canContinue = NO;
		
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[OpenFeint launchDashboard];
	}
	
	//Alt Vis
	if(point.x > 57 && point.x < 110 && point.y > 128 && point.y < 178 && canContinue)
	{
		canContinue = NO;
		
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[[CCDirector sharedDirector] replaceScene:[AltVisScene node]];
	}
}

#pragma mark -
#pragma mark load game method

-(void)loadGame
{
	//Loads user profil menu for selecting user
	[[CCDirector sharedDirector] replaceScene:[UserProfileScene node]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

#pragma mark -
#pragma mark cleanup
-(void)dealloc
{
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
	[smgr stop];
	[smgr release];
	[super dealloc];
}

@end
