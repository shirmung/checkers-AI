//
//  Piece.h
//  Checkers
//
//  Created by Shirmung Bielefeld on 1/29/12.
//  Copyright (c) 2012. All rights reserved.
//

@interface Piece : NSObject <NSCoding>
{
    NSString *player;
    NSString *type;
    
    NSNumber *a;
    NSNumber *b;
    
    NSNumber *right;
    NSNumber *left;
    
    NSNumber *rightFront;
    NSNumber *rightBack;
    NSNumber *leftFront;
    NSNumber *leftBack;
    
    NSMutableArray *neighbors;
}

@property (nonatomic, retain) NSString *player;
@property (nonatomic, retain) NSString *type;

@property (nonatomic, retain) NSNumber *a;
@property (nonatomic, retain) NSNumber *b;

@property (nonatomic, retain) NSNumber *right;
@property (nonatomic, retain) NSNumber *left;

@property (nonatomic, retain) NSNumber *rightFront;
@property (nonatomic, retain) NSNumber *rightBack;
@property (nonatomic, retain) NSNumber *leftFront;
@property (nonatomic, retain) NSNumber *leftBack;

@property (nonatomic, retain) NSMutableArray *neighbors;

@end
