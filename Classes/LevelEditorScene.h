//
//  LevelEditorScene.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/1/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EditorLayer.h"

@interface LevelEditorScene : CCScene 
{
	EditorLayer *layer;
}

-(EditorLayer *)getLayer;

@end
