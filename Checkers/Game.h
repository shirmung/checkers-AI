//
//  Game.h
//  Checkers
//
//  Created by Shirmung Bielefeld on 1/29/12.
//  Copyright (c) 2012 NYU. All rights reserved.
//

@class Piece;

@interface Game : NSObject
{
    NSMutableArray *currentBoard;
    NSMutableArray *currentMoves;
    NSMutableArray *currentJumps;
    
    NSMutableArray *limboBoard;
    NSMutableArray *limboMoves;
    NSMutableArray *limboJumps;
    
    NSMutableArray *ratedOptions;
    
    BOOL gameOver;
}

@property (nonatomic, retain) NSMutableArray *currentBoard;
@property (nonatomic, retain) NSMutableArray *currentMoves;
@property (nonatomic, retain) NSMutableArray *currentJumps;

@property (nonatomic, retain) NSMutableArray *limboBoard;
@property (nonatomic, retain) NSMutableArray *limboMoves;
@property (nonatomic, retain) NSMutableArray *limboJumps;

@property (nonatomic, retain) NSMutableArray *ratedOptions;

- (void)initializeBoard:(NSMutableArray *)board;

- (void)simulateGame:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps;

- (void)expandOut:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player;
- (void)findOptions:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player;
- (void)exploitOptions:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(Piece *)piece;
- (void)checkOptions:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)tag :(Piece *)piece :(int)diagonal :(BOOL)backwards;

- (void)evaluateOptions:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player;
- (void)makeMove:(NSMutableArray *)board :(NSMutableArray *)moves :(int)index;
- (void)makeJump:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(int)index;

- (void)setLimboObjects;
- (int)alphaBetaSearch:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player;
- (int)maxValue:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player :(int)level :(int)alpha :(int)beta;
- (int)minValue:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(NSString *)player :(int)count :(int)alpha :(int)beta;
- (BOOL)terminalTest:(int)count;

- (int)random:(NSMutableArray *)board;
- (int)regularPiecesCount:(NSMutableArray *)board :(NSString *)player;
- (int)kingPiecesCount:(NSMutableArray *)board :(NSString *)player;
- (int)defenseOverall:(NSMutableArray *)board :(NSString *)player;
- (int)defenseAgainstKings:(NSMutableArray *)board :(NSString *)player;
- (int)defenseOnSides:(NSMutableArray *)board :(NSString *)player;
- (int)optionsCount:(NSMutableArray *)board :(NSString *)player;
- (int)expert:(NSMutableArray *)board :(NSString *)player;

- (void)neighbors:(NSMutableArray *)board :(Piece *)piece;
- (BOOL)handleKinging:(Piece *)piece;
- (void)handleMultipleJumps:(NSMutableArray *)board :(NSMutableArray *)moves :(NSMutableArray *)jumps :(Piece *)piece;
- (void)printBoard:(NSMutableArray *)board;

@end