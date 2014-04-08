//
//  BluetoothDataSender.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 7/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "BluetoothDataSender.h"

@implementation BluetoothDataSender
@synthesize currentSession,delegate;

#pragma mark -
#pragma mark Init Method
-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		size = 0;
		count = 0;
		dataPackets = [[NSMutableArray alloc]init];
	}
	
	return self;
}

#pragma mark -
#pragma mark Bluetooth Session Methods

-(void) bdsConnect
{
    thePicker = [[GKPeerPickerController alloc] init];
    thePicker.delegate = self;
    thePicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;     
	
    [thePicker show];    
}

-(void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *) session 
{
    self.currentSession = session;
    session.delegate = self;
    [session setDataReceiveHandler:self withContext:nil];
	picker.delegate = nil;
	
    [picker dismiss];
    [picker autorelease];
}

-(void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
	if(self.delegate != nil && [self.delegate respondsToSelector:@selector(connectionCanceled)])[self.delegate connectionCanceled];
    picker.delegate = nil;
    [picker autorelease];
}

-(void)bdsDisconnect
{
    [self.currentSession disconnectFromAllPeers];
    [self.currentSession release];
    currentSession = nil;
}

#pragma mark -
#pragma mark Data Handling Methods

-(void)sendDataToPeers:(NSData *) data
{
    if (currentSession) 
	{
        [self.currentSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];   
	}
}

-(void) bdsSendData:(NSData*)data
{
	if (currentSession) 
	{
		[self sendDataToPeers:data];
	}
	
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can't share a custom worksite unless you are connected to another peer." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

-(void) bdsSendDataInPackets:(NSData *)data packetSize:(int)theSize
{	
	if (currentSession) 
	{		
		NSMutableArray *theDataPackets = [self arrayOfDataObjectsFromData:data blockSize:theSize];
			
		NSString *num = [[NSString alloc]initWithFormat:@"%i first",[theDataPackets count]];

		[self bdsSendData:[num dataUsingEncoding:NSUTF8StringEncoding]];
		
		for(NSData *packet in theDataPackets)
		{
			[self sendDataToPeers:packet];
		}

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sent!" message:@"Your custom worksite has been sent." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		////
		[num release];
	}
	
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can't share a custom worksite unless you are connected to another peer." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

-(void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context 
{	
	if([[[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]autorelease]hasSuffix:@"first"])
	{
		NSString *num = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		size = [self numberValueForPosition:1 string:num];
		[num release];
	}
	
	else if(count < size) 
	{
		count++;
		[dataPackets addObject:data];
			
		if(self.delegate != nil && count == size)
		{		
			NSData *data = [self dataWithDataObjects:dataPackets];
			[self.delegate receivedData:data];
		
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Received!" message:@"A custom worksite has been received." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
			[alert show];
			[alert release];
		
			//Reset
			[dataPackets removeAllObjects];
			size = 0;
			count = 0;
		}
	}
}

#pragma mark -
#pragma mark Bluetooth State Methods
-(void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state 
{
    switch (state)
    {
        case GKPeerStateConnected:
            break;
        case GKPeerStateDisconnected:
            [self.currentSession release];
			if(self.delegate != nil)[self.delegate connectionCanceled];
            currentSession = nil;
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"The connection has ended." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
			[alert show];
			[alert release];
            break;
    }
}

-(BOOL) isConnected
{
	if(currentSession)return YES;
	else return NO;
}

#pragma mark -
#pragma mark Utilitie Methods
-(NSMutableArray *)arrayOfDataObjectsFromData:(NSData *)data blockSize:(int)theSize
{
	int dataBlock = theSize;
	int position = 0;
	BOOL canContinue = YES;
	
	NSMutableArray *dataArray = [[[NSMutableArray alloc]init]autorelease];
	
	while(canContinue)
	{			
		if(position+dataBlock <= (int)data.length)
		{
			NSData *subData = [data subdataWithRange:NSMakeRange(position, dataBlock)];
			position = position + dataBlock;
			[dataArray addObject: subData];
		}
		
		else
		{
			NSData *subData = [data subdataWithRange:NSMakeRange(position, (data.length % dataBlock))];
			canContinue = NO;
			[dataArray addObject: subData];
		}
	}
	
	return dataArray;
}

-(NSData *)dataWithDataObjects:(NSArray *)dataArray
{
	NSMutableData *data = [[[NSMutableData alloc]init]autorelease];
	
	for(NSData *dataPacket in dataArray)
	{
		[data appendData:dataPacket];
	}
	
	return data;
}

-(int)numberValueForPosition:(int)desiredInt string:(NSString *)stringValue
{
	unsigned int x = 0;
	int numbersFound = 0;
	NSMutableString *number = [NSMutableString stringWithString:@""];
	BOOL hasCounted = NO;
	
	while(x <= [stringValue length]-1)
	{
		char currentChar = [stringValue characterAtIndex:x];
		
		if(currentChar >= '0' && currentChar <= '9')
		{
			[number appendString:[NSString stringWithFormat:@"%c",currentChar]];
			hasCounted = NO;
		}
		
		else
	    {
			if(!hasCounted && ![number isEqualToString:@""])
			{
				hasCounted = YES;
				numbersFound++;
			}
			
			if(numbersFound == desiredInt)return [number intValue];
			else [number setString:@""];
		}
		
		x++;
	}
	
	if(![number isEqualToString:@""])return [number intValue];
	
	return -1;
}


#pragma mark -
#pragma mark Cleanup
-(void)dealloc
{
	[dataPackets release];
	[currentSession release];
	[super dealloc];
}
@end
