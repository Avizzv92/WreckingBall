//
//  saveMenu.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/10/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "SaveMenu.h"
#import "MenuScene.h"
#import "Screenshot.h"
#import "CustomLevelsScene.h"
#import "WBManager.h"


@implementation SaveMenu
@synthesize delegate;

#pragma mark -
#pragma mark init methods

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{		
		//Touch enabled and visible are no by default
		self.isTouchEnabled = NO;
		[self setVisible:NO];
		
		//Creates the menu graphic
		menu = [CCSprite spriteWithFile:@"level_save_menu.png"];
		menu.position = ccp(240,170);
		[self addChild:menu];
		
		//Creates the slider value label with a default of zero
		sliderValueLabel = [CCLabel labelWithString:@"0" fontName:@"Chalkduster" fontSize:18];
		sliderValueLabel.position = ccp(400,100);
		[self addChild:sliderValueLabel];
		[sliderValueLabel setVisible:NO];
		
		//Creates and positions the UITextfields for level informaton
		
		name = [[UITextField alloc]initWithFrame:CGRectMake(154, 170, 150, 25)];
		[name setDelegate:self];
		[name setKeyboardType:UIKeyboardTypeDefault];
		name.placeholder = @"Level Name";
		name.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
		name.textColor = [UIColor whiteColor];
		name.font = [UIFont fontWithName:[[WBManager sharedManager]getFont] size:[[WBManager sharedManager]getFontSizeForSize:20]];
		
		timeLimit = [[UITextField alloc]initWithFrame:CGRectMake(169, 195, 50, 25)];
		[timeLimit setDelegate:self];
		[timeLimit setKeyboardType:UIKeyboardTypeNumberPad];
		timeLimit.placeholder = @"Mins";
		timeLimit.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
		timeLimit.textColor = [UIColor whiteColor];
		timeLimit.font = [UIFont fontWithName:[[WBManager sharedManager]getFont] size:[[WBManager sharedManager]getFontSizeForSize:20]];
		
		craneFuel = [[UITextField alloc]initWithFrame:CGRectMake(130, 200, 50, 25)];
		[craneFuel setDelegate:self];
		[craneFuel setKeyboardType:UIKeyboardTypeNumberPad];
		craneFuel.placeholder = @"Gas";
		craneFuel.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
		craneFuel.textColor = [UIColor whiteColor];
		craneFuel.font = [UIFont fontWithName:[[WBManager sharedManager]getFont] size:[[WBManager sharedManager]getFontSizeForSize:20]];
		
		//Creates a UISlider for setting the windspeed
		CGRect frame =CGRectMake(19, 265, 164 , 15);
		windSpeed = [[UISlider alloc] initWithFrame:frame];
		[windSpeed setMaximumValue: 120.0f];
		[windSpeed setMinimumValue: 0.0f];
		windSpeed.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
		
		//The method to call when the value of the slider has changed.
		[windSpeed addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
		
		//Wind direction selector
		windSelector = [CCSprite spriteWithFile:@"windDirectionSelector.png"];
		[self addChild:windSelector];
		windSelector.position = ccp(288,72);
		
		windDirection = bbWest;
	}
	
	return self;
}

-(void)setLevelName:(NSString *)theName timeLimit:(int)theTimeLimit craneFuel:(int)theCraneFuel hitLimit:(int)theHitLimit windSpeed:(int)theWindSpeed windDirection:(bbWindDirection)theWindDirection
{
	//Sets level imformation (when loading a custom level to edit)
	name.text = theName;
	windDirection = theWindDirection;
	
	if(windDirection == bbWest)windSelector.position = ccp(288,72);
	else if(windDirection == bbEast)windSelector.position = ccp(373,72);
	
	timeLimit.text = [NSString stringWithFormat:@"%i",theTimeLimit];
	craneFuel.text = [NSString stringWithFormat:@"%i",theCraneFuel];
	windSpeed.value = (float)(theWindSpeed);
	NSString *newText = [[NSString alloc] initWithFormat:@"%i mph",theWindSpeed];
	[sliderValueLabel setString:newText];
	[newText release];
}
#pragma mark -
#pragma mark Touch Methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];

	//Resign first responder
	[self hideKeypad];
	
	//Back
	if(point.y > 21 && point.y < 94 && point.x > 13 && point.x < 38)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		//hide self
		[self hide];
		return;
	}
	
	//Quit
	if(point.y > 204 && point.y < 270 && point.x > 13 && point.x < 38)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		//Return to main menu
		[[CCDirector sharedDirector] replaceScene:[CustomLevelsScene node]];
		return;
	}
	
	//Save
	if(point.y > 390 && point.y < 459 && point.x > 13 && point.x < 38)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		[delegate saveLevel];
		return;
	}
	
	//West
	if(point.y > 250 && point.y < 320 && point.x > 54 && point.x < 84)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		windDirection = bbWest;
		windSelector.position = ccp(288,72);
		return;
	}
	
	//East
	if(point.y > 330 && point.y < 400 && point.x > 54 && point.x < 84)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		windDirection = bbEast;
		windSelector.position = ccp(373,72);
		return;
	}
}

