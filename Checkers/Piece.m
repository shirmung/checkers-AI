//
//  Piece.m
//  Checkers
//
//  Created by Shirmung Bielefeld on 1/29/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "Piece.h"

@implementation Piece

@synthesize player, type;
@synthesize a, b;
@synthesize right, left;
@synthesize rightFront, rightBack, leftFront, leftBack;
@synthesize neighbors;

- (id)init
{
    self = [super init];
    
    if (self) {        
        neighbors = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [player release];
    [type release];
    
    [a release];
    [b release];
    
    [right release];
    [left release];
    
    [rightFront release];
    [rightBack release];
    [leftFront release];
    [leftBack release];
    
    [neighbors release];
    
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
    if (self = [super init]) {
        self.player = [decoder decodeObjectForKey:@"player"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.a = [decoder decodeObjectForKey:@"a"];
        self.b = [decoder decodeObjectForKey:@"b"];
        self.right = [decoder decodeObjectForKey:@"right"];
        self.left = [decoder decodeObjectForKey:@"left"];
        self.rightFront = [decoder decodeObjectForKey:@"rightFront"];
        self.rightBack = [decoder decodeObjectForKey:@"rightBack"];
        self.leftFront = [decoder decodeObjectForKey:@"leftFront"];
        self.leftBack = [decoder decodeObjectForKey:@"leftBack"];
        self.neighbors = [decoder decodeObjectForKey:@"neighbors"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:player forKey:@"player"];
    [encoder encodeObject:type forKey:@"type"];
    [encoder encodeObject:a forKey:@"a"];
    [encoder encodeObject:b forKey:@"b"];
    [encoder encodeObject:right forKey:@"right"];
    [encoder encodeObject:left forKey:@"left"];
    [encoder encodeObject:rightFront forKey:@"rightFront"];
    [encoder encodeObject:rightBack forKey:@"rightBack"];
    [encoder encodeObject:leftFront forKey:@"leftFront"];
    [encoder encodeObject:leftBack forKey:@"leftBack"];
    [encoder encodeObject:neighbors forKey:@"neighbors"];
}

@end
