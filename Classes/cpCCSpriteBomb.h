//
//  cpCCSpriteBomb.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/31/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "cpCCSpriteBlock.h"
#import "CCArray.h"

//Subclass of cpCCSpriteBlock, for handling explosions.
@interface cpCCSpriteBomb : cpCCSpriteBlock 
{

}
//Explods the cpCCSpriteBomb at point, affects the desired blocks in the blocks array on the given layer. 
-(void)bombAtPoint:(CGPoint)point spritesAffected:(CCArray *)blocks layer:(CCLayer*)layer;
@end
