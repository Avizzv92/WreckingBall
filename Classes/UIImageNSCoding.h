//
//  UIImageNSCoding.h
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/15/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

//For encoding and decoding UIImages
@interface UIImageNSCoding <NSCoding>
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
@end