//
//  GameLayer.m
//  Smiley Dash
//
//  Created by Stephen Sowole on 07/05/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#import "Config.h"
#import "Enemy.h"
#import "PowerEater.h"
#import "GameOver.h"

NSMutableArray * enemies;
NSMutableArray * powerups;
NSMutableArray * gameObjects;
NSMutableArray * circles;
NSMutableArray * particles;
NSMutableArray * hearts;
NSMutableArray * spriteToDelete;

CCLabelTTF *scoreLabel;
CCLabelTTF *waveLabel;

bool yellowLevelActive;
bool redLevelActive;
bool timePowerActive;
int timePowerStartTime;

bool circleCreated;
bool superHeroActive;
int superHeroStartTime;
int currentEnemyCount;

int wave, score, labelScore;
int previousYellowLevel;
int chosenRedLevel;
double heroSpeed;
double spawnTime;
int order;
int bouncerSpeedLevel;
int bouncerID;
// this is so that when checking for circles, the program doesnt do any unnecessary loops
int startParticle;

// fix it so that when black zombie slow down they can speed back up

// restart acts like a sort of constructor

@implementation GameLayer

- (void) restart {
    
    // used when rewind button is pressed
    
    yellowLevelActive = false;
    redLevelActive = false;
    timePowerActive = false;
    currentEnemyCount = 0;
    wave = startingWave, score = 0, labelScore = 0;
    previousYellowLevel = 0;
    chosenRedLevel = 0;
    heroSpeed = heroStartSpeed;
    spawnTime = enemy_spawnTime;
    order = -1;
    bouncerID = 0;
    circleCreated = false;
    time = 0;
    superHeroStartTime = 0;
    superHeroActive = false;
    timePowerStartTime = 0;
    
    
} // finish this at the end

- (id) init:(int)resume {
    
    if( (self=[super init])) {
        
        if (resume == game_restart) {
            
            [self removeAllChildrenWithCleanup:YES];
            
            [self restart];
            
        } else if (resume == game_resume) {
            
            yellowLevelActive = false;
            redLevelActive = false;
            timePowerActive = false;
            circleCreated = false;
            superHeroActive = false;
            touchMoved = NO;
            
        }
        
        // initialise arrays
        [self allocateArrays];
        
        // create the display and main character
        [self createDisplay];
        
        // set a schedule for the methods
        [self scheduleMethods];
        
        // touch is enabled
        self.touchEnabled = YES;
        
        time = 0;
        [self schedule:@selector(increaseTime:) interval:1.0];
        
        startParticle = 0;
        
	}
	return self;
}

+(CCScene *) scene:(int)resume {
    
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer nodeScenario:resume];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

+ (id) nodeScenario:(int)resume{
    return  [[[self alloc] init:resume] autorelease];
}

- (void) increaseTime:(ccTime)dt {
    
    time++;
    
}

- (void) allocateArrays {
    
    // allocate memory to all the arrays
    
    enemies = [[NSMutableArray alloc] init];
    powerups = [[NSMutableArray alloc] init];
    gameObjects = [[NSMutableArray alloc] init];
    circles = [[NSMutableArray alloc] init];
    particles = [[NSMutableArray alloc] init];
    hearts = [[NSMutableArray alloc] init];
    spriteToDelete = [[NSMutableArray alloc] init];
    

}

- (void) createDisplay {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // if iphone 5, change the display to use the larger image
    
    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
        
        background = [CCSprite spriteWithFile:@"bg1-568h.png"];
        
    } else {
        
        background = [CCSprite spriteWithFile:@"bg1.png"];
        
    }
    
    background.rotation = 90;
    // place background in the center of the screen
    background.position = ccp(winSize.width/2, winSize.height/2);
    
    // add the label as a child to this Layer
    [self addChild: background];

    // hero sprite
    hero = [CCSprite spriteWithFile:@"hero.png"];
    hero.position = ccp(winSize.width/2,winSize.height/2);
    hero.tag = heroTag;
    
    [self addChild:hero z:2];
    
    // wave label
    waveLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@" Wave: %i", wave] fontName:@"Baccarat" fontSize:15];
    waveLabel.position = ccp(winSize.width/2, winSize.height - 10);
    [self addChild:waveLabel z:4];
    
    // score label
    scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%07d", labelScore] fontName:@"Baccarat" fontSize:15];
    scoreLabel.position = ccp(34, winSize.height - 10);
    // change the colour to yelllow
    scoreLabel.color = ccc3(255, 255, 0);
    [self addChild:scoreLabel z:4];
    
    levelEnemyCount = startEnemies + (enemyAddition * (wave - 1));
    heroLife = startHeroLife;
    
    
    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
        
        particleLimit = iphone5Limit;
        
    } else if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 480)){
        
        particleLimit = iphoneRetinaLimit;
        
    } else {
        
        particleLimit = iphoneParticleLimit;
        
    }
}

- (void) scheduleMethods {
    
    // accelerate enemies also acts as a timer, this has to be here
    [self schedule:@selector(accelerateEnemies:) interval:accelerateEnemyInterval];
    // spawns enemies based on spawntime, also needed
    [self schedule:@selector(addEnemy:) interval:spawnTime];
    // this will have a different spawntime to enemies, also needed
    [self schedule:@selector(powerup:) interval:powerUpSpawn];
    // this update the game and everything in it
    [self schedule:@selector(update:)];
    
}

