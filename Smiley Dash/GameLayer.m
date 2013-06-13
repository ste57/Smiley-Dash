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
NSMutableArray * particleArray;
NSMutableArray * hearts;
NSMutableArray * spriteToDelete;

CCLabelTTF *scoreLabel;
CCLabelTTF *waveLabel;

CCSprite *pauseButton;
CCSprite *pauseBackground;

//ccColor3B oldColor;


/// consider removing aswell as method
CCSprite *ring;

int spawn;

bool doublePointsActive;
bool superActive;
bool paused;

int circlesDrawn;
int multiplier;

bool lifeLost;

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
int order;
int bouncerSpeedLevel;
int bouncerID;
// this is so that when checking for circles, the program doesnt do any unnecessary loops
int startParticle;


// fix superhero effect
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
    order = -1;
    bouncerID = 0;
    circleCreated = false;
    time = 0;
    superHeroStartTime = 0;
    superHeroActive = false;
    timePowerStartTime = 0;
    spawn = 0;
    pauseButton = nil;
    pauseBackground = nil;
    
    
} // finish this at the end

- (id) init:(int)resume {
    
    if( (self=[super init])) {
        
        prefs = [NSUserDefaults standardUserDefaults];
        
        if (resume == game_restart) {
            
            [self removeAllChildrenWithCleanup:YES];
            
            [self restart];
            
        } else if (resume == game_resume) {
            
            // so extra points do not get added
            NSInteger systemScore = [prefs integerForKey:@"totalScore"];
            [prefs setInteger:(systemScore - score) forKey:@"totalScore"];
            
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
        paused = false;
        [self schedule:@selector(increaseTime:) interval:1.0];
        
	}
	return self;
}

+ (CCScene *) scene:(int)resume {
    
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
    
    previousTouch = touchLocation;
    
}

- (void) allocateArrays {
    
    // allocate memory to all the arrays
    
    enemies = [[NSMutableArray alloc] init];
    powerups = [[NSMutableArray alloc] init];
    gameObjects = [[NSMutableArray alloc] init];
    particleArray = [[NSMutableArray alloc] init];
    hearts = [[NSMutableArray alloc] init];
    spriteToDelete = [[NSMutableArray alloc] init];
    
    
}

- (void) createDisplay {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // if iphone 5, change the display to use the larger image
    
    NSString *string = [prefs stringForKey:@"background"];
    NSString *retina = [string stringByAppendingString:@".png"];
    NSString *fourInch = [string stringByAppendingString:@"-568h.png"];
    
    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
        
        background = [CCSprite spriteWithFile:fourInch];
        
        
    } else {
        
        background = [CCSprite spriteWithFile:retina];
        
    }
    
    //oldColor = background.color;
    
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
    
    startParticle = 0;
    yellowLevelActive = false;
    redLevelActive = false;
    timePowerActive = false;
    circleCreated = false;
    superHeroActive = false;
    touchMoved = NO;
    
    circlesDrawn = 0;
    multiplier = startMultiplier;
    
    doublePointsActive = false;
    superActive = false;
    
    lifeLost = false;
    
    ring  = nil;
    
}

- (void) scheduleMethods {
    
    // accelerate enemies also acts as a timer, this has to be here
    [self schedule:@selector(accelerateEnemies:) interval:accelerateEnemyInterval];
    // spawns enemies based on spawntime, also needed
    [self schedule:@selector(addEnemy:) interval:enemy_spawnTime];
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
    
    if (sprite.tag == enemy_tag && superHeroActive == true) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        float diffx = (x - sprite.position.x);
        float diffy = (y - sprite.position.y);
        float z = pow((pow(diffx,2)+pow(diffy,2)), 0.5);
        
        float xVal = sprite.position.x + (-(diffx/z) * speed);
        float yVal = sprite.position.y + (-(diffy/z) * speed);
        
        if (xVal > winSize.width - sprite.contentSize.width/2 || xVal < sprite.contentSize.width/2) {
            
            xVal = sprite.position.x + ((diffx/z) * speed);
            
        }
        
        if (yVal > winSize.height - sprite.contentSize.width/2 || yVal < sprite.contentSize.height/2) {
            
            yVal = sprite.position.y + ((diffy/z) * speed);
            
        }
        
        sprite.position = ccp(xVal, yVal);
        
        
        
    } else {
        
        float diffx = (x - sprite.position.x);
        float diffy = (y - sprite.position.y);
        float z = pow((pow(diffx,2)+pow(diffy,2)), 0.5);
        
        float xVal = sprite.position.x + ((diffx/z) * speed);
        float yVal = sprite.position.y + ((diffy/z) * speed);
        
        sprite.position = ccp(xVal, yVal);
        
    }
}

