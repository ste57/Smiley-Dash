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

CCLabelTTF *scoreLabel, *pricebg1, *pricebg2, *pricebg3, *pricebg4;
CCLabelTTF *pricep1, *pricep2, *pricep3, *pricep4;
CCLabelTTF *pricepart1, *pricepart2, *pricepart3;
CCLabelTTF *prices1, *prices2, *prices3;
CCLabelTTF *pricelife, *pricemult;
CCLabelTTF *pricehelp, *pricenuke;
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
            priceMove = 90;
            
        } else {
            
            background = [CCSprite spriteWithFile:@"store.png"];
            screenFactor = 90;
            priceMove = 55;
        }
        
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        CCLabelTTF *label;
        
        ccColor3B labelColor = ccYELLOW;
        NSString *labelstyle = @"Collegiate-Normal";
        int labelFontSize = 14;
        
        CCSprite *scoreImage = [CCSprite spriteWithFile:@"scoreSprite.png"];
        scoreImage.color = ccYELLOW;
        scoreImage.position = ccp(size.width/2 - 50, size.height - 20);
        [self addChild:scoreImage z:4];
        [scoreImage runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:10.0 angle:400]]];
        
        NSInteger highScore = [prefs doubleForKey:@"totalScore"];
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:highScore]];
        
        [formatter release];
        
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", formatted] fontName:@"Larabiefont" fontSize:23];
        [scoreLabel setAnchorPoint:ccp(0, 0)];
        scoreLabel.position = ccp(size.width/2 - 30, size.height - 32);
        scoreLabel.color = ccYELLOW;
        [self addChild:scoreLabel z:4];
        
        
        // BACK BUTTON
        
        CCMenuItem *back = [CCMenuItemImage itemWithNormalImage:@"backOff.png" selectedImage:@"backOn.png" target:self selector:@selector(goBack:)];
        
        back.position = ccp(size.width/20, size.height/15 * 14);
        
        CCMenu *menu = [CCMenu menuWithItems:back, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];

        
        // SELECTABLE ITEMS
        
        CCSelectableItem *layer;
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
        
        if (![prefs integerForKey:@"unlockbg1"]) {
        
            pricebg1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricebg1.color = labelColor;
            pricebg1.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricebg1 z:2];
        
        }
        
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        
        [layer addChild:button];
        [layer addChild:label];

        
        [array addObject:layer];
        
        
        // BACKGROUND 2
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Background 2"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlbg2.png"];
        
        if (![prefs integerForKey:@"unlockbg2"]) {
            
            pricebg2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricebg2.color = labelColor;
            pricebg2.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricebg2 z:2];
            
        }
        
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
        
        if (![prefs integerForKey:@"unlockbg3"]) {
            
            pricebg3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricebg3.color = labelColor;
            pricebg3.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricebg3 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // BACKGROUND 4
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Background 4"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlbg4.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlockbg4"]) {
            
            pricebg4 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricebg4.color = labelColor;
            pricebg4.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricebg4 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
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
        
        if (![prefs integerForKey:@"unlockp1"]) {
            
            pricep1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"800,000"] fontName:labelstyle fontSize:labelFontSize];
            pricep1.color = labelColor;
            pricep1.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricep1 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // PARTICLE COLOUR 3
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Green"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlp3.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlockp2"]) {
            
            pricep2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"800,000"] fontName:labelstyle fontSize:labelFontSize];
            pricep2.color = labelColor;
            pricep2.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricep2 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // PARTICLE COLOUR 4
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Red"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlp4.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlockp3"]) {
            
            pricep3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"800,000"] fontName:labelstyle fontSize:labelFontSize];
            pricep3.color = labelColor;
            pricep3.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricep3 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];

        [array addObject:layer];
        
        // PARTICLE COLOUR 5
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"White"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"dlp2.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlockp4"]) {
            
            pricep4 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricep4.color = labelColor;
            pricep4.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricep4 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // MULTIPLIER
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Increase Multiplier"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"multiplier.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlockmultiplier"]) {
            
            pricemult = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"3,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricemult.color = labelColor;
            pricemult.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricemult z:2];
            
        } else if ([prefs integerForKey:@"unlockmultiplier"] == 1) {
            
            pricemult = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"6,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricemult.color = labelColor;
            pricemult.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricemult z:2];
            
        } else if ([prefs integerForKey:@"unlockmultiplier"] == 2) {
            
            pricemult = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"10,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricemult.color = labelColor;
            pricemult.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricemult z:2];
            
        } else {
            
            pricemult = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"MAX"] fontName:labelstyle fontSize:40];
            pricemult.color = ccBLACK;
            pricemult.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricemult z:2];
            
        }
    
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // INCREASE HEALTH
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Increase Max Life"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"increaseHealth.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlockmaxhealth"]) {
            
            pricelife = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"2,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricelife.color = labelColor;
            pricelife.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricelife z:2];
            
        } else if ([prefs integerForKey:@"unlockmaxhealth"] == 1) {
            
            pricelife = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"4,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricelife.color = labelColor;
            pricelife.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricelife z:2];
            
        } else if ([prefs integerForKey:@"unlockmaxhealth"] == 2) {
            
            pricelife = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"6,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricelife.color = labelColor;
            pricelife.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricelife z:2];
            
        } else if ([prefs integerForKey:@"unlockmaxhealth"] == 3) {
            
            pricelife = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"8,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricelife.color = labelColor;
            pricelife.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricelife z:2];
            
        } else if ([prefs integerForKey:@"unlockmaxhealth"] == 4) {
            
            pricelife = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"10,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricelife.color = labelColor;
            pricelife.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricelife z:2];
            
        } else if ([prefs integerForKey:@"unlockmaxhealth"] == 5) {
            
            pricelife = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"12,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricelife.color = labelColor;
            pricelife.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricelife z:2];

        } else {
            pricelife = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"MAX"] fontName:labelstyle fontSize:40];
            pricelife.color = ccBLACK;
            pricelife.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricelife z:2];

        }
            
        [layer addChild:button];
        [layer addChild:label];
        
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
        
        if (![prefs integerForKey:@"unlockpart1"]) {
            
            pricepart1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"800,000"] fontName:labelstyle fontSize:labelFontSize];
            pricepart1.color = labelColor;
            pricepart1.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricepart1 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // SQUARE TRAIL
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Square Trail"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"p2.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlockpart2"]) {
            
            pricepart2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"800,000"] fontName:labelstyle fontSize:labelFontSize];
            pricepart2.color = labelColor;
            pricepart2.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricepart2 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // STAR TRAIL
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Star Trail"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"p3.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlockpart3"]) {
            
            pricepart3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"1,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricepart3.color = labelColor;
            pricepart3.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricepart3 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
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
        
        if (![prefs integerForKey:@"unlocksmiley1"]) {
            
            prices1 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"2,500,000"] fontName:labelstyle fontSize:labelFontSize];
            prices1.color = labelColor;
            prices1.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:prices1 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // YELLOW SMILEY
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Yellow Smiley"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"yellowSmiley.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlocksmiley2"]) {
            
            prices2 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"2,500,000"] fontName:labelstyle fontSize:labelFontSize];
            prices2.color = labelColor;
            prices2.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:prices2 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // BLACK SMILEY
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Black Smiley"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"blackSmiley.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlocksmiley3"]) {
            
            prices3 = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"3,000,000"] fontName:labelstyle fontSize:labelFontSize];
            prices3.color = labelColor;
            prices3.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:prices3 z:2];
            
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // HELPER POWERUP
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Helper Power-up"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"helperbutton.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlockhelper"]) {
            
            pricehelp = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"5,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricehelp.color = labelColor;
            pricehelp.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricehelp z:2];
            
        } else {
            
            pricenuke = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"UNLOCKED"] fontName:labelstyle fontSize:labelFontSize];
            pricenuke.color = labelColor;
            pricenuke.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricenuke z:2];
        }

        
        [layer addChild:button];
        [layer addChild:label];
        
        [array addObject:layer];
        
        // NUKE POWERUP
        
        layer = [[CCSelectableItem alloc] initWithNormalColor:ccc4(160,65,13,0) andSelectectedColor:ccc4(91, 93, 92, 180) andWidth:size.width-screenFactor andHeight:80];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Nuke Power-up"] fontName:@"Collegiate-Normal" fontSize:15];
        button = [CCSprite spriteWithFile:@"nukebutton.png"];
        
        button.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        label.position = ccp(layer.contentSize.width/2, layer.contentSize.height/2);
        
        if (![prefs integerForKey:@"unlocknuke"]) {
            
            pricenuke = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"6,000,000"] fontName:labelstyle fontSize:labelFontSize];
            pricenuke.color = labelColor;
            pricenuke.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricenuke z:2];
            
        } else {
            
            pricenuke = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"UNLOCKED"] fontName:labelstyle fontSize:labelFontSize];
            pricenuke.color = labelColor;
            pricenuke.position = ccp(priceMove , layer.contentSize.height/2);
            [layer addChild:pricenuke z:2];
        }
        
        [layer addChild:button];
        [layer addChild:label];
        
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
    NSInteger highScore = [prefs doubleForKey:@"totalScore"];
    
    switch (index) {
            
        case 0:
            
            backgroundString = @"bg1";
            [prefs setObject:backgroundString forKey:@"background"];
            break;
            
        case 1:
            
            if (![prefs integerForKey:@"unlockbg1"] && highScore >= 1000000) {
                
                [prefs setDouble:(highScore - 1000000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockbg1"];
                [pricebg1 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlockbg1"]) {
                
                backgroundString = @"b1";
                [prefs setObject:backgroundString forKey:@"background"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;
        case 2:
            
            if (![prefs integerForKey:@"unlockbg2"] && highScore >= 1000000) {
                
                [prefs setDouble:(highScore - 1000000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockbg2"];
                [pricebg2 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlockbg2"]) {
                
                backgroundString = @"b2";
                [prefs setObject:backgroundString forKey:@"background"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;
        case 3:
            
            if (![prefs integerForKey:@"unlockbg3"] && highScore >= 1000000) {
                
                [prefs setDouble:(highScore - 1000000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockbg3"];
                [pricebg3 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlockbg3"]) {
                
                backgroundString = @"b3";
                [prefs setObject:backgroundString forKey:@"background"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;

        case 4:
            
            if (![prefs integerForKey:@"unlockbg4"] && highScore >= 1000000) {
                
                [prefs setDouble:(highScore - 1000000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockbg4"];
                [pricebg4 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlockbg4"]) {
                
                backgroundString = @"b4";
                [prefs setObject:backgroundString forKey:@"background"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;
        case 5:
            [prefs setInteger:1 forKey:@"colour"];
            break;
        case 6:
                
            if (![prefs integerForKey:@"unlockp1"] && highScore >= 800000) {
                
                [prefs setDouble:(highScore - 800000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockp1"];
                [pricep1 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlockp1"]) {
                
                [prefs setInteger:2 forKey:@"colour"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            
            break;
        case 7:
            
            if (![prefs integerForKey:@"unlockp2"] && highScore >= 800000) {
                
                [prefs setDouble:(highScore - 800000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockp2"];
                [pricep2 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlockp2"]) {
                
                [prefs setInteger:3 forKey:@"colour"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            
            break;
        case 8:
            
            if (![prefs integerForKey:@"unlockp3"] && highScore >= 800000) {
                
                [prefs setDouble:(highScore - 800000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockp3"];
                [pricep3 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlockp3"]) {
                
                [prefs setInteger:4 forKey:@"colour"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            
            break;
        case 9:
            
            if (![prefs integerForKey:@"unlockp4"] && highScore >= 1000000) {
                
                [prefs setDouble:(highScore - 1000000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockp4"];
                [pricep4 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlockp4"]) {
                
                [prefs setInteger:5 forKey:@"colour"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            
            break;
        case 10:
            
            if (![prefs integerForKey:@"unlockmultiplier"] && highScore >= 3000000) {
                
                [prefs setDouble:(highScore - 3000000) forKey:@"totalScore"];
                [pricemult setString:[NSString stringWithFormat:@"6,000,000"]];
                
                 [prefs setInteger:1 forKey:@"unlockmultiplier"];
                
                number = [prefs integerForKey:@"multiplier"];
                [prefs setInteger:(number + 1) forKey:@"multiplier"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            } else if ([prefs integerForKey:@"unlockmultiplier"] == 1 && highScore >= 6000000) {
                
                [prefs setDouble:(highScore - 6000000) forKey:@"totalScore"];
                [pricemult setString:[NSString stringWithFormat:@"10,000,000"]];
                
                [prefs setInteger:2 forKey:@"unlockmultiplier"];
                
                number = [prefs integerForKey:@"multiplier"];
                [prefs setInteger:(number + 1) forKey:@"multiplier"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            } else if ([prefs integerForKey:@"unlockmultiplier"] == 2 && highScore >= 10000000) {
                
                [prefs setDouble:(highScore - 10000000) forKey:@"totalScore"];
                [pricemult setString:[NSString stringWithFormat:@"MAX"]];
                [pricemult setFontSize:40];
                [pricemult setColor:ccBLACK];
                
                [prefs setInteger:3 forKey:@"unlockmultiplier"];
                
                number = [prefs integerForKey:@"multiplier"];
                [prefs setInteger:(number + 1) forKey:@"multiplier"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
            }
            
            break;
        case 11:
            
            if (![prefs integerForKey:@"unlockmaxhealth"] && highScore >= 2000000) {
                
                [prefs setDouble:(highScore - 2000000) forKey:@"totalScore"];
                [pricelife setString:[NSString stringWithFormat:@"4,000,000"]];
                
                [prefs setInteger:1 forKey:@"unlockmaxhealth"];
            
                number = [prefs integerForKey:@"life"];
                [prefs setInteger:(number + 1) forKey:@"life"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            } else if ([prefs integerForKey:@"unlockmaxhealth"] == 1 && highScore >= 4000000) {
                
                [prefs setDouble:(highScore - 4000000) forKey:@"totalScore"];
                [pricelife setString:[NSString stringWithFormat:@"6,000,000"]];
                
                [prefs setInteger:2 forKey:@"unlockmaxhealth"];
                
                number = [prefs integerForKey:@"life"];
                [prefs setInteger:(number + 1) forKey:@"life"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            } else if ([prefs integerForKey:@"unlockmaxhealth"] == 2 && highScore >= 6000000) {
                
                [prefs setDouble:(highScore - 6000000) forKey:@"totalScore"];
                [pricelife setString:[NSString stringWithFormat:@"8,000,000"]];
                
                [prefs setInteger:3 forKey:@"unlockmaxhealth"];
                
                number = [prefs integerForKey:@"life"];
                [prefs setInteger:(number + 1) forKey:@"life"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            } else if ([prefs integerForKey:@"unlockmaxhealth"] == 3 && highScore >= 8000000) {
                
                [prefs setDouble:(highScore - 8000000) forKey:@"totalScore"];
                [pricelife setString:[NSString stringWithFormat:@"10,000,000"]];
                
                [prefs setInteger:4 forKey:@"unlockmaxhealth"];
                
                number = [prefs integerForKey:@"life"];
                [prefs setInteger:(number + 1) forKey:@"life"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            } else if ([prefs integerForKey:@"unlockmaxhealth"] == 4 && highScore >= 10000000) {
                
                [prefs setDouble:(highScore - 10000000) forKey:@"totalScore"];
                [pricelife setString:[NSString stringWithFormat:@"12,000,000"]];
                
                [prefs setInteger:5 forKey:@"unlockmaxhealth"];
                
                number = [prefs integerForKey:@"life"];
                [prefs setInteger:(number + 1) forKey:@"life"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            } else if ([prefs integerForKey:@"unlockmaxhealth"] == 5 && highScore >= 12000000) {
                
                [prefs setDouble:(highScore - 12000000) forKey:@"totalScore"];
                [pricelife setString:[NSString stringWithFormat:@"MAX"]];
                [pricelife setFontSize:40];
                [pricelife setColor:ccBLACK];
                
                [prefs setInteger:6 forKey:@"unlockmaxhealth"];
                
                number = [prefs integerForKey:@"life"];
                [prefs setInteger:(number + 1) forKey:@"life"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
            }

            break;
        case 12:
            backgroundString = @"particleCircle.png";
            [prefs setObject:backgroundString forKey:@"particle"];
            break;
        case 13:
            
            if (![prefs integerForKey:@"unlockpart1"] && highScore >= 800000) {
                
                [prefs setDouble:(highScore - 800000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockpart1"];
                [pricepart1 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlockpart1"]) {
                
                backgroundString = @"particleDiamond.png";
                [prefs setObject:backgroundString forKey:@"particle"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;
        case 14:
            
            if (![prefs integerForKey:@"unlockpart2"] && highScore >= 800000) {
                
                [prefs setDouble:(highScore - 800000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockpart2"];
                [pricepart2 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlockpart2"]) {
                
                backgroundString = @"particleSquare.png";
                [prefs setObject:backgroundString forKey:@"particle"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;
        case 15:
            
            if (![prefs integerForKey:@"unlockpart3"] && highScore >= 1000000) {
                
                [prefs setDouble:(highScore - 1000000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockpart3"];
                [pricepart3 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlockpart3"]) {
                
                backgroundString = @"particleStar.png";
                [prefs setObject:backgroundString forKey:@"particle"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;
        case 16:
            backgroundString = @"hero.png";
            [prefs setObject:backgroundString forKey:@"smiley"];
            break;
        case 17:
            
            if (![prefs integerForKey:@"unlocksmiley1"] && highScore >= 2500000) {
                
                [prefs setDouble:(highScore - 2500000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlocksmiley1"];
                [prices1 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlocksmiley1"]) {
                
                backgroundString = @"pink.png";
                [prefs setObject:backgroundString forKey:@"smiley"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;
        case 18:
            if (![prefs integerForKey:@"unlocksmiley2"] && highScore >= 2500000) {
                
                [prefs setDouble:(highScore - 2500000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlocksmiley2"];
                [prices2 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlocksmiley2"]) {
                
                backgroundString = @"yellow.png";
                [prefs setObject:backgroundString forKey:@"smiley"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;

        case 19:
            if (![prefs integerForKey:@"unlocksmiley3"] && highScore >= 3000000) {
                
                [prefs setDouble:(highScore - 3000000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlocksmiley3"];
                [prices3 setString:[NSString stringWithFormat:@""]];
                
            }
            
            if ([prefs integerForKey:@"unlocksmiley3"]) {
                
                backgroundString = @"black.png";
                [prefs setObject:backgroundString forKey:@"smiley"];
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;
        case 20:
            if (![prefs integerForKey:@"unlockhelper"] && highScore >= 5000000) {
                
                [prefs setDouble:(highScore - 5000000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlockhelper"];
                [pricehelp setString:[NSString stringWithFormat:@"UNLOCKED"]];
                
            }
            
            if ([prefs integerForKey:@"unlockhelper"]) {
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;
        case 21:
            if (![prefs integerForKey:@"unlocknuke"] && highScore >= 6000000) {
                
                [prefs setDouble:(highScore - 6000000) forKey:@"totalScore"];
                [prefs setInteger:1 forKey:@"unlocknuke"];
                [pricenuke setString:[NSString stringWithFormat:@"UNLOCKED"]];
                
            }
            
            if ([prefs integerForKey:@"unlocknuke"]) {
                
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                
                NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[prefs integerForKey:@"totalScore"]]];
                
                [formatter release];
                
                [scoreLabel setString:[NSString stringWithFormat:@"%@", formatted]];
                
            }
            break;

        default:
            break;
            
    }
}

- (void)itemsScroller:(CCItemsScroller *)sender didUnSelectItemIndex:(int)index {
    
}

@end
