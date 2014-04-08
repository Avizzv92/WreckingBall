//
//  cpCCSpriteBlock.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "cpCCSpriteBlock.h"


@implementation cpCCSpriteBlock

#pragma mark -
#pragma mark init methods

//Creates a autoreleased block
+(id) spriteWithShape:(cpShape *)shape texture:(CCTexture2D*)texture type:(bbBlockType)blockType weight:(bbWeight)blockWeight rotation:(float)blockRotation
{
	return [[[self alloc] initWithShape:shape texture:texture type:blockType weight:blockWeight rotation:blockRotation] autorelease];
}

//Creates a block with the specified properties.
-(id) initWithShape:(cpShape *)shape texture:(CCTexture2D*)texture type:(bbBlockType)blockType weight:(bbWeight)blockWeight rotation:(float)blockRotation
{
	type = blockType;
	weight = blockWeight;
	rotation = blockRotation;
	
	[super initWithTexture:texture];
	
	CPCCNODE_MEM_VARS_INIT(shape)
	
	return self;
}

#pragma mark -
#pragma mark ivar getters
//Returns the block type
-(bbBlockType)getType
{
	return type;
}

//Returns the block weight
-(bbWeight)getWeight
{
	return weight;
}

//Returns the block rotation
-(float)getRotation
{
	return rotation;
}

#pragma mark -
#pragma mark rotation method

//Rotates by 45* increments
-(void)stepRotate
{
	float r = self.rotation;
	float rx = 45 + ((r >= 0 && r <= 45) ? 45 : (r > 45 && r <= 90) ? 90 : (r > 90 && r <= 135) ? 135 : (r > 135 && r <= 180) ? 180 : (r > 180 && r <= 225) ? 225 : (r > 225 && r <= 270) ? 270 : (r > 270 && r <= 315) ? 315 : (r > 315 && r <= 360) ? 360 : (r > 360) ? 0 : 0);
	rotation = rx;
	self.rotation = rx;
}

#pragma mark -
#pragma mark Grid Guides Methods