- (void) addEnemy:(ccTime)dt{
    
    spawn++;
    
    if (wave > 5 || spawn > ((5 - wave))){
        
        spawn = 0;
        
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
            enemy.maxSpeed = [self randomFloatBetween:enemy_speed and:speed];
            
            [self spawnEnemy:enemy tag:enemy_tag];
        }
    }
}

- (void) addSuperEnemy:(float)x yVal:(float)y {
    
    float speed;
    
    Enemy * enemy = [Enemy spriteWithFile:@"superEnemy.png"];
    
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
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    if (score > labelScore) {
        
        labelScore += displayChange;
        
    } else if (score < labelScore) {
        
        labelScore -= displayChange;
    }
    
    if (multiplier > startMultiplier) {
        
        [scoreLabel setString:[NSString stringWithFormat:@"%07d  x%i", labelScore, multiplier]];
        scoreLabel.position = ccp(44, winSize.height - 10);
        
    } else {
        
        [scoreLabel setString:[NSString stringWithFormat:@"%07d", labelScore]];
        scoreLabel.position = ccp(34, winSize.height - 10);
    }
    
}

- (void) displayWave {
    
    [waveLabel setString:[NSString stringWithFormat:@"Wave: %d", wave]];
    
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
    
    bool enemyFrozen = false;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    float minY = winSize.height, minX = winSize.width, maxX = 0, maxY = 0;
    
    bool dobreak = false;
    
    if (touchMoved == YES) {
        
        ccColor3B color = [self changeColour:circlesDrawn];
        
        for (int i = startParticle; !dobreak && i < particleArray.count; i++) {
            
            CCSprite * firstParticle = [particleArray objectAtIndex:i];
            
            for (int j = i + 1; j < particleArray.count; j++) {
                
                CCSprite * secondParticle = [particleArray objectAtIndex:j];
                
                double lengthIntersect = [self calculateDistanceBetween:firstParticle.position and:secondParticle.position];
                
                if (lengthIntersect < distanceBetweenParticles && firstParticle.tag != circleParticle && secondParticle.tag != circleParticle) {
                    
                    for (int a = i + 1 ; a < j + 1; a++) {
                        
                        CCSprite * particle = [particleArray objectAtIndex:a];
                        
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
                    
                    for (Enemy *enemy in enemies) {
                        
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
                                    [self addToDeletionPile:select];
                                }], nil]];
                                
                                select.position = enemy.position;
                                select.tag = actionEffect;
                                
                                [gameObjects addObject:select];
                                [self addChild:select z:2];
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    if (enemyFrozen == true) {
                        
                        circlesDrawn++;
                        // [self changeColour:circlesDrawn];
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
                        
                        
                    }
                    
                    circleCreated = true;
                    
                    dobreak = true;
                    
                    break;
                    
                }
            }
        }
    }
}

