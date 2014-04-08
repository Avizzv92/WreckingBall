//
//  UserProfileMenu.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "UserProfileMenu.h"
#import "LevelMenu1Scene.h"
#import "MenuScene.h"
#import "FontManager.h"
#import "WBManager.h"
#import "TutorialScene.h"

@implementation UserProfileMenu

#pragma mark -
#pragma mark init method(s)

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		self.isTouchEnabled = YES;
		
		loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		loading.frame = CGRectMake(140, 220, 40, 40);
		[loading startAnimating];
		[[[CCDirector sharedDirector]openGLView]addSubview:loading];
		
		//Default selected box is zero (none)
		boxSelected = 0;
		
		//No menus visible
		newProfileOptionVisible = NO;
		profileOptionsVisible = NO;
		
		//Touch effect
		[self addChild:[TouchEffect node] z:5];
		
		//Creates the user labels with names and datas (default values)
		user1 = [CCLabel labelWithString:@"" dimensions:CGSizeMake(144,42) alignment:UITextAlignmentCenter fontName:@"Chalkduster" fontSize:20];
		user2 = [CCLabel labelWithString:@"" dimensions:CGSizeMake(144,42) alignment:UITextAlignmentCenter fontName:@"Chalkduster" fontSize:20];
		user3 = [CCLabel labelWithString:@"" dimensions:CGSizeMake(144,42) alignment:UITextAlignmentCenter fontName:@"Chalkduster" fontSize:20];
		user4 = [CCLabel labelWithString:@"" dimensions:CGSizeMake(144,42) alignment:UITextAlignmentCenter fontName:@"Chalkduster" fontSize:20];
		user1.position = ccp(138,190);
		user2.position = ccp(350,190);
		user3.position = ccp(138,95);
		user4.position = ccp(350,95);
		[self addChild:user1];
		[self addChild:user2];
		[self addChild:user3];
		[self addChild:user4];
		
		[user1 setString:@"New Profile"];
		[user2 setString:@"New Profile"];
		[user3 setString:@"New Profile"];
		[user4 setString:@"New Profile"];
		
		user1Data = [CCLabel labelWithString:@""  dimensions:CGSizeMake(144,42) alignment:UITextAlignmentCenter fontName:@"Chalkduster" fontSize:14];
		user2Data = [CCLabel labelWithString:@""  dimensions:CGSizeMake(144,42) alignment:UITextAlignmentCenter fontName:@"Chalkduster" fontSize:14];
		user3Data = [CCLabel labelWithString:@""  dimensions:CGSizeMake(144,42) alignment:UITextAlignmentCenter fontName:@"Chalkduster" fontSize:14];
		user4Data = [CCLabel labelWithString:@""  dimensions:CGSizeMake(144,42) alignment:UITextAlignmentCenter fontName:@"Chalkduster" fontSize:14];
		user1Data.position = ccp(138,160);
		user2Data.position = ccp(350,160);
		user3Data.position = ccp(138,65);
		user4Data.position = ccp(350,65);
		[self addChild:user1Data];
		[self addChild:user2Data];
		[self addChild:user3Data];
		[self addChild:user4Data];
		
		//Creates new profile popup
		newProfilePopup = [CCSprite spriteWithFile:@"NewUser.png"];
		newProfilePopup.position = ccp(243,460);
		[self addChild:newProfilePopup];
		
		//Creates profile popup
		profileOptions = [CCSprite spriteWithFile:@"ProfileOptionMenu.png"];
		profileOptions.position = ccp(237,460);
		[self addChild:profileOptions];
			
		//Creates difficulty selector
		difficultySelector = [CCSprite spriteWithFile:@"windDirectionSelector.png"];
		difficultySelector.position = ccp(120,89);
		[newProfilePopup addChild:difficultySelector];
		
		//Default difficulty selection is easy
		difficulty = bbEasy;
		
		//Default is no profiles taken
		userProfile1Taken = NO;
		userProfile2Taken = NO;
		userProfile3Taken = NO;
		userProfile4Taken = NO;
	}
	
	return self;
}

