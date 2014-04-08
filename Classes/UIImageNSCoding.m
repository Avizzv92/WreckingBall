//
//  UIImageNSCoding.m
//  Wrecking Ball
//
//  Created by Aaron Vizzini on 5/15/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "UIImageNSCoding.h"

@implementation UIImage(NSCoding)
- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        NSData *data = [decoder decodeObjectForKey:@"UIImage"];
        self = [self initWithData:data];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSData *data = UIImagePNGRepresentation(self);
    [encoder encodeObject:data forKey:@"UIImage"];
}

@end
