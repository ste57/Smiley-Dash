//
//  Gameover.m
//  Smiley Dash
//
//  Created by Stephen Sowole on 14/05/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import "Gameover.h"
#import "GameLayer.h"
#import "Config.h"
#import "MenuLayer.h"

CCLabelTTF *pointsLabel;

@implementation GameOver

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameOver *layer = [GameOver node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init {
    
	if( (self=[super init])) {
        
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        prefs = [NSUserDefaults standardUserDefaults];
        
        NSInteger playPoints = [prefs integerForKey:@"playPoints"];
        
        pointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", playPoints] fontName:@"Collegiate-Normal" fontSize:23];
        
        CCLabelTTF *rewindlabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Restart"] fontName:@"ElGar" fontSize:23];
        
        CCLabelTTF *playlabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Resume" ] fontName:@"ElGar" fontSize:23];
        
        CCLabelTTF *stoplabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Main Menu" ] fontName:@"ElGar" fontSize:23];
        
        rewindlabel.position = ccp(size.width/2 - (size.width/3), size.height * 4/5);
        playlabel.position = ccp(size.width/2,(size.height * 4/5));
        stoplabel.position = ccp(size.width/2 + (size.width/3), size.height * 4/5);
        
        rewindlabel.color = ccc3(255, 255, 255);
        playlabel.color = ccc3(255, 255, 255);
        stoplabel.color = ccc3(255, 255, 255);
        
        pointsLabel.position = ccp(size.width/2,(size.height * 1/5));
        pointsLabel.color = ccc3(255, 255, 255);
        
        [self addChild:pointsLabel];
        [self addChild:rewindlabel];
        [self addChild:playlabel];
        [self addChild:stoplabel];
        
        
        CCMenuItem *rewind = [CCMenuItemImage itemWithNormalImage:@"rewindOn.png" selectedImage:@"rewindOff.png" target:self selector:@selector(rewindTapped:)];
        
        CCMenuItem *play;
        
        if (playPoints > 0) {
            
            play = [CCMenuItemImage itemWithNormalImage:@"playOn.png" selectedImage:@"playOff.png" target:self selector:@selector(playTapped:)];
        
        } else {
            
            play = [CCMenuItemImage itemWithNormalImage:@"playOff.png" selectedImage:@"playOn.png" target:self selector:@selector(playTapped:)];
       
        }
        
        CCMenuItem *stop = [CCMenuItemImage itemWithNormalImage:@"stopOn.png" selectedImage:@"stopOff.png" target:self selector:@selector(stopTapped:)];
        

        rewind.position = ccp(size.width/2 - (size.width/3), size.height/2);
        play.position = ccp(size.width/2, size.height/2);
        stop.position = ccp(size.width/2 + (size.width/3), size.height/2);

        
        CCMenu *restart = [CCMenu menuWithItems:rewind, play, stop, nil];
        restart.position = CGPointZero;
        
        [self addChild:restart];
        
        
	}

    self.touchEnabled = YES;
	return self;
}

- (void) stopTapped:(id)sender {
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
    
}

- (void) playTapped:(id)sender {
    
    NSInteger playPoints = [prefs integerForKey:@"playPoints"];
    
    if (playPoints > 0) {
        
        [prefs setInteger:(playPoints - 1) forKey:@"playPoints"];
        [pointsLabel setString:[NSString stringWithFormat:@"%i", playPoints - 1]];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene:game_resume]]];

    }
}

- (void) rewindTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene:game_restart]]];
}

@end