#pragma mark -
#pragma mark Menu Visability Methods

-(void)show
{
	//Creates a new screenshot and displays it
	screenshot = [CCSprite spriteWithTexture:[Screenshot takeAsTexture2D]];
	
	UIImage *shot = [Screenshot takeAsUIImage];
	[delegate setScreenshot:shot];
	
	//Displays the save screen and all the UI Elements
	[sliderValueLabel setVisible: YES];
	
	[[[CCDirector sharedDirector] openGLView]addSubview:name];
	[[[CCDirector sharedDirector] openGLView]addSubview:timeLimit];
	[[[CCDirector sharedDirector] openGLView]addSubview:craneFuel];
	[[[CCDirector sharedDirector] openGLView]addSubview:windSpeed];
	
	[self setVisible:YES];
	
	//Removes any old screenshots
	[self removeChildByTag:999 cleanup:YES];
	
	[screenshot setVisible:YES];
	screenshot.scale = .345f;
	screenshot.position = ccp(363,197);
	[self addChild:screenshot z:2 tag:999];
	
	//Enables the touch for the menu
	self.isTouchEnabled = YES;
	
	//If delegate is present disabled touch for it
	if(self.delegate != nil)
		[delegate setIsTouchEnabled:NO];
}

-(void)hide
{
	//Hides all the elements of the save menu
	[sliderValueLabel setVisible:NO];
	
	[name removeFromSuperview];
	[timeLimit removeFromSuperview];
	[craneFuel removeFromSuperview];
	[windSpeed removeFromSuperview];
	
	[self setVisible:NO];
	
	//Disabled touch for self, and enabled touch for delegate
	self.isTouchEnabled = NO;
	if(self.delegate != nil)
		[delegate setIsTouchEnabled:YES];
}

#pragma mark -
#pragma mark UI Methods

-(void)sliderChanged
{
	//gets slider value
	float sliderValue = windSpeed.value;
	
	//Displays the value in MPH for the wind
	NSString *newText = [[NSString alloc] initWithFormat:@"%i mph",(int)(sliderValue)];
	[sliderValueLabel setString:newText];
	[newText release];
}

-(void)hideKeypad
{
	//Resign first responder of all possibly textfield keypads
	[name resignFirstResponder];
	[timeLimit resignFirstResponder];
	[craneFuel resignFirstResponder];
}

//Called when return is pressed on a keypad
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{	
	//Resign the first responder of that textfield
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark UI Element Value Getters

-(NSString *)getName
{
	//Return level name
	return name.text;
}

-(NSString *)getTimeLimit
{
	//return time limit
	return timeLimit.text;
}

-(NSString *)getCraneFuel
{
	//return crane fuel
	return craneFuel.text;
}

-(int)getWindSpeed
{
	//return windspeed
	return (int)(windSpeed.value);
}

-(bbWindDirection)getWindDirection
{
	//Return wind direction
	return windDirection;
}

#pragma mark -
#pragma mark cleanup

-(void)dealloc
{
	[self hideKeypad];
	
	[name removeFromSuperview];
	[timeLimit removeFromSuperview];
	[craneFuel removeFromSuperview];
	[windSpeed removeFromSuperview];
	
	[name release];
	[timeLimit release];
	[craneFuel release];
	[windSpeed release];
	
	[super dealloc];
}


@end
