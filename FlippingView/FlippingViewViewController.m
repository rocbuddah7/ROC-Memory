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
const int DEFAULT_TILE_WIDTH = 80;
const int DEFAULT_TILE_HEIGHT = 80;
const int DEFAULT_SMALL_HEIGHT = 57;
const int DEFAULT_SMALL_WIDTH = 57;
const int DEFAULT_LARGE_HEIGHT = 80;
const int DEFAULT_LARGE_WIDTH = 80;
const int DEFAULT_X_TILES = 3;
const int DEFAULT_Y_TILES = 2;
const int MAX_SMALL_X_TILES = 5;
const int MAX_SMALL_Y_TILES = 6;
const int MAX_LARGE_X_TILES = 3;
const int MAX_LARGE_Y_TILES = 4;

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
@synthesize TILE_WIDTH = _TILE_WIDTH;
@synthesize TILE_HEIGHT = _TILE_HEIGHT;

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
    //clear game variables and counters, start timer
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
    int temp = (_gameView.frame.size.width - (_TILE_WIDTH * numOfXTiles)) / (numOfXTiles + 1);
    return temp;
}

-(int)getYSpacer:(int)numOfYTiles
{
    int temp = ((_gameView.frame.size.height - 50) - (_TILE_HEIGHT * numOfYTiles)) / (numOfYTiles + 1);
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
            float x_pos = (_TILE_WIDTH * x) + (X_SPACER * (x+1));
            float y_pos = (_TILE_HEIGHT * y) + (Y_SPACER * (y+1));
            NSString *l = [self randomLetter];
            CGRect containerRect = CGRectMake(x_pos, y_pos, _TILE_WIDTH, _TILE_HEIGHT);
            ContainerView *temp = [[[ContainerView alloc] initWithFrame:containerRect :l] autorelease];
            temp.viewController = self;
            [_containerList addObject:temp];
        }
    }
}

-(void)setBoard{
    //adds each container view tiles into the gameview as subviews
    for (int i=0;i<[_containerList count];i++){
        ContainerView *c = [_containerList objectAtIndex:i];
        [_gameView addSubview:c];
    }
}

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
        [self loadGame];
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
    [_xMax release];
    _xMax = nil;
    [_yMax release];
    _yMax = nil;
    [_tileSize release];
    _tileSize = nil;
    [_warning release];
    _warning = nil;
    [_saveButton release];
    _saveButton = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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