- (void) unScheduleMethods {
    
    // unschedules all methods, this allows better transitioning between screens
    [self unschedule:@selector(accelerateEnemies:)];
    [self unschedule:@selector(addEnemy:)];
    [self unschedule:@selector(powerup:)];
    [self unschedule:@selector(update:)];
    
}

- (float) randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
    
}

- (double) calculateDistanceBetween:(CGPoint)firstObject and:(CGPoint)secondObject {
    
    double diffx = firstObject.x - secondObject.x;
    double diffy = firstObject.y - secondObject.y;
    diffx = pow(diffx, 2);
    diffy = pow(diffy, 2);
    double lengthIntersect = pow((diffx + diffy), 0.5);
    
    return (double) lengthIntersect;
}

- (void) movePos:(float)x yVal:(float)y chase:(CCSprite*)sprite speed:(double)speed {
    
    float diffx = (x - sprite.position.x);
    float diffy = (y - sprite.position.y);
    float z = pow((pow(diffx,2)+pow(diffy,2)), 0.5);
    
    float xVal = sprite.position.x + ((diffx/z) * speed);
    float yVal = sprite.position.y + ((diffy/z) * speed);
    
    sprite.position = ccp(xVal, yVal);
}

- (void) addEnemy:(ccTime)dt{
    
    if (arc4random() % 10 < 1) {
        // 10% chance that a power eater will be spawned
        
        PowerEater * enemy = [PowerEater spriteWithFile:@"powerEater.png"];
        
        enemy.speed = PE_speed;
        enemy.time = setTime;
        enemy.tag = PE_tag;
        
        [self spawnEnemy:enemy tag:PE_tag];
        
    } else {
        // spawn an enemy
        
        float speed = 0;
        
        Enemy * enemy = [Enemy spriteWithFile:@"normalEnemy.png"];
    
        enemy.speed = enemy_speed;
        enemy.time = setTime;
        
        // increase speed of enemy as wave increases
        
        if (wave < 5) {
            
            speed = (wave * ((enemy_maxSpeed - enemy_speed)/5)) + enemy_speed;
            
        } else {
            
            speed = (4 * ((enemy_maxSpeed - enemy_speed)/5) + enemy_speed);
            
        }
        
        // random maxspeed so all enemies moving at different speeds
        enemy.maxSpeed = [self randomFloatBetween:speed and:enemy_maxSpeed];
    
        [self spawnEnemy:enemy tag:enemy_tag];
    }
}

- (void) addSuperEnemy:(float)x yVal:(float)y {
    
    float speed;
    
    Enemy * enemy = [Enemy spriteWithFile:@"bouncer.png"];
    
    enemy.speed = SE_speed;
    enemy.time = setTime;
    enemy.position = ccp(x,y);
    
    if (wave < 5) {
        
        speed = (wave * ((SE_maxSpeed - SE_speed)/5)) + SE_speed;
        
    } else {
        
        speed = (4 * ((SE_maxSpeed - SE_speed)/5) + SE_speed);
        
    }
    
    enemy.maxSpeed = [self randomFloatBetween:speed and:SE_maxSpeed];
    enemy.tag = enemy_tag;
    
    [self addChild:enemy z:3];
    [enemies addObject:enemy];
}

- (void) spawnEnemy:(CCSprite*)enemy tag:(int)tag {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    int width = winSize.width + 1;
    int height = winSize.height + 1;
    double xpos = 0, ypos = 0;
    
    // spawn an enemy if its within the max enemy count for that level and the max total amount of enemies onscreen at once
    if (timePowerActive == false && currentEnemyCount < levelEnemyCount && enemies.count < maxEnemies) {
        
        // regardless of the size of the enemy, spawn them outside of the background
        
        switch(arc4random() % 4) {
            
            case 0:
                xpos = - (enemy.contentSize.width / 2);
                ypos = arc4random() % height;
                break;
            case 1:
                xpos = arc4random() % width;
                ypos = - (enemy.contentSize.height / 2);
                break;
            case 2:
                xpos = arc4random() % width;
                ypos = height + (enemy.contentSize.height / 2);
                break;
            case 3:
                xpos = width + (enemy.contentSize.width / 2);
                ypos = arc4random() % height;
                break;
        }
        
        enemy.position = ccp(xpos,ypos);
        // tag the enemy
        enemy.tag = tag;
        // draw zombies above humans ( for human death purposes )
        [self addChild:enemy z:3];
         // add to enemies array
        [enemies addObject:enemy];
        
        // increase enemy count
        currentEnemyCount++ ;
        
    }
}

- (void) drawHearts {
    
    // if the hearts onscreen dont match the heros lives then create hearts to match
    if (hearts.count != heroLife) {
        
        CCSprite *heart;
        
        // remove all hearts off screen and redraw
        for (heart in hearts) {
            [self removeChild:heart cleanup:YES];
        }
        
        [hearts removeAllObjects];
        
    
        for (int life = 0; life < heroLife; life++) {
        
            CGSize winSize = [CCDirector sharedDirector].winSize;
        
            heart = [CCSprite spriteWithFile:@"life.png"];
            double width = (winSize.width - ((heart.contentSize.width + 5) * life) - 10);
            heart.position = ccp(width,winSize.height - heart.contentSize.height);
        
            [hearts addObject:heart];
            [self addChild:heart z:4];
        }
    }
}

