//
//  Ufo.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 10/17/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "Cocos2d.h"
#import "cpCCSpriteBlock.h"

@interface Ufo : CCLayer 
{
	int activeDirection;
	CCSprite *ufo;
	NSMutableArray *blocks;
	CGPoint touchLocation;
}
@property(nonatomic, retain) NSMutableArray *blocks;

-(void)flyBy;
-(void)ufoExit;

-(BOOL)canVaporize;
-(cpCCSpriteBlock *)blockForTouch: (UITouch *) touch;

@end