-(void)onEnter
{	
	//Creates namefield for creating new profiles
	nameField = [[UITextField alloc]initWithFrame:CGRectMake(112, 218, 150, 25)];
	[nameField setDelegate:self];
	[nameField setKeyboardType:UIKeyboardTypeDefault];
	nameField.placeholder = @"Profile Name";
	nameField.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
	nameField.textColor = [UIColor whiteColor];
	nameField.font = [UIFont fontWithName:[[WBManager sharedManager]getFont] size:[[WBManager sharedManager]getFontSizeForSize:18]];
	nameField.hidden = YES;
	[[[CCDirector sharedDirector]openGLView]addSubview:nameField];
	
	//Loads any profiles on file
	[self loadProfiles];
	
	[loading stopAnimating];
	[loading removeFromSuperview];
	[loading release];
	[super onEnter];
}

-(void)loadProfiles
{
	//Gets the documents directory for iPhone/iPod Touch
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	//Gets the fulls path with appending the file to be created. 
	NSString *profiles = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"Profiles"]];
	NSFileManager *fm = [[NSFileManager alloc]init];
	
	NSString *profileFileName1 = [profiles stringByAppendingPathComponent:@"profile1.arch"];
	
	//If first profile exists load it and display proper imformation
	if([fm fileExistsAtPath:profileFileName1])
	{
		userProfile1Taken = YES;
		
		UserProfile *profile1 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName1];
		[user1 setString: profile1.name];
		NSString *difficultyString = nil;
		
		if(profile1.difficulty == bbEasy)difficultyString = @"Easy";
		else if(profile1.difficulty == bbMedium)difficultyString = @"Med.";
		else if(profile1.difficulty == bbHard)difficultyString = @"Hard";
		
		[user1Data setString:[NSString stringWithFormat:@"%@  %i%%-Done", difficultyString, (int)[profile1 getPercentDone]]];
	}
	
	NSString *profileFileName2 = [profiles stringByAppendingPathComponent:@"profile2.arch"];
	
	//If second profile exists load it and display proper imformation
	if([fm fileExistsAtPath:profileFileName2])
	{
		userProfile2Taken = YES;
		
		UserProfile *profile2 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName2];
		[user2 setString: profile2.name];
		NSString *difficultyString = nil;
		
		if(profile2.difficulty == bbEasy)difficultyString = @"Easy";
		else if(profile2.difficulty == bbMedium)difficultyString = @"Med.";
		else if(profile2.difficulty == bbHard)difficultyString = @"Hard";
		
		[user2Data setString:[NSString stringWithFormat:@"%@ %i%%-Done", difficultyString, (int)[profile2 getPercentDone]]];
	}
	
	NSString *profileFileName3 = [profiles stringByAppendingPathComponent:@"profile3.arch"];
	
	//If third profile exists load it and display proper imformation
	if([fm fileExistsAtPath:profileFileName3])
	{
		userProfile3Taken = YES;
		
		UserProfile *profile3 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName3];
		[user3 setString: profile3.name];
		NSString *difficultyString = nil;
		
		if(profile3.difficulty == bbEasy)difficultyString = @"Easy";
		else if(profile3.difficulty == bbMedium)difficultyString = @"Med.";
		else if(profile3.difficulty == bbHard)difficultyString = @"Hard";
		
		[user3Data setString:[NSString stringWithFormat:@"%@  %i%%-Done", difficultyString, (int)[profile3 getPercentDone]]];
	}
	
	NSString *profileFileName4 = [profiles stringByAppendingPathComponent:@"profile4.arch"];
	
	//If fourth profile exists load it and display proper imformation
	if([fm fileExistsAtPath:profileFileName4])
	{
		userProfile4Taken = YES;
		
		UserProfile *profile4 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName4];
		[user4 setString: profile4.name];
		NSString *difficultyString = nil;
		
		if(profile4.difficulty == bbEasy)difficultyString = @"Easy";
		else if(profile4.difficulty == bbMedium)difficultyString = @"Med.";
		else if(profile4.difficulty == bbHard)difficultyString = @"Hard";
		
		[user4Data setString:[NSString stringWithFormat:@"%@  %i%%-Done", difficultyString, (int)[profile4 getPercentDone]]];
	}
	
	[fm release];
}