- (void) displayScore {
    
    if (score > labelScore) {
        labelScore += displayChange;
        [scoreLabel setString:[NSString stringWithFormat:@"%07d", labelScore]];
        
    } else if (score < labelScore) {
        
        labelScore -= displayChange;
        [scoreLabel setString:[NSString stringWithFormat:@"%07d", labelScore]];
    }
    
}

- (void) displayWave {

    [waveLabel setString:[NSString stringWithFormat:@"Wave: %d", wave]];
    
}

- (void) checkCircle {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    float minY = winSize.height, minX = winSize.width, maxX = 0, maxY = 0;
    
    for (CCSprite *particle in particles) {
        
        if (particle.tag == circleParticle) {
            
            
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
            
            //[self addToDeletionPile:particle];
        }
    }
    
    for (Enemy *enemy in enemies) {
        
        float enX = enemy.position.x;
        float enY = enemy.position.y;
        
        if (enX > minX && enX < maxX && enY > minY && enY < maxY) {
            
            if (enemy.tag == enemy_tag) {
                enemy.tag = frozenEnemy;
            }
            
            
        }
        
    }
    
  //  [self deleteFromDeletionPile];
    
    //[self unScheduleMethods];
    
}

- (void) checkDrawingCircle {
    
    bool dobreak = false;
    
    if (touchMoved == YES) {
        
        
        for (int i = startParticle; !dobreak && i < particles.count; i++) {
            
            CCSprite * firstParticle = [particles objectAtIndex:i];
            
            for (int j = i + 1; j < particles.count; j++) {
                
                CCSprite * secondParticle = [particles objectAtIndex:j];
                
                double lengthIntersect = [self calculateDistanceBetween:firstParticle.position and:secondParticle.position];
                
                if (lengthIntersect < distanceBetweenParticles && firstParticle.tag != circleParticle && secondParticle.tag != circleParticle) {
                    
                    for (int a = i + 1 ; a < j + 1; a++) {
                        
                        CCSprite * particle = [particles objectAtIndex:a];
                        
                        [particle setTexture:[[CCTextureCache sharedTextureCache] addImage:@"particleCircle.png"]];
                        particle.tag = circleParticle;
                        
                        [circles addObject:particle];
                        
                        
                    }
                    startParticle = j + 1;
                    
                    [self checkCircle];
                    circleCreated = true;
                    
                    dobreak = true;
                    //touchMoved = NO;
                    
                    break;

                }
            }
        }
    }
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
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:hero.position];
        
        if (lengthIntersect > hero.contentSize.width + 50) {
            
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
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:hero.position];
        
        if (lengthIntersect > hero.contentSize.width + 50) {
            
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
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:hero.position];
        
        if (lengthIntersect > hero.contentSize.width + 50) {
            
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

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (circleCreated == true) {
        
        for (Enemy *enemy in enemies) {
            
            if (enemy.tag == frozenEnemy) {
                
                [self addToDeletionPile:enemy];
                
            }
        }
        
        
        [self removeAllParticles];
        
        startParticle = 0;
        circleCreated = false;
        
    }
    
    [self deleteFromDeletionPile];
    
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    // stop all actions yet again
    if (yellowLevelActive == false) {
        
        if (superHeroActive == false) {
            [hero stopAllActions];
        }
        
    }
    
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
    double lengthIntersect = [self calculateDistanceBetween:hero.position and:touchLocation];
    
    // for some reason touchLocation is set to 0,0 at first (player is never going to touch here anyway)
    if (touchLocation.x != 0 && touchLocation.y != 0 && yellowLevelActive == false) {
        
        if (superHeroActive == false) {
            [hero stopAllActions];
        }

        [self removeAllParticles];
        
        CCSprite *particle;
        
        // if touch is anywhere in the radius of the sprite plus around it then set touch to be moved and allow player to move it
        if (lengthIntersect <= hero.contentSize.width + 50) {
            
            touchMoved = YES;
            particle = [CCSprite spriteWithFile:@"particle.png"];
            
        } else {
            
            particle = [CCSprite spriteWithFile:@"touch.png"];
            
            [particle runAction:[CCScaleTo actionWithDuration: 0.8 scaleX:2.5 scaleY:2.5]];
            [particle runAction:[CCFadeOut actionWithDuration:0.8]];
            
            //nice animations... interesting
            //[particle runAction:[CCFlipX3D actionWithDuration:3.0]];
            //[particle runAction:[CCEaseElasticOut actionWithAction:[CCFadeOut actionWithDuration:3.0] period:1.0]];
            //[particle runAction:[CCFadeOut actionWithDuration:1.0]];
            
        }
        
        // stop any movements made by the hero
        particle.position = touchLocation;
        
        [particles addObject:particle];
        [self addChild:particle];
        
    } else if (yellowLevelActive == true) {
        
        for (CCSprite *box in gameObjects) {
            
            if (box.tag == boxTag) {
                
                if (CGRectContainsPoint(box.boundingBox, touchLocation)) {
                    
                    [box stopAllActions];
                    
                    box.tag = boxSelected;
                    
                    [box runAction:[CCScaleTo actionWithDuration:0.3 scale:1.2]];
                    [box runAction:[CCFadeOut actionWithDuration:1.0]];
                    
                    CCDelayTime *delay = [CCDelayTime actionWithDuration:1.3];
                    CCCallFuncN *remove = [CCCallFuncN actionWithTarget:self selector:@selector(fadeAllOut)];
                    CCSequence *seq = [CCSequence actions:delay, remove, nil];
                    [box runAction:seq];
                    
                    [self placeCard];
                    
                    yellowLevelActive = false;
                    
                    CCDelayTime *timeDelay = [CCDelayTime actionWithDuration:3.0];
                    CCCallFuncN *stop = [CCCallFuncN actionWithTarget:self selector:@selector(stopYellowLevel)];
                    [self runAction:[CCSequence actions:timeDelay, stop, nil]];
                    break;
                }
            }
        }
        
    }

}

