//
//  Game.m
//  Checkers
//
//  Created by Shirmung Bielefeld on 1/29/12.
//  Copyright (c) 2012 NYU. All rights reserved.
//

#import "Game.h"
#import "Piece.h"

#include <stdlib.h>

@implementation Game

@synthesize currentBoard, currentMoves, currentJumps;
@synthesize limboBoard, limboMoves, limboJumps;
@synthesize ratedOptions;

- (id)init
{
    self = [super init];
    
    if (self) 
    {
        currentBoard  = [[NSMutableArray alloc] init];
        currentMoves = [[NSMutableArray alloc] init];
        currentJumps = [[NSMutableArray alloc] init];
        
        ratedOptions = [[NSMutableArray alloc] init];
        
        gameOver = FALSE;
        
        [self initializeBoard:currentBoard];
        [self simulateGame:currentBoard :currentMoves :currentJumps];
        
        [self printBoard:currentBoard];
    }
    
    return self;
}

- (void)dealloc
{
    [currentBoard release];
    [currentMoves release];
    [currentJumps release];
 
    [ratedOptions release];

    [super dealloc];
}

#pragma mark - method(s) for board initializing

- (void)initializeBoard:(NSMutableArray *)board
{
    for (int a = 0; a <= 7; a++)
    {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        
        for (int b = 0; b <= 7; b++) 
        {
            Piece *piece = [[[Piece alloc] init] autorelease];
            
            piece.player = @"empty";
            piece.type = @"empty";
            
            piece.a = [NSNumber numberWithInt:a];
            piece.b = [NSNumber numberWithInt:b];
            
            [row insertObject:piece atIndex:b];
		}
        
        [board addObject:row];
	}
    
    for (int a = 0; a <= 7; a++)
    {
        for (int b = 0; b <= 7; b++) 
        {
            if ((a + b) % 2 == 1) 
            {
                if (a == 0 || a == 1 || a == 2) {
                    Piece *piece = [[[Piece alloc] init] autorelease];
                    
                    piece.player = @"red";
                    piece.type = @"red";
                    
                    piece.a = [NSNumber numberWithInt:a];
                    piece.b = [NSNumber numberWithInt:b];
                    
                    piece.right = [NSNumber numberWithInt:0];
                    piece.left = [NSNumber numberWithInt:1];
                    
                    piece.rightFront = [NSNumber numberWithInt:2];
                    piece.rightBack = [NSNumber numberWithInt:0];
                    piece.leftFront = [NSNumber numberWithInt:3];
                    piece.leftBack = [NSNumber numberWithInt:1];
                    
                    [[board objectAtIndex:a] replaceObjectAtIndex:b withObject:piece];
				} else if (a == 5 || a == 6 || a == 7) {
                    Piece *piece = [[[Piece alloc] init] autorelease];
                    
                    piece.player = @"white";
                    piece.type = @"white";
                    
                    piece.a = [NSNumber numberWithInt:a];
                    piece.b = [NSNumber numberWithInt:b];
                    
                    piece.right = [NSNumber numberWithInt:1];
                    piece.left = [NSNumber numberWithInt:0];
                    
                    piece.rightFront = [NSNumber numberWithInt:1];
                    piece.rightBack = [NSNumber numberWithInt:3];
                    piece.leftFront = [NSNumber numberWithInt:0];
                    piece.leftBack = [NSNumber numberWithInt:2];
                    
                    [[board objectAtIndex:a] replaceObjectAtIndex:b withObject:piece];
				}
			}
		}
	}
}

#pragma mark - method(s) for general game play

- (void)simulateGame:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps
{
    for (int m = 1; m <= 3; m++) 
    {
        if (gameOver == FALSE)
        {
            [self expandOut:board :moves :jumps :@"red"];
            
            [moves removeAllObjects];
            [jumps removeAllObjects];
        }
        
        if (gameOver == FALSE)
        {
            [self expandOut:board :moves :jumps :@"white"];
            
            [moves removeAllObjects];
            [jumps removeAllObjects];
        }
        
        if (gameOver == TRUE) break;
    }
}

