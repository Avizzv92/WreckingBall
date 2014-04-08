//
//  UserProfileMenu.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TouchEffect.h"
#import "UserProfile.h"
#import "SimpleAudioEngine.h"

@interface UserProfileMenu : CCLayer <UITextFieldDelegate>
{	
	UIActivityIndicatorView *loading;
	
	//If new profile option visible
	BOOL newProfileOptionVisible;
	
	//If prfofile options visible
	BOOL profileOptionsVisible;
	
	//New profile menu
	CCSprite *newProfilePopup;
	//Difficulty selector
	CCSprite *difficultySelector;
	//Profile options menu
	CCSprite *profileOptions;
	
	//User names
	CCLabel *user1;
	CCLabel *user2;
	CCLabel *user3;
	CCLabel *user4;
	
	//Users' data
	CCLabel *user1Data;
	CCLabel *user2Data;
	CCLabel *user3Data;
	CCLabel *user4Data;
	
	//Which user box selected
	int boxSelected;
	
	//Namefield, creating new profile
	UITextField *nameField;
	//Difficullty, creating new profile
	bbDifficulty difficulty; 
	
	//If a userprofile box has been taken
	BOOL userProfile1Taken;
	BOOL userProfile2Taken;
	BOOL userProfile3Taken;
	BOOL userProfile4Taken;
}

//Loads all profiles on file
-(void)loadProfiles;

//Show/Hide profile options
-(void)showProfileOptions;
-(void)hideProfileOptions;

//Show/Hide/Save new profile
-(void)showNewProfile;
-(void)hideNewProfile;
-(void)saveNewProfile;

//Has exited/entered for profile menus
-(void)hasExited;
-(void)hasEntered;

@end