- (void) placeCard {
    
    for (CCSprite *box in gameObjects) {
        
        if (box.tag == boxSelected) {
            
            CCSprite *card = [CCSprite spriteWithFile:@"bouncer.png"];
            
            card.tag = cardNumber;
            box.tag = cardNumber;
            card.position = box.position;
            
            [self addChild:card z:3];
            [gameObjects addObject:card];
            
            [card runAction:[CCSequence actions: [CCFadeOut actionWithDuration:4.0], nil]];
            
            break;
        }
    }
    
}

- (void) fadeAllOut {
    
    for (CCSprite *box in gameObjects) {
        
        if (box.tag == boxTag) {
            
            [box stopAllActions];
            [box runAction:[CCFadeOut actionWithDuration:1.0]];
            
        }
    }
}

- (void) stopYellowLevel {

    [self scheduleMethods];
    levelEnemyCount = 0;
    
}

- (void) yellowLevelCreate {
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
   // [hero runAction:[CCMoveTo actionWithDuration:(3.0) position:ccp(size.width/2, size.height/2)]];
    
    for (int i = 0; i < 4; i++) {
        
        CCSprite * box = [CCSprite spriteWithFile:@"box.png"];
        box.position = ccp(size.width/5 * (i + 1), size.height/2);
        box.tag = boxTag;
        box.opacity = 0;
        [box runAction:[CCFadeIn actionWithDuration:3.0]];
        
        [self addChild:box z:4];
        [gameObjects addObject:box];
        
    }
}

- (void) addToDeletionPile:(CCSprite*)sprite {
    
    [spriteToDelete addObject:sprite];
    
}

- (void) deleteFromDeletionPile {
    
    for (CCSprite *sprite in spriteToDelete) {
        
        [gameObjects removeObject:sprite];
        [self removeChild:sprite cleanup:YES];
        
    }
    
    for (CCSprite *sprite in spriteToDelete) {
        
        [particles removeObject:sprite];
        [self removeChild:sprite cleanup:YES];
        
    }
    
    for (CCSprite *sprite in spriteToDelete) {
        
        [powerups removeObject:sprite];
        [self removeChild:sprite cleanup:YES];
        
    }
    
    for (CCSprite *sprite in spriteToDelete) {
        
        [enemies removeObject:sprite];
        [self removeChild:sprite cleanup:YES];
        
    }
    
    for (CCSprite *sprite in spriteToDelete) {
        
        [circles removeObject:sprite];
        [self removeChild:sprite cleanup:YES];
        
    }
    
    [spriteToDelete removeAllObjects];
}

- (void) updateBouncers:(ccTime)dt {
    
    float x,y;
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    for (Enemy *bouncer in enemies) {
        
        if (bouncer.tag == bouncer_tag) {
            
            x = bouncer.position.x + bouncer.xChange;
            y = bouncer.position.y + bouncer.yChange;
            bouncer.position = ccp(x,y);
            
            if (bouncer.position.y > winSize.height + bouncer.contentSize.width || bouncer.position.y < - bouncer.contentSize.width) {
                
                [self addToDeletionPile:bouncer];
                
            }
            if (bouncer.position.x > winSize.width + bouncer.contentSize.width || bouncer.position.x < - bouncer.contentSize.width) {
                
                [self addToDeletionPile:bouncer];

            }
            
            double lengthIntersect = [self calculateDistanceBetween:bouncer.position and:hero.position];
            double distanceBetweenSprites = (bouncer.contentSize.width + hero.contentSize.width) / 2;
            
            if (lengthIntersect <= distanceBetweenSprites) {
                
                if (hero.tag == superHeroTag) {
                    
                    switch(bouncer.type) {
                            
                        case topborder:
                            bouncer.yChange = (arc4random() % bouncerSpeedRange) + bouncerSpeedLevel;
                            break;
                        case leftborder:
                            bouncer.xChange = - (arc4random() % bouncerSpeedRange) + bouncerSpeedLevel;
                            break;
                        case bottomborder:
                            bouncer.yChange = - (arc4random() % bouncerSpeedRange) + bouncerSpeedLevel;
                            break;
                        case rightborder:
                            bouncer.xChange = (arc4random() % bouncerSpeedRange) + bouncerSpeedLevel;
                            break;
                    
                        default:
                            break;
                            
                        }
                    
                } else if (heroLife > 1) {
                    
                  // heroLife -= 1;
                    
                    switch(bouncer.type) {
                            
                        case topborder:
                            bouncer.yChange = (arc4random() % bouncerSpeedRange) + bouncerSpeedLevel;
                            break;
                        case leftborder:
                            bouncer.xChange = - ((arc4random() % bouncerSpeedRange) + bouncerSpeedLevel);
                            break;
                        case bottomborder:
                            bouncer.yChange = - ((arc4random() % bouncerSpeedRange) + bouncerSpeedLevel);
                            break;
                        case rightborder:
                            bouncer.xChange = (arc4random() % bouncerSpeedRange) + bouncerSpeedLevel;
                            break;
                            
                        default:
                            break;
                    }
                    
                } else {
                    
                    // DEATH!!
                    
                    redLevelActive = false;
                    levelEnemyCount = 0;
                    
                    [self unschedule:@selector(updateBouncers:)];
                    [self unschedule:@selector(createBouncers:)];
                    [self unScheduleMethods];
                    
                    [bouncer runAction:[CCMoveTo actionWithDuration:1.0 position:hero.position]];
                    
                    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3.0 scene: [GameOver scene]]];
                    
                }
            }
        }
    }
    
    // bounce off each other
    for (int firstbouncer = 0; firstbouncer < enemies.count; firstbouncer++) {
        
        Enemy * bouncer = [enemies objectAtIndex:firstbouncer];
        
        for (int secondbouncer = firstbouncer + 1; secondbouncer < enemies.count; secondbouncer++) {
            
            Enemy *secbouncer = [enemies objectAtIndex:secondbouncer];
            
            float lengthIntersect = [self calculateDistanceBetween:bouncer.position and:secbouncer.position];
            
            if (lengthIntersect <= bouncer.contentSize.width && bouncer.collidedWith != secbouncer.bouncerNo && secbouncer.collidedWith != bouncer.bouncerNo) {
                
                bouncer.collidedWith = secbouncer.bouncerNo;
                secbouncer.collidedWith = bouncer.bouncerNo;
                
                float tempx;
                float tempy;
                
                tempy = bouncer.yChange;
                tempx = bouncer.xChange;
                
                bouncer.yChange = secbouncer.yChange;
                bouncer.xChange = secbouncer.xChange;
                
                secbouncer.xChange = tempx;
                secbouncer.yChange = tempy;
                
            }
        }
        
    }
    
    // removes enemies that go offscreen
    
    [self deleteFromDeletionPile];
}