-(void)initMemory
{
    if (_numberOfXTiles == 0){
        _numberOfXTiles = DEFAULT_X_TILES;
    }
    if (_numberOfYTiles == 0){
        _numberOfYTiles = DEFAULT_Y_TILES;
    }
    if (_totalTiles == 0){
        _totalTiles = _numberOfXTiles * _numberOfYTiles;
    }
    if (_TILE_WIDTH == 0){
        _TILE_WIDTH = DEFAULT_TILE_WIDTH;
    }
    if (_TILE_HEIGHT == 0){
        _TILE_HEIGHT = DEFAULT_TILE_HEIGHT;
    }    
    _tileSize.selectedSegmentIndex = 1;
    _alphaArray = [[NSArray alloc] initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    [self loadAd];
    self.view.backgroundColor = [UIColor whiteColor];
    _gameView.backgroundColor = [UIColor whiteColor];
    _menuView.backgroundColor = [UIColor orangeColor];
    _configView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_configView];
    [self.view addSubview:_gameView];
    [self.view addSubview:_menuView];    
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [self initMemory];
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
    if (_TILE_WIDTH == 0){
        _TILE_WIDTH = DEFAULT_TILE_WIDTH;
    }
    if (_TILE_HEIGHT == 0){
        _TILE_HEIGHT = DEFAULT_TILE_HEIGHT;
    }
    
    if (_TILE_WIDTH == DEFAULT_SMALL_WIDTH){
        _xMax.text = [NSString stringWithFormat:@"MAX = %d", MAX_SMALL_X_TILES];
        _yMax.text = [NSString stringWithFormat:@"MAX = %d", MAX_SMALL_Y_TILES];        
    }else{
        _xMax.text = [NSString stringWithFormat:@"MAX = %d", MAX_LARGE_X_TILES];
        _yMax.text = [NSString stringWithFormat:@"MAX = %d", MAX_LARGE_Y_TILES];                
    }
    _warning.lineBreakMode  = UILineBreakModeWordWrap;
    _warning.numberOfLines = 0;
    [_warning setHidden:YES];
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
    [self startGame];
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

-(void)validateSettings{
    if (_tileSize.selectedSegmentIndex == 0){
        //small is selected
    }else{
        
    }
}

-(IBAction)moveMenuViewToFront
{
    [self validateSettings];
    [self saveSettings];
    [self.view bringSubviewToFront:_menuView];
}

-(IBAction)moveMenuViewToFrontFromGame
{
    [_timer invalidate];
    [self clearBoard];
    [self clearContainerList];
    [self.view bringSubviewToFront:_menuView];    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(NSString *)checkYMax{
    NSString * warningMessage;
    warningMessage = nil;
    if (_tileSize.selectedSegmentIndex == 0){
        if ([_yText.text intValue] > MAX_SMALL_Y_TILES){
            warningMessage = [NSString stringWithFormat: @"Number of vertical tiles can't be larger than %d.", MAX_SMALL_Y_TILES];
        }
        
    }else{
        if ([_yText.text intValue] > MAX_LARGE_Y_TILES){
            warningMessage = [NSString stringWithFormat: @"Number of vertical tiles can't be larger than %d.", MAX_LARGE_Y_TILES];
        }        
    }
    return warningMessage;
}

-(NSString *)checkXMax{
    NSString * warningMessage;
    warningMessage = nil;
    if (_tileSize.selectedSegmentIndex == 0){
        if ([_xText.text intValue] > MAX_SMALL_X_TILES){
            warningMessage = [NSString stringWithFormat: @"Number of horizontal tiles can't be larger than %d.", MAX_SMALL_X_TILES];
        }
        
    }else{
        if ([_xText.text intValue] > MAX_LARGE_X_TILES){
            warningMessage = [NSString stringWithFormat: @"Number of horizontal tiles can't be larger than %d.", MAX_LARGE_X_TILES];
        }        
    }
    return warningMessage;
}

-(NSString *)checkEvenTile{
    NSString * warningMessage;
    warningMessage = nil;
    //check total tiles
    int temp = [_xText.text intValue] * [_yText.text intValue];
    if (temp % 2 != 0){
        warningMessage = @"Total number of tiles should be an even number.";
    }    
    return warningMessage;
}

-(IBAction) segmentedControlIndexChanged{
    NSString * warningMessage;
    NSString * maxXMessage;
    NSString * maxYMessage;
    
    switch (_tileSize.selectedSegmentIndex) {
        case 0:
            _TILE_HEIGHT = DEFAULT_SMALL_HEIGHT;
            _TILE_WIDTH = DEFAULT_SMALL_WIDTH;
            _xMax.text = [NSString stringWithFormat:@"MAX = %d", MAX_SMALL_X_TILES];
            _yMax.text = [NSString stringWithFormat:@"MAX = %d", MAX_SMALL_Y_TILES];            
            break;
        case 1:
            _TILE_HEIGHT = DEFAULT_LARGE_HEIGHT;
            _TILE_WIDTH = DEFAULT_LARGE_WIDTH;
            _xMax.text = [NSString stringWithFormat:@"MAX = %d", MAX_LARGE_X_TILES];
            _yMax.text = [NSString stringWithFormat:@"MAX = %d", MAX_LARGE_Y_TILES];            
            break;
        default:
            _xMax.text = [NSString stringWithFormat:@"MAX = %d", MAX_LARGE_X_TILES];
            _yMax.text = [NSString stringWithFormat:@"MAX = %d", MAX_LARGE_Y_TILES];            
            _TILE_HEIGHT = DEFAULT_LARGE_HEIGHT;
            _TILE_WIDTH = DEFAULT_LARGE_WIDTH;            
            break;
    }
    warningMessage = nil;
    maxXMessage = [self checkXMax];
    maxYMessage = [self checkYMax];

    if (maxXMessage){
        if (maxYMessage){
            warningMessage = [NSString stringWithFormat:@"%@ %@", maxXMessage, maxYMessage];
        }
    }else{
        if (maxYMessage){
            warningMessage = maxYMessage;
        }
    }
    
    if (warningMessage){
        _warning.text = warningMessage;
        [_warning setHidden:NO];
        [_saveButton setHidden:YES];
    }else{
        [_warning setHidden:YES];
        [_saveButton setHidden:NO];
    }    
}

-(IBAction)validateYText{
    NSString * warningMessage;
    NSString * maxMessage;
    NSString * evenMessage;
    
    warningMessage = nil;
    maxMessage = [self checkYMax];
    evenMessage = [self checkEvenTile];
    
    if (maxMessage){
        if (evenMessage){
            warningMessage = [NSString stringWithFormat:@"%@ %@", maxMessage, evenMessage];
        }else{
            warningMessage = maxMessage;
        }
    }else{
        if (evenMessage){
            warningMessage = evenMessage;
        }
    }
    
    if (warningMessage){
        _warning.text = warningMessage;
        [_warning setHidden:NO];
        [_saveButton setHidden:YES];
    }else{
        [_warning setHidden:YES];
        [_saveButton setHidden:NO];
    }
}

-(IBAction)validateXText{
    NSString * warningMessage;
    NSString * maxMessage;
    NSString * evenMessage;
    warningMessage = nil;
    maxMessage = [self checkYMax];
    evenMessage = [self checkEvenTile];

    if (maxMessage){
        if (evenMessage){
            warningMessage = [NSString stringWithFormat:@"%@ %@", maxMessage, evenMessage];
        }else{
            warningMessage = maxMessage;
        }
    }else{
        if (evenMessage){
            warningMessage = evenMessage;
        }
    }
    
    if (warningMessage){
        _warning.text = warningMessage;
        [_warning setHidden:NO];
        [_saveButton setHidden:YES];
    }else{
        [_warning setHidden:YES];
        [_saveButton setHidden:NO];
    }
}

@end