- (void) drawParticles {
    
    CCSprite *particle = [particleArray lastObject];
    
    double lengthIntersect = [self calculateDistanceBetween:touchLocation and:particle.position];
    
    // ensures that particles do not bunch up together by checking that there are at least 10 pixels between the touch and the last particle
    if (lengthIntersect >= distanceBetweenParticles && lengthIntersect < distanceBetweenParticles*2) {
        
        CCSprite *particle;
        particle = [CCSprite spriteWithFile:@"particle.png"];
        particle.position = touchLocation;
        [particleArray addObject:particle];
        [self addChild:particle];
        
    } else if (lengthIntersect >= distanceBetweenParticles*2 && lengthIntersect < distanceBetweenParticles*3) {
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:hero.position];
        
        if (lengthIntersect > hero.contentSize.width + 50) {
            
            CCSprite *firstParticle = [particleArray lastObject];
            
            double diffx = (touchLocation.x - firstParticle.position.x)/2;
            double diffy = (touchLocation.y - firstParticle.position.y)/2;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            CCSprite *particle;
            particle = [CCSprite spriteWithFile:@"particle.png"];
            particle.position = ccp(diffx,diffy);
            [particleArray addObject:particle];
            [self addChild:particle];
        }
        
        particle = [CCSprite spriteWithFile:@"particle.png"];
        particle.position = touchLocation;
        [particleArray addObject:particle];
        [self addChild:particle];
        
    } else if (lengthIntersect >= distanceBetweenParticles*3) {
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:hero.position];
        
        if (lengthIntersect > hero.contentSize.width + 50) {
            
            CCSprite *firstParticle = [particleArray lastObject];
            
            double diffx = (touchLocation.x - firstParticle.position.x)/3;
            double diffy = (touchLocation.y - firstParticle.position.y)/3;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            CCSprite *particle;
            particle = [CCSprite spriteWithFile:@"particle.png"];
            particle.position = ccp(diffx,diffy);
            [particleArray addObject:particle];
            [self addChild:particle];
            
            diffx = ((touchLocation.x - firstParticle.position.x)/3) * 2;
            diffy = ((touchLocation.y - firstParticle.position.y)/3) * 2;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            particle = [CCSprite spriteWithFile:@"particle.png"];
            particle.position = ccp(diffx,diffy);
            [particleArray addObject:particle];
            [self addChild:particle];
        }
        
        particle = [CCSprite spriteWithFile:@"particle.png"];
        particle.position = touchLocation;
        [particleArray addObject:particle];
        [self addChild:particle];
        
    } else if (lengthIntersect >= distanceBetweenParticles*3 && lengthIntersect < distanceBetweenParticles*4){
        
        double lengthIntersect = [self calculateDistanceBetween:touchLocation and:hero.position];
        
        if (lengthIntersect > hero.contentSize.width + 50) {
            
            CCSprite *firstParticle = [particleArray lastObject];
            
            double diffx = (touchLocation.x - firstParticle.position.x)/3;
            double diffy = (touchLocation.y - firstParticle.position.y)/3;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            CCSprite *particle;
            particle = [CCSprite spriteWithFile:@"particle.png"];
            particle.position = ccp(diffx,diffy);
            [particleArray addObject:particle];
            [self addChild:particle];
            
            diffx = ((touchLocation.x - firstParticle.position.x)/3) * 2;
            diffy = ((touchLocation.y - firstParticle.position.y)/3) * 2;
            
            diffx += firstParticle.position.x;
            diffy += firstParticle.position.y;
            
            particle = [CCSprite spriteWithFile:@"particle.png"];
            particle.position = ccp(diffx,diffy);
            [particleArray addObject:particle];
            [self addChild:particle];
        }
        
        particle = [CCSprite spriteWithFile:@"particle.png"];
        particle.position = touchLocation;
        [particleArray addObject:particle];
        [self addChild:particle];
        
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (circleCreated == true && paused == false) {
        
        CCSprite * select;
        int enemy_Score = 0;
        
        for (CCSprite *effect in gameObjects) {
            
            if (effect.tag == actionEffect) {
                [self addToDeletionPile:effect];
            }
            
        }
        
        for (Enemy *enemy in enemies) {
            
            if (enemy.tag == frozenEnemy) {
                
                enemy_Score += enemyScore;
                
                select = [CCSprite spriteWithFile:@"enemyEffect.png"];
                
                [select runAction:[CCScaleTo actionWithDuration: 0.7 scale:1.5]];
                
                CCFadeOut *fade = [CCFadeOut actionWithDuration:0.2];
                [select runAction:[CCSequence actions:fade, [CCCallBlockN actionWithBlock:^(CCNode *node) {
                    [self addToDeletionPile:select];
                    
                }], nil]];
                
                select.position = enemy.position;
                select.tag = actionEffect;
                
                [gameObjects addObject:select];
                [self addChild:select z:4];
                
                [self addToDeletionPile:enemy];
            }
        }
        
        enemy_Score *= circlesDrawn;
        enemy_Score *= ((wave/10) + 1);
        
        if (circlesDrawn > 0) {
            
            CCLabelTTF *pointsLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", enemy_Score] fontName:@"Baccarat" fontSize:18];
            
            pointsLabel.position = scoreLabel.position;
            // change the colour to yelllow
            pointsLabel.color = ccc3(0, 0, 0);
            
            [pointsLabel runAction:[CCScaleTo actionWithDuration:1.0 scale:2.0]];
            
            [pointsLabel runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.7] ,[CCCallBlockN actionWithBlock:^(CCNode *node) {
                
                [self removeChild:pointsLabel],
                score += (enemy_Score * multiplier);
                
            }], nil]];
            
            [self addChild:pointsLabel z:5];
            
            
        } else {
            score += (enemy_Score * multiplier);
        }
        
        
        [self removeAllParticles];
        
        startParticle = 0;
        circleCreated = false;
        circlesDrawn = 0;
        
    }
    
    //[background runAction:[CCTintTo actionWithDuration:1.0 red:oldColor.r green:oldColor.g blue:oldColor.b]];
    
    [self deleteFromDeletionPile];
    
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    double lengthIntersect = [self calculateDistanceBetween:previousTouch and:touchLocation];
    
    if (lengthIntersect >= distanceBetweenParticles && superHeroActive == false && paused == false) {
        
        if (heroSpeed > heroStartSpeed) {
            
            heroSpeed -= 0.5;
            
        } else if (heroSpeed < heroStartSpeed) {
            
            heroSpeed = heroStartSpeed;
            
        }
        
    }
    
    // stop all actions yet again
    if (yellowLevelActive == false) {
        
        if (superHeroActive == false && lifeLost != true) {
            [hero stopAllActions];
        }
        
    }
    
    if (touchMoved == YES) {
        
        [self drawParticles];
    }
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // touch only moved when touch moved
    touchMoved = NO;
    
    // get touch location
    UITouch *touch = [touches anyObject];
    
    touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    
    if (touchLocation.y > (winSize.height/10 * 9) && yellowLevelActive != true) {
        
        [self pause];
    }
    
    if (paused == true && pauseButton != nil) {
        
        if (CGRectContainsPoint(pauseButton.boundingBox, touchLocation)) {
            
            paused = false;
            
            [self removeChild:pauseBackground];
            [self removeChild:pauseButton];

            if (redLevelActive == true) {
                [self schedule:@selector(createBouncers:) interval:bouncerInterval];
                [self schedule:@selector(updateBouncers:)];
                [self schedule:@selector(stopRedLevel:) interval: redLevelTime];
                
                
                [self schedule:@selector(accelerateEnemies:) interval:accelerateEnemyInterval];
                [self schedule:@selector(update:)];
            } else {
                
                [self scheduleMethods];
                
            }
            
            
        }
    }
    
    // calculate the distance between the touch and hero center
    double lengthIntersect = [self calculateDistanceBetween:hero.position and:touchLocation];
    
    // for some reason touchLocation is set to 0,0 at first (player is never going to touch here anyway)
    if (touchLocation.x != 0 && touchLocation.y != 0 && yellowLevelActive == false && paused == false) {
        
        if (superHeroActive == false && lifeLost != true) {
            [hero stopAllActions];
            heroSpeed = heroStartSpeed;
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
        
        [particleArray addObject:particle];
        [self addChild:particle];
        
    } else if (yellowLevelActive == true && paused == false) {
        
        for (CCSprite *box in gameObjects) {
            
            if (box.tag == boxTag) {
                
                if (CGRectContainsPoint(box.boundingBox, touchLocation)) {
                    
                    [box stopAllActions];
                    
                    box.tag = boxSelected;
                    
                    box.opacity = 0;
                    
                    //[box runAction:[CCFadeOut actionWithDuration:0.1]];
                    
                    CCDelayTime *delay = [CCDelayTime actionWithDuration:5.0];
                    CCCallFuncN *remove = [CCCallFuncN actionWithTarget:self selector:@selector(fadeAllOut)];
                    CCSequence *seq = [CCSequence actions:delay, remove, nil];
                    [self runAction:seq];
                    
                    [self placeCard];
                    
                    yellowLevelActive = false;
                    
                    CCDelayTime *timeDelay = [CCDelayTime actionWithDuration:5.0];
                    CCCallFuncN *stop = [CCCallFuncN actionWithTarget:self selector:@selector(stopYellowLevel)];
                    [self runAction:[CCSequence actions:timeDelay, stop, nil]];
                    
                    break;
                }
            }
        }
        
    }
    
}