- (void) createBouncers:(ccTime)dt {
    
    if (enemies.count < levelEnemyCount) {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        double xpos, ypos;
        int width = winSize.width + 1;
        int height = winSize.height + 1;
        
        Enemy * enemy = [Enemy spriteWithFile:@"bouncer.png"];

        // spawn outside of screen
        switch(arc4random() % 4) {
                
            case 0:
                xpos = - (enemy.contentSize.width / 2);
                ypos = arc4random() % height;
                enemy.xChange = (arc4random() % bouncerSpeedRange) + bouncerSpeedLevel;
                enemy.yChange = 0;
                enemy.type = leftborder;
                break;
            case 1:
                xpos = arc4random() % width;
                ypos = - (enemy.contentSize.height / 2);
                enemy.xChange = 0;
                enemy.yChange = (arc4random() % bouncerSpeedRange) + bouncerSpeedLevel;
                enemy.type = bottomborder;
                break;
            case 2:
                xpos = arc4random() % width;
                ypos = height + (enemy.contentSize.height / 2);
                enemy.xChange = 0;
                enemy.yChange = - ((arc4random() % bouncerSpeedRange) + bouncerSpeedLevel);
                enemy.type = topborder;
                break;
            case 3:
                xpos = width + (enemy.contentSize.width / 2);
                ypos = arc4random() % height;
                enemy.xChange = - ((arc4random() % bouncerSpeedRange) + bouncerSpeedLevel);
                enemy.yChange = 0;
                enemy.type = rightborder;
                break;
        }

        enemy.position = ccp(xpos,ypos);
        enemy.tag = bouncer_tag;
        enemy.bouncerNo = bouncerID++;
        
        [self addChild:enemy z:3];
        [enemies addObject:enemy];
    }
}

- (void) redLevelCreate {
    
    if (wave < 10) {
        levelEnemyCount = level1bouncers;
        bouncerSpeedLevel = redLevel1Speed;
    } else if (wave < 15) {
        levelEnemyCount = level2bouncers;
        bouncerSpeedLevel = redLevel2Speed;
    } else {
        levelEnemyCount = level3bouncers;
        bouncerSpeedLevel = redLevel3Speed;
    }
    
    // spawn time can be changed if level too easy
    // creates bouncers and updates bouncer position
    [self schedule:@selector(createBouncers:) interval:bouncerInterval];
    [self schedule:@selector(updateBouncers:)];
    [self schedule:@selector(stopRedLevel:) interval: redLevelTime];
    
    
    [self schedule:@selector(accelerateEnemies:) interval:accelerateEnemyInterval];
    [self schedule:@selector(update:)];
    
} // consider...

- (void) stopRedLevel:(ccTime)dt {
    
    [self unschedule:@selector(createBouncers:)];
    [self unschedule:@selector(updateBouncers:)];
    [self unschedule:@selector(stopRedLevel:)];
    
    bouncerID = 0;
    levelEnemyCount = 0;
    
    for (CCSprite *enemy in enemies) {
        
        CCFadeOut *fade = [CCFadeOut actionWithDuration:1];
        CCCallFuncN *remove = [CCCallFuncN actionWithTarget:self selector:@selector(removeBouncer:)];
        CCSequence *seq = [CCSequence actions:fade, remove, nil];
        [enemy runAction:seq];
        
    }
    
    [self unScheduleMethods];
    [self scheduleMethods];
    
}

- (void) removeBouncer:(CCSprite*)sprite {
    [self removeChild:sprite];
    [enemies removeObject:sprite];
}

