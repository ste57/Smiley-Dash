//
//  StoreLayer.m
//  Smiley Dash
//
//  Created by Stephen Sowole on 06/06/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import "StoreLayer.h"
#import "MenuLayer.h"
#import "CCSelectableItem.h"
#import "CCItemsScroller.h"


CCItemsScroller *itemScroll;
int screenFactor;
NSMutableArray * array;

@implementation StoreLayer

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StoreLayer *layer = [StoreLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init {
    
	if( (self=[super init])) {
        
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        // database of items used
        prefs = [NSUserDefaults standardUserDefaults];
        
        array = [[NSMutableArray alloc] init];
        
        CCSprite *background;
        
        // if iphone 5, change the display to use the larger image
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            background = [CCSprite spriteWithFile:@"store-568h.png"];
            screenFactor = 105;
            
        } else {
            
            background = [CCSprite spriteWithFile:@"store.png"];
            screenFactor = 90;
            
        }
        
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        // BACK BUTTON
        
        CCMenuItem *back = [CCMenuItemImage itemWithNormalImage:@"backOff.png" selectedImage:@"backOn.png" target:self selector:@selector(goBack:)];
        
        back.position = ccp(size.width/20, size.height/15 * 14);
        
        CCMenu *menu = [CCMenu menuWithItems:back, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];

        
        // SELECTABLE ITEMS
        
        CCSelectableItem *layer;
        CCLabelTTF *label;
        CCSprite *button;
        
        // ORIGINAL BACKGROUND
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Original Background"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"originalbg.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        
        // BACKGROUND 1
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Background 1"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlbg1.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        
        // BACKGROUND 2
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Background 2"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlbg2.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        
        // BACKGROUND 3
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Background 3"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlbg3.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // BACKGROUND 4
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Background 4"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlbg4.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        

        
        for (int i = 15; i > 0; i--) {
            
            CCSelectableItem *page = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
            
            CCLabelTTF *button = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"item #%d", i+1] fontName:@"Marker Felt" fontSize:15];
            button.position = ccp(page.contentSize.width/2, page.contentSize.height/2);
            [page addChild:button];
            [array addObject:page];
        }
    
        itemScroll = [CCItemsScroller itemsScrollerWithItems:array andOrientation:CCItemsScrollerVertical andRect:CGRectMake(screenFactor, 0, size.width - screenFactor*2, size.height/10 * 8.7)];
        
        itemScroll.delegate = self;
        
        [self addChild:itemScroll];
	}
    
	return self;
}

- (void) dealloc {
    
    [super dealloc];
    [array release];

    array = nil;

}

- (void) goBack:(id)sender {
    
   [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
    
}

- (void)itemsScroller:(CCItemsScroller *)sender didSelectItemIndex:(int)index {
    
    NSString *backgroundString;
    
    switch (index) {
            
        case 0:
            backgroundString = @"bg1";
            [prefs setObject:backgroundString forKey:@"background"];
            break;
        case 1:
            backgroundString = @"b1";
            [prefs setObject:backgroundString forKey:@"background"];
            break;
        case 2:
            backgroundString = @"b2";
            [prefs setObject:backgroundString forKey:@"background"];
            break;
        case 3:
            backgroundString = @"b3";
            [prefs setObject:backgroundString forKey:@"background"];
            break;
        case 4:
            backgroundString = @"b4";
            [prefs setObject:backgroundString forKey:@"background"];
            break;
            
        default:
            break;
            
    }
}

- (void)itemsScroller:(CCItemsScroller *)sender didUnSelectItemIndex:(int)index {
    
}

@end
