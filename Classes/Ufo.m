//
//  Ufo.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 10/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "Ufo.h"
#import "cpCCSpriteBlock.h"

@implementation Ufo
@synthesize blocks;

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		ufo = [CCSprite spriteWithFile:@"ufo.png"];
		ufo.position = ccp(-150,280);
		ufo.scaleX = .60f;
		ufo.scaleY = .60f;
		[self addChild:ufo];
		
		self.isTouchEnabled = YES;
	}
	
	return self;
}

-(void) draw {
	if (CGPointEqualToPoint(touchLocation, CGPointZero) == NO && [self canVaporize]) {
		glEnable(GL_LINE_SMOOTH);
		glColor4ub(20,255,0,75);
		glLineWidth(2.0f);
		ccDrawLine( ccp(240, 260), ccp(touchLocation.y, touchLocation.x) );
	}
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	if(CGPointEqualToPoint(touchLocation, CGPointZero)==NO)touchLocation = point;
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	if([self canVaporize])touchLocation = point;
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	touchLocation = CGPointZero;
	
	UITouch *touch = [touches anyObject];
	
	cpCCSpriteBlock *blockToVaporize = [self blockForTouch:touch];
	
	if(blockToVaporize != nil)
	{
		[self.blocks removeObject:blockToVaporize];

		[[self parent] removeChild:blockToVaporize cleanup:YES];
		
		[self ufoExit];
	}
}

-(void)ufoExit
{
	if(activeDirection == 0)
	{
		[ufo stopAllActions];
		id raction = [CCRotateTo actionWithDuration:2.0f angle:3.0f];
		id raction2 = [CCRotateTo actionWithDuration:2.0f angle:-3.0f];
		
		[ufo runAction:[CCRepeatForever actionWithAction:[CCSequence actions:raction,raction2,nil]]];
		
		id action3 = [CCMoveTo actionWithDuration:5.0f position:ccp(630,280)];
		id action4 = [CCMoveTo actionWithDuration:.01f position:ccp(-150,280)];
		
		[ufo runAction:[CCSequence actions:action3,action4,nil]];
	}
	
	else if(activeDirection == 1)
	{
		[ufo stopAllActions];
		id raction = [CCRotateTo actionWithDuration:2.0f angle:3.0f];
		id raction2 = [CCRotateTo actionWithDuration:2.0f angle:-3.0f];
		
		[ufo runAction:[CCRepeatForever actionWithAction:[CCSequence actions:raction,raction2,nil]]];
		
		id action3 = [CCMoveTo actionWithDuration:5.0f position:ccp(-150,280)];
		id action4 = [CCMoveTo actionWithDuration:.01f position:ccp(630,280)];
		
		[ufo runAction:[CCSequence actions:action3,action4,nil]];
	}
}

-(void)flyBy
{
	int randomNum = arc4random() % 2;
	activeDirection = randomNum;
	
	id raction = [CCRotateTo actionWithDuration:2.0f angle:3.0f];
	id raction2 = [CCRotateTo actionWithDuration:2.0f angle:-3.0f];
	
	[ufo runAction:[CCRepeatForever actionWithAction:[CCSequence actions:raction,raction2,nil]]];
	
	//Fly right
	if(randomNum == 0)
	{
		ufo.position = ccp(-150, 280);
		
		id action = [CCMoveTo actionWithDuration:5.0f position:ccp(240,280)];
		id action2 = [CCMoveTo actionWithDuration:5.0f position:ccp(240,280)];
		id action3 = [CCMoveTo actionWithDuration:5.0f position:ccp(630,280)];
		id action4 = [CCMoveTo actionWithDuration:.01f position:ccp(-150,280)];
		
		[ufo runAction:[CCSequence actions:action,action2,action3,action4,nil]];
	}
	
	//Fly left
	else  if(randomNum == 1)
	{
		ufo.position = ccp(630, 280);
		
		id action = [CCMoveTo actionWithDuration:5.0f position:ccp(240,280)];
		id action2 = [CCMoveTo actionWithDuration:5.0f position:ccp(240,280)];
		id action3 = [CCMoveTo actionWithDuration:5.0f position:ccp(-150,280)];
		id action4 = [CCMoveTo actionWithDuration:.01f position:ccp(630,280)];
		
		[ufo runAction:[CCSequence actions:action,action2,action3,action4,nil]];
	} 

}

-(BOOL)canVaporize
{
	if(ufo.position.x == 240) return YES;
	else return NO;
}
	  
#define bufferSize 10

-(cpCCSpriteBlock *)blockForTouch: (UITouch *) touch
{
	CGPoint touchLocationX = [touch locationInView: [touch view]];
	touchLocationX = [[CCDirector sharedDirector] convertToGL: touchLocationX];
	
	//Goes through each block currently placed in the level
	for( cpCCSpriteBlock* item in self.blocks) 
	{
		//Converts the touchLocation to a point in the block's space
		CGPoint local = [item convertToNodeSpace:touchLocationX];
		
		//Gets and edits the rect of the texture for the block sprite
		CGRect r = [item textureRect];
		CGSize size = r.size;
		CGRect newRect = CGRectMake(r.origin.x - (bufferSize/2) , r.origin.y - (bufferSize/2), size.width+bufferSize, size.height+bufferSize);
		
		//Normalize point for moving object where touch begins? AnchorPoint 0-1.0
		//Something to do with normalize
		
		//if the touch location local is in newRect then that block is being touched.
		if( CGRectContainsPoint( newRect, local ) )
		{
			//Return the block being touched
			return item;
		}
	}
	//If no block being touched return nil
	return nil;
}

-(void)dealloc
{
	[blocks release];
	[super dealloc];
}

@end