- (void) firstBackground {
    
    CCSprite *newbackground;
    
    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
        
        newbackground = [CCSprite spriteWithFile:@"bg1-568h.png"];
        
    } else {
        
        newbackground = [CCSprite spriteWithFile:@"bg1.png"];
        
    }
    
    newbackground.position = background.position;
    newbackground.opacity = 0;
    newbackground.rotation = 90;
    
    [self addChild:newbackground z:order--];
    
    
    // old background sequence
    
    id actionFadeOut = [CCFadeTo actionWithDuration:3.0 opacity:0];
    id actionSequence = [CCSequence actions:actionFadeOut, [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }], nil];
    
    [background runAction:actionSequence];
    
    // new background sequence
    
    id actionFadeIn = [CCFadeIn actionWithDuration:0.1];
    id bgSequence = [CCSequence actions:actionFadeIn, nil];
    
    [newbackground runAction:bgSequence];
    
    background = newbackground;
    newbackground = nil;
}

- (void) backgroundTransition:(bool)red {
    
    CCSprite *newbackground;
    
    if (red == YES) {
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            newbackground = [CCSprite spriteWithFile:@"bg2-568h.png"];
        
        } else {
            
            newbackground = [CCSprite spriteWithFile:@"bg2.png"];
        }
        
    } else {
        
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
            
            newbackground = [CCSprite spriteWithFile:@"bg3-568h.png"];
            
        } else {
            
            newbackground = [CCSprite spriteWithFile:@"bg3.png"];
            
        }
        
    }
    
    newbackground.position = background.position;
    newbackground.opacity = 0;
    newbackground.rotation = 90;
    
    if (red == YES) {
        [self addChild:newbackground z:order--];
    } else {
        [self addChild:newbackground z:3];
    }
    
    
    // old background sequence
    
    id actionFadeOut = [CCFadeTo actionWithDuration:3.0 opacity:0];
    id actionSequence = [CCSequence actions:actionFadeOut, [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }], nil];
    
    [background runAction:actionSequence];
    
    // new background sequence
    
    id actionFadeIn = [CCFadeIn actionWithDuration:0.1];
    id bgSequence = [CCSequence actions:actionFadeIn, nil];
    
    [newbackground runAction:bgSequence];
    
    background = newbackground;
    newbackground = nil;
}

- (void) powerup:(ccTime)dt {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if (powerups.count < powerUpCount) {
        
        CCSprite * powerup = nil;
        
        switch(arc4random() % 100) {
            case 0 ... 29:
                powerup = [CCSprite spriteWithFile:@"time.png"];
                powerup.tag = timeNumber;
                break;
            case 30 ... 84:
                powerup = [CCSprite spriteWithFile:@"star.png"];
                powerup.tag = starNumber;
                break;
            case 85 ... 89:
                powerup = [CCSprite spriteWithFile:@"heart.png"];
                powerup.tag = heartNumber;
                break;
            case 90 ... 99:
                powerup = [CCSprite spriteWithFile:@"coin.png"];
                powerup.tag = coinNumber;
                break;
            default:
                break;
        }
        
        // RANDOM SPAWNING
        int maxXpos = (winSize.width - (powerup.contentSize.width / 2)) + 1;
        int maxYpos = (winSize.height - (powerup.contentSize.height / 2)) + 1;
        
        int xpos = arc4random() % maxXpos;
        int ypos = arc4random() % maxYpos;
        
        if (xpos < (powerup.contentSize.width/2)){
            xpos += powerup.contentSize.width/2;
        }
        
        if (ypos < (powerup.contentSize.height/2)){
            ypos += powerup.contentSize.height/2;
        }
        
        powerup.position = ccp(xpos,ypos);
        
        [self addChild:powerup];
        [powerups addObject:powerup];
    }
    
}

- (void) powerupAction:(CCSprite*)powerup {
    
    /*if (powerup.tag == mineNumber) {
        
        CCSprite * mine = [CCSprite spriteWithFile:@"mine.png"];
        mine.position = powerup.position;
        mine.tag = mineNumber;
        
        [self addChild:mine z:0];
        [gameObjects addObject:mine];
        
    } else*/
    if (powerup.tag == timeNumber) {
        
        timePowerActive = true;
        timePowerStartTime = time;
        
        for (Enemy *enemy in enemies) {
            if (enemy.tag == enemy_tag) {
                enemy.speed = enemy_slow;
            }
        }
        
        
    } else if (powerup.tag == starNumber) {
        
        [self activateSuperhero];
        
    } else if (powerup.tag == heartNumber) {
        
        heroLife += 1;
    
    } else if (powerup.tag == coinNumber) {
        
        score += coinScore;
        
    }
    
    score += powerupScore;
    
}

- (void) activateSuperhero {

    CGPoint heroPos = hero.position;
    
    [self removeChild:hero cleanup:YES];
    
    hero = [CCSprite spriteWithFile:@"superhero.png"];
    hero.position = heroPos;
    hero.tag = superHeroTag;
    
    [self addChild:hero z:2];

    heroSpeed = superHeroSpeed;
    
    id rotate = [CCRotateBy actionWithDuration:superHeroTime - 2 angle:720 * superHeroTime];
    id slowRotate = [CCRotateBy actionWithDuration:1 angle:600];
    id slowRotate2 = [CCRotateBy actionWithDuration:1 angle:360];
   [hero runAction:[CCSequence actions: rotate, slowRotate, slowRotate2, nil]];
    
    superHeroStartTime = time;
    superHeroActive = true;
    
}

