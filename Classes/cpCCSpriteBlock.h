//
//  ;
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/2/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "cpCCSprite.h"
#import "BlockTypeDefines.h"

#define kGridGuideTag 1

@interface cpCCSpriteBlock : cpCCSprite //cpCCSprite Cocos2d Wrapper in Objective-C for Chipmunk Physics
{
	//ivar for properties of a block
	bbBlockType type;
	bbWeight weight;
	float rotation;
}
//Block creation methods
- (id) initWithShape:(cpShape *)shape texture:(CCTexture2D*)texture type:(bbBlockType)blockType weight:(bbWeight)blockWeight rotation:(float)blockRotation;
+ (id) spriteWithShape:(cpShape *)shape texture:(CCTexture2D*)texture type:(bbBlockType)blockType weight:(bbWeight)blockWeight rotation:(float)blockRotation;

//getters for the properties of the block
-(bbBlockType)getType;
-(bbWeight)getWeight;
-(float)getRotation;

//Rotates 45* at a time
-(void)stepRotate;

//Grid guides
-(void)showGridGuide;
-(void)hideGridGuide;

//Lock to Grid
//-(void)lockToGrid;
-(CGRect) getBoundingRect;
@end
