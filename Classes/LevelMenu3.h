//
//  LevelMenu3.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TouchEffect.h"

#import "OFAchievementService.h"
#import "OFDefines.h"
#import "OFAchievement.h"

#import "SimpleAudioEngine.h"

@interface LevelMenu3 : CCLayer <UITableViewDelegate, UITableViewDataSource>
{
	NSArray *locationLevels;
	
	UITableView *table;
	
	NSString *currentFile;
	int selectedIndex;
	
	UIActivityIndicatorView *loading;
	
	BOOL canContinue;
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;
-(NSString *)getLevelStringForIntValue:(int)val;
-(BOOL)levelCanBeShown:(int)levelNumber;
-(int)getLatestLevelIndex;

@end