- (void) pause {
    
    if (paused != true) {
        
        paused = true;
    
        CGSize winSize = [[CCDirector sharedDirector] winSize];
    
        if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
        
            pauseBackground = [CCSprite spriteWithFile:@"pause-568h.png"];
        
        } else {
        
            pauseBackground = [CCSprite spriteWithFile:@"pause.png"];
        
        }
    
        pauseBackground.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:pauseBackground z:5];
            
        [self unscheduleAllSelectors];
        [self schedule:@selector(increaseTime:) interval:1.0];
        
        pauseButton = [CCSprite spriteWithFile:@"playOff.png"];
        pauseButton.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:pauseButton z:6];
        
    }
    
}

- (void) placeCard {
    
    for (CCSprite *box in gameObjects) {
        
        CCSprite * card = nil;
        if (box.tag == boxSelected) {
            
            switch(arc4random() % 100) {
                case 0 ... 39:
                    card = [CCSprite spriteWithFile:@"nothing.png"];
                    card.tag = nothingCard;
                    break;
                case 40 ... 59:
                    card = [CCSprite spriteWithFile:@"doublePoints.png"];
                    card.tag = doublePoints;
                    doublePointsActive = true;
                    multiplier *= 2;
                    break;
                case 60 ... 79:
                    card = [CCSprite spriteWithFile:@"superCard.png"];
                    card.tag = superCard;
                    
                    CGPoint heroPos = hero.position;
                    
                    [self removeChild:hero cleanup:YES];
                    
                    hero = [CCSprite spriteWithFile:@"superhero.png"];
                    hero.position = heroPos;
                    hero.tag = superHeroTag;
                    
                    [self addChild:hero z:2];
                    
                    heroSpeed = superHeroSpeed;
                    
                    superActive = true;
                    superHeroActive = true;
                    superHeroStartTime = time;
                    [hero runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:superHeroSpeed angle:720*superHeroSpeed]]];
                    
                    [self createSuperEffect];
                    
                    break;
                case 80 ... 99:
                    card = [CCSprite spriteWithFile:@"playCard.png"];
                    card.tag = playCard;
                    
                    NSInteger playPoints = [prefs integerForKey:@"playPoints"];
                    [prefs setInteger:(playPoints+1) forKey:@"playPoints"];
                    break;
                default:
                    break;
            }
            
            card.position = box.position;
            
            [self addChild:card z:3];
            [gameObjects addObject:card];
            
            //[card runAction:[CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCFadeOut actionWithDuration:3.0], nil]];
            
            break;
        }
    }
    
}

