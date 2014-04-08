//
//  OptionsLayer.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "OptionsLayer.h"
#import "MenuScene.h"
#import "TouchEffect.h"
#import "CreditsScene.h"
#import "SimpleAudioEngine.h"


@implementation OptionsLayer

#pragma mark -
#pragma mark init method

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{		
		//Gets the documents directory for iPhone/iPod Touch
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory=[paths objectAtIndex:0];		
		NSString *settingsPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"GameSettings"]];
		
		settingsDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
		
		self.isTouchEnabled = YES;
		[self addChild:[TouchEffect node]];
		
		controller = nil;
		
		soundVolume = [[UISlider alloc]initWithFrame:CGRectMake(123,310,240,25)];
		soundVolume.minimumValue = 0.0f;
		soundVolume.maximumValue = 1.0f;
		soundVolume.value = [[settingsDictionary objectForKey:@"SfxVolume"]floatValue];
		soundVolume.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
		[soundVolume addTarget:self action:@selector(volumeChange) forControlEvents:UIControlEventValueChanged];	
		
		musicVolume = [[UISlider alloc]initWithFrame:CGRectMake(93,310,240,25)];
		musicVolume.minimumValue = 0.0f;
		musicVolume.maximumValue = 1.0f;
		musicVolume.value = [[settingsDictionary objectForKey:@"MusicVolume"]floatValue];
		musicVolume.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
		[musicVolume addTarget:self action:@selector(volumeMusicChange) forControlEvents:UIControlEventValueChanged];	
		
		worksitesAttempted = [CCLabel labelWithString:@"" dimensions:CGSizeMake(75, 17) alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:16];
		[worksitesAttempted setString:[NSString stringWithFormat:@"%i",[[settingsDictionary objectForKey:@"WorksitesAttempted"]intValue]]];
		worksitesAttempted.position = ccp(363,117);
		[self addChild:worksitesAttempted];
		
		timeSpentPlaying = [CCLabel labelWithString:@"" dimensions:CGSizeMake(125, 17) alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:16];
		
		int seconds = [[settingsDictionary objectForKey:@"TotalTime"]intValue];
		int mins = seconds / 60;
		int hours = mins / 60;
		mins = mins % 60;
		
		[timeSpentPlaying setString: [NSString stringWithFormat:@"%i hrs %i mins",hours,mins]];
		timeSpentPlaying.position = ccp(297,95);
		[self addChild:timeSpentPlaying];
		
		hdCapacity = [CCLabel labelWithString:@"" dimensions:CGSizeMake(75, 17) alignment:UITextAlignmentLeft fontName:@"Chalkduster" fontSize:16];
		
		int kbValue = [self getCapacityUsed];
		
		if(kbValue >= 1024)
		{
			double newValue = (double)kbValue / 1024.0;
			[hdCapacity setString: [NSString stringWithFormat:@"%.2gmb",newValue]];
		}
		
		else [hdCapacity setString: [NSString stringWithFormat:@"%ikb",kbValue]];
		
		hdCapacity.position = ccp(298,60);
		[self addChild:hdCapacity];
		
		[[[CCDirector sharedDirector]openGLView]addSubview:soundVolume];
		[[[CCDirector sharedDirector]openGLView]addSubview:musicVolume];
	}
	
	return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//If they hit YES
	if(buttonIndex == 0)
	{
		NSFileManager *fm = [[NSFileManager alloc]init];
		
		//Gets the documents directory for iPhone/iPod Touch
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory=[paths objectAtIndex:0];
		//Gets the fulls path with appending the file to be created. 
		NSString *profiles = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"Profiles"]];
		
		//Get the file path for selected profile box
		NSString *profileFileName=[profiles stringByAppendingPathComponent: @"profile1.arch"];
		NSString *profileFileName1=[profiles stringByAppendingPathComponent: @"profile2.arch"];
		NSString *profileFileName2=[profiles stringByAppendingPathComponent: @"profile3.arch"];
		NSString *profileFileName3=[profiles stringByAppendingPathComponent: @"profile4.arch"];
		
		//Remove that file
		[fm removeItemAtPath:profileFileName error:nil];
		[fm removeItemAtPath:profileFileName1 error:nil];
		[fm removeItemAtPath:profileFileName2 error:nil];
		[fm removeItemAtPath:profileFileName3 error:nil];
		
		NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
		
		//All the custom levels in the folder
		NSArray *customLevelFiles = [fm contentsOfDirectoryAtPath:customLevelsDirectory error:nil];
		
		for(NSString *path in customLevelFiles)
		{
			NSString *filePath = [customLevelsDirectory stringByAppendingPathComponent: path];
			[fm removeItemAtPath:filePath error:nil];
		}
				
		int kbValue = [self getCapacityUsed];
		
		if(kbValue >= 1024)
		{
			double newValue = (double)kbValue / 1024.0;
			[hdCapacity setString: [NSString stringWithFormat:@"%.2gmb",newValue]];
		}
		
		else [hdCapacity setString: [NSString stringWithFormat:@"%ikb",kbValue]];
		
	
		NSString *settingsPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"GameSettings"]];

		[settingsDictionary setObject:[NSNumber numberWithInt:0] forKey:@"WorksitesAttempted"];
		[settingsDictionary setObject:[NSNumber numberWithInt:0] forKey:@"TotalTime"];
		
		[fm removeItemAtPath:settingsPath error:nil];
		
		[settingsDictionary writeToFile:settingsPath atomically:YES];
		
		[fm release];
	
		[worksitesAttempted setString: [NSString stringWithFormat:@"%i",[[settingsDictionary objectForKey:@"WorksitesAttempted"]intValue]]];
		[timeSpentPlaying setString:[NSString stringWithFormat:@"%i hrs %i mins",0,0]];
	}	
}

