//
//  CustomLevels.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/15/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "CustomLevels.h"
#import "LevelEditorScene.h"
#import "MenuScene.h"
#import "TouchEffect.h"
#import "WBManager.h"
#import "GameScene.h"
#import "LocationSelectionScene.h"

#import "OFAchievementService.h"
#import "OFDefines.h"

@implementation CustomLevels

-(id)init
{
	self = [super init];
	
	if(self!=nil)
	{
		dataSender = [[BluetoothDataSender alloc]init];
		dataSender.delegate = self;
		
		self.isTouchEnabled = YES;
		hasNotBeenDone = YES;
		[self addChild:[TouchEffect node]];
					  
		currentFile = nil;
		selectedIndex = 0;
		
		customLevels = [[NSMutableArray alloc]init];
		
		//Creates a table to display the custom levels
		table = [[UITableView alloc] initWithFrame:CGRectMake(-75, 125, 447, 230) style:UITableViewStylePlain];
		[table setDelegate:self];
		[table setDataSource:self];
		table.backgroundColor = [UIColor clearColor];
		table.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
		
		//Gets the documents directory for iPhone/iPod Touch
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory=[paths objectAtIndex:0];
		//Gets the fulls path with appending the file to be created. 
		NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
		//Filemanager
		NSFileManager *fm = [[NSFileManager alloc]init];
		
		//All the custom levels in the folder
		NSArray *customLevelFiles = [fm contentsOfDirectoryAtPath:customLevelsDirectory error:nil];
		
		//For each path create  a level and adds the level to the array of customlevels
		for(NSString *path in customLevelFiles)
		{
			NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
			NSString *filePath = [customLevelsDirectory stringByAppendingPathComponent: path];

			Level *customLevel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
						
			[customLevels addObject:customLevel];
		}
		
		[fm release];
		
		if([customLevels count]>=3)[OFAchievementService unlockAchievement:DESIGNER];
		else if([customLevels count]>=10)[OFAchievementService unlockAchievement:ARCHITECT];
		
		//Creates the bluetooth disconnect and connect button
		disconnectButton = [CCSprite spriteWithFile:@"disconnectButton.png"];
		connectButton = [CCSprite spriteWithFile:@"connectButton.png"];
		disconnectButton.position = ccp(92,24);
		connectButton.position = ccp(75,24);
		[disconnectButton setVisible:NO];
		[self addChild:connectButton];
		[self addChild:disconnectButton];
		
		//[self loadComplete];
		//Add the table view
		[[[CCDirector sharedDirector]openGLView]addSubview:table];
	}
	
	return self;
}

#pragma mark -
#pragma mark touch methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
	
	//Bluetooth
	if(point.y > 16 && point.y < 165 && point.x > 10 && point.x < 33)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		//Connect
		if([connectButton visible] == YES)
		{		
			[dataSender bdsConnect];
			[disconnectButton setVisible:YES];
			[connectButton setVisible:NO];
		}
		
		//Disconnect
		else if([disconnectButton visible] == YES)
		{	
			[dataSender bdsDisconnect];
			[disconnectButton setVisible:NO];
			[connectButton setVisible:YES];
		}
		
		return;
	}
	
	//Editor
	if(point.y > 404 && point.y < 470 && point.x > 12 && point.x < 32)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		//Sets the singleton's level to load and it's settings for loading within the editor
		[[WBManager sharedManager] setLoadWithEditor:YES];
		[[WBManager sharedManager] setLevelFile:nil];
		[[CCDirector sharedDirector]replaceScene:[LocationSelectionScene node]];
		return;
	}
	
	//Menu
	if(point.y > 205 && point.y < 288 && point.x > 12 && point.x < 32)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		//Glitch preventer...
		if(hasNotBeenDone)
		{
			hasNotBeenDone = NO;
			
			//Loads menu
			[[WBManager sharedManager] setLoadWithEditor:NO];
			[[CCDirector sharedDirector]replaceScene:[MenuScene node]];
		}
		return;
	}
	
	//Play
	if(point.y > 35 && point.y < 95 && point.x > 270 && point.x < 300)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		//If currentfile exists
		if(currentFile!=nil)
		{
			//Play the custom level, singleton gets the filepath and it's settings are set.
			[[WBManager sharedManager] setLoadWithEditor:NO];
			[[WBManager sharedManager] setLoadWithGameLevel:NO];
			[[WBManager sharedManager] setLevelFile:currentFile];
			//Gets the documents directory for iPhone/iPod Touch
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory=[paths objectAtIndex:0];
			//Gets the fulls path with appending the file to be created. 
			NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
			//Filemanager			
			NSString *filePath = [customLevelsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.arch",currentFile]];
			
			GameScene *scene = [GameScene node];
			Level *customLevel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];//filePath
			[scene setLocation: customLevel.location];
			[[CCDirector sharedDirector] replaceScene:scene];
		}
		
		return;
	}
	
	//Edit
	if(point.y > 135 && point.y < 205 && point.x > 270 && point.x < 300)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		//If currentfile exists
		if(currentFile!=nil)
		{
			//Edit the custom level, singleton gets the filepath and it's settings are set.
			[[WBManager sharedManager] setLoadWithEditor:YES];
			[[WBManager sharedManager] setLevelFile:currentFile];
			LevelEditorScene *scene = [LevelEditorScene node];
			[[CCDirector sharedDirector] replaceScene:scene];
		}
		return;
	}
	
	//Share
	if(point.y > 240 && point.y < 319 && point.x > 270 && point.x < 300)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		if([dataSender isConnected])
		{
			
		//Gets the documents directory for iPhone/iPod Touch
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory=[paths objectAtIndex:0];
		//Gets the fulls path with appending the file to be created. 
		NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
		//Filemanager			
		NSString *filePath = [customLevelsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.arch",currentFile]];
		
		Level *levelToSend = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
		
		[NSKeyedArchiver archiveRootObject:levelToSend toFile:filePath];
		NSData *theData = [NSData dataWithContentsOfFile:filePath];
		
		[dataSender bdsSendDataInPackets:theData packetSize:1000];
		
		}
		return;
	}
	
	//Delete
	if(point.y > 351 && point.y < 449 && point.x > 270 && point.x < 300)
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];

		//If currentFile exists
		if(currentFile != nil)
		{
			//Display a UIAlertView to comfirm their decision to delete level
			UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Attention" message:@"Are you sure you want to delete this worksite permanently?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil];
			[alert addButtonWithTitle:@"NO"];
			[alert show];
			[alert release];
			return;
		}
	}
}

