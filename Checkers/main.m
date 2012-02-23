//
//  main.m
//  Checkers
//
//  Created by Shirmung Bielefeld on 1/29/12.
//  Copyright (c) 2012 NYU. All rights reserved.
//

#import "Game.h"

int main (int argc, const char * argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    Game *newGame = [[Game alloc] init];
    
    [newGame release];
    
    [pool drain];
    
    return 0;
}