#pragma mark -
#pragma mark touch methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];

	//Hide any visible key pads
	[nameField resignFirstResponder];
	
	//If not popups visible
	if(newProfileOptionVisible == NO && profileOptionsVisible == NO)
	{
		
	//main menu
	if(point.x > 11 && point.x < 36 && point.y > 189 && point.y < 284) 
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
		[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
	}
		
	//1
	if(point.x > 152 && point.x < 217 && point.y  > 265 && point.y < 421)
	{		
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		boxSelected = 2;
		if(!userProfile2Taken)[self showNewProfile];
		else [self showProfileOptions];
		
		return;
	}
	
	//2
	if(point.x > 152 && point.x < 217 && point.y > 51 && point.y < 212)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		boxSelected = 1;
		if(!userProfile1Taken)[self showNewProfile];
		else [self showProfileOptions];
		
		return;
	}
	
	//3
	if(point.x > 59 && point.x < 126 && point.y > 265 && point.y < 421)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		boxSelected = 4;
		if(!userProfile4Taken)[self showNewProfile];
		else [self showProfileOptions];
		
		return;
	}
	
	//4
	if(point.x > 59 && point.x < 126 && point.y > 51 && point.y < 212)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		boxSelected = 3;
		if(!userProfile3Taken)[self showNewProfile];
		else [self showProfileOptions];
		
		return;
	}
		
	}
	
	//If new profile popup visible
	if(newProfileOptionVisible)
	{
		//Hide popup
		if(point.x > 61 && point.x < 103 && point.y > 380 && point.y < 422)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			[self hideNewProfile];
			return;
		}
		
		//Save profile
		if(point.x > 62 && point.x < 90 && point.y > 58 && point.y < 115)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			[self saveNewProfile];
			return;
		}
		
		//Easy
		if(point.x > 96 && point.x < 124 && point.y > 107 && point.y < 166)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			difficulty = bbEasy;
			difficultySelector.position = ccp(120,89);
			return;
		}
		
		//Med.
		if(point.x > 96 && point.x < 124 && point.y > 207 && point.y < 270)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			difficulty = bbMedium;
			difficultySelector.position = ccp(220,92);
			return;
		}
		
		//Hard
		if(point.x > 96 && point.x < 124 && point.y > 308 && point.y < 370)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			difficulty = bbHard;
			difficultySelector.position = ccp(320,92);
			return;
		}
	}
	
	//Profile Option Buttons
	if(profileOptionsVisible)
	{
		//Hide popup
		if(point.x > 70 && point.x < 107 && point.y > 360 && point.y < 402)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			[self hideProfileOptions];
			return;
		}
		
		//Load
		if(point.x > 127 && point.x < 160 && point.y > 114 && point.y < 208)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			//Gets the documents directory for iPhone/iPod Touch
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory=[paths objectAtIndex:0];
			//Gets the fulls path with appending the file to be created. 
			NSString *profiles = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"Profiles"]];
			NSFileManager *fm = [[NSFileManager alloc]init];
			
			NSString *profileFileName1 = [profiles stringByAppendingPathComponent:@"profile1.arch"];
			
			//If first profile exists load it and display proper imformation
			if(boxSelected == 1)
			{
				UserProfile *profile1 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName1];
				[[WBManager sharedManager] setCurrentUser:profile1];
				
				if(profile1.shouldShowTutorial)
				{
					[[WBManager sharedManager] setLoadWithGameLevel:YES];
					[[CCDirector sharedDirector] replaceScene:[TutorialScene node]];
				}
				
				else 
				{
					[[WBManager sharedManager] setLoadWithGameLevel:YES];
					[[CCDirector sharedDirector] replaceScene:[LevelMenu1Scene node]];
				}

			}
			
			NSString *profileFileName2 = [profiles stringByAppendingPathComponent:@"profile2.arch"];
			
			//If second profile exists load it and display proper imformation
			if(boxSelected == 2)
			{
				UserProfile *profile2 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName2];
				[[WBManager sharedManager] setCurrentUser:profile2];
				
				if(profile2.shouldShowTutorial)
				{
					[[WBManager sharedManager] setLoadWithGameLevel:YES];
					[[CCDirector sharedDirector] replaceScene:[TutorialScene node]];
				}
				
				else 
				{
					[[WBManager sharedManager] setLoadWithGameLevel:YES];
					[[CCDirector sharedDirector] replaceScene:[LevelMenu1Scene node]];
				}
			}
			
			NSString *profileFileName3 = [profiles stringByAppendingPathComponent:@"profile3.arch"];
			
			//If third profile exists load it and display proper imformation
			if(boxSelected == 3)
			{
				UserProfile *profile3 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName3];
				[[WBManager sharedManager] setCurrentUser:profile3];
				
				if(profile3.shouldShowTutorial)
				{
					[[WBManager sharedManager] setLoadWithGameLevel:YES];
					[[CCDirector sharedDirector] replaceScene:[TutorialScene node]];
				}
				
				else 
				{
					[[WBManager sharedManager] setLoadWithGameLevel:YES];
					[[CCDirector sharedDirector] replaceScene:[LevelMenu1Scene node]];
				}
			}
			
			NSString *profileFileName4 = [profiles stringByAppendingPathComponent:@"profile4.arch"];
			
			//If fourth profile exists load it and display proper imformation
			if(boxSelected == 4)
			{
				UserProfile *profile4 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName4];
				[[WBManager sharedManager] setCurrentUser:profile4];
				
				if(profile4.shouldShowTutorial)
				{
					[[WBManager sharedManager] setLoadWithGameLevel:YES];
					[[CCDirector sharedDirector] replaceScene:[TutorialScene node]];
				}
				
				else 
				{
					[[WBManager sharedManager] setLoadWithGameLevel:YES];
					[[CCDirector sharedDirector] replaceScene:[LevelMenu1Scene node]];
				}
			}
			
			[fm release];
			return;
		}
		
		//Delete
		if(point.x > 127 && point.x < 160 && point.y > 257 && point.y < 366)
		{
			[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Attention" message:@"Are you sure you want to delete this profile permanently?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil];
			[alert addButtonWithTitle:@"NO"];
			[alert show];
			[alert release];
			return;
		}
	}
}

