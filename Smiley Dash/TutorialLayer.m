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
NSMutableArray * instructions;

int tutorialStage;
bool stageRunning;
bool touchMoved;
CCSprite *testHero;
CGPoint touchLocation;
double heroSpeed;
int startParticle;
int particleLimit;
int circlesDrawn;
bool circleCreated;

@implementation TutorialLayer

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	TutorialLayer *layer = [TutorialLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (double) calculateDistanceBetween:(CGPoint)firstObject and:(CGPoint)secondObject {
    
    double diffx = firstObject.x - secondObject.x;
    double diffy = firstObject.y - secondObject.y;
    diffx = pow(diffx, 2);
    diffy = pow(diffy, 2);
    double lengthIntersect = pow((diffx + diffy), 0.5);
    
    return (double) lengthIntersect;
}

- (void) setValues {
    heroSpeed = heroStartSpeed;
    startParticle = 0;
    circlesDrawn = 0;
    circleCreated = false;
    tutorialStage = 0;
    stageRunning = false;
    touchMoved = NO;
}

- (id) init {
    
	if( (self=[super init])) {
        
        [self removeAllChildrenWithCleanup:YES];
        
        particles = [[NSMutableArray alloc] init];
        objects = [[NSMutableArray alloc] init];
        instructions = [[NSMutableArray alloc] init];
        
        // ask director for the window size
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite * background;
        CCLabelTTF * label;
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            background = [CCSprite spriteWithFile:@"bg1-568h.png"];
            
        } else {
            
            background = [CCSprite spriteWithFile:@"bg1.png"];
            
        }
        
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            particleLimit = iphone5Limit;
            
        } else if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 480)){
            
            particleLimit = iphoneRetinaLimit;
            
        } else {
            
            particleLimit = iphoneParticleLimit;
            
        }
        
        background.rotation = 90;
        // place background in the center of the screen
        background.position = ccp(winSize.width/2, winSize.height/2);
        
        // add the label as a child to this Layer
        [self addChild: background];
        
        // hero sprite
        testHero = [CCSprite spriteWithFile:@"hero.png"];
        testHero.position = ccp(winSize.width/2,winSize.height/2);
        testHero.tag = heroTag;
        
        [self addChild:testHero z:2];
        
        // wave label
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"TUTORIAL"] fontName:@"Baccarat" fontSize:20];
        label.position = ccp(winSize.width/2, winSize.height - 10);
        [self addChild:label z:1];
        
        [self setValues];
        
        self.touchEnabled = YES;
        [self schedule:@selector(updates:)];

        
    }

	return self;
}

- (void) drawParticles {
    
    CCSprite *particle = [particles lastObject];
    
    double lengthIntersect = [self calculateDistanceBetween:touchLocation and:particle.position];
    
    // ensures that particles do not bunch up together by checking that there are at least 10 pixels between the touch and the last particle
    if (lengthIntersect >= distanceBetweenParticles && lengthIntersect < distanceBetweenParticles*2) {
        
        CCSprite *particle;
        particle = [CCSprite spriteWithFile:@"particle.png"];
        particle.position = touchLocation;
        [particles addObject:particle];
        [self addChild:particle];
        
    } else if (lengthIntersect >= distanceBetweenParticles*2 && lengthIntersect < distanceBetweenParticles*3) {
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:testHero.position];
        
        if (lengthIntersect > testHero.contentSize.width + 50) {
            
            CCSprite *firstParticle = [particles lastObject];
            
            double diffx = (touchLocation.x - firstParticle.position.x)/2;
            double diffy = (touchLocation.y - firstParticle.position.y)/2;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            CCSprite *particle;
            particle = [CCSprite spriteWithFile:@"particle.png"];
            particle.position = ccp(diffx,diffy);
            [particles addObject:particle];
            [self addChild:particle];
        }
        
        particle = [CCSprite spriteWithFile:@"particle.png"];
        particle.position = touchLocation;
        [particles addObject:particle];
        [self addChild:particle];
        
    } else if (lengthIntersect >= distanceBetweenParticles*3) {
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:testHero.position];
        
        if (lengthIntersect > testHero.contentSize.width + 50) {
            
            CCSprite *firstParticle = [particles lastObject];
            
            double diffx = (touchLocation.x - firstParticle.position.x)/3;
            double diffy = (touchLocation.y - firstParticle.position.y)/3;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            CCSprite *particle;
            particle = [CCSprite spriteWithFile:@"particle.png"];
            particle.position = ccp(diffx,diffy);
            [particles addObject:particle];
            [self addChild:particle];
            
            diffx = ((touchLocation.x - firstParticle.position.x)/3) * 2;
            diffy = ((touchLocation.y - firstParticle.position.y)/3) * 2;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            particle = [CCSprite spriteWithFile:@"particle.png"];
            particle.position = ccp(diffx,diffy);
            [particles addObject:particle];
            [self addChild:particle];
        }
        
        particle = [CCSprite spriteWithFile:@"particle.png"];
        particle.position = touchLocation;
        [particles addObject:particle];
        [self addChild:particle];
        
    } else if (lengthIntersect >= distanceBetweenParticles*3 && lengthIntersect < distanceBetweenParticles*4){
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:testHero.position];
        
        if (lengthIntersect > testHero.contentSize.width + 50) {
            
            CCSprite *firstParticle = [particles lastObject];
            
            double diffx = (touchLocation.x - firstParticle.position.x)/3;
            double diffy = (touchLocation.y - firstParticle.position.y)/3;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            CCSprite *particle;
            particle = [CCSprite spriteWithFile:@"particle.png"];
            particle.position = ccp(diffx,diffy);
            [particles addObject:particle];
            [self addChild:particle];
            
            diffx = ((touchLocation.x - firstParticle.position.x)/3) * 2;
            diffy = ((touchLocation.y - firstParticle.position.y)/3) * 2;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            particle = [CCSprite spriteWithFile:@"particle.png"];
            particle.position = ccp(diffx,diffy);
            [particles addObject:particle];
            [self addChild:particle];
        }
        
        particle = [CCSprite spriteWithFile:@"particle.png"];
        particle.position = touchLocation;
        [particles addObject:particle];
        [self addChild:particle];
        
    }
}

