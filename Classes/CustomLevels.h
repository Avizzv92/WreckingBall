//
//  CustomLevels.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/15/10.
//  Copyright 2010 Home. All rights reserved.
//
#import "cocos2d.h"
#import "Level.h"
#import "LocationSelectionLayer.h"

#import "BluetoothDataSender.h"

#import <GameKit/GameKit.h>
#import <Foundation/Foundation.h>

#import "OFAchievement.h"

#import "SimpleAudioEngine.h"

@interface CustomLevels : CCLayer  <UITableViewDelegate, UITableViewDataSource, BluetoothDataSenderDelegate>
{
	UITableView *table;
	NSMutableArray *customLevels;
	
	NSString *currentFile;
	int selectedIndex;
	
	BOOL hasNotBeenDone;
	
	CCSprite *connectButton;
	CCSprite *disconnectButton;
	
	BluetoothDataSender *dataSender;
}
-(void)receivedData:(NSData *)data;
-(void)loadComplete;
-(void)connectionCanceled;
@end
