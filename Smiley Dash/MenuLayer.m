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
        
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

        CCSprite *background;
        
        // if iphone 5, change the display to use the larger image
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            background = [CCSprite spriteWithFile:@"menu-568h.png"];
            
        } else {
            
            background = [CCSprite spriteWithFile:@"menu.png"];
            
        }
        
        background.position = ccp(size.width/2, size.height/2);
        
        [self addChild:background];
       
        
        CCMenuItem *play = [CCMenuItemImage itemWithNormalImage:@"MenuPlay.png" selectedImage:@"MenuPlayOn.png" target:self selector:@selector(playTapped:)];
        
        CCMenuItem *guide = [CCMenuItemImage itemWithNormalImage:@"MenuGuide.png" selectedImage:@"MenuGuideOn.png" target:self selector:@selector(guideTapped:)];
        
        CCMenuItem *store = [CCMenuItemImage itemWithNormalImage:@"MenuStore.png" selectedImage:@"MenuStoreOn.png" target:self selector:@selector(storeTapped:)];
        
        CCMenuItem *about = [CCMenuItemImage itemWithNormalImage:@"MenuAbout.png" selectedImage:@"MenuAboutOn.png" target:self selector:@selector(aboutTapped:)];
        
        play.position = ccp(size.width/2, size.height/5 * 4);
        guide.position = ccp(size.width/2, (size.height/5 * 3));
        store.position = ccp(size.width/2, (size.height/5 * 2));
        about.position = ccp(size.width/2, (size.height/5 * 1));
        
        CCMenu *menu = [CCMenu menuWithItems:play, guide, store, about, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];
        
        
	}
    
    self.touchEnabled = YES;
	return self;
}

- (void) playTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene:game_restart]]];
}

- (void) guideTapped:(id)sender {
    printf("yet to be done!");
}

- (void) storeTapped:(id)sender {
   printf("yet to be done!");
}

- (void) aboutTapped:(id)sender {
    printf("yet to be done!");
}




@end
