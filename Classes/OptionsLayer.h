//
//  OptionsLayer.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/29/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "cocos2d.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SimpleAudioEngine.h"

@interface OptionsLayer : CCLayer <MPMediaPickerControllerDelegate>
{
	MPMediaPickerController *controller;
	MPMusicPlayerController *myPlayer;
		
	UISlider *soundVolume;
	UISlider *musicVolume;
	
	CCLabel *worksitesAttempted;
	CCLabel *timeSpentPlaying;
	
	CCLabel *hdCapacity;
	
	NSMutableDictionary *settingsDictionary;
}
-(int)getCapacityUsed;

-(void)animationDidStop;

-(void)resetAll;
-(void)volumeChange;
-(void)volumeMusicChange;

-(void)createPlaylist;

-(void)saveSettings;

@end