#pragma mark - method(s) for discovering moves/jumps

- (void)expandOut:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player
{
    [self findOptions:board :moves :jumps :player];
    
    if ([moves count] != 0 || [jumps count] != 0) {
        [self evaluateOptions:board :moves :jumps :player];
    } else {
        gameOver = TRUE;
        
        NSLog(@"%@ lost...bummer", player);
    }
}

- (void)findOptions:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player
{
    for (int a = 0; a <= 7; a++) 
    {
        for (int b = 0; b <= 7; b++) 
        {
            if ((a + b) % 2 == 1) 
            {
                Piece *piece = [[board objectAtIndex:a] objectAtIndex:b];
                
                if ([piece.player isEqualToString:player]) [self exploitOptions:board :moves :jumps :piece];
            }
        }
    }
}

- (void)exploitOptions:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(Piece *)piece
{
    [self neighbors:board :piece];

    if ([piece.type isEqualToString:[NSString stringWithFormat:@"%@ king", piece.player]]) 
    {
        if (![[piece.neighbors objectAtIndex:[piece.rightBack intValue]] isEqualToString:@""]) 
        {
            [self checkOptions:board :moves :jumps :[piece.neighbors objectAtIndex:[piece.rightBack intValue]] :piece :[piece.right intValue] :TRUE];
        }
            
        if (![[piece.neighbors objectAtIndex:[piece.leftBack intValue]] isEqualToString:@""]) 
        {
            [self checkOptions:board :moves :jumps :[piece.neighbors objectAtIndex:[piece.leftBack intValue]] :piece :[piece.left intValue] :TRUE];
        }
    }
        
    if (![[piece.neighbors objectAtIndex:[piece.rightFront intValue]] isEqualToString:@""]) 
    {
        [self checkOptions:board :moves :jumps :[piece.neighbors objectAtIndex:[piece.rightFront intValue]] :piece :[piece.right intValue] :FALSE];
    }
        
    if (![[piece.neighbors objectAtIndex:[piece.leftFront intValue]] isEqualToString:@""])
    {
        [self checkOptions:board :moves :jumps :[piece.neighbors objectAtIndex:[piece.leftFront intValue]] :piece :[piece.left intValue] :FALSE];
    }
}

- (void)checkOptions:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)tag :(Piece *)piece :(int)diagonal :(BOOL)backwards
{
    if ([tag hasPrefix:@"empty"]) {
        [moves addObject:[NSString stringWithFormat:@"%i,%i move to %@", [piece.a intValue], [piece.b intValue], tag]];
    } else if (![tag hasPrefix:[NSString stringWithFormat:@"%@", piece.player]]) {
        int aa, bb;
        
        if (backwards == TRUE) {
            if ([piece.player isEqualToString:@"white"]) aa = [piece.a intValue] + 2;
            else if ([piece.player isEqualToString:@"red"]) aa = [piece.a intValue] - 2;
        } else if (backwards == FALSE) {
            if ([piece.player isEqualToString:@"white"]) aa = [piece.a intValue] - 2;
            else if ([piece.player isEqualToString:@"red"]) aa = [piece.a intValue] + 2;
        }
        
        if (diagonal == 0) bb = [piece.b intValue] - 2;
        else if (diagonal == 1) bb = [piece.b intValue] + 2;

        if (aa >= 0 && aa <= 7 && bb >= 0 && bb <= 7) 
        {
            Piece *questionablePiece = [[board objectAtIndex:aa] objectAtIndex:bb]; 
                        
            if ([questionablePiece.type isEqualToString:@"empty"]) 
            {
                [jumps addObject:[NSString stringWithFormat:@"%i,%i jump over %@ to %i,%i", [piece.a intValue], [piece.b intValue], tag, aa, bb]];
            }
        }
    } 
}

#pragma mark - method(s) to move/jump