- (void) fadeAllOut {
    
    for (CCSprite *box in gameObjects) {
        
       // if (box.tag == boxTag) {
            
            [box stopAllActions];
            [box runAction:[CCFadeOut actionWithDuration:1.0]];
            
        //}
    }
}

- (void) stopYellowLevel {
    
    [self scheduleMethods];
    levelEnemyCount = 0;
    
}

- (void) yellowLevelCreate {
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
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
        
        [particleArray removeObject:sprite];
        [self removeChild:sprite cleanup:YES];
        
    }
    
    for (CCSprite *sprite in spriteToDelete) {
        
        [powerups removeObject:sprite];
        [self removeChild:sprite cleanup:YES];
        
    }
    
    for (CCSprite *sprite in spriteToDelete) {
        
        if (sprite.tag == scoreEnemy) {
            score += (enemyScore * multiplier);
        }
        
        [enemies removeObject:sprite];
        [self removeChild:sprite cleanup:YES];
        
    }
    
    [spriteToDelete removeAllObjects];
}

- (void) updateBouncers:(ccTime)dt {
    
    // displays time
    [self displayScore];
    // draws the hearts that acts as a hud to the hero
    [self drawHearts];
    
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
            
            if (lengthIntersect <= distanceBetweenSprites && lifeLost == false) {
                
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
                    
                    lifeLost = true;
                    
                    [hero runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.7] ,[CCCallBlockN actionWithBlock:^(CCNode *node) {
                        
                        lifeLost = false;
                        
                    }], nil]];
                    
                } else if (heroLife > 1) {
                    
                    heroLife --;
                    
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
                    
                    
                    CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:50];
                    CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:255];
                    
                    CCSequence *pulseSequence = [CCSequence actionOne:fadeIn two:fadeOut];
                    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:pulseSequence];
                    [hero runAction:repeat];
                    
                    lifeLost = true;
                    
                    [hero runAction:[CCSequence actions:[CCDelayTime actionWithDuration:retreatTime] ,[CCCallBlockN actionWithBlock:^(CCNode *node) {
                        
                        lifeLost = false;
                        [hero stopAllActions];
                        hero.opacity = 255;
                        
                    }], nil]];
                    
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
    
}

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
    
    score += (redLevelScore * multiplier);
    
    [self unScheduleMethods];
    [self scheduleMethods];
    
}