#pragma mark -
#pragma mark UIAlertView method

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//If they hit YES
	if(buttonIndex == 0)
	{
		NSFileManager *fm = [[NSFileManager alloc]init];
		
		//Gets the documents directory for iPhone/iPod Touch
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory=[paths objectAtIndex:0];
		//Gets the fulls path with appending the file to be created. 
		NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];	
		//Path to the selected level
		NSString *thePath = [customLevelsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.arch",currentFile]];
		//Delete file of selected level
		[fm removeItemAtPath:thePath error:nil];
		[fm release];
		
		//Removes the custom level from custom level array
		[customLevels removeObjectAtIndex:selectedIndex];
		
		//Reload table with new imformation
		[table reloadData];
		
		currentFile = nil;
	}	
}

#pragma mark -
#pragma mark Table View Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger) section
{
	//Number of custom levels
	return [customLevels count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
	if(cell == nil)
	{
		//Creates the tableViewCell with desired imformation
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: SimpleTableIdentifier]autorelease];
	}
	
	//The cell
	NSUInteger row = [indexPath row];
	cell.textLabel.textColor = [UIColor whiteColor];
	
	//The level
	Level *level = [customLevels objectAtIndex:row];
	//Adds the name
	cell.textLabel.text = level.name;
	cell.textLabel.font = [UIFont fontWithName:[[WBManager sharedManager]getFont] size:[[WBManager sharedManager]getFontSizeForSize:22]];
	
	//adds the screenshot
	UIImage *img = level.screenshot;
	cell.imageView.image = img;

	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Sets the selected level from the table
	selectedIndex = [indexPath row];
	//Gets the level for purposes of getting the name
	Level *level = [customLevels objectAtIndex:[indexPath row]];
	//sets the currentfile to the name of the level
	currentFile = level.name;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Height for each table cell being created is 110
	return 110;
}

-(void)loadComplete
{
//	[activityIndicator stopAnimating];
//	[activityIndicator removeFromSuperview];
}

#pragma mark -
#pragma mark Bluetooth Methods
-(void)receivedData:(NSData *)data
{
	if(data.length > 0)
	{
		
	[customLevels removeAllObjects];
	
	Level *levelReceived = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	//Gets the documents directory for iPhone/iPod Touch
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory=[paths objectAtIndex:0];
	//Gets the fulls path with appending the file to be created. 
	NSString *customLevelsPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
	NSString *customLevelFileName = [customLevelsPath stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.arch",levelReceived.name]];
	
	//Archives File
    [NSKeyedArchiver archiveRootObject: levelReceived toFile: customLevelFileName];
	
	//Filemanager
	NSFileManager *fm = [[NSFileManager alloc]init];
	
	NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];

	//All the custom levels in the folder
	NSArray *customLevelFiles = [fm contentsOfDirectoryAtPath:customLevelsDirectory error:nil];
	
	//For each path create  a level and adds the level to the array of customlevels
	for(NSString *path in customLevelFiles)
	{
		NSString *customLevelsDirectory = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"CustomLevels"]];
		NSString *filePath = [customLevelsDirectory stringByAppendingPathComponent: path];
		
		Level *customLevel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
		
		[customLevels addObject:customLevel];
	}
	
	[fm release];
	
	[OFAchievementService unlockAchievement:TRADER];
	
	[table reloadData];
	}
}

-(void)connectionCanceled
{
	[disconnectButton setVisible:NO];
	[connectButton setVisible:YES];
}

#pragma mark -
#pragma mark cleanup
-(void)dealloc
{	
	[dataSender release];
	[customLevels release];
	[table removeFromSuperview];
	[table release];
	[super dealloc];
}

@end
