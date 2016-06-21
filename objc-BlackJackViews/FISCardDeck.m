//
//  FISCardDeck.m
//  OOP-Cards-Model
//
//  Created by Salmaan Rizvi on 6/15/16.
//  Copyright © 2016 Al Tyus. All rights reserved.
//

#import "FISCardDeck.h"

@implementation FISCardDeck

-(instancetype)init {
    self = [super init];
    
    if (self) {
        _remainingCards = [[NSMutableArray alloc] init];
        _dealtCards = [[NSMutableArray alloc] init];
        [self generateDeck];
    }
    
    return self;
}

-(void)generateDeck {
    for (NSString *suit in [FISCard validSuits]) {
        for (NSString *rank in [FISCard validRanks]) {
            [self.remainingCards addObject:[[FISCard alloc] initWithSuit:suit rank:rank]];
        }
    }
}

-(FISCard *) drawNextCard {
    
    if (self.remainingCards.count == 0) {
        NSLog(@"There are no remaining cards in the deck.");
        return nil;
    }
    else {
        FISCard *drawnCard = self.remainingCards[0];
        [self.remainingCards removeObjectAtIndex:0];
        [self.dealtCards addObject:drawnCard];
        return drawnCard;
    }
}

-(void) resetDeck {
    [self gatherDealtCards];
    [self shuffleRemainingCards];
}

-(void) gatherDealtCards {
    while (self.dealtCards.count != 0) {
        [self.remainingCards addObject:self.dealtCards[0]];
        [self.dealtCards removeObjectAtIndex:0];
    }
}

-(void) shuffleRemainingCards {
    NSMutableArray *mutableRemainingCards = [self.remainingCards mutableCopy];
    [self.remainingCards removeAllObjects];
    
    while(mutableRemainingCards.count != 0) {
        NSUInteger randomIndex = arc4random_uniform((uint32_t)mutableRemainingCards.count);
        FISCard *randomCard = mutableRemainingCards[randomIndex];
        [self.remainingCards addObject:randomCard];
        [mutableRemainingCards removeObjectAtIndex:randomIndex];
    }
}

-(NSString *)description {
    NSMutableString *cardDeck = [@"\nDeck count: " mutableCopy];
    [cardDeck appendFormat:@"%lu \nCards: ", self.remainingCards.count];
    
    for (NSUInteger i = 0; i < self.remainingCards.count; i++) {
        if (i % 13 == 0) {
            [cardDeck appendString:@"\n"];
        }
        [cardDeck appendFormat:@"%@ ", self.remainingCards[i]];
    }
    
    return cardDeck;
}

@end
