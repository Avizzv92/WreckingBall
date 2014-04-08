//
//  TouchEffect.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "TouchEffect.h"

@implementation TouchEffect

#pragma mark -
#pragma mark init methods

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		self.isTouchEnabled = YES;
		
		//alloc and init the mutable array
		circleArray = [[NSMutableArray alloc]init];
		
		//Create the 5 usuable sprites for the touch effect.
		circle = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"circleHL.png"]];
		circle.position = ccp(-50,-50);
		circle.opacity = 0;
		circle.scaleY = 1.5f;
		circle.scaleX = 1.5f;
		[self addChild:circle];
		[circleArray addObject: circle];
		
		circle1 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"circleHL.png"]];
		circle1.position = ccp(-50,-50);
		circle1.opacity = 0;
		circle1.scaleY = 1.5f;
		circle1.scaleX = 1.5f;
		[self addChild:circle1];
		[circleArray addObject: circle1];
		
		circle2 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"circleHL.png"]];
		circle2.position = ccp(-50,-50);
		circle2.opacity = 0;
		circle2.scaleY = 1.5f;
		circle2.scaleX = 1.5f;
		[self addChild:circle2];
		[circleArray addObject: circle2];
		
		circle3 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"circleHL.png"]];
		circle3.position = ccp(-50,-50);
		circle3.opacity = 0;
		circle3.scaleY = 1.5f;
		circle3.scaleX = 1.5f;
		[self addChild:circle3];
		[circleArray addObject: circle3];
		
		circle4 = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage:@"circleHL.png"]];
		circle4.position = ccp(-50,-50);
		circle4.opacity = 0;
		circle4.scaleY = 1.5f;
		circle4.scaleX = 1.5f;
		[self addChild:circle4];
		[circleArray addObject: circle4];
		
		//Set default value to nil
		circleTouch = nil;
		circleTouch1 = nil;
		circleTouch2 = nil;
		circleTouch3 = nil;
		circleTouch4 = nil;
	}
	
	return self;
}

#pragma mark -
#pragma mark Touch Methods

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Array of all the touches present
	NSArray *touchesArray = [touches allObjects];
	
	//For each touch create a circle at that location
	for(UITouch *touched in touchesArray)
	{
		//Checks each posible touch in order for one that is not being used (nil)
		if(circleTouch == nil)
		{
			[self createCircleAtPoint:[touched locationInView:[touched view]] circle: circle];
			circleTouch = touched;
		}
		
		else if(circleTouch1 == nil)
		{
			[self createCircleAtPoint:[touched locationInView:[touched view]] circle: circle1];
			circleTouch1 = touched;
		}
		
		else if(circleTouch2 == nil)
		{
			[self createCircleAtPoint:[touched locationInView:[touched view]] circle: circle2];
			circleTouch2 = touched;
		}
		
		else if(circleTouch3 == nil)
		{
			[self createCircleAtPoint:[touched locationInView:[touched view]] circle: circle3];
			circleTouch3 = touched;
		}
		
		else if(circleTouch4 == nil)
		{
			[self createCircleAtPoint:[touched locationInView:[touched view]] circle: circle4];
			circleTouch4 = touched;
		}
	}
	
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{	
	//All touches currently present
	NSArray *touchesArray = [touches allObjects];
	
	//For each touch in the array
	for(UITouch *touched in touchesArray)
	{	
		//Goes through all the ivar UITouches to see if they are not nil and equal to the current touch. If so move the touch.
		//The same touch object is present throughout a life of a touch (began,moved,end)
		if(circleTouch != nil && touched == circleTouch)
		{
			CGPoint newPoint = [[CCDirector sharedDirector] convertToGL:[touched locationInView:[touched view]]];			
			circle.position = newPoint;
		}
		
		else if(circleTouch1 != nil && touched == circleTouch1)
		{
			CGPoint newPoint = [[CCDirector sharedDirector] convertToGL:[touched locationInView:[touched view]]];			
			circle1.position = newPoint;
		}
		
		else if(circleTouch2 != nil && touched == circleTouch2)
		{
			CGPoint newPoint = [[CCDirector sharedDirector] convertToGL:[touched locationInView:[touched view]]];			
			circle2.position = newPoint;
		}
		
		else if(circleTouch3 != nil && touched == circleTouch3)
		{
			CGPoint newPoint = [[CCDirector sharedDirector] convertToGL:[touched locationInView:[touched view]]];			
			circle3.position = newPoint;
		}
		
		else if(circleTouch4 != nil&& touched == circleTouch4)
		{
			CGPoint newPoint = [[CCDirector sharedDirector] convertToGL:[touched locationInView:[touched view]]];			
			circle4.position = newPoint;
		}
	}
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//All the touches presently on the screen
	NSArray *touchesArray = [touches allObjects];
	
	//For each touch.
	for(UITouch *touched in touchesArray)
	{	
		//If the touch is equal to the given touch and the given touch is no nil (which means its in use) hide that touch.
		if(circleTouch != nil && touched == circleTouch)
		{
			[self hideCircle:circle];
			circleTouch = nil;
		}
		
		else if(circleTouch1 != nil && touched == circleTouch1)
		{
			[self hideCircle:circle1];
			circleTouch1 = nil;
		}
		
		else if(circleTouch2 != nil && touched == circleTouch2)
		{
			[self hideCircle:circle2];
			circleTouch2 = nil;
		}
		
		else if(circleTouch3 != nil && touched == circleTouch3)
		{
			[self hideCircle:circle3];
			circleTouch3 = nil;
		}
		
		else if(circleTouch4 != nil&& touched == circleTouch4)
		{
			[self hideCircle:circle4];
			circleTouch4 = nil;
		}
	}
}	

#pragma mark -
#pragma mark Circle Touch Methods

-(void)createCircleAtPoint:(CGPoint)thePoint circle:(CCSprite *)theCircle
{
	//Position theCircle in the correct location then give it a fade in effect.
	CGPoint point = [[CCDirector sharedDirector] convertToGL:thePoint];
	theCircle.position = point;
	
	id fadeIn = [CCFadeTo actionWithDuration:.3f opacity: 255];
	[theCircle runAction:[CCSequence actions:fadeIn,nil]];
}

-(void)hideCircle:(CCSprite *)theCircle
{	
	//Properly fade out a given theCircle
	id fadeOut = [CCFadeTo actionWithDuration:.3f opacity: 0];
	id move = [CCMoveTo actionWithDuration:.0f position:ccp(-50,-50)]; 
	[theCircle runAction:[CCSequence actions:fadeOut,move,nil]];
}

#pragma mark -
#pragma mark cleanup

-(void)dealloc
{
	[circleArray release];
	[super dealloc];
}

@end