- (void)evaluateOptions:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player
{
    [self saveCurrentState];
    
    int value = [self alphaBetaSearch:limboBoard :limboMoves :limboJumps :player];
    
    NSLog(@"%i", value);
    NSLog(@"%@", ratedOptions);
    
    for (NSString *ratedOption in ratedOptions) 
    {
        if ([[ratedOption substringWithRange:NSMakeRange(0, 1)] intValue] == value) 
        { 
            if (jumps.count != 0) [self makeJump:board :moves :jumps :(int)[ratedOptions indexOfObject:ratedOption]];
            else [self makeMove:board :moves :(int)[ratedOptions indexOfObject:ratedOption]];
            
            break;
        }
    }
    
    [ratedOptions removeAllObjects];
}

- (void)makeMove:(NSMutableArray *)board :(NSMutableArray *)moves :(int)index
{
    NSString *move = [moves objectAtIndex:index];
    //NSLog(@"make move: %@", move);
    
    int a = [[move substringWithRange:NSMakeRange(0, 1)] intValue];
    int b = [[move substringWithRange:NSMakeRange(2, 1)] intValue];
    
    Piece *activePiece = [[board objectAtIndex:a] objectAtIndex:b];
    
    activePiece.a = [NSNumber numberWithInt:[[move substringWithRange:NSMakeRange([move length] - 3, 1)] intValue]];
    activePiece.b = [NSNumber numberWithInt:[[move substringWithRange:NSMakeRange([move length] - 1, 1)] intValue]];
    
    [self handleKinging:activePiece];
    
    [[board objectAtIndex:[activePiece.a intValue]] replaceObjectAtIndex:[activePiece.b intValue] withObject:activePiece];
    
    Piece *emptyPiece = [[[Piece alloc] init] autorelease];
    
    emptyPiece.player = @"empty";
    emptyPiece.type = @"empty";
    
    emptyPiece.a = [NSNumber numberWithInt:a];
    emptyPiece.b = [NSNumber numberWithInt:b];
    
    [[board objectAtIndex:a] replaceObjectAtIndex:b withObject:emptyPiece];
}

- (void)makeJump:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(int)index
{
    NSString *jump = [jumps objectAtIndex:index];
    //NSLog(@"make jump: %@", jump);
    
    int a = [[jump substringWithRange:NSMakeRange(0, 1)] intValue];
    int b = [[jump substringWithRange:NSMakeRange(2, 1)] intValue];
    
    Piece *activePiece = [[board objectAtIndex:a] objectAtIndex:b];
    
    activePiece.a = [NSNumber numberWithInt:[[jump substringWithRange:NSMakeRange([jump length] - 3, 1)] intValue]];
    activePiece.b = [NSNumber numberWithInt:[[jump substringWithRange:NSMakeRange([jump length] - 1, 1)] intValue]];
    
    BOOL justKinged = [self handleKinging:activePiece];
    
    [[board objectAtIndex:[activePiece.a intValue]] replaceObjectAtIndex:[activePiece.b intValue] withObject:activePiece];
    
    Piece *emptyPiece1 = [[[Piece alloc] init] autorelease];
    
    emptyPiece1.player = @"empty";
    emptyPiece1.type = @"empty";
    
    emptyPiece1.a = [NSNumber numberWithInt:[[jump substringWithRange:NSMakeRange([jump length] - 10, 1)] intValue]];
    emptyPiece1.b = [NSNumber numberWithInt:[[jump substringWithRange:NSMakeRange([jump length] - 8, 1)] intValue]];
    
    [[board objectAtIndex:[emptyPiece1.a intValue]] replaceObjectAtIndex:[emptyPiece1.b intValue] withObject:emptyPiece1];
    
    Piece *emptyPiece2 = [[[Piece alloc] init] autorelease];
    
    emptyPiece2.player = @"empty";
    emptyPiece2.type = @"empty";
    
    emptyPiece2.a = [NSNumber numberWithInt:a];
    emptyPiece2.b = [NSNumber numberWithInt:b];
    
    [[board objectAtIndex:a] replaceObjectAtIndex:b withObject:emptyPiece2];
    
    if (justKinged == FALSE) [self handleMultipleJumps:board :moves :jumps :activePiece];
}

#pragma mark - method(s) for decision making

