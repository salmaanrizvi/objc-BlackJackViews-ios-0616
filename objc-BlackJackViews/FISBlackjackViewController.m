//
//  FISBlackjackViewController.m
//  objc-BlackJackViews
//
//  Created by Salmaan Rizvi on 6/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackViewController.h"

@interface FISBlackjackViewController ()

// Game properties
@property (strong, nonatomic) IBOutlet UIButton *dealNewGameButton;
@property (strong, nonatomic) IBOutlet UILabel *winnerLabel;
@property (strong, nonatomic) NSMutableArray *houseCardLabelArray;
@property (strong, nonatomic) NSMutableArray *playerCardLabelArray;

// House properties
@property (strong, nonatomic) IBOutlet UILabel *houseScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *houseActionLabel;
@property (strong, nonatomic) IBOutlet UILabel *houseCardLabel1;
@property (strong, nonatomic) IBOutlet UILabel *houseCardLabel2;
@property (strong, nonatomic) IBOutlet UILabel *houseCardLabel3;
@property (strong, nonatomic) IBOutlet UILabel *houseCardLabel4;
@property (strong, nonatomic) IBOutlet UILabel *houseCardLabel5;
@property (strong, nonatomic) IBOutlet UILabel *houseWinsLabel;
@property (strong, nonatomic) IBOutlet UILabel *houseLossesLabel;
@property (strong, nonatomic) IBOutlet UILabel *houseBustedLabel;
@property (strong, nonatomic) IBOutlet UILabel *houseBlackjackLabel;

// Player properties
@property (strong, nonatomic) IBOutlet UILabel *playerScoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *playerHitButton;
@property (strong, nonatomic) IBOutlet UIButton *playerStayButton;
@property (strong, nonatomic) IBOutlet UILabel *playerCardLabel1;
@property (strong, nonatomic) IBOutlet UILabel *playerCardLabel2;
@property (strong, nonatomic) IBOutlet UILabel *playerCardLabel3;
@property (strong, nonatomic) IBOutlet UILabel *playerCardLabel4;
@property (strong, nonatomic) IBOutlet UILabel *playerCardLabel5;
@property (strong, nonatomic) IBOutlet UILabel *playerWinsLabel;
@property (strong, nonatomic) IBOutlet UILabel *playerLossesLabel;
@property (strong, nonatomic) IBOutlet UILabel *playerBustedLabel;
@property (strong, nonatomic) IBOutlet UILabel *playerBlackjackLabel;
@property (strong, nonatomic) IBOutlet UILabel *playerActionLabel;

@end

@implementation FISBlackjackViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.houseCardLabelArray = [@[self.houseCardLabel1, self.houseCardLabel2, self.houseCardLabel3, self.houseCardLabel4, self.houseCardLabel5] mutableCopy];

    self.playerCardLabelArray = [@[self.playerCardLabel1, self.playerCardLabel2, self.playerCardLabel3, self.playerCardLabel4, self.playerCardLabel5] mutableCopy];
    
    self.houseWinsLabel.text = [NSString stringWithFormat:@"Wins: %lu", self.game.house.wins];
    self.houseLossesLabel.text = [NSString stringWithFormat:@"Losses: %lu", self.game.house.losses];
    self.playerWinsLabel.text = [NSString stringWithFormat:@"Wins: %lu", self.game.player.wins];
    self.playerLossesLabel.text = [NSString stringWithFormat:@"Losses: %lu", self.game.player.losses];
    
    [self initializeNewGameLabels];
    
    self.game = [[FISBlackjackGame alloc] init];
}

-(void) initializeNewGameLabels {
    
    // Hide House and Player labels that don't have immediate values to start
    self.houseScoreLabel.hidden = self.houseCardLabel1.hidden =
    self.houseCardLabel2.hidden = self.houseCardLabel3.hidden =
    self.houseCardLabel4.hidden = self.houseCardLabel5.hidden =
    self.houseActionLabel.hidden = self.houseBustedLabel.hidden =
    self.houseBlackjackLabel.hidden = YES;
    
    self.playerScoreLabel.hidden = self.playerCardLabel1.hidden =
    self.playerCardLabel2.hidden = self.playerCardLabel3.hidden =
    self.playerCardLabel4.hidden = self.playerCardLabel5.hidden =
    self.playerActionLabel.hidden = self.playerBustedLabel.hidden =
    self.playerBlackjackLabel.hidden = YES;
    
    self.winnerLabel.hidden = YES;
}

