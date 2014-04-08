//
//  Wrecking_BallAppDelegate.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 3/17/10.
//  Copyright Home 2010. All rights reserved.
//

#import "Wrecking_BallAppDelegate.h"
#import "cocos2d.h"
#import "MenuScene.h"
#import "OpenFeint.h"
#import "OpenFeintSettings.h"
#import "Intro_Scene.h"
#import "SimpleAudioEngine.h"
#import <AVFoundation/AVFoundation.h>
#import "UserProfile.h"
#import "GameCard.h"

@implementation Wrecking_BallAppDelegate
@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{	
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
		
	if(![CCDirector setDirectorType:CCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:CCDirectorTypeDefault];

	[[CCDirector sharedDirector] setPixelFormat:kPixelFormatRGBA8888];
	
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// before creating any layer, set the landscape mode
	[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	//[[CCDirector sharedDirector] setDisplayFPS:YES];
	
	[[CCDirector sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		
	
	NSDictionary* settings = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight], OpenFeintSettingDashboardOrientation,nil];	
	[OpenFeint initializeWithProductKey:@"PK4ymIiQABs3kb9suuGvLg" andSecret:@"b6JpH9frf8WO1WOubPp5dR8eqboGU5MQVfggvCzslw" andDisplayName:@"Wrecking Ball" andSettings:settings andDelegates:nil];
	
	//Gets the documents directory for iPhone/iPod Touch
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	//Gets the fulls path with appending the file to be created. 
	NSString *customLevels = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
	NSString *profiles = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"Profiles"]];
	//Filemanager
	NSFileManager *fm = [[NSFileManager alloc]init];
	
	//Creates a folder for all the custom files. 
	if(![fm fileExistsAtPath:customLevels isDirectory:nil])
		[fm createDirectoryAtPath:customLevels withIntermediateDirectories:YES attributes:nil error:nil];
	
	//Creates a folder for all the profiles
	if(![fm fileExistsAtPath:profiles isDirectory:nil])
		[fm createDirectoryAtPath:profiles withIntermediateDirectories:YES attributes:nil error:nil];
	
	NSString *settingsPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"GameSettings"]];
	
	//Create Settings File
	if(![fm fileExistsAtPath:settingsPath])
	{
		NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc]init];
		
		float sfxVolume = .5f;
		float musicVolume = .5f;
		int worksitesAttempted = 0;
		int totalTime = 0;
		
		[settingsDictionary setObject:[NSNumber numberWithFloat:sfxVolume] forKey:@"SfxVolume"];
		[settingsDictionary setObject:[NSNumber numberWithFloat:musicVolume] forKey:@"MusicVolume"];
		[settingsDictionary setObject:[NSNumber numberWithInt:worksitesAttempted] forKey:@"WorksitesAttempted"];
		[settingsDictionary setObject:[NSNumber numberWithInt:totalTime] forKey:@"TotalTime"];
		
		[settingsDictionary writeToFile:settingsPath atomically:YES];
		
		[settingsDictionary release];
	}
	
	[fm release];
	
	//Gets the documents directory for iPhone/iPod Touch		
	NSMutableDictionary *settingsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
	
	[[SimpleAudioEngine sharedEngine]setEffectsVolume:[[settingsDictionary objectForKey:@"SfxVolume"]floatValue]];
	[[SimpleAudioEngine sharedEngine]setBackgroundMusicVolume:[[settingsDictionary objectForKey:@"SfxVolume"]floatValue]];
	
	[settingsDictionary release];
	[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	
	[self updateUserProfiles];
	
	MenuScene *scene = [Intro_Scene node];
	[[CCDirector sharedDirector] runWithScene: scene];
}

-(void)updateUserProfiles
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
		UserProfile *profile1 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName1];
		
		if ([profile1 respondsToSelector:@selector(versionNumber)])return;
		
		for(int i = 0; i<30; i++)
		{
			GameCard *old = [profile1 getGameCardForLevel:i];
			[profile1 addGameCardWithScore:old.score time:old.time height:old.height forLevel:i+1 didCheat:NO];
		}
		
		[NSKeyedArchiver archiveRootObject:profile1 toFile:profileFileName1];
	}
	
	NSString *profileFileName2 = [profiles stringByAppendingPathComponent:@"profile2.arch"];
	
	//If second profile exists load it and display proper imformation
	if([fm fileExistsAtPath:profileFileName2])
	{		
		UserProfile *profile2 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName2];
		
		if ([profile2 respondsToSelector:@selector(versionNumber)])return;
		
		for(int i = 0; i<30; i++)
		{
			GameCard *old = [profile2 getGameCardForLevel:i];
			[profile2 addGameCardWithScore:old.score time:old.time height:old.height forLevel:i+1 didCheat:NO];
		}
		
		[NSKeyedArchiver archiveRootObject:profile2 toFile:profileFileName2];
	}
	
	NSString *profileFileName3 = [profiles stringByAppendingPathComponent:@"profile3.arch"];
	
	//If third profile exists load it and display proper imformation
	if([fm fileExistsAtPath:profileFileName3])
	{		
		UserProfile *profile3 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName3];
		
		if ([profile3 respondsToSelector:@selector(versionNumber)])return;
		
		for(int i = 0; i<30; i++)
		{
			GameCard *old = [profile3 getGameCardForLevel:i];
			[profile3 addGameCardWithScore:old.score time:old.time height:old.height forLevel:i+1 didCheat:NO];
		}
		
		[NSKeyedArchiver archiveRootObject:profile3 toFile:profileFileName3];
	}
	
	NSString *profileFileName4 = [profiles stringByAppendingPathComponent:@"profile4.arch"];
	
	//If fourth profile exists load it and display proper imformation
	if([fm fileExistsAtPath:profileFileName4])
	{		
		UserProfile *profile4 = [NSKeyedUnarchiver unarchiveObjectWithFile:profileFileName4];
		
		if ([profile4 respondsToSelector:@selector(versionNumber)])return;
		
		for(int i = 0; i<30; i++)
		{
			GameCard *old = [profile4 getGameCardForLevel:i];
			[profile4 addGameCardWithScore:old.score time:old.time height:old.height forLevel:i+1 didCheat:NO];
		}
		
		[NSKeyedArchiver archiveRootObject:profile4 toFile:profileFileName4];
	}
	
	[fm release];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
	[OpenFeint applicationWillResignActive];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
	[OpenFeint applicationDidBecomeActive];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	//[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	[[CCDirector sharedDirector] startAnimation];
	[OpenFeint applicationDidBecomeActive];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	[[CCDirector sharedDirector] stopAnimation];
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[OpenFeint applicationWillResignActive];
}


//- (void)applicationDidBecomeActive:(UIApplication *)application {
//	[[CCDirector sharedDirector] resume];
//	[OpenFeint applicationDidBecomeActive];
//}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end