- (void)saveCurrentState 
{ 
    NSData *currentBoardBuffer = [NSKeyedArchiver archivedDataWithRootObject:currentBoard];
    limboBoard = [NSKeyedUnarchiver unarchiveObjectWithData:currentBoardBuffer];
    
    NSData *currentMovesBuffer = [NSKeyedArchiver archivedDataWithRootObject:currentMoves];
    limboMoves = [NSKeyedUnarchiver unarchiveObjectWithData:currentMovesBuffer];
    
    NSData *currentJumpsBuffer = [NSKeyedArchiver archivedDataWithRootObject:currentJumps];
    limboJumps = [NSKeyedUnarchiver unarchiveObjectWithData:currentJumpsBuffer];
}

- (int)alphaBetaSearch:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player
{
    int value = [self maxValue:board :moves :jumps :player :0 :-1000000 :1000000];
    return value;
}

- (int)maxValue:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player :(int)level :(int)alpha :(int)beta
{
    NSData *levelBoardBuffer = [NSKeyedArchiver archivedDataWithRootObject:board];
    NSMutableArray *levelBoard = [NSKeyedUnarchiver unarchiveObjectWithData:levelBoardBuffer];
    
    NSMutableArray *levelMoves = [[[NSMutableArray alloc] init] autorelease]; 
    NSMutableArray *levelJumps = [[[NSMutableArray alloc] init] autorelease];
    
    int value = alpha;
    
    [self findOptions:levelBoard :levelMoves :levelJumps :player];
    
    if ([self terminalTest:level] && [levelJumps count] == 0) return [self utility:levelBoard];

    if ([levelJumps count] != 0) 
    {
        while ([levelJumps count] != 0) 
        {
            [self makeJump:levelBoard :levelMoves :levelJumps :0];
        
            value = MAX(value, [self minValue:levelBoard :levelMoves :levelJumps :player :(level + 1) :alpha :beta]);
            
            if (level == 0) [ratedOptions addObject:[NSString stringWithFormat:@"%i %@", value, [levelJumps objectAtIndex:0]]];
            
            [levelJumps removeObjectAtIndex:0];
            
            if (value >= beta) return value;
            
            alpha = MAX(alpha, value);
        }
    } else {
        while ([levelMoves count] != 0)
        {
            [self makeMove:levelBoard :levelMoves :0];
        
            value = MAX(value, [self minValue:levelBoard :levelMoves :jumps :player :(level + 1) :alpha :beta]);
        
            if (level == 0) [ratedOptions addObject:[NSString stringWithFormat:@"%i %@", value, [levelMoves objectAtIndex:0]]];
            
            [levelMoves removeObjectAtIndex:0];
            
            if (value >= beta) return value;
            
            alpha = MAX(alpha, value);
        }
    }
    
    return value;
}

- (int)minValue:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player :(int)level :(int)alpha :(int)beta
{    
    NSData *levelBoardBuffer = [NSKeyedArchiver archivedDataWithRootObject:board];
    NSMutableArray *levelBoard = [NSKeyedUnarchiver unarchiveObjectWithData:levelBoardBuffer];
    
    NSMutableArray *levelMoves = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *levelJumps = [[[NSMutableArray alloc] init] autorelease];
    
    int value = beta;
    
    if ([self terminalTest:level] && [levelJumps count] == 0) return [self utility:levelBoard];

    if ([player isEqualToString:@"red"]) [self findOptions:levelBoard :levelMoves :levelJumps :@"white"];
    else if ([player isEqualToString:@"white"]) [self findOptions:levelBoard :levelMoves :levelJumps :@"red"];

    if ([levelJumps count] != 0) 
    {
        while ([levelJumps count] != 0) 
        {
            [self makeJump:levelBoard :levelMoves :levelJumps :0];

            value = MIN(value, [self maxValue:levelBoard :levelMoves :levelJumps :player :(level + 1) :alpha :beta]);

            if (level == 0) [ratedOptions addObject:[NSString stringWithFormat:@"%i %@", value, [levelJumps objectAtIndex:0]]];
            
            [levelJumps removeObjectAtIndex:0];
            
            if (value <= alpha) return value;
            
            beta = MIN(beta, value);
        }
    } else {
        while ([levelMoves count] != 0)
        {
            [self makeMove:levelBoard :levelMoves :0];
            
            value = MIN(value, [self maxValue:levelBoard :levelMoves :levelJumps :player :(level + 1) :alpha :beta]);
            
            if (level == 0) [ratedOptions addObject:[NSString stringWithFormat:@"%i %@", value, [levelMoves objectAtIndex:0]]];
        
            [levelMoves removeObjectAtIndex:0];
            
            if (value <= alpha) return value;
            
            beta = MIN(beta, value);
        }
    }
    
    return value;
}

