//
//  FlippingViewViewController.m
//  FlippingView
//
//  Created by ROGER CHENG on 6/3/11.
//  Copyright 2011 ROC Solutions Inc. All rights reserved.
//

#import "FlippingViewViewController.h"
#import "ContainerView.h"

//total x is 320
//total y is 410
//spacer x = (320 - (tile width * number of x tiles)) / (number of x tiles + 1)
//spacer y = (410 - (tile height * number of y tiles)) / (number of y tiles + 1)
const int TILE_WIDTH = 100;
const int TILE_HEIGHT = 100;
const int NUM_X_TILES = 3;
const int NUM_Y_TILES = 4;

@implementation FlippingViewViewController
@synthesize openTiles = _openTiles;
@synthesize currentLetter = _currentLetter;
@synthesize containerList = _containerList;
@synthesize fininshedAnimation = _finishedAnimation;
@synthesize timer = _timer;
@synthesize needToReset = _needToReset;
@synthesize alphaArray = _alphaArray;
@synthesize gameLetters = _gameLetters;
@synthesize usedRandomList = _usedRandomList;

-(int)generateRandomInt
{
    int j = arc4random() % 25;
    while ([_usedRandomList containsObject:[NSString stringWithFormat:@"%d", j]])
    {
        j = arc4random() % 25;
    }
    return j;
}

