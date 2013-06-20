//
//  TutorialLayer.m
//  Smiley Dash
//
//  Created by Stephen Sowole on 05/06/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import "TutorialLayer.h"
#import "Config.h"
#import "GameLayer.h"
#import "MenuLayer.h"

NSMutableArray * particles;
NSMutableArray * objects;

/*int tutorialStage;
 bool stageRunning;
 bool touchMoved;
 CCSprite *hero;
 CGPoint touchLocation;
 double heroSpeed;
 int startParticle;
 int particleLimit;
 int circlesDrawn;
 bool circleCreated;
 
 ccColor3B particleColor;*/

int particleLimit;
CCSprite *hero;
ccColor3B particleColor;
double heroSpeed;
int circlesDrawn;
bool circleCreated;
int tutorialStage;
bool touchMoved;
bool stageRunning;

@implementation TutorialLayer

+ (CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TutorialLayer *layer = [TutorialLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) movePos:(float)x yVal:(float)y chase:(CCSprite*)sprite speed:(double)speed {
    
    float diffx = (x - sprite.position.x);
    float diffy = (y - sprite.position.y);
    float z = pow((pow(diffx,2)+pow(diffy,2)), 0.5);
    
    float xVal = sprite.position.x + ((diffx/z) * speed);
    float yVal = sprite.position.y + ((diffy/z) * speed);
    
    sprite.position = ccp(xVal, yVal);
}

- (double) calculateDistanceBetween:(CGPoint)firstObject and:(CGPoint)secondObject {
    
    double diffx = firstObject.x - secondObject.x;
    double diffy = firstObject.y - secondObject.y;
    diffx = pow(diffx, 2);
    diffy = pow(diffy, 2);
    double lengthIntersect = pow((diffx + diffy), 0.5);
    
    return (double) lengthIntersect;
}

- (id) init {
    
	if( (self=[super init])) {
        
        [self removeAllChildrenWithCleanup:YES];
        
        particles = [[NSMutableArray alloc] init];
        objects = [[NSMutableArray alloc] init];
        
        // ask director for the window size
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            background = [CCSprite spriteWithFile:@"stage1-568h.png"];
            
        } else {
            
            background = [CCSprite spriteWithFile:@"stage1.png"];
            
        }
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            particleLimit = iphone5Limit;
            
        } else if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 480)){
            
            particleLimit = iphoneRetinaLimit;
            
        } else {
            
            particleLimit = iphoneParticleLimit;
            
        }
        
        background.position = ccp(winSize.width/2, winSize.height/2);
        
        [self addChild: background];
        
        hero = [CCSprite spriteWithFile:@"hero.png"];
        hero.position = ccp(winSize.width/2,winSize.height/2);
        hero.tag = heroTag;
        
        [self addChild:hero z:2];
        
        [self setValues];
        
        particleColor = ccYELLOW;
        
        self.touchEnabled = YES;
        [self schedule:@selector(update:)];
        
        
    }
    
	return self;
}

- (void) setValues {
    
    heroSpeed = heroStartSpeed;
    circlesDrawn = 0;
    circleCreated = false;
    tutorialStage = 0;
    touchMoved = NO;
    stageRunning = false;
}