#pragma mark -
#pragma mark Alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//if index is 0 (YES)
	if(buttonIndex == 0)
	{
		NSFileManager *fm = [[NSFileManager alloc]init];
		
		//Gets the documents directory for iPhone/iPod Touch
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory=[paths objectAtIndex:0];
		//Gets the fulls path with appending the file to be created. 
		NSString *profiles = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"Profiles"]];
		NSString *profileFileName = nil;
		
		//Get the file path for selected profile box
		if(boxSelected == 1)profileFileName=[profiles stringByAppendingPathComponent: @"profile1.arch"];
		else if(boxSelected == 2)profileFileName=[profiles stringByAppendingPathComponent: @"profile2.arch"];
		else if(boxSelected == 3)profileFileName=[profiles stringByAppendingPathComponent: @"profile3.arch"];
		else if(boxSelected == 4)profileFileName=[profiles stringByAppendingPathComponent: @"profile4.arch"];
		
		//Remove that file
		[fm removeItemAtPath:profileFileName error:nil];
		
		[fm release];
		
		//Update the labels to default values when the box selected is deleted
		if(boxSelected == 1)
		{
			userProfile1Taken = NO;
			[user1 setString:@"New Profile"];
			[user1Data setString:@""];
		}
		
		else if(boxSelected == 2)
		{
			userProfile2Taken = NO;
			[user2 setString:@"New Profile"];
			[user2Data setString:@""];
		}
		
		else if(boxSelected == 3)
		{
			userProfile3Taken = NO;
			[user3 setString:@"New Profile"];
			[user3Data setString:@""];
		}
		
		else if(boxSelected == 4)
		{
			userProfile4Taken = NO;
			[user4 setString:@"New Profile"];
			[user4Data setString:@""];
		}
		
		//Hide profile option popup once done
		[self hideProfileOptions];
	}	
}

#pragma mark -
#pragma mark Profile menu methods

-(void)showNewProfile
{
	//Displays a new profile popup with animation
	difficultySelector.position = ccp(120,89);
	
	newProfileOptionVisible = YES;
	
	id move = [CCMoveTo actionWithDuration:1.0f position:ccp(243,155)];
	id action = [CCEaseBounceOut actionWithAction:move];
	id action1 = [CCCallFunc actionWithTarget:self selector:@selector(hasEntered)];
	[newProfilePopup runAction: [CCSequence actions: action,action1,nil]];	
}

-(void)hideNewProfile
{	
	nameField.hidden = YES;

	//Hides new profile popup with animation
	// acceleration at the end
	id action = [CCMoveTo actionWithDuration:.5f position:ccp(243,-200)];
	id ease = [CCEaseIn actionWithAction:action rate:2];
	id action2 = [CCMoveTo actionWithDuration:0.001f position:ccp(243,460)];
	id action3 = [CCCallFunc actionWithTarget:self selector:@selector(hasExited)];
	 
	[newProfilePopup runAction:[CCSequence actions:ease,action2,action3,nil]];
}