-(void)createGameLetters{
    //if used letters exists then empty it out
    if (_usedRandomList)
    {
        [_usedRandomList release];
        _usedRandomList = nil;
        _usedRandomList = [[NSMutableArray alloc] init];
    }
    else
    {
        _usedRandomList = [[NSMutableArray alloc] init];
    }
    
    if ([_gameLetters count] == 0)
    {
        for (int j=1;j<=6;j++)
        {
            //int i= arc4random() % 25;
            int i = [self generateRandomInt];
            //add duplicate letters into our gameLetters array
            [_gameLetters addObject:[_alphaArray objectAtIndex:i]];
            [_gameLetters addObject:[_alphaArray objectAtIndex:i]];
            [_usedRandomList addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
}

-(NSString *)randomLetter{
    int i = [_gameLetters count];
    int j = arc4random() % i;
    NSString *temp = [_gameLetters objectAtIndex:j];
    //remove from gameletters after it's been used;
    [_gameLetters removeObjectAtIndex:j];
    return temp;
}

-(void)startGame{
    _openTiles = 0;
    _currentLetter = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(targetMethod:) userInfo:nil repeats:YES];
}

-(void)clearBoard{
    for (int i=0;i<[_containerList count];i++){
        ContainerView *c = [_containerList objectAtIndex:i];
        [c removeFromSuperview];
    }
}

-(void)clearContainerList{
    for (int i=0; i<[_containerList count];i++){
        [_containerList removeObjectAtIndex:i];
    }
}

-(int)getXSpacer:(int)numOfXTiles
{
    int temp = (320 - (TILE_WIDTH * numOfXTiles)) / (numOfXTiles + 1);
    return temp;
}

-(int)getYSpacer:(int)numOfYTiles
{
    int temp = (410 - (TILE_HEIGHT * numOfYTiles)) / (numOfYTiles + 1);
    return temp;    
}

-(void)populateContainerList{
    int X_SPACER = [self getXSpacer:NUM_X_TILES];
    int Y_SPACER = [self getYSpacer:NUM_Y_TILES];
    ContainerView *R = [[[ContainerView alloc] initWithFrame:CGRectMake(X_SPACER, Y_SPACER, TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    R.viewController = self;
    ContainerView *A = [[[ContainerView alloc] initWithFrame:CGRectMake(TILE_WIDTH + (X_SPACER * 2), Y_SPACER, TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    A.viewController = self;
    ContainerView *O = [[[ContainerView alloc] initWithFrame:CGRectMake((TILE_WIDTH * 2) + (X_SPACER * 3), Y_SPACER, TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    O.viewController = self;
    ContainerView *R1 = [[[ContainerView alloc] initWithFrame:CGRectMake(X_SPACER, TILE_HEIGHT + (Y_SPACER * 2), TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    R1.viewController = self;
    ContainerView *A1 = [[[ContainerView alloc] initWithFrame:CGRectMake(TILE_WIDTH + (X_SPACER * 2), TILE_HEIGHT + (Y_SPACER * 2), TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    A1.viewController = self;
    ContainerView *O1 = [[[ContainerView alloc] initWithFrame:CGRectMake((TILE_WIDTH * 2) + (X_SPACER * 3), TILE_HEIGHT + (Y_SPACER * 2), TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    O1.viewController = self;
    ContainerView *R2 = [[[ContainerView alloc] initWithFrame:CGRectMake(X_SPACER, (TILE_HEIGHT * 2) + (Y_SPACER * 3), TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    R2.viewController = self;
    ContainerView *A2 = [[[ContainerView alloc] initWithFrame:CGRectMake(TILE_WIDTH + (X_SPACER * 2), (TILE_HEIGHT * 2) + (Y_SPACER * 3), TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    A2.viewController = self;
    ContainerView *O2 = [[[ContainerView alloc] initWithFrame:CGRectMake((TILE_WIDTH * 2) + (X_SPACER * 3), (TILE_HEIGHT * 2) + (Y_SPACER * 3), TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    O2.viewController = self;
    ContainerView *R3 = [[[ContainerView alloc] initWithFrame:CGRectMake(X_SPACER, (TILE_HEIGHT * 3) + (Y_SPACER * 4), TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    R3.viewController = self;
    ContainerView *A3 = [[[ContainerView alloc] initWithFrame:CGRectMake(TILE_WIDTH + (X_SPACER * 2), (TILE_HEIGHT * 3) + (Y_SPACER * 4), TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    A3.viewController = self;
    ContainerView *O3 = [[[ContainerView alloc] initWithFrame:CGRectMake((TILE_WIDTH * 2) + (X_SPACER * 3), (TILE_HEIGHT * 3) + (Y_SPACER * 4), TILE_WIDTH, TILE_HEIGHT) :[self randomLetter]] autorelease];
    O3.viewController = self;
    
    _containerList = [[NSMutableArray alloc] initWithObjects:R, A, O, R1, A1, O1, R2, A2, O2, R3, A3, O3, nil];    
}

-(void)setBoard{
    for (int i=0;i<[_containerList count];i++){
        ContainerView *c = [_containerList objectAtIndex:i];
        [_gameView addSubview:c];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self clearBoard];
        [self clearBoard];
        [self.view bringSubviewToFront:_menuView];
	}
	else {
        [self clearBoard];
        [self clearContainerList];
        [self createGameLetters];
        [self populateContainerList];
        [self setBoard];
        [self startGame];
	}
}

-(void)gameFinished{
    int j=0;
    for (int i=0; i <[_containerList count];i++){
        ContainerView *c = [_containerList objectAtIndex:i];
        if (c.isLocked){
            j++;
        }
    }
    if (j==[_containerList count]){
        [_timer invalidate];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Olivia's Game"
                              message: @"New game?"
                              delegate: self
                              cancelButtonTitle:@"Menu"
                              otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
}

-(void) targetMethod: (NSTimer *)theTimer {
    if (_needToReset == YES){
        _openTiles = 0;
        _currentLetter = nil;    
        //loop through the containers and reset all front tiles to back
        for (int i=0; i<[_containerList count];i++){
            ContainerView *c = [_containerList objectAtIndex:i];
            if (!c.isLocked && c.displayingPrimary == YES){
                //add it to the clearQ
                [c flipViews:YES];
            }
        }
        _needToReset = NO;
    }
    [self gameFinished];
}

-(void)resetTiles{
    _needToReset = YES;
}

-(void)disableTiles:(NSString *)letter{
    _openTiles = 0;
    _currentLetter = nil;
    //loop through the array of container looking for this letter and lock them
    for (int i =0; i < [_containerList count];i++){
        ContainerView *c = [_containerList objectAtIndex:i];
        if (c.frontTile.letter == letter){
            c.isLocked = YES;
            c.frontTile.backgroundColor = [UIColor greenColor];
        }
    }    
}

- (void)dealloc
{
    [_usedRandomList release];
    _usedRandomList = nil;
    [_gameLetters release];
    _gameLetters = nil;
    [_alphaArray release];
    _alphaArray = nil;
    [_currentLetter release];
    _currentLetter = nil;
    [_containerList release];
    _containerList = nil;
    [_currentLetter release];
    _currentLetter = nil;
    [_timer release];
    _timer = nil;
    [_gameView release];
    _gameView = nil;
    [_menuView release];
    _menuView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)loadGame
{
    //SET UP CONSTANT ARRAY
    //self.view.backgroundColor = [UIColor whiteColor];
    _alphaArray = [[NSArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    _gameLetters = [[NSMutableArray alloc] init];
    [self createGameLetters];
    [self populateContainerList];
    [self setBoard];
    [self startGame];    
}

#pragma mark - ADBannerViewDelegate
-(void)loadAd
{
    ADBannerView *adView = [[[ADBannerView alloc] initWithFrame:CGRectZero] autorelease];
	adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	adView.delegate = self; //*********incredibly important*************//
	adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait,
											 ADBannerContentSizeIdentifierLandscape,
											 nil];
	CGRect myRect = CGRectMake(0, 0, 320, 50);				
	adView.frame = myRect;
	adView.hidden = YES;
	adView.userInteractionEnabled = NO;    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)adView 
{	
    //needed to remove iAd if there isn't any iAds there, required by Apple.
	adView.userInteractionEnabled = YES;
	adView.hidden = NO;
	[self.view addSubview:adView];
	
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"%@", [error description]);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self loadAd];
    self.view.backgroundColor = [UIColor whiteColor];
    _gameView.backgroundColor = [UIColor whiteColor];
    _menuView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_gameView];
    [self.view addSubview:_menuView];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)moveGameViewToFront
{
    [self loadGame];
    [self.view bringSubviewToFront:_gameView];   
}

@end