- (void) removeBouncer:(CCSprite*)sprite {
    [self removeChild:sprite];
    [enemies removeObject:sprite];
}

- (void) firstBackground {
    
    CCSprite *newbackground;
    
    NSString *string = [prefs stringForKey:@"background"];
    NSString *retina = [string stringByAppendingString:@".png"];
    NSString *fourInch = [string stringByAppendingString:@"-568h.png"];
    
    if((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height == 568)) {
        
        newbackground = [CCSprite spriteWithFile:fourInch];
        
        
    } else {
        
        newbackground = [CCSprite spriteWithFile:retina];
        
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
        int maxYpos = (winSize.height - (powerup.contentSize.height / 2)) - 25;
        
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
        [powerup runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:3.0 angle:180]]];
    }
    
}

- (void) powerupAction:(CCSprite*)powerup {
    
    if (powerup.tag == timeNumber) {
        
        
        CCSprite * select;
        
        select = [CCSprite spriteWithFile:@"timeEffect.png"];
        
        [select runAction:[CCScaleTo actionWithDuration: 0.7 scaleX:100.8 scaleY:100.8]];
        CCFadeOut *fade = [CCFadeOut actionWithDuration:0.7];
        [select runAction:[CCSequence actions:fade, [CCCallBlockN actionWithBlock:^(CCNode *node) {
            [self addToDeletionPile:select];
        }], nil]];
        
        select.position = powerup.position;
        select.tag = actionEffect;
        
        [gameObjects addObject:select];
        [self addChild:select z:3];
        
        
        
        timePowerActive = true;
        timePowerStartTime = time;
        
        for (Enemy *enemy in enemies) {
            if (enemy.tag == enemy_tag) {
                enemy.speed = enemy_slow;
            }
        }
        
        
    } else if (powerup.tag == starNumber && superActive == false) {
        
        lifeLost = false;
        [hero stopAllActions];
        hero.opacity = 255;
        
        [self activateSuperhero];
        
    } else if (powerup.tag == heartNumber) {
        
        if (heroLife < heroMaxLife) {
            
            heroLife += 1;
            
        } else {
            
            score += 100;
            
        }
        
    } else if (powerup.tag == coinNumber) {
        
        score += (coinScore * multiplier);
        
    }
    
    score += (powerupScore * multiplier);
    
}

- (void) activateSuperhero {
    
    CGPoint heroPos = hero.position;
    
    [self removeChild:hero cleanup:YES];
    
    hero = [CCSprite spriteWithFile:@"superhero.png"];
    hero.position = heroPos;
    hero.tag = superHeroTag;
    
    [self addChild:hero z:2];
    
    heroSpeed = superHeroSpeed;
    
    CCRotateBy *rotate = [CCRotateBy actionWithDuration:superHeroTime - 2 angle:720 * superHeroTime];
    CCRotateBy *slowRotate = [CCRotateBy actionWithDuration:1 angle:600];
    CCRotateBy *slowRotating = [CCRotateBy actionWithDuration:1 angle:360];
    
    [hero runAction:[CCSequence actions: rotate, slowRotate, slowRotating, nil]];
    
    superHeroStartTime = time;
    superHeroActive = true;
    
    [self createSuperEffect];
    
}

- (void) createSuperEffect {
    
    if ((time - superHeroStartTime) < superHeroTime - 1 || superActive == true) {
        
        if (ring == nil) {
            
            ring = [CCSprite spriteWithFile:@"superEffect.png"];
            
            ring.position = hero.position;
            
            [gameObjects addObject:ring];
            [self addChild:ring z:2];
            
        } else {
            
            [ring stopAllActions];
            ring.opacity = 255;
            ring.scale = 1.0;
        }
        
        [ring runAction:[CCSequence actions:[CCFadeOut actionWithDuration:0.7] ,[CCCallBlockN actionWithBlock:^(CCNode *node) {
            [self createSuperEffect];
        }], nil]];
        
        [ring runAction:[CCScaleTo actionWithDuration: 0.7 scale:0.8]];
        
        
    } else if (superHeroActive == false) {
        
        [self addToDeletionPile:ring];
        [self deleteFromDeletionPile];
        ring = nil;
        
    }
}

