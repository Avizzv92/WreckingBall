//
//  Wrecking_BallAppDelegate.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 3/17/10.
//  Copyright Home 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Wrecking_BallAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
}

@property (nonatomic, retain) UIWindow *window;
-(void)updateUserProfiles;
@end
