//
//  GameLayer.h
//  Smiley Dash
//
//  Created by Stephen Sowole on 07/05/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer {
    
    CCSprite *hero, *background;
    CGPoint touchLocation;
    CGPoint previousTouch;
    BOOL touchMoved;
    int heroLife, levelEnemyCount, particleLimit;
    float time;
    NSUserDefaults *prefs;
}

+(id)nodeScenario:(int)resume;

+(CCScene *) scene:(int)resume;

@end