- (void) deactivateSuperhero {
    
    CGPoint heroPos = hero.position;
    
    [hero stopAllActions];
    
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
    
}

- (void) resetHeroSpeed {
    
    heroSpeed = heroStartSpeed;
    
}

- (void) accelerateEnemies:(ccTime)dt {
    
    for (Enemy *enemy in enemies){
        
        enemy.time++;
        
        if (enemy.time >= enemy_killTime) {
            
            //currentEnemyCount = 0;
            [self addToDeletionPile:enemy];
            
        }
        
        if (enemy.tag == enemy_tag && timePowerActive == false) {
            
            if (enemy.speed < enemy.maxSpeed) {
                
                enemy.speed += enemy_acceleration;
                
            } else if (enemy.speed > enemy.maxSpeed) {
                
                enemy.speed -= enemy_acceleration;
                
            }
            
        }
    }
}

- (void) removeAllParticles {
    
    if (particleArray.count > 0) {
        
        for (CCSprite *particle in particleArray) {
            [self removeChild:particle cleanup:YES];
        }
    }
    
    [particleArray removeAllObjects];
}

- (CCSprite*) getParticle {
    
    CCSprite *particle;
    
    for (int i = 0; i < particleArray.count; i++) {
        
        particle = [particleArray objectAtIndex: i];
        
        if (particle.tag != circleParticle) {
            break;
        }
        
    }
    
    return particle;
}

- (void) followParticles {
    
    CCSprite* particle;
    
    if (particleArray.count > 0) {
        
        // get most recent particle
        // CCSprite* particle = [particles objectAtIndex: 0];
        
        CCSprite *particle = [self getParticle];
        
        if (particle.tag != circleParticle) {
            
            // make the human chase the last particle
            [self movePos:particle.position.x yVal:particle.position.y chase:hero speed:heroSpeed];
            
            if (ring != nil && superHeroActive == true) {
                ring.position = hero.position;
            }
            
            // if the human moves to the particle
            double lengthIntersect = [self calculateDistanceBetween:hero.position and:particle.position];
            
            // so that the powereater overlaps the powerup
            if (lengthIntersect <= particle.contentSize.width) {
                
                [particleArray removeObject: particle];
                [self removeChild:particle cleanup:YES];
                
                if (startParticle > 0) {
                    startParticle--;
                }
            }
        }
        
    }
    
    // particle limit = 300
    if (particleArray.count > particleLimit) {
        
        // remove latest particle
        particle = [self getParticle];
        
        [particleArray removeObject: particle];
        [self removeChild:particle cleanup:YES];
        
        if (startParticle > 0) {
            startParticle--;
        }
        
    }
    
}

