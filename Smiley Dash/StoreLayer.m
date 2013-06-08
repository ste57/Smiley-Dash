//
//  StoreLayer.m
//  Smiley Dash
//
//  Created by Stephen Sowole on 06/06/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import "StoreLayer.h"
#import "CCSelectableItem.h"


CCItemsScroller *itemScroll;
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
        
        array = [[NSMutableArray alloc] init];
        
        CCSprite *background;
        
        // if iphone 5, change the display to use the larger image
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            background = [CCSprite spriteWithFile:@"menu-568h.png"];
            
        } else {
            
            background = [CCSprite spriteWithFile:@"menu.png"];
            
        }
        
        background.position = ccp(size.width/2, size.height/2);
        
        [self addChild:background];



        
       /* play.position = ccp(size.width/2, size.height/5 * 2);
        guide.position = ccp(size.width/2 - 75, (size.height/5));
        store.position = ccp(size.width/2 + 75, (size.height/5));
        about.position = ccp(size.width/11, size.height/2);*/
        
        //CCMenu *menu = [CCMenu menuWithItems:play, guide, store, about, nil];
        //menu.position = CGPointZero;

        
        //[self addChild:menu];
        
        //CCMenuAdvanced * menuAd = [CCMenuAdvanced menuWithItems:play, guide, store, about, about2, about3, about4, nil];
        
        //menuAd.position = CGPointZero;
       // [menuAd alignItemsVerticallyWithPadding:10];
        
       // menuAd.boundaryRect = CGRectMake(0, 0, size.width, size.height);
        //[menuAd fixPosition];
        
        
        
        /*menuAd.contentSize=CGSizeMake(667, 86*4);
        [menuAd setBoundaryRect:CGRectMake(-270, 0, 667, 250)];
        [menuAd alignItemsVertically];
        [menuAd fixPosition];
        
        menuAd.bEaseVertical=YES;
        menuAd.fEaseConstant=10;
        menuAd.fBounceBack=2;
        
        [self addChild:menuAd];*/
        
        //CCSelectableItem *bg = [[CCSelectableItem alloc] initWithColor:ccc4(255, 255, 255, 255) width:size.width-40 height:40];
        
        /*CCSprite *menu = [CCSprite spriteWithFile:@"playOn.png"];
        menu.position = ccp(bg.contentSize.width/2, bg.contentSize.height/2);
        [bg addChild:menu];
        
        [array addObject:bg];*/
        
        for (int i = 15; i > 0; i--) {
            CCSelectableItem *page = [[CCSelectableItem alloc] initWithNormalColor:ccc4(150, 150, 150, 125) andSelectectedColor:ccc4(190, 150, 150, 255) andWidth:size.width-40 andHeight:40];
            
            //CCLabelTTF *lbl = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"item #%d", i+1] fontName:@"Marker Felt" fontSize:15];
            CCSprite *button = [CCSprite spriteWithFile:@"]
            lbl.position = ccp(page.contentSize.width/2, page.contentSize.height/2);
            [page addChild:lbl];
            page.identifier = i;
            [array addObject:page];
        }
        
        itemScroll = [CCItemsScroller itemsScrollerWithItems:array andOrientation:CCItemsScrollerVertical andRect:CGRectMake(0, 0, size.width, size.height)];
        
        [self addChild:itemScroll];
        
        self.touchEnabled = YES;
	}
    
	return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // get touch location
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation;
    
    touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    for (CCSelectableItem *item in array) {

        if (CGRectContainsPoint(item.boundingBox, touchLocation)) {
            
            printf("  %i  ", item.identifier);
            
        }
        
    }
    
}


- (void) dealloc {
    
    [super dealloc];
    [array release];

    array = nil;

}

@end
