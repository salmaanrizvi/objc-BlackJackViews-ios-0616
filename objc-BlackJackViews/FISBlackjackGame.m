//
//  FISBlackjackGame.m
//  BlackJack
//
//  Created by Salmaan Rizvi on 6/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackGame.h"

@implementation FISBlackjackGame

-(instancetype) init {
    self = [super init];
    
    if (self) {
        _deck = [[FISCardDeck alloc] init];
        _house = [[FISBlackjackPlayer alloc] initWithName:@"House"];
        _player = [[FISBlackjackPlayer alloc] initWithName:@"Player"];
    }
    
    return self;
}

-(void) playBlackjack {
    
    NSLog(@"Starting a new game of Blackjack");
    [self.deck resetDeck];
    [self.player resetForNewGame];
    [self.house resetForNewGame];
    [self dealNewRound];
    
    for(NSUInteger i = 0; i < 3; i++) {
        
        if (self.player.busted || self.house.busted) {
            break;
        }
        else {
            [self processPlayerTurn];
            [self processHouseTurn];
        }
    }
    
    [self incrementWinsAndLossesForHouseWins:[self houseWins]];
    NSLog(@"%@", self.house);
    NSLog(@"%@", self.player);
}

-(void) dealNewRound {
    for(NSUInteger i = 0; i < 2; i++) {
        [self dealCardToHouse];
        [self dealCardToPlayer];
    }
}

-(void)deal {
    NSLog(@"Starting a new game of Blackjack");
    [self.deck resetDeck];
    [self.player resetForNewGame];
    [self.house resetForNewGame];
    [self dealNewRound];
}

-(void) dealCardToPlayer {
    [self.player acceptCard:[self.deck drawNextCard]];
}

-(void) dealCardToHouse {
    [self.house acceptCard:[self.deck drawNextCard]];
}

-(void) processPlayerTurn {
    if (self.player.shouldHit) {
        [self dealCardToPlayer];
    }
}

-(void) processHouseTurn {
    if (self.house.shouldHit) {
        [self dealCardToHouse];
    }
}

-(BOOL) houseWins {
    if (self.player.busted) { // House wins if player busted, regardless of whether the house
        return YES;
    }
    else if (self.house.busted && !self.player.busted) { // House loses if busted and the player hasn't
        return NO;
    }
    else if (self.player.blackjack && self.house.blackjack) { // House loses if both house and player have blackjack
        return NO;
    }
    else if (self.player.handscore == self.house.handscore) { // House wins in a draw except in blackjack scenario
        return YES;
    }
    else if (self.player.handscore < self.house.handscore) { // House wins if it's handscore exceeds the players
        return YES;
    }
    else { // Otherwise no house win
        return NO;
    }
}

-(void) incrementWinsAndLossesForHouseWins:(BOOL)houseWins {
    if (houseWins) {
        self.house.wins++;
        self.player.losses++;
    }
    else {
        self.house.losses++;
        self.player.wins++;
    }
}

@end
