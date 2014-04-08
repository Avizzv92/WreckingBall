//
//  LevelMenu3.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 4/5/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "LevelMenu3.h"
#import "MenuScene.h"
#import "LevelMenu2Scene.h"
#import "GameScene.h"
#import "OpenFeint.h"
#import "WBManager.h"

#define level21Path [[NSBundle mainBundle] pathForResource:@"Level21" ofType:@"arch"] 
#define level22Path [[NSBundle mainBundle] pathForResource:@"Level22" ofType:@"arch"] 
#define level23Path [[NSBundle mainBundle] pathForResource:@"Level23" ofType:@"arch"] 
#define level24Path [[NSBundle mainBundle] pathForResource:@"Level24" ofType:@"arch"] 
#define level25Path [[NSBundle mainBundle] pathForResource:@"Level25" ofType:@"arch"] 
#define level26Path [[NSBundle mainBundle] pathForResource:@"Level26" ofType:@"arch"] 
#define level27Path [[NSBundle mainBundle] pathForResource:@"Level27" ofType:@"arch"] 
#define level28Path [[NSBundle mainBundle] pathForResource:@"Level28" ofType:@"arch"] 
#define level29Path [[NSBundle mainBundle] pathForResource:@"Level29" ofType:@"arch"] 
#define level30Path [[NSBundle mainBundle] pathForResource:@"Level30" ofType:@"arch"] 

@implementation LevelMenu3

#pragma mark -
#pragma mark init methods

-(id)init
{
	self = [super init];
	
	if(self != nil)
	{
		self.isTouchEnabled = YES;
				
		loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		loading.frame = CGRectMake(140, 220, 40, 40);
		[loading startAnimating];
		[[[CCDirector sharedDirector]openGLView]addSubview:loading];
		
		currentFile = nil;
		selectedIndex = 0;
		
		locationLevels = [[NSArray alloc]initWithObjects:level21Path,level22Path,level23Path,level24Path,level25Path,level26Path,level27Path,level28Path,level29Path,level30Path,nil];
		
		table = [[UITableView alloc] initWithFrame:CGRectMake(-75, 135, 447, 210) style:UITableViewStylePlain];
		[table setDelegate:self];
		[table setDataSource:self];
		table.backgroundColor = [UIColor clearColor];
		table.transform = CGAffineTransformMakeRotation(90 * M_PI / 180);
	
		//Add touch effect
		[self addChild:[TouchEffect node]];
				
		if([[[WBManager sharedManager]currentUser]countrysideDone] && [[WBManager sharedManager]currentUser].difficulty != bbHard)[OFAchievementService unlockAchievement:COUNTRYSIDE];
		if([[[WBManager sharedManager]currentUser]wildernessDone] && [[WBManager sharedManager]currentUser].difficulty != bbHard)[OFAchievementService unlockAchievement:WILDERNESS];
		if([[[WBManager sharedManager]currentUser]cityDone] && [[WBManager sharedManager]currentUser].difficulty != bbHard)[OFAchievementService unlockAchievement:CITY];
		
		if([[[WBManager sharedManager]currentUser]countrysideDone] && [[WBManager sharedManager]currentUser].difficulty == bbHard)[OFAchievementService unlockAchievement:COUNTRYSIDE_MASTER];
		if([[[WBManager sharedManager]currentUser]wildernessDone] && [[WBManager sharedManager]currentUser].difficulty == bbHard)[OFAchievementService unlockAchievement:WILDERNESS_MASTER];
		if([[[WBManager sharedManager]currentUser]cityDone] && [[WBManager sharedManager]currentUser].difficulty == bbHard)[OFAchievementService unlockAchievement:CITY_MASTER];
	

		NSIndexPath *pathIndex = [NSIndexPath indexPathForRow:[self getLatestLevelIndex]-20 inSection:0];
		//[table scrollToRowAtIndexPath:pathIndex atScrollPosition:UITableViewScrollPositionTop animated:NO];
		if([[[UIDevice currentDevice] systemVersion] floatValue]>=4.0)[table selectRowAtIndexPath:pathIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
		if([[[UIDevice currentDevice] systemVersion] floatValue]>=4.0)[table deselectRowAtIndexPath:pathIndex animated:YES];
		
		canContinue = YES;
	}
	
	return self;
}

-(void)onEnter
{	
	[loading stopAnimating];
	[loading removeFromSuperview];
	
	[[[CCDirector sharedDirector]openGLView]addSubview:table];
	
	[super onEnter];
}

-(BOOL)levelCanBeShown:(int)levelNumber
{		
	GameCard *card = [[[WBManager sharedManager]currentUser]getGameCardForLevel:levelNumber-2];
	GameCard *card2 = [[[WBManager sharedManager]currentUser]getGameCardForLevel:levelNumber-1];
		
	if(card.score > 0)return YES;
	else if(card2.score>0)return YES;
	else return NO;
}

#pragma mark -
#pragma mark touch methods

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];

	if(!canContinue)return;
	
	if(point.x > 258 && point.x < 305 && point.y > 420 && point.y < 467) 
	{
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
		[OpenFeint launchDashboard];
	}
	
	//Menu
	if(point.x > 11 && point.x < 36 && point.y > 189 && point.y < 284) 
	{
		canContinue = NO;
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
		[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
	}
	
	//Prev
	if(point.x > 11 && point.x < 36 && point.y > 13 && point.y < 114) 
	{
		canContinue = NO;
		[[SimpleAudioEngine sharedEngine]playEffect:@"Button.caf"];
		[[CCDirector sharedDirector] replaceScene:[LevelMenu2Scene node]];
	}
}