- (void) deactivateSuperhero {

    CGPoint heroPos = hero.position;
    
    [self removeChild:hero cleanup:YES];
    
    hero = [CCSprite spriteWithFile:@"hero.png"];
    hero.position = heroPos;
    hero.tag = heroTag;
    
    [self addChild:hero z:2];
    [self resetHeroSpeed];
    
    superHeroActive = false;
    
}

- (void) resetEnemySpeed {
    timePowerActive = false;
    
} //fix this

- (void) resetHeroSpeed {
    
    heroSpeed = heroStartSpeed;
    
}

- (void) accelerateEnemies:(ccTime)dt {
    
    for (Enemy *enemy in enemies){
        
        enemy.time++;
        
        if (enemy.time >= enemy_killTime) {
            
            currentEnemyCount = 0;
            
        }
        
        if (enemy.tag == enemy_tag && timePowerActive == false) {
            
            if (enemy.speed <= enemy.maxSpeed) {
            
                enemy.speed += enemy_acceleration;
            
            } else {
            
                enemy.speed -= enemy_acceleration;
            
            }
            
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
    //inefficient
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
            [self movePos:particle.position.x yVal:particle.position.y chase:hero speed:heroSpeed*2];
        
            // if the human moves to the particle
            double lengthIntersect = [self calculateDistanceBetween:hero.position and:particle.position];
        
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
        particle = [particles objectAtIndex:0];
        
        [particles removeObject: particle];
        [self removeChild:particle cleanup:YES];
        
        if (startParticle > 0) {
            startParticle--;
        }
        
    }
    
}

- (void) removeSprite:(CCSprite*)sprite {
    
    // for exploision purposes NEEDED
    
    [circles removeObject:sprite];
    [self removeChild:sprite cleanup:YES];
    
}

- (void) dealloc {
    
    [super dealloc];
    [powerups release];
    [enemies release];
    [gameObjects release];
    [circles release];
    [particles release];
    [hearts release];
    [spriteToDelete release];
    
    powerups = nil;
    enemies = nil;
    gameObjects = nil;
    circles = nil;
    particles = nil;
    hearts = nil;
    spriteToDelete = nil;
    
}

- (void) enemyUpdate {
    
    NSMutableArray *superEnemies = [[NSMutableArray alloc] init];
    
    CCSprite *powerup;
    
    if (powerups.count > 0) {
        
        powerup = [powerups objectAtIndex:0];
    }
    
    for (Enemy *enemy in enemies) {
        
        
        if (particles.count > 0) {
            
            for (CCSprite *particle in particles) {
                
                if (enemy.tag != frozenEnemy && circleCreated == true) {
                    
                    if (CGRectIntersectsRect(enemy.boundingBox, particle.boundingBox)) {
                    
                        [self removeAllParticles];
                        powerup = nil;
                        startParticle = 0;
                        circleCreated = false;
                        touchMoved = NO;
                        break;
                    }
                }
            }
        }
        
        
        
        
        
        if (circleCreated == false && enemy.tag == frozenEnemy) {
            
            enemy.tag = enemy_tag;
            
        }
        
        
        /**** this first section basically handles enemy updating  denoted by the stars ****/
        
        if (enemy.tag == PE_tag) {
            
            // if human collides with the powereater zombie
            
            if (CGRectIntersectsRect(enemy.boundingBox, hero.boundingBox)) {
                
                // add enemy to deletion
                [self addToDeletionPile:enemy];
                score += enemyScore;
                
            }
            
            if (powerups.count > 0) {
                
                // move the power eater towards the powerup
                [self movePos:powerup.position.x yVal:powerup.position.y chase:enemy speed:enemy.speed];
                
                double lengthIntersect = [self calculateDistanceBetween:powerup.position and:enemy.position];
                
                // so that the powereater overlaps the powerup
                if (lengthIntersect <= powerup.contentSize.width/10) {
                    
                    // delete powerup
                    [self addToDeletionPile:powerup];
                    
                    if (powerup.tag == starNumber) {
                        
                        // error here, your adding to an iterating list
                        //[self addSuperEnemy:powerup.position.x yVal:powerup.position.y];
                        [superEnemies addObject:enemy];
                        
                        [self addToDeletionPile:enemy];
                        
                    } else if (powerup.tag == coinNumber) {
                        
                        score -= coinScore;
                        
                    } else if (powerup.tag == heartNumber) {
                        
                        heroLife--;
                        
                    } else if (powerup.tag == timeNumber) {
                        
                        heroSpeed /= 2;
                        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(resetHeroSpeed) userInfo:nil repeats:NO];
                        
                    }
                }
            }
            
        } else if (enemy.tag == enemy_tag) {

            // make zombie chace hero
            [self movePos:hero.position.x yVal:hero.position.y chase:enemy speed:enemy.speed];
            
            double lengthIntersect = [self calculateDistanceBetween:enemy.position and:hero.position];
            double distanceBetweenSprites = (enemy.contentSize.width + hero.contentSize.width) / 2;
            
            // used for circles.. if sprites touch
            if (lengthIntersect <= distanceBetweenSprites) {
                
                // if superhero remove the enemy
                if (hero.tag == superHeroTag) {
                    
                    score += enemyScore;
                    [self addToDeletionPile:enemy];
                    
                } else if (heroLife > 1) {
                    
                    score += enemyScore;
                    heroLife--;
                    [self addToDeletionPile:enemy];
                    
                } else {
                    
                    // death of hero
                    /********************************************************************/
                    
                    // unschedule
                    [self unScheduleMethods];
                    
                    currentEnemyCount -= enemies.count;
                    
                    [enemy runAction:[CCMoveTo actionWithDuration:1.0 position:hero.position]];
                    
                    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3.0 scene: [GameOver scene]]];
                }
            }
            
        }
        /*****************************************************************/
        
        
        /**** next handles object collision with enemy ****/
        
        // if zombie clashes with an object such as a mine
        
       /* for (CCSprite *sprite in gameObjects) {
            
            if (CGRectIntersectsRect(enemy.boundingBox, sprite.boundingBox) && enemy.tag == enemy_tag) {
                
                // if enemy collides with a mine
                if (sprite.tag == mineNumber) {
                    
                    CCSprite *explode = [CCSprite spriteWithFile:@"explode.png"];
                    explode.position = sprite.position;
                    
                    explode.tag = explodeNumber;
                    // set the explosion to be invisible
                    explode.opacity = 0;
                    
                    [effects addObject:explode];
                    
                    // this makes it seem as if the bomb is actually exploding
                    CCFadeIn *fadeIn = [CCFadeTo actionWithDuration:0.1 opacity:255];
                    CCFadeOut *fade = [CCFadeOut actionWithDuration:1];
                    CCCallFuncN *remove = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite:)];
                    CCSequence *seq = [CCSequence actions: fadeIn, fade, remove, nil];
                    [explode runAction:seq];
                    
                    [self addChild:explode z:1];
                    // remove mine
                    [self addToDeletionPile:sprite];
                }
            }
        }
        
        for (CCSprite *sprite in effects) {
            // if sprite collides with explosion remove sprite (except hero)
            
            if (CGRectIntersectsRect(enemy.boundingBox, sprite.boundingBox) && sprite.tag != bouncer_tag) {
                
                [self addToDeletionPile:enemy];
                
            }
            
        }
    }
        */
    }
    
    for (CCSprite* enemy in superEnemies) {
        
        [self addSuperEnemy:enemy.position.x yVal:enemy.position.y];
        
    }
    
    [self deleteFromDeletionPile];
    
}