- (void) dealloc {
    
    [super dealloc];
    [powerups release];
    [enemies release];
    [gameObjects release];
    [particleArray release];
    [hearts release];
    [spriteToDelete release];
    
    powerups = nil;
    enemies = nil;
    gameObjects = nil;
    particleArray = nil;
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
        
        
        if (particleArray.count > 0) {
            
            for (CCSprite *particle in particleArray) {
                
                if (enemy.tag != frozenEnemy && circleCreated == true) {
                    
                    if (CGRectIntersectsRect(enemy.boundingBox, particle.boundingBox)) {
                        
                        [self removeAllParticles];
                        powerup = nil;
                        startParticle = 0;
                        circleCreated = false;
                        touchMoved = NO;
                        
                        circlesDrawn = 0;
                        //[background runAction:[CCTintTo actionWithDuration:1.0 red:oldColor.r green:oldColor.g blue:oldColor.b]];
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
                score += (enemyScore * multiplier);
                
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
                        
                        [superEnemies addObject:enemy];
                        
                        [self addToDeletionPile:enemy];
                        
                    } else if (powerup.tag == coinNumber) {
                        
                        score -= coinScore;
                        
                        if (score < 0) {
                            score = 0;
                        }
                        
                    } else if (powerup.tag == heartNumber) {
                        
                        heroLife--;
                        
                    } else if (powerup.tag == timeNumber) {
                        
                        heroSpeed /= 2;
                        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(resetHeroSpeed) userInfo:nil repeats:NO];
                        
                    }
                }
            }
            
        } else if (enemy.tag == enemy_tag && lifeLost != true) {
            
            // make zombie chace hero
            [self movePos:hero.position.x yVal:hero.position.y chase:enemy speed:enemy.speed];
            
            double lengthIntersect = [self calculateDistanceBetween:enemy.position and:hero.position];
            
            double distanceBetweenSprites;
            
            if (superHeroActive == true) {
                
                CCSprite *radius = [CCSprite spriteWithFile:@"superEffect.png"];
                
                distanceBetweenSprites = (enemy.contentSize.width + radius.contentSize.width) / 2;
                
                radius = nil;
                
            } else {
                
                distanceBetweenSprites = (enemy.contentSize.width + hero.contentSize.width) / 2;
                
            }
            // used for circles.. if sprites touch
            
            if (lengthIntersect <= distanceBetweenSprites) {
                
                // if superhero remove the enemy
                if (hero.tag == superHeroTag) {
                    
                    //[self addToDeletionPile:enemy];
                    
                    //[enemy stopAllActions];
                    
                    CCMoveTo *move = [CCMoveTo actionWithDuration:0.2 position:hero.position];
                    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.3 scale:0];
                    
                    [enemy runAction:[CCSequence actions: move, scale, [CCCallBlockN actionWithBlock:^(CCNode *node) {
                        
                        [self addToDeletionPile:enemy],
                        enemy.tag = scoreEnemy;
                        
                    }],nil]];
                    
                    
                } else if (heroLife > 1) {
                    
                    heroLife--;
                    
                    // [hero runAction:[CCEaseElasticOut actionWithAction:[CCFadeIn actionWithDuration:10.0] period:0.4]];
                    //[hero runAction:[cc]]
                    //[hero runAction:[CCEaseBounceInOut actionWithDuration:4.0]];
                    CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:50];
                    CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:255];
                    
                    CCSequence *pulseSequence = [CCSequence actionOne:fadeIn two:fadeOut];
                    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:pulseSequence];
                    [hero runAction:repeat];
                    
                    lifeLost = true;
                    
                    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:retreatTime] ,[CCCallBlockN actionWithBlock:^(CCNode *node) {
                        
                        lifeLost = false;
                        [hero stopAllActions];
                        hero.opacity = 255;
                        
                    }], nil]];
                    
                    [self addToDeletionPile:enemy];
                    
                } else {
                    
                    // death of hero
                    /********************************************************************/
                    
                    // unschedule
                    [self unScheduleMethods];
                    
                    currentEnemyCount -= enemies.count;
                    
                    [enemy runAction:[CCMoveTo actionWithDuration:1.0 position:hero.position]];
                    
                    NSInteger highScore = [prefs integerForKey:@"highScore"];
                    
                    if (score > highScore) {
                        [prefs setInteger:score forKey:@"highScore"];
                    }
                    
                    [prefs setInteger:(highScore + score) forKey:@"totalScore"];
                    
                    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:3.0 scene: [GameOver scene]]];
                }
            }
            
        }
        
    }
    
    for (CCSprite* enemy in superEnemies) {
        
        [self addSuperEnemy:enemy.position.x yVal:enemy.position.y];
        
    }
    
    [self deleteFromDeletionPile];
    
}

- (void) update:(ccTime)dt {
    
    if (superHeroActive == false) {
        
        double lengthIntersect = [self calculateDistanceBetween:previousTouch and:touchLocation];
        
        if (lengthIntersect < distanceBetweenParticles) {
            
            if (heroSpeed < heroStartSpeed*2) {
                
                heroSpeed += 0.1;
            }
            
        }
        
    }
    
    
    
    if (timePowerActive == true && (time - timePowerStartTime) > timePowerActiveTime) {
        
        [self resetEnemySpeed];
        
    }
    
    
    if ((wave - previousYellowLevel) == 2 && previousYellowLevel != 0) {
        
        if (doublePointsActive == true || superActive == true) {
            
            doublePointsActive = false;
            superActive = false;
            multiplier = startMultiplier;
            
        }
        
    }
    
    
    if (superHeroActive == true && (time - superHeroStartTime) > superHeroTime && superActive == false) {
        
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
            
            redLevelActive = false;
            
            [self firstBackground];
            
            chosenRedLevel += redLevelChange;
        }
        
        if (wave != chosenRedLevel && (wave - previousYellowLevel) > redLevelSpace && (arc4random() % (100/yellowLevelChance)) ==  0) {
            
            //YELLOW LEVEL!!!
            /**********************************************************************************************/
            
            superActive = false;
            doublePointsActive = false;
            multiplier = startMultiplier;
            
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
    
}

@end