-(void)resetAll
{
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Attention" message:@"All profiles, custom worksites, and settings will be deleted. Do you wish to continue?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil];
	[alert addButtonWithTitle:@"NO"];
	[alert show];
	[alert release];
	return;
}

-(void)volumeChange
{
	[[SimpleAudioEngine sharedEngine]setEffectsVolume:soundVolume.value];
	[[SimpleAudioEngine sharedEngine]setBackgroundMusicVolume:soundVolume.value];
}

-(void)volumeMusicChange
{
	myPlayer.volume = musicVolume.value;
}

#pragma mark -
#pragma mark Media Methods

-(void)createPlaylist
{
	if(controller == nil)
	{
		
		//Begin
		controller = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
		controller.delegate = self;
		controller.prompt = @"Select the music you wish to hear!";
		[controller setAllowsPickingMultipleItems: YES];  
		[controller.view setBackgroundColor:[UIColor blackColor]];
		controller.view.frame = CGRectMake(0, 525, 320, 480);
		[[[CCDirector sharedDirector]openGLView]addSubview:controller.view];
		
		//Animation of the Media Picker
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		controller.view.frame = CGRectMake(0, 0, 320, 480);
		[UIView commitAnimations];	
		//End
		
	}
}

- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
	myPlayer = [MPMusicPlayerController applicationMusicPlayer];
	[myPlayer setQueueWithItemCollection: mediaItemCollection];
	myPlayer.volume = musicVolume.value;
	[myPlayer play];

	[UIView beginAnimations:@"MediaAnimate" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	controller.view.frame = CGRectMake(0, 525, 320, 480);
	[UIView commitAnimations];	
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
	[UIView beginAnimations:@"MediaAnimate" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop)];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	controller.view.frame = CGRectMake(0, 525, 320, 480);
	[UIView commitAnimations];	
	
}

- (void)animationDidStop
{
	[controller.view removeFromSuperview];
	[controller release];	
	controller = nil;
}

