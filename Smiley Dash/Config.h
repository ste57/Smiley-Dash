//
//  Config.h
//  Smiley Dash
//
//  Created by Stephen Sowole on 12/05/2013.
//  Copyright 2013 Stephen Sowole. All rights reserved.
//

#import "cocos2d.h"

// DONT CHANGE

#define setTime 1.0

// GAME

#define startingWave 1
#define displayChange 50
#define startPlayPoints 3
#define maxEnemies 150
#define game_restart 0
#define game_resume 1


// ENEMIES

#define startEnemies 10
#define enemyAddition 5
#define enemyScore 1000
#define accelerateEnemyInterval 1.0

#define enemy_speed 0.1
#define enemy_maxSpeed 1.0

#define enemy_slow 0.03

#define enemy_killTime 60

#define enemy_acceleration 0.2
#define enemy_spawnTime 0.75

// POWER EATERS

#define PE_speed 0.5
#define PE_tag 2

// SUPER ZOMBIE

#define SE_speed 1.0
#define SE_maxSpeed 2.5

// HERO

#define superHeroSpeed 3.0
#define superHeroTime 10.0
#define heroStartSpeed 1.4
#define retreatTime 5.0
#define heroMaxLife 3

// PARTICLES

#define distanceBetweenParticles 10

// RED LEVEL

#define redLevelChange 4
#define redLevelStartMin 3
#define redLevelScore 5000
#define redLevelTime 30.0

#define level1bouncers 7
#define level2bouncers 10
#define level3bouncers 15

#define redLevel1Speed 1
#define redLevel2Speed 2
#define redLevel3Speed 2

#define bouncerSpeedRange 3
#define bouncerInterval 0.2

// YELLOW LEVEL

#define yellowLevelSpace 1
#define yellowLevelChance 20//percent

// SYSTEM

#define iphoneParticleLimit 200
#define iphoneRetinaLimit 300
#define iphone5Limit 1000

// TAGS

#define enemy_tag 1
#define actionEffect 2
#define boxTag 3
#define boxSelected 4
#define cardNumber 5
#define topborder 6
#define leftborder 7
#define rightborder 8
#define bottomborder 9
#define scoreEnemy 10
#define circleParticle 11
#define normalParticle 12
#define frozenEnemy 13
#define playCard 14
#define superCard 15
#define doublePoints 16
#define nothingCard 17
#define ringEffect 18
#define timeNumber 19
#define starNumber 20
#define heartNumber 21
#define coinNumber 22
#define heroTag 23
#define superHeroTag 24
#define bouncer_tag 21

// POWERUPS

#define powerUpSpawn 10.0
#define powerUpCount 2
#define powerupScore 50

#define timePowerActiveTime 10.0
#define coinScore 3000