- (ccColor3B) changeColour:(int)circles {
    
    ccColor3B color;
    
    switch (circles) {
            
        case 0:
            color = ccc3(255,255,255);
            break;
        case 1:
            color = ccc3(238, 122, 233);
            break;
        case 2:
            color = ccc3(28, 134, 238);
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
            color = ccc3(230, 0, 0);
            break;
        default:
            color = ccc3(0, 0, 0);
            break;
    }
    
    return color;
}

- (void) checkDrawingCircle {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    float minY = winSize.height, minX = winSize.width, maxX = 0, maxY = 0;
    
    bool dobreak = false;
    
    if (touchMoved == YES) {
        
        ccColor3B color = [self changeColour:circlesDrawn];
        
        for (int i = startParticle; !dobreak && i < particles.count; i++) {
            
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
                    startParticle = j + 1;
                    circleCreated = true;
                    
                    for (CCSprite *enemy in objects) {
                        
                        float enX = enemy.position.x;
                        float enY = enemy.position.y;
                        
                        if (enX > minX && enX < maxX && enY > minY && enY < maxY) {
                            
                            if (enemy.tag == enemy_tag) {
                                
                                enemy.tag = frozenEnemy;
                                
                                circlesDrawn++;
                                if (circlesDrawn > 1) {
                                    
                                    CCLabelTTF *pointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"x%01d", circlesDrawn] fontName:@"Cartoon" fontSize:15];
                                    
                                    
                                    pointsLabel.position = ccp(((maxX - minX)/2) + minX, ((maxY - minY)/2) + minY);
                                    // change the colour to yelllow
                                    pointsLabel.color = ccc3(255, 255, 0);
                                    
                                    [pointsLabel runAction:[CCScaleTo actionWithDuration:1.0 scale:2.0]];
                                    [pointsLabel runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.7] ,[CCCallBlockN actionWithBlock:^(CCNode *node) {
                                        [self removeChild:pointsLabel];;
                                    }], nil]];
                                    
                                    [self addChild:pointsLabel z:4];
                                }
                            
                                break;
                                dobreak = true;
                            }
                        }
                    }
                }
            }
        }
    }
}

