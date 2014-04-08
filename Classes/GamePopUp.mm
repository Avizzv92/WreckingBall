//
//  GamePopUp.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/22/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "GamePopUp.h"
#import "OpenFeint.h"
#import "WBManager.h"
#import "Level.h"
#import "GameScene.h"
#import "OFDefines.h"

@implementation GamePopUp
@synthesize delegate;

#pragma mark -
#pragma mark init method(s)

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		popupAnimationDone = NO;
		
		//Default is niether popups have been shown
		gameCompletePopup = NO;
		gameFailedPopup = NO;
		
		//Creates the labels with default imformation
		gameComplete = [CCSprite spriteWithFile:@"GameComplete.png"];
		gameComplete.position = ccp(243,460);
		[self addChild:gameComplete];
		
		levelFailed = [CCSprite spriteWithFile:@"WorksiteFailed.png"];
		levelFailed.position = ccp(243,460);
		[self addChild:levelFailed];
		
		finalHeight = [CCLabel labelWithString:@""  dimensions:CGSizeMake(250,22) alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:20];
		finalHeight.position = ccp(253,170);
		[gameComplete addChild:finalHeight];
		
		fuelLeft = [CCLabel labelWithString:@""  dimensions:CGSizeMake(250,22) alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:20];
		fuelLeft.position = ccp(253,145);
		[gameComplete addChild:fuelLeft];
		
		timeLeft = [CCLabel labelWithString:@""  dimensions:CGSizeMake(250,22) alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:20];
		timeLeft.position = ccp(253,120);
		[gameComplete addChild:timeLeft];
		
		finalScore = [CCLabel labelWithString:@""  dimensions:CGSizeMake(250,22) alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:20];
		finalScore.position = ccp(253,70);
		[gameComplete addChild:finalScore];
		
		//Touch for this layer not enabled
		self.isTouchEnabled = NO;
	}
	
	return self;
}

#pragma mark -
#pragma mark touch method(s)

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	if(gameCompletePopup)
	{
		if(point.x > 61 && point.x < 103 && point.y > 60 && point.y < 99 && popupAnimationDone)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			//Load openfeint
			[OpenFeint launchDashboard];
			return;
		}
	
		else if(point.x > 61 && point.x < 103 && point.y > 380 && point.y < 422 && popupAnimationDone)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			//tells delegate to return to main menu
			[delegate returnToMenu];
			return;
		}
	}
	
	else if(gameFailedPopup)
	{
		//Quit
		if(point.x > 70 && point.x < 105 && point.y > 59 && point.y < 140 && popupAnimationDone)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			[delegate returnToMenu];
			return;
		}
		
		//Restart
		if(point.x > 70 && point.x < 105 && point.y > 312 && point.y < 408 && popupAnimationDone)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			[delegate saveSettings];
			
			//Play the custom level, singleton gets the filepath and it's settings are set.
			[[WBManager sharedManager] setLoadWithEditor:NO];
			[[WBManager sharedManager] setLevelFile:[delegate getLevelLoc]];
			
			NSString *filePath = nil;
			NSFileManager *fm = nil;
			
			//If .arch not found it means it's a custom level loading... not a premade level
			NSRange range =[[delegate getLevelLoc] rangeOfString:@".arch"];
			
			if(range.length == 0)
			{
				//Gets the documents directory for iPhone/iPod Touch
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory=[paths objectAtIndex:0];
				//Gets the fulls path with appending the file to be created. 
				NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
				//Filemanager
				fm = [[NSFileManager alloc]init];
				
				filePath = [customLevelsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.arch",[delegate getLevelLoc]]];
			}
			
			else 
			{
				filePath = [delegate getLevelLoc];
			}
			
			GameScene *scene = [GameScene node];
			Level *customLevel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];//filePath
			[scene setLocation: customLevel.location];
			[[CCDirector sharedDirector] replaceScene:scene];
			
			[fm release];
			return;			
		}
	}
}

#pragma mark -
#pragma mark game complete popup method

