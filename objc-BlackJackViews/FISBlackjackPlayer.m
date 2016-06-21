//
//  FISBlackjackPlayer.m
//  BlackJack
//
//  Created by Salmaan Rizvi on 6/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackPlayer.h"

@implementation FISBlackjackPlayer

-(instancetype) init {
    return [self initWithName:@""];
}
-(instancetype) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        _cardsInHand = [[NSMutableArray alloc] init];
        _handscore = _wins = _losses = 0;
        _aceInHand = _blackjack = _busted = _stayed = NO;
    }
    return self;
}

-(void) resetForNewGame {
    
    [self.cardsInHand removeAllObjects];
    self.handscore = 0;
    self.aceInHand = self.blackjack = self.busted = self.stayed = NO;
    
}

-(void) acceptCard:(FISCard *)card {
    
    [self.cardsInHand addObject:card];
    self.handscore += card.cardValue;
    
    if(card.cardValue == 1) {
        self.aceInHand = YES;
        if (self.handscore <= 11) {
            self.handscore += 10; // Uses the ace as a "soft 11"
        }
    }
    
    if (self.handscore == 21 && self.cardsInHand.count == 2) {
        self.blackjack = YES;
    }
    
    if (self.handscore > 21) {
        self.busted = YES;
        self.blackjack = NO;
    }
    
    
}

-(BOOL) shouldHit {
    if (self.handscore >= 17 || self.stayed == YES || self.busted == YES) {
        self.stayed = YES;
        return NO;
    }
    return YES;
}

-(NSString *)description {

    NSMutableString *cards = [@"" mutableCopy];
    for (FISCard *card in self.cardsInHand) {
        [cards appendFormat:@"%@ ", card];
    }
    
    NSMutableString *description = [NSMutableString stringWithFormat:@"\n  Name: %@ \n  Cards: %@ \n  Handscore: %lu \n  Ace in Hand?: %d \n  Stayed?: %d \n  Blackjack?: %d \n  Busted?: %d \n  Wins: %lu \n  Losses: %lu", self.name, cards, self.handscore, self.aceInHand, self.stayed, self.blackjack, self.busted, self.wins, self.losses];
    
    return description;
}

@end
