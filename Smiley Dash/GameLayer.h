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
    BOOL touchMoved;
    int heroLife, levelEnemyCount, particleLimit;;
    float time;
}

+(id)nodeScenario:(int)resume;

+(CCScene *) scene:(int)resume;

@end