- (IBAction)dealButtonTapped:(id)sender {
    
    [self initializeNewGameLabels];
    [self.game deal];
    NSLog(@"%@", self.game.player);
    NSLog(@"%@", self.game.house);
    
    // House set up
    self.houseScoreLabel.text = [NSString stringWithFormat:@"Score: %lu", self.game.house.handscore];
    self.houseCardLabel1.text = ((FISCard *)self.game.house.cardsInHand[0]).cardLabel;
    self.houseCardLabel2.text = ((FISCard *)self.game.house.cardsInHand[1]).cardLabel;

    
    // Unhide set labels
    self.houseScoreLabel.hidden = self.houseCardLabel1.hidden = self.houseCardLabel2.hidden =
    self.houseWinsLabel.hidden = self.houseLossesLabel.hidden = NO;
    
    // Player set up
    self.playerScoreLabel.text = [NSString stringWithFormat:@"Score: %lu", self.game.player.handscore];
    self.playerCardLabel1.text = ((FISCard *)self.game.player.cardsInHand[0]).cardLabel;
    self.playerCardLabel2.text = ((FISCard *)self.game.player.cardsInHand[1]).cardLabel;

    
    // Unhide set labels
    self.playerScoreLabel.hidden = self.playerCardLabel1.hidden = self.playerCardLabel2.hidden =
    self.playerWinsLabel.hidden = self.playerLossesLabel.hidden = NO;
    
    // Enable hit and stay buttons
    self.playerHitButton.enabled = self.playerStayButton.enabled = YES;
}

- (IBAction)playerHitTapped:(id)sender {
    
    [self.game dealCardToPlayer];
    [self processTurn:self.game.player];
    
    [self.game processHouseTurn];
    [self processTurn:self.game.house];
    
    [self checkWins];
    
    NSLog(@"%@", self.game.player);
    NSLog(@"%@", self.game.house);
}

- (IBAction)playerStayTapped:(id)sender {

    self.game.player.stayed = YES;
    self.playerActionLabel.hidden = NO;
    
    [self.game processHouseTurn];
    [self processTurn:self.game.house];

    [self checkWins];
    NSLog(@"%@", self.game.player);
    NSLog(@"%@", self.game.house);
}

-(void) processTurn:(FISBlackjackPlayer *)player {
    NSUInteger cardCount = player.cardsInHand.count;
    
    if([player.name isEqualToString:@"House"]) {
        ((UILabel *)self.houseCardLabelArray[cardCount - 1]).text = ((FISCard *)player.cardsInHand[cardCount - 1]).cardLabel;
        ((UILabel *)self.houseCardLabelArray[cardCount - 1]).hidden = NO;
        self.houseScoreLabel.text = [NSString stringWithFormat:@"Score: %lu", player.handscore];
        
        if(player.shouldHit) {
            self.houseActionLabel.text = @"Hit";
        }
        else {
            self.houseActionLabel.text = @"Stayed";
        }
        self.houseActionLabel.hidden = NO;
        
    }
    else { // player
        ((UILabel *)self.playerCardLabelArray[cardCount - 1]).text = ((FISCard *)player.cardsInHand[cardCount - 1]).cardLabel;
        ((UILabel *)self.playerCardLabelArray[cardCount - 1]).hidden = NO;
        self.playerScoreLabel.text = [NSString stringWithFormat:@"Score: %lu", player.handscore];
    }
    
}

-(void) checkWins {
    if ((self.game.house.stayed && self.game.player.stayed) || (self.game.house.busted || self.game.player.busted)) { // both players have stayed or someone has busted.
        
        if(self.game.houseWins) {
            self.winnerLabel.text = [NSString stringWithFormat:@"%@ wins!", self.game.house.name];
            [self.game incrementWinsAndLossesForHouseWins:YES];
        }
        else {
            self.winnerLabel.text = @"You win!";
            [self.game incrementWinsAndLossesForHouseWins:NO];
        }
        
        self.winnerLabel.hidden = NO;
        
        self.playerWinsLabel.text = [NSString stringWithFormat:@"Wins: %lu", self.game.player.wins];
        self.playerLossesLabel.text = [NSString stringWithFormat:@"Losses: %lu", self.game.player.losses];
        
        self.houseWinsLabel.text = [NSString stringWithFormat:@"Wins: %lu", self.game.house.wins];
        self.houseLossesLabel.text = [NSString stringWithFormat:@"Losses: %lu", self.game.house.losses];
        
        self.playerWinsLabel.hidden = self.playerLossesLabel.hidden =
        self.houseWinsLabel.hidden = self.houseLossesLabel.hidden = NO;
        
        self.playerHitButton.enabled = self.playerStayButton.enabled = NO;
        
        if (self.game.house.busted) {
            self.houseBustedLabel.hidden = NO;
        }
        else if (self.game.player.busted) {
            self.playerBustedLabel.hidden = NO;
        }
        else if (self.game.house.blackjack) {
            self.houseBlackjackLabel.hidden = NO;
        }
        else if (self.game.player.blackjack) {
            self.playerBlackjackLabel.hidden = NO;
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
