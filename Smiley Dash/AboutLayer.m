//
//  AboutLayer.m
//  Smiley Dash
//
//  Created by Stephen Sowole on 16/06/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import "AboutLayer.h"
#import "MenuLayer.h"

@implementation AboutLayer

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AboutLayer *layer = [AboutLayer node];
	
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
            
            background = [CCSprite spriteWithFile:@"aboutbg-568h.png"];
            
        } else {
            
            background = [CCSprite spriteWithFile:@"aboutbg.png"];
        }
        
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        
        CCMenuItem *back = [CCMenuItemImage itemWithNormalImage:@"backOff.png" selectedImage:@"backOn.png" target:self selector:@selector(goBack:)];
        
        back.position = ccp(size.width/20, size.height/15 * 14);
        
        CCMenu *menu = [CCMenu menuWithItems:back, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];
        
        CCParticleSystem *emitter;
        
        emitter = [CCParticleRain node];
        
        emitter.startColor = ccc4FFromccc3B(ccYELLOW);
        
        ccColor4F endColor = {255, 255, 255, 0};
        emitter.endColor = endColor;
        
        emitter.scale = 3.0;
        
        emitter.speed = 0.1;
        
        emitter.position = ccp(size.width/2, size.height + 50);
        
        emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"normalEnemy.png"];
        
        emitter.life = 4;
        
        [self addChild:emitter];
        
        emitter.autoRemoveOnFinish = YES;
        
	}
    
    self.touchEnabled = YES;
	return self;
}

- (void) goBack:(id)sender {
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
    
}

@end
