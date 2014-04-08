//
//  WBManager.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/16/10.
//  Copyright 2010 Home. All rights reserved.
//
#import "UserProfile.h"

@interface WBManager : NSObject 
{
	//Level to load
	NSString *levelToLoad;
	
	//Determines if level should load in editor mode.
	BOOL loadWithEditor;
	BOOL loadWithGameLevel;
	
	//The user profile currently being used
	UserProfile *currentUser;
}
@property (readwrite) BOOL loadWithEditor,loadWithGameLevel;
@property (nonatomic,retain) UserProfile *currentUser;

//Sets the level to load
-(void)setLevelFile:(NSString*)level;
//Gets current level
-(NSString *)getLevelFile;

//Returns font face based on OS version (Custom font is for OS 4.0+)
-(NSString *)getFont;

//Returns a converted font size based on the OS version.
-(int)getFontSizeForSize:(int)size;

//Creates the shared instance of this object
+(WBManager*)sharedManager;
	
@end
	