- (void) runFirstStage {
    
    if (stageRunning == false) {
        
        CCSprite * star;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        star = [CCSprite spriteWithFile:@"coin.png"];
        star.position = ccp(winSize.width/4,winSize.height/4 * 3);
        
        [self addChild:star z:2];
        [objects addObject:star];
        [star runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2.0 angle:180]]];
        
        star = [CCSprite spriteWithFile:@"coin.png"];
        star.position = ccp(winSize.width/4 * 3,winSize.height/4 * 3);
        
        [self addChild:star z:2];
        [objects addObject:star];
        [star runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2.0 angle:180]]];
        
        star = [CCSprite spriteWithFile:@"coin.png"];
        star.position = ccp(winSize.width/4,winSize.height/4);
        
        [self addChild:star z:2];
        [objects addObject:star];
        [star runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2.0 angle:180]]];
        
        star = [CCSprite spriteWithFile:@"coin.png"];
        star.position = ccp(winSize.width/4 * 3,winSize.height/4);
        
        [self addChild:star z:2];
        [objects addObject:star];
        [star runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2.0 angle:180]]];
        
        star = [CCSprite spriteWithFile:@"coin.png"];
        star.position = ccp(winSize.width/10,winSize.height/2);
        
        [self addChild:star z:2];
        [objects addObject:star];
        [star runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2.0 angle:180]]];
        
        star = [CCSprite spriteWithFile:@"coin.png"];
        star.position = ccp(winSize.width/10 * 9,winSize.height/2);
        
        [self addChild:star z:2];
        [objects addObject:star];
        [star runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2.0 angle:180]]];
        
        star = [CCSprite spriteWithFile:@"coin.png"];
        star.position = ccp(winSize.width/2,winSize.height/5 * 4);
        
        [self addChild:star z:2];
        [objects addObject:star];
        [star runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2.0 angle:180]]];
        
        star = [CCSprite spriteWithFile:@"coin.png"];
        star.position = ccp(winSize.width/2,winSize.height/5);
        
        [self addChild:star z:2];
        [objects addObject:star];
        [star runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:2.0 angle:180]]];
        
        stageRunning = true;
        
    }
    
    
    for (CCSprite * star in objects) {
        
        if (CGRectIntersectsRect(hero.boundingBox, star.boundingBox)) {
            
            [self removeChild:star];
            [objects removeObject:star];
            break;
            
        }
        
    }
    
    if (objects.count == 0) {
        
        tutorialStage ++;
        stageRunning = false;
        
    }
    
    
}

- (void) runSecondStage {
    
    if (stageRunning == false) {
        
        [self removeAllParticles];
        
        CCSprite *enemy = [CCSprite spriteWithFile:@"normalEnemy.png"];
        enemy.tag = enemy_tag;
        
        [objects addObject:enemy];
        [self addChild:enemy z:2];
        
        CCSprite *enemy2 = [CCSprite spriteWithFile:@"normalEnemy.png"];
        enemy2.tag = enemy_tag;
        
        [objects addObject:enemy2];
        [self addChild:enemy2 z:2];
        
        heroSpeed = 0;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        [self removeChild:background];
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            background = [CCSprite spriteWithFile:@"stage2-568h.png"];
            hero.position = ccp(winSize.width/5, winSize.height/4 * 2.75);
            enemy.position = ccp(winSize.width/1.9, winSize.height/2);
            enemy2.position = ccp(winSize.width/1.9, winSize.height/2.4);
            
        } else {
            
            background = [CCSprite spriteWithFile:@"stage2.png"];
            hero.position = ccp(winSize.width/7, winSize.height/4 * 2.75);
            enemy.position = ccp(winSize.width/1.9, winSize.height/2);
            enemy2.position = ccp(winSize.width/1.9, winSize.height/2.4);
            
        }
        
        background.position = ccp(winSize.width/2, winSize.height/2);
        
        [self addChild: background];
        
        stageRunning = true;
    }
    
}

- (void) runThirdStage {
    
    if (stageRunning == false) {
        
        [self removeAllParticles];
        
        CCSprite *enemy = [CCSprite spriteWithFile:@"normalEnemy.png"];
        enemy.tag = enemy_tag;
        
        [objects addObject:enemy];
        [self addChild:enemy z:2];
        
        CCSprite *enemy2 = [CCSprite spriteWithFile:@"normalEnemy.png"];
        enemy2.tag = enemy_tag;
        
        [objects addObject:enemy2];
        [self addChild:enemy2 z:2];
        
        heroSpeed = 0;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        [self removeChild:background];
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            background = [CCSprite spriteWithFile:@"stage3-568h.png"];
            hero.position = ccp(winSize.width/5, winSize.height/4 * 2.75);
            enemy.position = ccp(winSize.width/4 * 2.6, winSize.height/2);
            enemy2.position = ccp(winSize.width/4 * 1.5, winSize.height/2);
            
        } else {
            
            background = [CCSprite spriteWithFile:@"stage3.png"];
            hero.position = ccp(winSize.width/7, winSize.height/4 * 2.75);
            enemy.position = ccp(winSize.width/4 * 2.8, winSize.height/2);
            enemy2.position = ccp(winSize.width/4 * 1.3, winSize.height/2);
            
        }
        
        background.position = ccp(winSize.width/2, winSize.height/2);
        
        [self addChild: background];
        
        stageRunning = true;
    }
    
}

- (void) runFourthStage {
    
    [self removeChild:hero];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
        
        background = [CCSprite spriteWithFile:@"stage4-568h.png"];
        
    } else {
        
        background = [CCSprite spriteWithFile:@"stage4.png"];
        
    }
    
    background.position = ccp(winSize.width/2, winSize.height/2);
    
    [self addChild: background];
    
}

