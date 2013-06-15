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
        int priceMove;
        
        // if iphone 5, change the display to use the larger image
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            background = [CCSprite spriteWithFile:@"store-568h.png"];
            screenFactor = 105;
            priceMove = 100;
            
        } else {
            
            background = [CCSprite spriteWithFile:@"store.png"];
            screenFactor = 90;
            priceMove = 55;
        }
        
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        CCLabelTTF *label;
        
        CCSprite *scoreImage = [CCSprite spriteWithFile:@"particleStar.png"];
        scoreImage.scale = 3;
        scoreImage.color = ccYELLOW;
        scoreImage.position = ccp(size.width/2 - 60, size.height - 17);
        [self addChild:scoreImage z:4];
        
        NSInteger highScore = [prefs integerForKey:@"totalScore"];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", highScore] fontName:@"Collegiate-Normal" fontSize:20];
        [label setAnchorPoint:ccp(1, 0)];
        label.position = ccp(size.width/2 + 50, size.height - 32);
        label.color = ccYELLOW;
        [self addChild:label z:4];
        
        
        // BACK BUTTON
        
        CCMenuItem *back = [CCMenuItemImage itemWithNormalImage:@"backOff.png" selectedImage:@"backOn.png" target:self selector:@selector(goBack:)];
        
        back.position = ccp(size.width/20, size.height/15 * 14);
        
        CCMenu *menu = [CCMenu menuWithItems:back, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];

        
        // SELECTABLE ITEMS
        
        CCSelectableItem *layer;
        CCLabelTTF *price;
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
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1,000,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);

        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        
        // BACKGROUND 2
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Background 2"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlbg2.png"];
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1,000,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        
        // BACKGROUND 3
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Background 3"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlbg3.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1,000,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // BACKGROUND 4
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Background 4"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlbg4.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1,000,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // PARTICLE COLOUR 1
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Original Yellow"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlp1.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // PARTICLE COLOUR 2
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Blue"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlp5.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"800,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // PARTICLE COLOUR 3
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Green"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlp3.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"800,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // PARTICLE COLOUR 4
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Red"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlp4.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"800,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // PARTICLE COLOUR 5
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"White"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlp2.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1,000,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // MULTIPLIER
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Increase Multiplier"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"multiplier.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"3,000,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // INCREASE HEALTH
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Increase Max Life"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"increaseHealth.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"2,000,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // CIRCLE TRAIL
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Circle Trail"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"p0.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // DIAMOND TRAIL
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Diamond Trail"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"p1.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"800,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // SQUARE TRAIL
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Square Trail"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"p2.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"800,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // STAR TRAIL
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Star Trail"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"p3.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"800,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // ORIGINAL SMILEY
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Original Smiley"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"originalSmiley.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // PINK SMILEY
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Pink Smiley"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"pinkSmiley.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"2,500,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // YELLOW SMILEY
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Yellow Smiley"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"yellowSmiley.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"2,500,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
        // BLACK SMILEY
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Black Smiley"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"blackSmiley.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        price = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"3,000,000"] fontName:@"Collegiate-Normal" fontSize:18];
        price.color = ccYELLOW;
        price.position = ccp(priceMove , layer.contentSize.height/2);
        
        [layer addChild:button];
        [layer addChild:label];
        [layer addChild:price];
        
        [array addObject:layer];
        
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
    NSInteger number;
    
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
        case 5:
            [prefs setInteger:1 forKey:@"colour"];
            break;
        case 6:
            [prefs setInteger:2 forKey:@"colour"];
            break;
        case 7:
            [prefs setInteger:3 forKey:@"colour"];
            break;
        case 8:
            [prefs setInteger:4 forKey:@"colour"];
            break;
        case 9:
            [prefs setInteger:5 forKey:@"colour"];
            break;
        case 10:
            number = [prefs integerForKey:@"multiplier"];
            [prefs setInteger:(number + 1) forKey:@"multiplier"];
            break;
        case 11:
            number = [prefs integerForKey:@"life"];
            [prefs setInteger:(number + 1) forKey:@"life"];
            break;
        case 12:
            backgroundString = @"particleCircle.png";
            [prefs setObject:backgroundString forKey:@"particle"];
            break;
        case 13:
            backgroundString = @"particleDiamond.png";
            [prefs setObject:backgroundString forKey:@"particle"];
            break;
        case 14:
            backgroundString = @"particleSquare.png";
            [prefs setObject:backgroundString forKey:@"particle"];
            break;
        case 15:
            backgroundString = @"particleStar.png";
            [prefs setObject:backgroundString forKey:@"particle"];
            break;
        case 16:
            backgroundString = @"hero.png";
            [prefs setObject:backgroundString forKey:@"smiley"];
            break;
        case 17:
            backgroundString = @"pink.png";
            [prefs setObject:backgroundString forKey:@"smiley"];
            break;
        case 18:
            backgroundString = @"yellow.png";
            [prefs setObject:backgroundString forKey:@"smiley"];
            break;
        case 19:
            backgroundString = @"black.png";
            [prefs setObject:backgroundString forKey:@"smiley"];
            break;
        default:
            break;
            
    }
}

- (void)itemsScroller:(CCItemsScroller *)sender didUnSelectItemIndex:(int)index {
    
}

@end