#pragma mark -
#pragma mark Table View Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger) section
{
	//Number of custom levels
	return [locationLevels count];
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
	CGRect CellFrame = CGRectMake(0, 0, 447, 210);
	
	UILabel *levelName = [[UILabel alloc]initWithFrame:CGRectMake(170,6,280,17)];
	UILabel *levelStatus = [[UILabel alloc]initWithFrame:CGRectMake(170,25,280,17)];
	UILabel *levelTime = [[UILabel alloc]initWithFrame:CGRectMake(175,44,300,17)];
	UILabel *levelHeight = [[UILabel alloc]initWithFrame:CGRectMake(175,63,300,17)];
	UILabel *levelScore = [[UILabel alloc]initWithFrame:CGRectMake(175,82,300,17)];
	
	levelName.font = [UIFont fontWithName:[[WBManager sharedManager]getFont] size:[[WBManager sharedManager]getFontSizeForSize:17]];
	levelStatus.font = [UIFont fontWithName:[[WBManager sharedManager]getFont] size:[[WBManager sharedManager]getFontSizeForSize:17]];
	levelTime.font = [UIFont fontWithName:[[WBManager sharedManager]getFont] size:[[WBManager sharedManager]getFontSizeForSize:17]];
	levelHeight.font = [UIFont fontWithName:[[WBManager sharedManager]getFont] size:[[WBManager sharedManager]getFontSizeForSize:17]];
	levelScore.font = [UIFont fontWithName:[[WBManager sharedManager]getFont] size:[[WBManager sharedManager]getFontSizeForSize:17]];
	
	levelName.textAlignment = UITextAlignmentCenter;
	levelStatus.textAlignment = UITextAlignmentCenter;
	
	levelName.backgroundColor = [UIColor clearColor];
	levelStatus.backgroundColor = [UIColor clearColor];
	levelTime.backgroundColor = [UIColor clearColor];
	levelHeight.backgroundColor = [UIColor clearColor];
	levelScore.backgroundColor = [UIColor clearColor];
	
	levelName.textColor = [UIColor whiteColor]; 
	levelStatus.textColor = [UIColor whiteColor]; 
	levelTime.textColor = [UIColor whiteColor]; 
	levelHeight.textColor = [UIColor whiteColor]; 
	levelScore.textColor = [UIColor whiteColor]; 
	
	levelName.tag = 1;
	levelStatus.tag = 2;
	levelTime.tag = 3;
	levelHeight.tag = 4;
	levelScore.tag = 5;
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	[[cell contentView] addSubview:levelName];
	[[cell contentView] addSubview:levelStatus];
	[[cell contentView] addSubview:levelTime];
	[[cell contentView] addSubview:levelHeight];
	[[cell contentView] addSubview:levelScore];
	
	[levelName release];
	[levelStatus release];
	[levelTime release];
	[levelHeight release];
	[levelScore release];
	
	UIImageView *cheaterBoxView = [[UIImageView alloc]initWithFrame:CGRectMake(381, 4, 62, 19)];
	cheaterBoxView.tag = 6;
	[[cell contentView] addSubview:cheaterBoxView];
	[cheaterBoxView release];
	
	return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
		cell = [self getCellContentView:CellIdentifier];
	
	if([self levelCanBeShown:indexPath.row+20])
	{
		
		GameCard *card = [[[WBManager sharedManager]currentUser]getGameCardForLevel:indexPath.row+20];
		
		UILabel *levelName = (UILabel *)[cell viewWithTag:1];
		UILabel *levelStatus = (UILabel *)[cell viewWithTag:2];
		UILabel *levelTime = (UILabel *)[cell viewWithTag:3];
		UILabel *levelHeight = (UILabel *)[cell viewWithTag:4];
		UILabel *levelScore = (UILabel *)[cell viewWithTag:5];
		
		UIImageView *cheaterBoxView = (UIImageView *)[cell viewWithTag:6];
		
		levelName.text = [self getLevelStringForIntValue:indexPath.row+20];
		levelStatus.text = card.score <= 0 ? @"Incomplete" : @"Complete";
		
		if(card.score != 0)
		{
			levelScore.text = [NSString stringWithFormat:@"Score: %i",card.score];
			levelTime.text = [NSString stringWithFormat:@"Best Time: %i mins %i secs",card.time/60,card.time%60];
			levelHeight.text = [NSString stringWithFormat:@"Lowest Height: %i",card.height];
		}
		
		else
		{
			levelScore.text = @"Score: -";
			levelTime.text = @"BestTime: -";
			levelHeight.text = @"Lowest Height: -";
		}
		
		UIImage *screenshot = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"WSimg%i",indexPath.row+1+20] ofType:@"PNG"]];
		
		cell.imageView.image = screenshot;
		
		[screenshot release];
		
		//IF Cheated
		if(card.didCheat == YES)
		{
			UIImage *cheaterBox = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cheaterBox" ofType:@"png"]];
			[cheaterBoxView setImage:cheaterBox];
			//[cell addSubview: cheaterBoxView];
			[cheaterBox release];			
		}
		
		else {
			[cheaterBoxView setImage:nil];
		}
		
	}
	
	else
	{
		UILabel *levelName = (UILabel *)[cell viewWithTag:1];
		UILabel *levelStatus = (UILabel *)[cell viewWithTag:2];
		UILabel *levelTime = (UILabel *)[cell viewWithTag:3];
		UILabel *levelHeight = (UILabel *)[cell viewWithTag:4];
		UILabel *levelScore = (UILabel *)[cell viewWithTag:5];
		
		UIImageView *cheaterBoxView = (UIImageView *)[cell viewWithTag:6];
		
		levelName.text = [self getLevelStringForIntValue:indexPath.row+20];
		levelStatus.text = @"LOCKED";
		levelTime.text = @"";
		levelHeight.text = @"";
		levelScore.text = @"";
		
		UIImage *screenshot = [[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"WSimg%i",indexPath.row+1+20] ofType:@"PNG"]];
		
		cell.imageView.image = screenshot;
		
		[screenshot release];
		
		[cheaterBoxView setImage:nil];
	}
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([self levelCanBeShown:[indexPath row]+20])
	{		
		canContinue = NO;

		//Sets the selected level from the table
		selectedIndex = [indexPath row];
		
		Level *customLevel = [NSKeyedUnarchiver unarchiveObjectWithFile:[locationLevels objectAtIndex:selectedIndex]];//filePath
		[[WBManager sharedManager] setLevelFile:[locationLevels objectAtIndex:selectedIndex]];
		[[WBManager sharedManager] setLoadWithGameLevel:YES];
		
		GameScene *scene = [GameScene node];
		[scene setLocation: customLevel.location];
		[[CCDirector sharedDirector] replaceScene:scene];
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//Height for each table cell being created is 110
	return 110;
}

