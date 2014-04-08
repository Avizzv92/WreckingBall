//
//  EditorBlock.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "cocos2d.h"
#import "BlockBuilder.h"
#import "BlockTypeDefines.h"

//Like a regular cpCCSpriteBlock minus the Physics, imformation for the purpose of archiving.
@interface EditorBlock : NSObject <NSCoding> //NSCoding Protocol
{
	//Block information and properties
	bbBlockType type;
	bbWeight weight;
	float rotation;
	CGPoint position;
}
//Creates a editor block with desired imformation
-(id)initWithType:(bbBlockType)blockType weight:(bbWeight)blockWeight rotation:(float)blockRotation position:(CGPoint)blockPosition;

//NSCoding Methods
-(void)encodeWithCoder:(NSCoder *)encoder;
-(id)initWithCoder:(NSCoder *)decoder;

//Returns the information about a given block
-(CGPoint) getPosition;
-(float) getRotation;
-(bbWeight) getWeight;
-(bbBlockType) getBlockType;

@end