- (void) update:(ccTime)dt {
    
    [self followParticles];
    
    if (particles.count > 0) {
        
        [self checkDrawingCircle];
        
    }
    
    if (tutorialStage == 0) {
        
        [self runFirstStage];
        
    } else if (tutorialStage == 1) {
        
        [self runSecondStage];
        
    } else if (tutorialStage == 2) {
        
        [self runThirdStage];
        
    } else if (tutorialStage == 3) {
        
        [self runFourthStage];
        
        [self unschedule:@selector(update:)];
        
    }
    
}

- (void) drawParticles {
    
    CCSprite *particle = [particles lastObject];
    
    double lengthIntersect = [self calculateDistanceBetween:touchLocation and:particle.position];
    
    // ensures that particles do not bunch up together by checking that there are at least 10 pixels between the touch and the last particle
    if (lengthIntersect >= distanceBetweenParticles && lengthIntersect < distanceBetweenParticles*2) {
        
        CCSprite *particle;
        particle = [CCSprite spriteWithFile:@"particleCircle.png"];
        particle.color = particleColor;
        particle.position = touchLocation;
        [particles addObject:particle];
        [self addChild:particle];
        
    } else if (lengthIntersect >= distanceBetweenParticles*2 && lengthIntersect < distanceBetweenParticles*3) {
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:hero.position];
        
        if (lengthIntersect > hero.contentSize.width + 50) {
            
            CCSprite *firstParticle = [particles lastObject];
            
            double diffx = (touchLocation.x - firstParticle.position.x)/2;
            double diffy = (touchLocation.y - firstParticle.position.y)/2;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            CCSprite *particle;
            particle = [CCSprite spriteWithFile:@"particleCircle.png"];
            particle.color = particleColor;
            particle.position = ccp(diffx,diffy);
            [particles addObject:particle];
            [self addChild:particle];
        }
        
        particle = [CCSprite spriteWithFile:@"particleCircle.png"];
        particle.color = particleColor;
        particle.position = touchLocation;
        [particles addObject:particle];
        [self addChild:particle];
        
    } else if (lengthIntersect >= distanceBetweenParticles*3) {
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:hero.position];
        
        if (lengthIntersect > hero.contentSize.width + 50) {
            
            CCSprite *firstParticle = [particles lastObject];
            
            double diffx = (touchLocation.x - firstParticle.position.x)/3;
            double diffy = (touchLocation.y - firstParticle.position.y)/3;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            CCSprite *particle;
            particle = [CCSprite spriteWithFile:@"particleCircle.png"];
            particle.color = particleColor;
            particle.position = ccp(diffx,diffy);
            [particles addObject:particle];
            [self addChild:particle];
            
            diffx = ((touchLocation.x - firstParticle.position.x)/3) * 2;
            diffy = ((touchLocation.y - firstParticle.position.y)/3) * 2;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            particle = [CCSprite spriteWithFile:@"particleCircle.png"];
            particle.color = particleColor;
            particle.position = ccp(diffx,diffy);
            [particles addObject:particle];
            [self addChild:particle];
        }
        
        particle = [CCSprite spriteWithFile:@"particleCircle.png"];
        particle.color = particleColor;
        particle.position = touchLocation;
        [particles addObject:particle];
        [self addChild:particle];
        
    } else if (lengthIntersect >= distanceBetweenParticles*3 && lengthIntersect < distanceBetweenParticles*4){
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:hero.position];
        
        if (lengthIntersect > hero.contentSize.width + 50) {
            
            CCSprite *firstParticle = [particles lastObject];
            
            double diffx = (touchLocation.x - firstParticle.position.x)/3;
            double diffy = (touchLocation.y - firstParticle.position.y)/3;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            CCSprite *particle;
            particle = [CCSprite spriteWithFile:@"particleCircle.png"];
            particle.color = particleColor;
            particle.position = ccp(diffx,diffy);
            [particles addObject:particle];
            [self addChild:particle];
            
            diffx = ((touchLocation.x - firstParticle.position.x)/3) * 2;
            diffy = ((touchLocation.y - firstParticle.position.y)/3) * 2;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            particle = [CCSprite spriteWithFile:@"particleCircle.png"];
            particle.color = particleColor;
            particle.position = ccp(diffx,diffy);
            [particles addObject:particle];
            [self addChild:particle];
        }
        
        particle = [CCSprite spriteWithFile:@"particleCircle.png"];
        particle.color = particleColor;
        particle.position = touchLocation;
        [particles addObject:particle];
        [self addChild:particle];
        
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSMutableArray * toDelete = [[NSMutableArray alloc] init];
    
    bool delete = false;
    
    if (tutorialStage != 0 || circleCreated == true) {
        
        [self removeAllParticles];
        
        for (CCSprite *enemy in objects) {
            
            if (enemy.tag == frozenEnemy) {
                
                [toDelete addObject:enemy];
                
            }
        }
    }
    
    if (toDelete.count == tutorialStage && tutorialStage == 2) {
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0] ,[CCCallBlockN actionWithBlock:^(CCNode *node) {
            stageRunning = false;
            tutorialStage++;
        }], nil]];
        
        delete = true;
        
    } else if (tutorialStage == 1) {
        
        if (toDelete.count == 2) {
            
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.0] ,[CCCallBlockN actionWithBlock:^(CCNode *node) {
                stageRunning = false;
                tutorialStage++;
            }], nil]];
            
            delete = true;
            
        }
    }
    
    if (delete == true) {
        
        for (CCSprite *item in toDelete) {
            
            CCParticleSystem *emitter;
            
            emitter = [[CCParticleExplosion alloc] initWithTotalParticles:30];
            
            emitter.tangentialAccel = 30;
            
            ccColor4F startColor = ccc4FFromccc3B(ccYELLOW);
            emitter.startColor = startColor;
            
            ccColor4F endColor = {255, 255, 255, 0};
            emitter.endColor = endColor;
            
            emitter.speed = 0.3;
            
            emitter.position = item.position;
            
            emitter.scale = 0.6;
            
            emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"particleCircle.png"];
            
            emitter.life = 0.8f;
            
            emitter.lifeVar = 0;
            
            [self addChild:emitter];
            
            emitter.autoRemoveOnFinish = YES;
            
            [self removeChild:item];
            [objects removeObject:item];
        }
        
    } else {
        
        for (CCSprite *item in toDelete) {
            
            if (item.tag == frozenEnemy) {
                item.tag = enemy_tag;
            }
        }
    }
    
    [toDelete removeAllObjects];
    
    circlesDrawn = 0;
    circleCreated = false;
    touchMoved = NO;
    
    [toDelete release];
    toDelete = nil;
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    if (touchMoved == YES) {
        
        [self drawParticles];
    }
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // touch only moved when touch moved
    touchMoved = NO;
    
    // get touch location
    UITouch *touch = [touches anyObject];
    
    touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    if (tutorialStage != 3) {
        
        // calculate the distance between the touch and hero center
        double lengthIntersect = [self calculateDistanceBetween:hero.position and:touchLocation];
        
        // for some reason touchLocation is set to 0,0 at first (player is never going to touch here anyway)
        if (touchLocation.x != 0 && touchLocation.y != 0) {
            
            [self removeAllParticles];
            
            CCSprite *particle;
            
            // if touch is anywhere in the radius of the sprite plus around it then set touch to be moved and allow player to move it
            if (lengthIntersect <= hero.contentSize.width + 70) {
                
                touchMoved = YES;
                particle = [CCSprite spriteWithFile:@"particleCircle.png"];
                particle.color = particleColor;
                
            } else {
                
                particle = [CCSprite spriteWithFile:@"touch.png"];
                particle.color = particleColor;
                
                [particle runAction:[CCScaleTo actionWithDuration: 0.8 scaleX:2.5 scaleY:2.5]];
                [particle runAction:[CCFadeOut actionWithDuration:0.8]];
            }
            
            // stop any movements made by the hero
            particle.position = touchLocation;
            
            [particles addObject:particle];
            [self addChild:particle];
        }
    } else {
        
        if (CGRectContainsPoint(background.boundingBox, touchLocation)) {
            
            [self removeAllChildrenWithCleanup:YES];
            [self removeFromParentAndCleanup:YES];
            
            [particles removeAllObjects];
            [objects removeAllObjects];
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene:game_restart]]];
        }
        
    }
}