-(void)saveNewProfile
{
	//Creates a user profile
	UserProfile *newProfile = [[UserProfile alloc]init];
	
	//Set it's name and difficulty
	newProfile.name = nameField.text;
	newProfile.difficulty = difficulty;
	
	NSString *difficultyString = nil;
	
	//Gets the string value for difficulty selection
	if(newProfile.difficulty == bbEasy)difficultyString = @"Easy";
	else if(newProfile.difficulty == bbMedium)difficultyString = @"Med.";
	else if(newProfile.difficulty == bbHard)difficultyString = @"Hard";
	
	//Based on box selected update it's imformation for the new user's data and imformation
	if(boxSelected == 1)
	{
		newProfile.profileNumber = 1;
		userProfile1Taken = YES;
		[user1 setString:nameField.text];
		[user1Data setString:[NSString stringWithFormat:@"%@  %i%%-Done", difficultyString, [newProfile getPercentDone]]];
	}
	
	else if(boxSelected == 2)
	{
		newProfile.profileNumber = 2;
		userProfile2Taken = YES;
		[user2 setString:nameField.text];
		[user2Data setString:[NSString stringWithFormat:@"%@  %i%%-Done", difficultyString, [newProfile getPercentDone]]];
	}
	
	else if(boxSelected == 3)
	{
		newProfile.profileNumber = 3;
		userProfile3Taken = YES;
		[user3 setString:nameField.text];
		[user3Data setString:[NSString stringWithFormat:@"%@  %i%%-Done", difficultyString, [newProfile getPercentDone]]];
	}
	
	else if(boxSelected == 4)
	{
		newProfile.profileNumber = 4;
		userProfile4Taken = YES;
		[user4 setString:nameField.text];
		[user4Data setString:[NSString stringWithFormat:@"%@  %i%%-Done", difficultyString, [newProfile getPercentDone]]];
	}
	
	//Gets the documents directory for iPhone/iPod Touch
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	//Gets the fulls path with appending the file to be created. 
	NSString *profiles = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"Profiles"]];
	NSString *profileFileName = nil;
	
	//Creates the file path for the profile to be saved
	if(boxSelected == 1)profileFileName=[profiles stringByAppendingPathComponent: @"profile1.arch"];
	else if(boxSelected == 2)profileFileName=[profiles stringByAppendingPathComponent: @"profile2.arch"];
	else if(boxSelected == 3)profileFileName=[profiles stringByAppendingPathComponent: @"profile3.arch"];
	else if(boxSelected == 4)profileFileName=[profiles stringByAppendingPathComponent: @"profile4.arch"];
	
	//Archives File
	[NSKeyedArchiver archiveRootObject: newProfile toFile: profileFileName];
	
	//Release profile
	[newProfile release];
	
	//Hides the popup
	[self hideNewProfile];
}

-(void)showProfileOptions
{
	//Shows profile options popup with animation
	profileOptionsVisible = YES;
	id move = [CCMoveTo actionWithDuration:1.0f position:ccp(237,153)];
	id action = [CCEaseBounceOut actionWithAction:move];
	[profileOptions runAction: [CCSequence actions: action,nil]];	
}

-(void)hideProfileOptions
{
	//Hides profile options popup with animation
	profileOptionsVisible = NO;
	id action = [CCMoveTo actionWithDuration:.5f position:ccp(237,-200)];
	id ease = [CCEaseIn actionWithAction:action rate:2];
	id action2 = [CCMoveTo actionWithDuration:0.001f position:ccp(237,460)];
	[profileOptions runAction:[CCSequence actions:ease,action2,nil]];
}

#pragma mark -
#pragma mark Enter/Exit methods
-(void)hasEntered
{
	//When popup has been entered reset the default value for UITextfield
	//Show the textfield
	[nameField setText:@""];
	nameField.hidden = NO;
}

-(void)hasExited
{
	//When exiting the popup is no longer visible
	newProfileOptionVisible = NO;
}

//Called when return is pressed on a keypad
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark WBKeypadDelegate Methods
-(void)dealloc
{	
	[nameField resignFirstResponder];
	[nameField removeFromSuperview];
	[nameField release];
	[super dealloc];
}

@end
