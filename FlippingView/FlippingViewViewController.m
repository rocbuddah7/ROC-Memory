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
const int TILE_WIDTH = 50;
const int TILE_HEIGHT = 50;
const int DEFAULT_X_TILES = 4;
const int DEFAULT_Y_TILES = 4;

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
@synthesize adView = _adView;
@synthesize numberOfXTiles = _numberOfXTiles;
@synthesize numberOfYTiles = _numberOfYTiles;
@synthesize totalTiles = _totalTiles;
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
        for (int j=1;j<=(_totalTiles/2);j++)
        {
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
    int temp = (_gameView.frame.size.width - (TILE_WIDTH * numOfXTiles)) / (numOfXTiles + 1);
    return temp;
}

-(int)getYSpacer:(int)numOfYTiles
{
    int temp = ((_gameView.frame.size.height - 50) - (TILE_HEIGHT * numOfYTiles)) / (numOfYTiles + 1);
    return temp;    
}

-(void)populateContainerList{
    int X_SPACER = [self getXSpacer:_numberOfXTiles];
    int Y_SPACER = [self getYSpacer:_numberOfYTiles];
    
    if (!_containerList){
        _containerList = [[NSMutableArray alloc] init];
    }else{
        [_containerList release];
        _containerList = nil;
        _containerList = [[NSMutableArray alloc] init];
    }
    for (int x=0; x< _numberOfXTiles; x++){
        for (int y=0; y< _numberOfYTiles; y++){
            float x_pos = (TILE_WIDTH * x) + (X_SPACER * (x+1));
            float y_pos = (TILE_HEIGHT * y) + (Y_SPACER * (y+1));
            NSString *l = [self randomLetter];
            CGRect containerRect = CGRectMake(x_pos, y_pos, TILE_WIDTH, TILE_HEIGHT);
            ContainerView *temp = [[[ContainerView alloc] initWithFrame:containerRect :l] autorelease];
            temp.viewController = self;
            [_containerList addObject:temp];
        }
    }
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
        [self clearContainerList];
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
    [_adView release];
    _adView = nil;
    [_xText release];
    _xText = nil;
    [_yText release];
    _yText = nil;
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
    //SET UP DEFAULT NUMBER OF TILES AND TOTAL TILES IF NOT AVAILABLE
    if (_numberOfXTiles == 0){
        _numberOfXTiles = DEFAULT_X_TILES;
    }
    if (_numberOfYTiles == 0){
        _numberOfYTiles = DEFAULT_Y_TILES;
    }
    if (_totalTiles == 0){
        _totalTiles = _numberOfXTiles * _numberOfYTiles;
    }
    
    //SET UP CONSTANT ARRAY
    if (!_gameLetters){
        _gameLetters = [[NSMutableArray alloc] init];
    }
    [self createGameLetters];
    [self populateContainerList];
    [self setBoard];
    [self startGame];    
}

#pragma mark - ADBannerViewDelegate
-(void)loadAd
{
    _adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
	_adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	_adView.delegate = self; //*********incredibly important*************//
	_adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierPortrait,
											 ADBannerContentSizeIdentifierLandscape,
											 nil];
	CGRect myRect = CGRectMake(0, 0, 320, 50);				
	_adView.frame = myRect;
	_adView.hidden = YES;
	_adView.userInteractionEnabled = NO;    
}

- (void)bannerViewDidLoadAd:(ADBannerView *)adView 
{	
    //needed to remove iAd if there isn't any iAds there, required by Apple.
	_adView.userInteractionEnabled = YES;
	_adView.hidden = NO;
	[self.view addSubview:_adView];
	
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"%@", [error description]);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    _alphaArray = [[NSArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    [self loadAd];
    self.view.backgroundColor = [UIColor whiteColor];
    _gameView.backgroundColor = [UIColor whiteColor];
    _menuView.backgroundColor = [UIColor orangeColor];
    _configView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_configView];
    [self.view addSubview:_gameView];
    [self.view addSubview:_menuView];
    [super viewDidLoad];
}

-(void)loadConfigView
{
    if (_numberOfXTiles == 0){
        _xText.text = [NSString stringWithFormat: @"%d",  DEFAULT_X_TILES];
    }else{
        _xText.text = [NSString stringWithFormat:@"%d", _numberOfXTiles];
    }
    if (_numberOfYTiles == 0){
        _yText.text = [NSString stringWithFormat: @"%d", DEFAULT_Y_TILES];
    }else{
        _yText.text = [NSString stringWithFormat:@"%d", _numberOfYTiles];
    }
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

-(IBAction)moveConfigViewToFront
{
    [self loadConfigView];
    [self.view bringSubviewToFront:_configView];
}

-(void)saveSettings
{
    _numberOfXTiles = [_xText.text intValue];
    _numberOfYTiles = [_yText.text intValue];
    _totalTiles = _numberOfXTiles * _numberOfYTiles;
}

-(IBAction)moveMenuViewToFront
{
    [self saveSettings];
    [self.view bringSubviewToFront:_menuView];
}

-(IBAction)moveMenuViewToFrontFromGame
{
    [self clearBoard];
    [self clearBoard];
    [self.view bringSubviewToFront:_menuView];    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end



