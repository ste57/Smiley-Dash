//
//  Enemy.h
//  Smiley Dash
//
//  Created by Stephen Sowole on 13/05/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Enemy : CCSprite {
    
	float speed;
    float maxSpeed;
    int time;
    int xChange;
    int yChange;
    int type;
    int bouncerNo;
    int collidedWith;
    
}

@property (readwrite, assign) float speed;
@property (readwrite, assign) float maxSpeed;
@property (readwrite, assign) int time;
@property (readwrite, assign) int xChange;
@property (readwrite, assign) int yChange;
@property (readwrite, assign) int type;
@property (readwrite, assign) int bouncerNo;
@property (readwrite, assign) int collidedWith;

@end