//
//  EditorBlock.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "EditorBlock.h"


@implementation EditorBlock

#pragma mark -
#pragma mark init methods

-(id)initWithType:(bbBlockType)blockType weight:(bbWeight)blockWeight rotation:(float)blockRotation position:(CGPoint)blockPosition
{
	self = [super init];
	
	if(self!=nil)
	{
		//Sets the block properties
		type = blockType;
		weight = blockWeight;
		rotation = blockRotation;
		position = blockPosition;
	}
	
	return self;
}

#pragma mark -
#pragma mark NSCoding Methods

-(void)encodeWithCoder:(NSCoder *)encoder
{
	//Encode block properties
	[encoder encodeInt: type forKey:@"BlockType"];
	[encoder encodeInt: weight forKey:@"BlockWeight"];
	[encoder encodeFloat: rotation forKey:@"BlockRotation"];
	[encoder encodeCGPoint: position forKey:@"BlockPosition"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
	//Decodes block properties
	type = [decoder decodeIntForKey: @"BlockType"];
	weight = [decoder decodeIntForKey: @"BlockWeight"];
	rotation = [decoder decodeFloatForKey: @"BlockRotation"];
	position = [decoder decodeCGPointForKey: @"BlockPosition"];
	return self;
}

#pragma mark -
#pragma mark ivar Getter Methods

//Returns block position
-(CGPoint) getPosition
{
	return position;
}

//Returns block rotation
-(float) getRotation
{
	return rotation;
}

//Returns block weight
-(bbWeight) getWeight
{
	return weight;
}

//Returns block type
-(bbBlockType) getBlockType
{
	return type;
}

@end