- (void) update:(ccTime)dt {
    
    if (timePowerActive == true && (time - timePowerStartTime) > timePowerActiveTime) {
        
        [self resetEnemySpeed];
        
    }
    
    if (superHeroActive == true && (time - superHeroStartTime) > superHeroTime) {
        
        [self deactivateSuperhero];
        
    }
    
    [self checkDrawingCircle];
    
    // no powerups or normal enemies during red level
    
    if (redLevelActive == false) {
        
        // update enemies
        [self enemyUpdate];
        
    }
    
    // displays time
    [self displayScore];
    // draws the hearts that acts as a hud to the hero
    [self drawHearts];

    for (CCSprite *power in powerups) {
        
        if (CGRectIntersectsRect(power.boundingBox, hero.boundingBox)) {
            
            [self addToDeletionPile:power];
            [self powerupAction:power];
            
        }
    }
    
    if (currentEnemyCount == levelEnemyCount && enemies.count < 1) {
        
        wave++;
        currentEnemyCount = 0;
        
        levelEnemyCount = startEnemies + (enemyAddition * (wave - 1));
        
        score += waveScore;
        
        [self displayWave];
        
        if (chosenRedLevel == 0) {
            
            chosenRedLevel = (redLevelStartMin + arc4random() % 5);
            
        } else if (chosenRedLevel == wave) {
            
            //RED LEVEL!!
            /**********************************************************************************************/
            
            // unschedule right things
            if (redLevelActive == false) {
                
                [self backgroundTransition:YES];
                redLevelActive = true;
                
            }
            
            for (CCSprite *enemy in enemies) {
                
                [self removeChild:enemy];
                
            }
            
            [enemies removeAllObjects];
            
            [self unScheduleMethods];
            
            [self redLevelCreate];
            
            
            
        } else if (chosenRedLevel < wave) {
            
            score += redLevelScore;
            
            redLevelActive = false;
            
            [self firstBackground];
            
            chosenRedLevel += redLevelChange;
        }
        
        if (wave != chosenRedLevel && (wave - previousYellowLevel) > redLevelSpace && (arc4random() % (100/yellowLevelChance)) ==  0) {
            
            //YELLOW LEVEL!!!
            /**********************************************************************************************/
            
            previousYellowLevel = wave;
            
            if (yellowLevelActive == false) {
                
                [self backgroundTransition:NO];
                yellowLevelActive = true;
                
            }
            
            for (CCSprite *enemy in enemies) {
                
                [self removeChild:enemy];
                
            }
            
            [enemies removeAllObjects];
            
            [self unScheduleMethods];
            
            [self yellowLevelCreate];
            
        } else if ((wave - previousYellowLevel) == 1 && previousYellowLevel != 0) {
            
            for (CCSprite *box in gameObjects) {
                
                if (box.tag == boxTag || box.tag == boxSelected || box.tag == cardNumber) {
                
                    [self addToDeletionPile:box];
                    
                }
                
            }
            
            yellowLevelActive = false;
            
            if (redLevelActive == true) {
                
                // transition to red bug fix
                [self backgroundTransition:YES];
                
            } else {
            
                [self firstBackground];
                
            }
            
        }
        
    }
    
    
    [self followParticles];
    
    [self deleteFromDeletionPile];
    
} //still to do part1 done

@end
