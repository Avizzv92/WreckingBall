//
//  BlockTypeDefines.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/14/10.
//  Copyright 2010 Home. All rights reserved.
//

//Typedef for the type of block weights
typedef enum
{
	bbHeavy,
	bbLight,
	bbStatic
}bbWeight;

//Typedef for the type of blocks possible to choose from
typedef enum
{
	bbStraightIV, bbStraightIII, bbStraightII,bbStraightI, bbAngleI, bbAngleII, bbAngleIII, bbAngleIV, bbDelete, bbSquareS, bbSquareM, bbSquareL, bbSquareXL, bbTriangleS, bbTriangleM, bbTriangleL, bbTriangleXL, bbBomb
}bbBlockType;