-(void)showGridGuide
{
	CCSprite *guide = nil;
	
	//Gets the correct grid guide image for the designated block.
	switch (type) 
	{
		case bbStraightI:
		{
			guide = [CCSprite spriteWithFile:@"smallBlockGrid.png"];
			guide.position = ccp(self.textureRect.size.width/2,self.textureRect.size.height/2);
			break;
		}
			
		case bbStraightII:
		{
			guide = [CCSprite spriteWithFile:@"mediumBlockGrid.png"];
			guide.position = ccp(self.textureRect.size.width/2,self.textureRect.size.height/2);
			break;
		}
			
		case bbStraightIII:
		{
			guide = [CCSprite spriteWithFile:@"largeBlockGrid.png"];
			guide.position = ccp(self.textureRect.size.width/2,self.textureRect.size.height/2);
			break;
		}
			
		case bbStraightIV:
		{
			guide = [CCSprite spriteWithFile:@"xtraLargeBlockGrid.png"];
			guide.position = ccp(self.textureRect.size.width/2,self.textureRect.size.height/2);
			break;
		}
			
		case bbAngleI:
		{
			guide = [CCSprite spriteWithFile:@"smallAngleGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2)+1,(self.textureRect.size.height/2)-44);
			guide.rotation = 45;
			break;
		}
			
		case bbAngleII:
		{
			guide = [CCSprite spriteWithFile:@"mediumAngleGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2)+2,(self.textureRect.size.height/2)-30);
			guide.rotation = 45;
			break;
		}
			
		case bbAngleIII:
		{
			guide = [CCSprite spriteWithFile:@"largeAngleGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2)+2,(self.textureRect.size.height/2)-15);
			guide.rotation = 45;
			break;
		}
			
		case bbAngleIV:
		{
			guide = [CCSprite spriteWithFile:@"xtraLargeAngleGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2)+2,(self.textureRect.size.height/2));
			guide.rotation = 45;
			break;
		}
			
		case bbSquareS:
		{
			guide = [CCSprite spriteWithFile:@"smallSquareGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2)+11,(self.textureRect.size.height/2)-8);
			break;
		}
			
		case bbSquareM:
		{
			guide = [CCSprite spriteWithFile:@"mediumSquareGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2)+21,(self.textureRect.size.height/2)-20);
			break;
		}
			
		case bbSquareL:
		{
			guide = [CCSprite spriteWithFile:@"largeSquareGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2)+11,(self.textureRect.size.height/2)-10);
			break;
		}
			
		case bbSquareXL:
		{
			guide = [CCSprite spriteWithFile:@"xtraLargeSquareGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2),(self.textureRect.size.height/2)+1);
			break;
		}
			
		case bbTriangleS:
		{
			guide = [CCSprite spriteWithFile:@"smallTriangleGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2)+10,(self.textureRect.size.height/2)-1);
			break;
		}
			
		case bbTriangleM:
		{
			guide = [CCSprite spriteWithFile:@"mediumTriangleGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2)+10,(self.textureRect.size.height/2)-1);
			break;
		}
			
		case bbTriangleL:
		{
			guide = [CCSprite spriteWithFile:@"largeTriangleGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2)+24,(self.textureRect.size.height/2)-12);
			break;
		}
			
		case bbTriangleXL:
		{
			guide = [CCSprite spriteWithFile:@"xtraLargeTriangleGrid.png"];
			guide.position = ccp((self.textureRect.size.width/2)+13,(self.textureRect.size.height/2)-1);
			break;
		}
			
		default:
			break;
	}
	
	if(type!=bbBomb)[self addChild:guide z:-1 tag:kGridGuideTag];
}

-(void)hideGridGuide
{
	//removes grid guide
	if([self getChildByTag:kGridGuideTag]!=nil && type!=bbBomb)[self removeChildByTag:kGridGuideTag cleanup:YES];
}

/* Old Code
-(void)lockToGrid
{
	if(type != bbAngleI && type != bbAngleII && type != bbAngleIII && type != bbAngleIV && type != bbAngleV)
	{
		int x = (self.position.x - 39)-3.5;
		int y = (self.position.y - 18)-3.5;
		int difX = x % 7;
		int difY = y % 7;
	
		y = y - difY;
		x = x - difX;
	
		if(((int)self.getBoundingRect.size.width % 2) == 0)x += 3.5;
		if(((int)self.getBoundingRect.size.height % 2) == 0)y += 3.5;
	
		self.position = ccp(x + 39,y + 18);	
	}
	
	else 
	{
		int x = (self.position.x - 39)-3.5;
		int y = (self.position.y - 18)-3.5;
		
		//Any fine adjustments for a given block
		x = (type == bbAngleV) ? x+1 : (type == bbAngleIV) ? x+0 : (type == bbAngleIII) ? x+0 : (type == bbAngleII) ? x+0 : (type == bbAngleI) ? x+0 : x+0;
		y = (type == bbAngleV) ? y-1 : (type == bbAngleIV) ? y+0 : (type == bbAngleIII) ? y-0 : (type == bbAngleII) ? y-0 : (type == bbAngleI) ? y-0 : y-0;
		
		int difX = x % 7;
		int difY = y % 7;
		
		y = y - difY;
		x = x - difX;
		
		int width = (type == bbAngleV) ? 77 : (type == bbAngleIV) ? 63 : (type == bbAngleIII) ? 0 : (type == bbAngleII) ? 0 : (type == bbAngleI) ? 0 : 0;
 		
		if(((int)width % 2) == 0)x += 3.5;
		if(((int)width % 2) == 0)y += 3.5;//Method to return size based on block type... if needed.
		
		self.position = ccp(x + 39,y + 18);	
	}

}
*/

//**NOT SURE IF THIS WILL REMAIN**//
-(CGRect) getBoundingRect
{
	CGSize size = [self contentSize];
	size.width *= scaleX_;
	size.height *= scaleY_;
	return CGRectMake(position_.x - size.width * anchorPoint_.x, 
					  position_.y - size.height * anchorPoint_.y, 
					  size.width, size.height);
}

#pragma mark -
#pragma mark cleanup

-(void)dealloc
{
	[super dealloc];
}
@end