//Shows game compete popup
-(void)showGameCompleteWithHeight:(NSString *)height fuelLeft:(NSString *)fuel timeLeft:(NSString *)time hits:(NSString *)hits finalScore:(NSString *)score didCheat:(BOOL)hasCheated
{
	//If game failed popup has not been shown
	if(gameFailedPopup == NO)
	{
		//Game complete popup has now been shown
		gameCompletePopup = YES;
	
		//Disables touch for the delegate layer
		if(delegate != nil)
		{
			[delegate setIsTouchEnabled: NO];
			[delegate endSound];
		}
		
		//Enables touch for this layer
		self.isTouchEnabled = YES;
	
		//Updates the labels to display the final level scores and states
		[finalHeight setString:[NSString stringWithFormat:@"Final Height: %@",height]];
		[fuelLeft setString:[NSString stringWithFormat:@"Fuel Left: %@",fuel]];
		[timeLeft setString:[NSString stringWithFormat:@"Time Left: %@",time]];
		[finalScore setString:[NSString stringWithFormat:@"Final Score: %@",score]];
	
		//Animation for the popup
		id move = [CCMoveTo actionWithDuration:2 position:ccp(243,155)];
		id action = [CCEaseBounceOut actionWithAction:move];
		[gameComplete runAction: [CCSequence actions:action,[CCCallFunc actionWithTarget:self selector:@selector(animationDone)],nil]];	
		
		if([[WBManager sharedManager]loadWithGameLevel])
		{
			
		if(!hasCheated)
		{

		int levelNum = [self getLevelNumber];
		int theScore = [score intValue];
		
		switch (levelNum) {
			case 1:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite1 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 2:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite2 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 3:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite3 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 4:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite4 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 5:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite5 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 6:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite6 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 7:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite7 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 8:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite8 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 9:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite9 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 10:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite10 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 11:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite11 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 12:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite12 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 13:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite13 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 14:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite14 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 15:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite15 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 16:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite16 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 17:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite17 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 18:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite18 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 19:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite19 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 20:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite20 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 21:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite21 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 22:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite22 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 23:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite23 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 24:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite24 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 25:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite25 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 26:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite26 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 27:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite27 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 28:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite28 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 29:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite29 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			case 30:
				[OFHighScoreService setHighScore: theScore forLeaderboard: Worksite30 onSuccess:OFDelegate() onFailure:OFDelegate()  ];	
 				break;
			default:
				break;
		}
			
		}
			
		}
	}
}

-(void)showLevelFailed
{
	//If game complete popup has not be shown
	if(gameCompletePopup == NO)
	{
		//Game failed popup has been shown.
		gameFailedPopup = YES;
	
		//Disables touch for the delegate layer
		if(delegate != nil)
		{
			[delegate setIsTouchEnabled: NO];
			[delegate endSound];
		}
		
		//Enables touch for this layer
		self.isTouchEnabled = YES;
	
		//Animation for the popup
		id move = [CCMoveTo actionWithDuration:2 position:ccp(243,155)];
		id action = [CCEaseBounceOut actionWithAction:move];
		[levelFailed runAction: [CCSequence actions:action,[CCCallFunc actionWithTarget:self selector:@selector(animationDone)],nil]];
	}
}

-(void)animationDone
{
	popupAnimationDone = YES;
}

-(int)getLevelNumber
{
	NSString *level = [[WBManager sharedManager]getLevelFile];
	
	if([level hasSuffix:@"Level1.arch"])return 1;
	else if([level hasSuffix:@"Level2.arch"])return 2;
	else if([level hasSuffix:@"Level3.arch"])return 3;
	else if([level hasSuffix:@"Level4.arch"])return 4;
	else if([level hasSuffix:@"Level5.arch"])return 5;
	else if([level hasSuffix:@"Level6.arch"])return 6;
	else if([level hasSuffix:@"Level7.arch"])return 7;
	else if([level hasSuffix:@"Level8.arch"])return 8;
	else if([level hasSuffix:@"Level9.arch"])return 9;
	else if([level hasSuffix:@"Level10.arch"])return 10;
	
	else if([level hasSuffix:@"Level11.arch"])return 11;
	else if([level hasSuffix:@"Level12.arch"])return 12;
	else if([level hasSuffix:@"Level13.arch"])return 13;
	else if([level hasSuffix:@"Level15.arch"])return 14;
	else if([level hasSuffix:@"Level17.arch"])return 15;
	else if([level hasSuffix:@"Level17.arch"])return 16;
	else if([level hasSuffix:@"Level18.arch"])return 17;
	else if([level hasSuffix:@"Level14.arch"])return 18;
	else if([level hasSuffix:@"Level19.arch"])return 19;
	else if([level hasSuffix:@"Level20.arch"])return 20;
	
	else if([level hasSuffix:@"Level21.arch"])return 21;
	else if([level hasSuffix:@"Level22.arch"])return 22;
	else if([level hasSuffix:@"Level23.arch"])return 23;
	else if([level hasSuffix:@"Level24.arch"])return 24;
	else if([level hasSuffix:@"Level25.arch"])return 25;
	else if([level hasSuffix:@"Level26.arch"])return 26;
	else if([level hasSuffix:@"Level27.arch"])return 27;
	else if([level hasSuffix:@"Level28.arch"])return 28;
	else if([level hasSuffix:@"Level29.arch"])return 29;
	else if([level hasSuffix:@"Level30.arch"])return 30;
	else return 0;
}

#pragma mark -
#pragma mark cleanup

-(void)dealloc
{
	[super dealloc];
}

@end