- (void) removeAllParticles {
    
    if (particles.count > 0) {
        
        for (CCSprite *particle in particles) {
            [self removeChild:particle cleanup:YES];
        }
    }
    
    [particles removeAllObjects];
}

- (CCSprite*) getParticle {
    
    CCSprite *particle;
    
    for (int i = 0; i < particles.count; i++) {
        
        particle = [particles objectAtIndex: i];
        
        if (particle.tag != circleParticle) {
            break;
        }
        
    }
    
    return particle;
}

- (void) followParticles {
    
    CCSprite* particle;
    
    if (particles.count > 0) {
        
        CCSprite *particle = [self getParticle];
        
        if (particle.tag != circleParticle) {
            
            // make the human chase the last particle
            [self movePos:particle.position.x yVal:particle.position.y chase:hero speed:heroSpeed];
            
            // if the human moves to the particle
            double lengthIntersect = [self calculateDistanceBetween:hero.position and:particle.position];
            
            // so that the powereater overlaps the powerup
            if (lengthIntersect <= particle.contentSize.width) {
                
                [particles removeObject: particle];
                [self removeChild:particle cleanup:YES];
                
            }
        }
        
    }
    
    // particle limit = 300
    if (particles.count > particleLimit) {
        
        // remove latest particle
        particle = [self getParticle];
        
        [particles removeObject: particle];
        [self removeChild:particle cleanup:YES];
        
    }
    
}