#pragma mark -
#pragma mark touch method

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	//Menu
	if(point.x > 14 && point.x < 38 && point.y > 390 && point.y < 463) 
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[self saveSettings];
		[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
		return;
	}
	
	//Credits
	if(point.x > 14 && point.x < 38 && point.y > 17 && point.y < 117) 
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[self saveSettings];
		[[CCDirector sharedDirector] replaceScene: [CreditsScene node]];
		return;
	}
	
	//New playlist
	if(point.x > 162 && point.x < 192 && point.y > 163 && point.y < 315) 
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[self createPlaylist];
		return;
	}
	
	//Restore
	if(point.x > 52 && point.x < 70 && point.y > 350 && point.y < 440) 
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[self resetAll];
		return;
	}
}

-(int)getCapacityUsed
{
	int total = 0;
	
	NSFileManager *fm = [[NSFileManager alloc]init];
	
	//Gets the documents directory for iPhone/iPod Touch
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	//Gets the fulls path with appending the file to be created. 
	NSString *profiles = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"Profiles"]];
	
	//Get the file path for selected profile box
	NSString *profileFileName=[profiles stringByAppendingPathComponent: @"profile1.arch"];
	NSString *profileFileName1=[profiles stringByAppendingPathComponent: @"profile2.arch"];
	NSString *profileFileName2=[profiles stringByAppendingPathComponent: @"profile3.arch"];
	NSString *profileFileName3=[profiles stringByAppendingPathComponent: @"profile4.arch"];
	
	//Remove that file
	NSDictionary *dict1 = [fm attributesOfItemAtPath:profileFileName error:nil];
	NSDictionary *dict2 =[fm attributesOfItemAtPath:profileFileName1 error:nil];
	NSDictionary *dict3 =[fm attributesOfItemAtPath:profileFileName2 error:nil];
	NSDictionary *dict4 =[fm attributesOfItemAtPath:profileFileName3 error:nil];
	
	int num1 = [[dict1 objectForKey:@"NSFileSize"]intValue];
	int num2 = [[dict2 objectForKey:@"NSFileSize"]intValue];
	int num3 = [[dict3 objectForKey:@"NSFileSize"]intValue];
	int num4 = [[dict4 objectForKey:@"NSFileSize"]intValue];
	
	total = total + num1 + num2 + num3 + num4;
	
	NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
	
	//All the custom levels in the folder
	NSArray *customLevelFiles = [fm contentsOfDirectoryAtPath:customLevelsDirectory error:nil];
	
	for(NSString *path in customLevelFiles)
	{
		NSString *filePath = [customLevelsDirectory stringByAppendingPathComponent: path];
		NSDictionary *dict = [fm attributesOfItemAtPath:filePath error:nil];
		int num = [[dict objectForKey:@"NSFileSize"]intValue];
		
		total+=num;
	}
	
	[fm release];
	
	return total/1024;
}

-(void)saveSettings
{
	//Gets the documents directory for iPhone/iPod Touch
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];		
	NSString *settingsPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"GameSettings"]];
	NSFileManager *fm = [[NSFileManager alloc]init];
	
	[settingsDictionary setObject:[NSNumber numberWithFloat:musicVolume.value] forKey:@"MusicVolume"];
	[settingsDictionary setObject:[NSNumber numberWithFloat:soundVolume.value] forKey:@"SfxVolume"];
	
	[fm removeItemAtPath:settingsPath error:nil];
	
	[settingsDictionary writeToFile:settingsPath atomically:YES];
	
	[fm release];
}

#pragma mark -
#pragma mark CLEANUP
-(void)dealloc
{
	[settingsDictionary release];

	[soundVolume removeFromSuperview];
	[musicVolume removeFromSuperview];
	
	[soundVolume release];
	[musicVolume release];
	
	if(controller != nil)
	{
		[controller.view removeFromSuperview];
		[controller release];
	}
	
	if(myPlayer != nil)
	{
		[myPlayer release];
	}
	
	[super dealloc];
}

@end