- (void) movePos:(float)x yVal:(float)y chase:(CCSprite*)sprite speed:(double)speed {
    
    float diffx = (x - sprite.position.x);
    float diffy = (y - sprite.position.y);
    float z = pow((pow(diffx,2)+pow(diffy,2)), 0.5);
    
    float xVal = sprite.position.x + ((diffx/z) * speed);
    float yVal = sprite.position.y + ((diffy/z) * speed);
    
    sprite.position = ccp(xVal, yVal);
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSMutableArray * toDelete = [[NSMutableArray alloc] init];
    
    if (tutorialStage != 0 || circleCreated == true) {
       
        [self removeAllParticles];
        
        for (CCSprite *enemy in objects) {
            
            if (enemy.tag == frozenEnemy) {

                [toDelete addObject:enemy];
                
            }
            
        }
        
        if (toDelete.count != 0) {
            
            for (CCSprite *sprite in instructions) {
                
                [self removeChild:sprite];
                
            }
            
            [instructions removeAllObjects];
        
            for (CCSprite *sprite in objects) {
                
                [self removeChild:sprite];
                
            }
        
            [objects removeAllObjects];
        
            stageRunning = false;
        
            if (toDelete.count == tutorialStage) {

                tutorialStage ++;
                
                if (tutorialStage > 2) {
                    
                    [self unschedule:@selector(updates:)];
                    [self removeAllChildrenWithCleanup:YES];
                    [self removeFromParentAndCleanup:YES];
                    
                    [particles removeAllObjects];
                    [instructions removeAllObjects];
                    [objects removeAllObjects];

                    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeTR transitionWithDuration:2.0 scene:[GameLayer scene:game_restart]]];
                    
                }
            
            }
        }
        
                

        
        startParticle = 0;
        circlesDrawn = 0;
        
    }
    
    for (CCSprite *sprite in toDelete) {
        [self removeChild:sprite];
        [objects removeObject:sprite];
    }
    
    circleCreated = false;
    
    [toDelete release];
    toDelete = nil;
    touchMoved = NO;
    
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
    
    // calculate the distance between the touch and hero center
    double lengthIntersect = [self calculateDistanceBetween:testHero.position and:touchLocation];
    
    // for some reason touchLocation is set to 0,0 at first (player is never going to touch here anyway)
    if (touchLocation.x != 0 && touchLocation.y != 0) {
        
        [self removeAllParticles];
        
        CCSprite *particle;
        
        // if touch is anywhere in the radius of the sprite plus around it then set touch to be moved and allow player to move it
        if (lengthIntersect <= testHero.contentSize.width + 50) {
            
            touchMoved = YES;
            particle = [CCSprite spriteWithFile:@"particle.png"];
            
        } else {
            
            particle = [CCSprite spriteWithFile:@"touch.png"];
            
            [particle runAction:[CCScaleTo actionWithDuration: 0.8 scaleX:2.5 scaleY:2.5]];
            [particle runAction:[CCFadeOut actionWithDuration:0.8]];
            
        }
        
        // stop any movements made by the hero
        particle.position = touchLocation;
        
        [particles addObject:particle];
        [self addChild:particle];
        
    }
    
}

- (void) runFirstStage {
    
    if (stageRunning == false) {
        
        CCSprite * star;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        stageRunning = true;
        
        
        CCLabelTTF *instruction;
        
        instruction = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Collect the stars by"] fontName:@"Cartoon" fontSize:14];
        instruction.position = ccp(winSize.width/3.7, winSize.height/9);
        
        [self addChild:instruction z:1];
        [instructions addObject:instruction];
        
        instruction = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"touching and dragging"] fontName:@"Cartoon" fontSize:14];
        instruction.position = ccp(winSize.width/1.48, winSize.height/9);
        instruction.color = ccYELLOW;
        
        [self addChild:instruction z:1];
        [instructions addObject:instruction];
        
        instruction = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"the smiley or"] fontName:@"Cartoon" fontSize:14];
        instruction.position = ccp(winSize.width/4, winSize.height/15);
        
        [self addChild:instruction z:1];
        [instructions addObject:instruction];
        
        instruction = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"tapping"] fontName:@"Cartoon" fontSize:14];
        instruction.position = ccp(winSize.width/2.23, winSize.height/15);
        instruction.color = ccYELLOW;
        
        [self addChild:instruction z:1];
        [instructions addObject:instruction];
        
        instruction = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"anywhere on the screen"] fontName:@"Cartoon" fontSize:14];
        instruction.position = ccp(winSize.width/1.35, winSize.height/15);
        
        [self addChild:instruction z:1];
        [instructions addObject:instruction];
        
        
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
        
    }
    
    for (CCSprite * star in objects) {
        
        if (CGRectIntersectsRect(testHero.boundingBox, star.boundingBox)) {
            
            [self removeChild:star];
            [objects removeObject:star];
            break;
            
        }
        
    }
    
    if (objects.count == 0) {
        
        
        for (CCSprite *label in instructions) {
            [self removeChild:label];
        }
        
        [instructions removeAllObjects];
        
        tutorialStage ++;
        stageRunning = false;
        
    }
    
}