- (ccColor3B) changeColour:(int)circles {
    
    ccColor3B color;
    
    switch (circles) {
            
        case 0:
            color = ccc3(210,210,210);
            break;
        case 1:
            color = ccc3(255, 187, 255);
            break;
        case 2:
            color = ccc3(72, 118, 255);
            break;
        case 3:
            color = ccc3(202, 225, 255);
            break;
        case 4:
            color = ccc3(0, 255, 127);
            break;
        case 5:
            color = ccc3(255, 215, 0);
            break;
        case 6:
            color = ccc3(255, 128, 0);
            break;
        case 7:
            color = ccc3(230, 20, 20);
            break;
        default:
            color = ccc3(0, 0, 0);
            break;
    }
    
    return color;
}

- (void) checkDrawingCircle {
    
    bool enemyFrozen = false;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    float minY = winSize.height, minX = winSize.width, maxX = 0, maxY = 0;
    
    bool dobreak = false;
    
    if (touchMoved == YES) {
        
        ccColor3B color = [self changeColour:circlesDrawn];
        
        for (int i = 0; !dobreak && i < particles.count; i++) {
            
            CCSprite * firstParticle = [particles objectAtIndex:i];
            
            for (int j = i + 1; j < particles.count; j++) {
                
                CCSprite * secondParticle = [particles objectAtIndex:j];
                
                double lengthIntersect = [self calculateDistanceBetween:firstParticle.position and:secondParticle.position];
                
                if (lengthIntersect < distanceBetweenParticles && firstParticle.tag != circleParticle && secondParticle.tag != circleParticle) {
                    
                    for (int a = i + 1 ; a < j + 1; a++) {
                        
                        CCSprite * particle = [particles objectAtIndex:a];
                        
                        [particle setTexture:[[CCTextureCache sharedTextureCache] addImage:@"particleCircle.png"]];
                        
                        particle.color = color;
                        
                        particle.tag = circleParticle;
                        
                        if (particle.position.x > maxX) {
                            maxX = particle.position.x;
                        }
                        
                        if (particle.position.x < minX) {
                            minX = particle.position.x;
                        }
                        
                        if (particle.position.y > maxY) {
                            maxY = particle.position.y;
                        }
                        
                        if (particle.position.y < minY) {
                            minY = particle.position.y;
                        }
                        
                        
                    }
                    
                    for (CCSprite *enemy in objects) {
                        
                        float enX = enemy.position.x;
                        float enY = enemy.position.y;
                        
                        if (enX > minX && enX < maxX && enY > minY && enY < maxY) {
                            
                            if (enemy.tag == enemy_tag) {
                                enemy.tag = frozenEnemy;
                                enemyFrozen = true;
                                
                                CCSprite * select;
                                
                                select = [CCSprite spriteWithFile:@"select.png"];
                                
                                [select runAction:[CCScaleTo actionWithDuration: 0.8 scaleX:1.8 scaleY:1.8]];
                                CCFadeOut *fade = [CCFadeOut actionWithDuration:0.8];
                                [select runAction:[CCSequence actions:fade, [CCCallBlockN actionWithBlock:^(CCNode *node) {
                                    [self removeChild:select];
                                }], nil]];
                                
                                select.position = enemy.position;
                                select.tag = actionEffect;
                                
                                [self addChild:select z:2];
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    if (enemyFrozen == true) {
                        
                        circlesDrawn++;
                        // [self changeColour:circlesDrawn];
                        if (circlesDrawn > 1) {
                            
                            CCLabelTTF *pointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%01d", circlesDrawn] fontName:@"Nonstop" fontSize:15];
                            
                            
                            pointsLabel.position = ccp(((maxX - minX)/2) + minX, ((maxY - minY)/2) + minY);
                            // change the colour to yelllow
                            pointsLabel.color = ccc3(255, 255, 0);
                            
                            [pointsLabel runAction:[CCScaleTo actionWithDuration:1.0 scale:2.0]];
                            
                            [pointsLabel runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.7] ,[CCCallBlockN actionWithBlock:^(CCNode *node) {
                                [self removeChild:pointsLabel];;
                            }], nil]];
                            
                            [self addChild:pointsLabel z:4];
                        }
                        
                        
                    }
                    
                    circleCreated = true;
                    
                    dobreak = true;
                    
                    break;
                    
                }
            }
        }
    }
    
    
    /*CGSize winSize = [[CCDirector sharedDirector] winSize];
     
     float minY = winSize.height, minX = winSize.width, maxX = 0, maxY = 0;
     
     bool dobreak = false;
     
     if (touchMoved == YES) {
     
     ccColor3B color = [self changeColour:circlesDrawn];
     
     for (int i = 0; !dobreak && i < particles.count; i++) {
     
     CCSprite * firstParticle = [particles objectAtIndex:i];
     
     for (int j = i + 1; j < particles.count; j++) {
     
     CCSprite * secondParticle = [particles objectAtIndex:j];
     
     double lengthIntersect = [self calculateDistanceBetween:firstParticle.position and:secondParticle.position];
     
     if (lengthIntersect < distanceBetweenParticles && firstParticle.tag != circleParticle && secondParticle.tag != circleParticle) {
     
     for (int a = i + 1 ; a < j + 1; a++) {
     
     CCSprite * particle = [particles objectAtIndex:a];
     
     [particle setTexture:[[CCTextureCache sharedTextureCache] addImage:@"particleCircle.png"]];
     
     particle.color = color;
     
     particle.tag = circleParticle;
     
     if (particle.position.x > maxX) {
     maxX = particle.position.x;
     }
     
     if (particle.position.x < minX) {
     minX = particle.position.x;
     }
     
     if (particle.position.y > maxY) {
     maxY = particle.position.y;
     }
     
     if (particle.position.y < minY) {
     minY = particle.position.y;
     }
     
     
     }
     
     circleCreated = true;
     
     for (CCSprite *enemy in objects) {
     
     float enX = enemy.position.x;
     float enY = enemy.position.y;
     
     if (enX > minX && enX < maxX && enY > minY && enY < maxY) {
     
     if (enemy.tag == enemy_tag) {
     
     enemy.tag = frozenEnemy;
     
     CCSprite * select;
     
     select = [CCSprite spriteWithFile:@"select.png"];
     
     [select runAction:[CCScaleTo actionWithDuration: 0.8 scaleX:1.8 scaleY:1.8]];
     CCFadeOut *fade = [CCFadeOut actionWithDuration:0.8];
     [select runAction:[CCSequence actions:fade, [CCCallBlockN actionWithBlock:^(CCNode *node) {
     [self removeChild:select];
     }], nil]];
     
     select.position = enemy.position;
     select.tag = actionEffect;
     
     [self addChild:select z:2];
     
     
     if (circlesDrawn > 1) {
     
     CCLabelTTF *pointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%01d", circlesDrawn] fontName:@"Nonstop" fontSize:15];
     
     
     pointsLabel.position = ccp(((maxX - minX)/2) + minX, ((maxY - minY)/2) + minY);
     // change the colour to yelllow
     pointsLabel.color = ccc3(255, 255, 0);
     
     [pointsLabel runAction:[CCScaleTo actionWithDuration:1.0 scale:2.0]];
     [pointsLabel runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.7] ,[CCCallBlockN actionWithBlock:^(CCNode *node) {
     [self removeChild:pointsLabel];;
     }], nil]];
     
     [self addChild:pointsLabel z:4];
     }
     
     circlesDrawn++;
     break;
     dobreak = true;
     }
     }
     }
     }
     }
     }
     }*/
}

- (void) dealloc {
    
    [super dealloc];
    [particles release];
    [objects release];
    
    objects = nil;
    particles = nil;
    
}

@end
