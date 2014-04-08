//
//  saveMenu.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/10/10.
//  Copyright 2010 Home. All rights reserved.
//
#import "cocos2d.h"
#import "Level.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SimpleAudioEngine.h"

@protocol WBSaveMenuDelegate <NSObject>
@required
-(void)setIsTouchEnabled:(BOOL)state;
-(BOOL)isTouchEnabled;
-(void)saveLevel;
-(void)setScreenshot:(UIImage*)shot;
@end

@interface SaveMenu : CCLayer <UITextFieldDelegate>
{
	//Menu bg
	CCSprite *menu;
	
	//Screenshot created of the level being saved
	CCSprite *screenshot;
	
	//Displays the speed of the wind based on slider value
	CCLabel *sliderValueLabel;
	
	//the delegate, used for disabling and eneabling touches on it
	id <WBSaveMenuDelegate> delegate;
	 
	//Text/Number fields for level information
	UITextField *name;
	UITextField *timeLimit;
	UITextField *craneFuel;
	
	//Slider to set windspeed
	UISlider *windSpeed;
	
	//Wind Selector
	CCSprite *windSelector;
	
	//Wind direction
	bbWindDirection windDirection;
}
//Property for delegates
@property (nonatomic, assign) id <WBSaveMenuDelegate> delegate;

//Sets the level with the desired imformation when loading a previously created custom level 
-(void)setLevelName:(NSString *)theName timeLimit:(int)theTimeLimit craneFuel:(int)theCraneFuel hitLimit:(int)theHitLimit windSpeed:(int)theWindSpeed windDirection:(bbWindDirection)theWindDirection;

//Show or Hide the menu
-(void)show;
-(void)hide;

//Called to resign first responder (hide keypad)
-(void)hideKeypad;
//Called when the value of the slider has changed.
-(void)sliderChanged;

//Gets values from the UI elemets
-(NSString *)getName;
-(NSString *)getTimeLimit;
-(NSString *)getCraneFuel;

//Get windspeed and direction
-(int)getWindSpeed;
-(bbWindDirection)getWindDirection;

@end
