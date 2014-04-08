//
//  BluetoothDataSender.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 7/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol BluetoothDataSenderDelegate <NSObject>

@required
-(void)receivedData:(NSData *)data;
@optional
-(void)connectionCanceled;

@end


@interface BluetoothDataSender : NSObject <GKSessionDelegate, GKPeerPickerControllerDelegate>
{
	GKSession *currentSession;
	GKPeerPickerController *thePicker;
	
	id <BluetoothDataSenderDelegate> delegate;
	
	NSMutableArray *dataPackets;
	int size;
	int count;
}
@property (nonatomic, retain) GKSession *currentSession;
@property (nonatomic, assign) id <BluetoothDataSenderDelegate> delegate;

-(void) bdsSendData:(NSData *)data;
-(void) bdsSendDataInPackets:(NSData *)data packetSize:(int)theSize;

-(void) bdsConnect;
-(void) bdsDisconnect;

-(BOOL) isConnected;

-(NSMutableArray *)arrayOfDataObjectsFromData:(NSData *)data blockSize:(int)theSize;
-(NSData *)dataWithDataObjects:(NSArray *)dataArray;
-(int)numberValueForPosition:(int)desiredInt string:(NSString *)stringValue;

@end
