//
//  MenuLayer.m
//  Smiley Dash
//
//  Created by Stephen Sowole on 19/05/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import "MenuLayer.h"
#import "GameLayer.h"
#import "Config.h"
#import "TutorialLayer.h"
#import "StoreLayer.h"
#import "SimpleAudioEngine.h"


@implementation MenuLayer

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init {
    
	if( (self=[super init])) {
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        prefs = [NSUserDefaults standardUserDefaults];
        
        CCSprite *background;
        
        if (![prefs objectForKey:@"firstRun"]) {
            // add this for when tutorial is being done
            
            [prefs setObject:[NSDate date] forKey:@"firstRun"];
            [prefs setInteger:startPlayPoints forKey:@"playPoints"];

            NSString *backgroundString = @"bg1";
            [prefs setObject:backgroundString forKey:@"background"];
            
            [prefs setInteger:1 forKey:@"colour"];
            
            [prefs setInteger:1 forKey:@"multiplier"];
            
            [prefs setInteger:heroMaxLife forKey:@"life"];
            
            backgroundString = @"particleCircle.png";
            [prefs setObject:backgroundString forKey:@"particle"];
            
            backgroundString = @"hero.png";
            [prefs setObject:backgroundString forKey:@"smiley"];
            
        }

        
        // if iphone 5, change the display to use the larger image
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            background = [CCSprite spriteWithFile:@"menu-568h.png"];
            
        } else {
            
            background = [CCSprite spriteWithFile:@"menu.png"];
            
        }
        
        background.position = ccp(size.width/2, size.height/2);
        
        [self addChild:background];
        
        
       // NSInteger playPoints = [prefs integerForKey:@"playPoints"];
        
        CCSprite *label;
        /*label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@" playPoints: %i", playPoints] fontName:@"Baccarat" fontSize:15];
        label.position = ccp(size.width/4 * 3, size.height - 10);
        [self addChild:label z:4];
        
        NSInteger totalPoints = [prefs integerForKey:@"totalScore"];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@" total: %i", totalPoints] fontName:@"Baccarat" fontSize:15];
        label.position = ccp(size.width/2, size.height - 10);
        [self addChild:label z:4];
        
        */
        
        CCSprite *scoreImage = [CCSprite spriteWithFile:@"highScore.png"];
        scoreImage.position = ccp(size.width/8 - 40, size.height - 20);
        [self addChild:scoreImage z:4];
        
        NSInteger highScore = [prefs integerForKey:@"highScore"];

        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", highScore] fontName:@"Baccarat" fontSize:15];
        [label setAnchorPoint:ccp(1, 0)];
        label.position = ccp(size.width/6.5, size.height - 30);
        label.color = ccc3(132, 15, 5);
        [self addChild:label z:4];
        
        
        CCMenuItem *play = [CCMenuItemImage itemWithNormalImage:@"MenuPlay.png" selectedImage:@"MenuPlayOn.png" target:self selector:@selector(playTapped:)];
        
        CCMenuItem *guide = [CCMenuItemImage itemWithNormalImage:@"MenuGuide.png" selectedImage:@"MenuGuideOn.png" target:self selector:@selector(guideTapped:)];
        
        CCMenuItem *store = [CCMenuItemImage itemWithNormalImage:@"MenuStore.png" selectedImage:@"MenuStoreOn.png" target:self selector:@selector(storeTapped:)];
        
        CCMenuItem *about = [CCMenuItemImage itemWithNormalImage:@"MenuAbout.png" selectedImage:@"MenuAboutOn.png" target:self selector:@selector(aboutTapped:)];
        
        play.position = ccp(size.width/2, size.height/5 * 2);
        guide.position = ccp(size.width/2 - 75, (size.height/5));
        store.position = ccp(size.width/2 + 75, (size.height/5));
        about.position = ccp(size.width/12 * 11, size.height/9);
        
        CCMenu *menu = [CCMenu menuWithItems:play, guide, store, about, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"mainMenu.mp3"];
        
	}
    
    self.touchEnabled = YES;
	return self;
}

- (void) playTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene:game_restart]]];
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TutorialLayer scene]]];
}

- (void) guideTapped:(id)sender {
    printf("yet to be done!");
}

- (void) storeTapped:(id)sender {
   [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[StoreLayer scene]]];
}

- (void) aboutTapped:(id)sender {
    printf("yet to be done!");
}

- (void) dealloc {
    
    [super dealloc];
    
}

@end
