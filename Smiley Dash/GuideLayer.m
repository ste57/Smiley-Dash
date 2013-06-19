//
//  GuideLayer.m
//  Smiley Dash
//
//  Created by Stephen Sowole on 16/06/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import "GuideLayer.h"
#import "MenuLayer.h"
#import "TutorialLayer.h"


@implementation GuideLayer

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GuideLayer *layer = [GuideLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init {
    
	if( (self=[super init])) {
        
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background;
        
        // if iphone 5, change the display to use the larger image
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            background = [CCSprite spriteWithFile:@"guide-568h.png"];
            
        } else {
            
            background = [CCSprite spriteWithFile:@"guide.png"];
        }
        
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        
        CCMenuItem *back = [CCMenuItemImage itemWithNormalImage:@"backOff.png" selectedImage:@"backOn.png" target:self selector:@selector(goBack:)];
        
        back.position = ccp(size.width/20, size.height/15 * 14);
        
        CCMenuItem *play = [CCMenuItemImage itemWithNormalImage:@"playTutorial.png" selectedImage:@"playTutorialOn.png" target:self selector:@selector(playTutorial:)];
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            play.position = ccp(size.width/15 * 11.6, size.height/11);
            
        } else {
            
            play.position = ccp(size.width/15 * 12.3, size.height/11);
        }
        
        CCMenu *menu = [CCMenu menuWithItems:play, back, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];

        
	}
    
    self.touchEnabled = YES;
	return self;
}

- (void) playTutorial:(id)sender {
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TutorialLayer scene]]];
    
}

- (void) goBack:(id)sender {
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
    
}

@end