-(NSString *)getLevelStringForIntValue:(int)val
{
	int number = val + 1;
	
	switch(number)
	{
		case 1:
			return @"Worksite 1";
			break;
		case 2:
			return @"Worksite 2";
			break;
		case 3:
			return @"Worksite 3";
			break;
		case 4:
			return @"Worksite 4";
			break;
		case 5:
			return @"Worksite 5";
			break;
		case 6:
			return @"Worksite 6";
			break;
		case 7:
			return @"Worksite 7";
			break;
		case 8:
			return @"Worksite 8";
			break;
		case 9:
			return @"Worksite 9";
			break;
		case 10:
			return @"Worksite 10";
			break;
		case 11:
			return @"Worksite 11";
			break;
		case 12:
			return @"Worksite 12";
			break;
		case 13:
			return @"Worksite 13";
			break;
		case 14:
			return @"Worksite 14";
			break;
		case 15:
			return @"Worksite 15";
			break;
		case 16:
			return @"Worksite 16";
			break;
		case 17:
			return @"Worksite 17";
			break;
		case 18:
			return @"Worksite 18";
			break;
		case 19:
			return @"Worksite 19";
			break;
		case 20:
			return @"Worksite 20";
			break;
		case 21:
			return @"Worksite 21";
			break;
		case 22:
			return @"Worksite 22";
			break;
		case 23:
			return @"Worksite 23";
			break;
		case 24:
			return @"Worksite 24";
			break;
		case 25:
			return @"Worksite 25";
			break;
		case 26:
			return @"Worksite 26";
			break;
		case 27:
			return @"Worksite 27";
			break;
		case 28:
			return @"Worksite 28";
			break;
		case 29:
			return @"Worksite 29";
			break;
		case 30:
			return @"Worksite 30";
			break;
		default:
			break;
	}
	
	return nil;
}

-(int)getLatestLevelIndex
{
	int index = -1;
	
	for(int i = 20; i <= 29; i++)
	{
		GameCard *card=[[[WBManager sharedManager]currentUser]getGameCardForLevel:i];
		if(card.score != 0)index=i;
	}
	
	if(index != 29 && index != -1)return index+1;
	else if(index == 29)return index;
	else return 20;
}

#pragma mark -
#pragma mark cleanup

-(void)onExit
{	
	[table removeFromSuperview];
	[table release];
	[super onExit];
}

-(void)dealloc
{
	[loading removeFromSuperview];
	[loading release];
	[locationLevels release];
	[super dealloc];
}

@end