- (BOOL)terminalTest:(int)level
{
    if (level >= 6) return TRUE;
    else return FALSE; 
}

- (int)utility:(NSMutableArray *)board
{
    int value = arc4random() % 9;
    return value;
}

#pragma mark - method(s) that help out

- (void)neighbors:(NSMutableArray *)board :(Piece *)piece
{    
    [piece.neighbors removeAllObjects];
    
    int a = [piece.a intValue];
    int b = [piece.b intValue];
    
    if (((a - 1) >= 0) && ((b - 1) >= 0)) {
        Piece *neighborPiece = [[board objectAtIndex:(a - 1)] objectAtIndex:(b - 1)];
        [piece.neighbors addObject:[NSString stringWithFormat:@"%@ at %i,%i", neighborPiece.type, a - 1, b - 1]];
    } else {
        [piece.neighbors addObject:@""];
    }
    
    if (((a - 1) >= 0) && ((b + 1) <= 7)) {
        Piece *neighborPiece = [[board objectAtIndex:(a - 1)] objectAtIndex:(b + 1)];
        [piece.neighbors addObject:[NSString stringWithFormat:@"%@ at %i,%i", neighborPiece.type, a - 1, b + 1]];
    } else {
        [piece.neighbors addObject:@""];
    }
    
    if (((a + 1) <= 7) && ((b - 1) >= 0)) {
        Piece *neighborPiece = [[board objectAtIndex:(a + 1)] objectAtIndex:(b - 1)];
        [piece.neighbors addObject:[NSString stringWithFormat:@"%@ at %i,%i", neighborPiece.type, a + 1, b - 1]];
    } else {
        [piece.neighbors addObject:@""];
    }
    
    if (((a + 1) <= 7) && ((b + 1) <= 7)) {
        Piece *neighborPiece = [[board objectAtIndex:(a + 1)] objectAtIndex:(b + 1)];
        [piece.neighbors addObject:[NSString stringWithFormat:@"%@ at %i,%i", neighborPiece.type, a + 1, b + 1]];
    } else {
        [piece.neighbors addObject:@""];
    }
}

- (BOOL)handleKinging:(Piece *)piece
{
    if (![piece.type isEqualToString:[NSString stringWithFormat:@"%@ king", piece.player]])
    {
        if ([piece.a intValue] == 0 && [piece.player isEqualToString:@"white"]) {
            piece.type = [NSString stringWithFormat:@"%@ king", piece.player];
            
            return TRUE;
        } else if ([piece.a intValue] == 7 && [piece.player isEqualToString:@"red"]) {
            piece.type = [NSString stringWithFormat:@"%@ king", piece.player];

            return TRUE;
        }
    }
    
    return FALSE;
}

- (void)handleMultipleJumps:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(Piece *)piece
{
    NSMutableArray *additionalJumps = [[[NSMutableArray alloc] init] autorelease];
    
    [self exploitOptions:board :moves :additionalJumps :piece];
    
    if (additionalJumps.count != 0) [self makeJump:board :moves :additionalJumps :0];
}

- (void)printBoard:(NSMutableArray *)board
{
    for (int a = 0; a <= 7; a++) 
    {
        NSLog(@"row: %i", a);
        
        for (int b = 0; b <= 7; b++) 
        {
            Piece *piece = [[board objectAtIndex:a] objectAtIndex:b];
                
            NSLog(@"    %@", piece.type);
        }
    }
}

@end