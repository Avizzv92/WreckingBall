//
//  Credits.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 7/7/10.
//  Copyright 2010 Alternative Visuals. All rights reserved.
//
//  Website:
//  http://www.alternativevisuals.com
//

#import "Credits.h"

//Menus
#import "OptionsScene.h"

#import "TouchEffect.h"

@implementation Credits

#pragma mark -
#pragma mark Intialization Method

-(id) init
{
	self = [super init];
	if(self != nil)
	{
		cheatCodes = nil;
		
		[self addChild:[TouchEffect node]];
		//Enable Touch
		self.isTouchEnabled = YES;
		
		//Creates Credits
		credits = [CCSprite spriteWithFile:@"Credits.png"];
		credits.position = ccp(240, -20);
		[self addChild:credits z:0];
		
		button = [CCSprite spriteWithFile:@"menuCredits.png"];
		button.position = ccp(437,300);
		[self addChild:button];
		
		//Set initial value of y
		y = 0;
	}
	
	return self;
}

#pragma mark -
#pragma mark Touch Methods

//Called while screen is being touched
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	//Sets start point of the touch for later use
	touchStartPoint = point;
	
	
	return;
}
- (void) ccTouchesMoved: (NSSet *)touches withEvent: (UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	// simple position update
	CGPoint a = [[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:touch.view]];
	CGPoint b = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
	CGPoint nowPosition = credits.position;
	nowPosition.y += ( b.y - a.y );
	
	if(nowPosition.y < 480.0f && nowPosition.y > -20.0f)
		credits.position = nowPosition;
	
	if(nowPosition.y >= 475.0f && cheatCodes == nil)
	{
		cheatCodes = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		cheatCodes.frame = CGRectMake(-25, +40, 100, 35);
		cheatCodes.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
		[cheatCodes setTitle:@"Cheat Codes" forState:0];
		[cheatCodes setTitle:@"Cheat Codes" forState:1];
		
		[cheatCodes addTarget:self action:@selector(linkToCheats) forControlEvents:UIControlEventAllEvents];
		
		[[[CCDirector sharedDirector]openGLView]addSubview:cheatCodes];
	}
	
	else if(nowPosition.y < 475.0f) {
		[cheatCodes removeFromSuperview];
		cheatCodes = nil;
	}
	
	
	return;
}

-(void)linkToCheats
{
	NSString *iTunesLink = @"http://alternativevisuals.com/WBcheat.html";
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

//Called when screen has been touched then released
- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *) event
{	
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	if(point.x > 280 && point.y > 390)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
		OptionsScene *menu = [OptionsScene node];
		[[CCDirector sharedDirector] replaceScene: menu];
	}
	
	return;
}

#pragma mark -
#pragma mark Cleanup

-(void) dealloc
{
	if(cheatCodes != nil) [cheatCodes removeFromSuperview];
	
	[self removeChild:credits cleanup:YES];
	[self removeChild:button cleanup:YES];
	
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[super dealloc];
}
@end
