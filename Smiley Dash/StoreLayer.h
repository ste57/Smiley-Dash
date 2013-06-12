//
//  StoreLayer.h
//  Smiley Dash
//
//  Created by Stephen Sowole on 06/06/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCItemsScroller.h"

@interface StoreLayer : CCLayer <CCItemsScrollerDelegate> {
    
    NSUserDefaults *prefs;
    
}

+(CCScene *) scene;

@end
