//
//  PowerEater.h
//  Smiley Dash
//
//  Created by Stephen Sowole on 14/05/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PowerEater : CCSprite {
    
	float speed;
    int time;
    
}

@property (readwrite, assign) float speed;
@property (readwrite, assign) int time;

@end
