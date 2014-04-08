//
//  WBManager.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/16/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "WBManager.h"

static WBManager *sharedInstance = nil;

@implementation WBManager
@synthesize loadWithEditor,loadWithGameLevel,currentUser;

#pragma mark -
#pragma mark class instance methods
-(void)setLevelFile:(NSString *)level
{
	levelToLoad = level;
}

-(NSString *)getLevelFile
{
	return levelToLoad;	
}

-(NSString *)getFont
{
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 4.0)return @"Chalkduster";
	else return @"Marker Felt";
}

-(int)getFontSizeForSize:(int)size
{
	int newSize = size;
	
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 4.0)newSize = newSize;
	else newSize += 4;
	
	return newSize;
}
	

#pragma mark -
#pragma mark Singleton methods

+ (WBManager*)sharedManager
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
			sharedInstance = [[WBManager alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(id)retain{
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}

-(void)release {
    //do nothing
}

-(id)autorelease {
    return self;
}

@end