- (void) runSecondStage {
    
    if (stageRunning == false) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        touchMoved = NO;
        [self removeAllParticles];
        
        stageRunning = true;
        
        CCLabelTTF *instruction;
        
        instruction = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Draw a"] fontName:@"Cartoon" fontSize:14];
        instruction.position = ccp(winSize.width/10, winSize.height/15);
        
        [self addChild:instruction z:1];
        [instructions addObject:instruction];
        
        instruction = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"loop"] fontName:@"Cartoon" fontSize:14];
        instruction.position = ccp(winSize.width/4.6, winSize.height/15);
        instruction.color = ccYELLOW;
        
        [self addChild:instruction z:1];
        [instructions addObject:instruction];
        
        instruction = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"around an enemy smiley to kill it"] fontName:@"Cartoon" fontSize:14];
        instruction.position = ccp(winSize.width/1.75, winSize.height/15);
        
        [self addChild:instruction z:1];
        [instructions addObject:instruction];
        
        heroSpeed = 0;
        
        testHero.position = ccp(winSize.width/11, winSize.height/10 * 7.95);
        
        CCSprite *stage;
        
        stage = [CCSprite spriteWithFile:@"stage1.png"];
        
        stage.position = ccp(winSize.width/2, winSize.height/6 * 4);
        stage.opacity = 40;
        
        // add the label as a child to this Layer
        [self addChild: stage];
        [objects addObject:stage];

        
        CCSprite * enemy;
        
        enemy = [CCSprite spriteWithFile:@"normalEnemy.png"];
        enemy.position = ccp(winSize.width/10 * 6.3,winSize.height/1.7);
        enemy.tag = enemy_tag;
        
        [self addChild:enemy z:2];
        [objects addObject:enemy];
        
    }
    
}

- (void) runThirdStage {
    
    if (stageRunning == false) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        touchMoved = NO;
        [self removeAllParticles];
        
        stageRunning = true;
        
        heroSpeed = 0.3;
        
        testHero.position = ccp(winSize.width/11, winSize.height/2);
        
        CCLabelTTF *instruction;
        
        instruction = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Chain"] fontName:@"Cartoon" fontSize:14];
        instruction.position = ccp(winSize.width/10, winSize.height/15);
        instruction.color = ccYELLOW;
        
        [self addChild:instruction z:1];
        [instructions addObject:instruction];
        
        instruction = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"loops together to increase your multiplier"] fontName:@"Cartoon" fontSize:14];
        instruction.position = ccp(winSize.width/1.8, winSize.height/15);
        
        [self addChild:instruction z:1];
        [instructions addObject:instruction];

        CCSprite * enemy;
    
        enemy = [CCSprite spriteWithFile:@"normalEnemy.png"];
        enemy.position = ccp(winSize.width/2.4,winSize.height/2);
        enemy.tag = enemy_tag;
    
        [self addChild:enemy z:2];
        [objects addObject:enemy];
    
        enemy = [CCSprite spriteWithFile:@"normalEnemy.png"];
        enemy.position = ccp(winSize.width/4 * 3,winSize.height/2);
        enemy.tag = enemy_tag;
    
        [self addChild:enemy z:2];
        [objects addObject:enemy];
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
        
        // get most recent particle
        // CCSprite* particle = [particles objectAtIndex: 0];
        
        CCSprite *particle = [self getParticle];
        
        if (particle.tag != circleParticle) {
            
            // make the human chase the last particle
            [self movePos:particle.position.x yVal:particle.position.y chase:testHero speed:heroSpeed];
            
            // if the human moves to the particle
            double lengthIntersect = [self calculateDistanceBetween:testHero.position and:particle.position];
            
            // so that the powereater overlaps the powerup
            if (lengthIntersect <= particle.contentSize.width) {
                
                [particles removeObject: particle];
                [self removeChild:particle cleanup:YES];
                
                if (startParticle > 0) {
                    startParticle--;
                }
            }
        }
        
    }
    
    // particle limit = 300
    if (particles.count > particleLimit) {
        
        // remove latest particle
        particle = [self getParticle];
        
        [particles removeObject: particle];
        [self removeChild:particle cleanup:YES];
        
        if (startParticle > 0) {
            startParticle--;
        }
        
    }
    
}

- (void) dealloc {
    
    [super dealloc];
    [particles release];
    [objects release];
    [instructions release];
    
    instructions = nil;
    objects = nil;
    particles = nil;
    
}

- (void) updates:(ccTime)dt {
    
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
        
    }
    
}

@end
