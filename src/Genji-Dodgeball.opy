#!mainFile "./Genji-Dodgeball.opy"
#debug macro so don't need to time deflect:
##!defineMember isUsingAbility2 isOnGround

settings {
    "main": {
        "modeName": "Genji Dodgeball v7.8.1",
        "description": "Genji Dodgeball v7.8.1. Developed by Mazawrath. Numerous updates by u/FearlessKat, u/Blink, u/TheRedstoneBlaze, and ELIMINATED#1572. Deflect the ball when it is red to target someone else! Use jump pads to get air!"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "spectatorSlots": 6,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false,
        "teamBalancing": "afterGame"
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "workshopIslandNight",
                "workshopIsland"
            ],
            "gameLengthInMn": 15,
            "enableSelfInitiatedRespawn": false
        },
        "tdm": {
            "enabled": false,
            "gameLengthInMn": 15,
            "needsImbalancedTeamScoreToWin": true,
            "team1ScoreToWin": 10,
            "team2ScoreToWin": 10
        },
        "general": {
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableRandomHeroes": true
        }
    },
    "heroes": {
        "allTeams": {
            "genji": {
                "ability2Cooldown%": 0,
                "enableInfiniteAmmo": true,
                "enablePrimaryFire": false,
                "enableMelee": false,
                "enableSecondaryFire": false,
                "ability1Cooldown%": 38,
                "combatUltGen%": 0,
                "passiveUltGen%": 0
            },
            "reinhardt": {
                "ability1Cooldown%": 0,
                "ability1Kb%": 300,
                "movementSpeed%": "125"
            },
            "ana": {
                "ability1Cooldown%": 0,
                "movementSpeed%": "125"
            },
            "torbjorn": {
                "enableAbility1": false,
                "ability2Cooldown%": 30,
                "ability2Duration%": 8,
                "weaponsEnabled": "hammer"
            },
            "enabledHeroes": [
                "torbjorn"
            ]
        }
    }
}

#Global variables

globalvar targetedPlayer 0
globalvar previousTargetedPlayer 1
globalvar ballSpeed 2
globalvar ballPosition 3
globalvar ballSpawnCountdown 4
globalvar ballIsOut 5
globalvar ballDeleteRequested 6
globalvar roundInProgress 7
globalvar bouncePadCooldownLength 8
globalvar ballSpawnSpeed 9
globalvar maxBallSpeed 10
globalvar isInFinalDuel 11
globalvar ballSpawnCountdownHUD 12
globalvar bouncePadDistance 13
globalvar bouncePadStrength 14
globalvar bouncePad1 15
globalvar bouncePad2 16
globalvar bouncePad3 17
globalvar bouncePad4 18
globalvar deathSphere 19
globalvar deathSphereRad 20
globalvar isEnoughPlayersToStart 21
globalvar waitingForPlayersHUD 22
globalvar centerOffLimitsSize 23
globalvar sphereSize 24
globalvar circleCenter 25
globalvar redGreenColorblindMode 26
globalvar watermarkEnabled 27
globalvar bouncepadDashingEnabled 28
globalvar gameEndEnabled 29
globalvar cooldownDashingEnabled 30
globalvar deathSpherePos 31
globalvar deathBeam 32
globalvar ballDirection 33
globalvar ballCollisionSurfaceNormal 34
globalvar prevBallPos 35
globalvar prevBallPos2 36
globalvar ballSmoke 37
globalvar ballTail1 38
globalvar ballTail2 39
globalvar ballColor 40
globalvar highestScore 41
globalvar tieBreakerActive 42
globalvar randomExplosionPicker 43
globalvar explosionSoundVolume 44
globalvar improvedExplosions 45
globalvar randomExplosionSounds 46
globalvar finalDuelNuke 47
globalvar ballDirectionRate 48
globalvar entityReference 49
globalvar allowMatchEnd 51
globalvar passingDamage 52
globalvar isPassingTeam1 53
globalvar isPassingTeam2 54
globalvar scoreToWin 55
globalvar passingEnabled 56
globalvar bouncePadSuperjumpNerf 57
globalvar passingPlayer 58
globalvar passingAssistId 59
globalvar passingPlayerName 60
globalvar passingAuraToggle 61
globalvar torbBall 62
globalvar ballHero 63
globalvar playerHero 64
globalvar ballPlayer 65
globalvar ballPlayerMock 66
globalvar ballHeroRegretText 67
globalvar ballHeroRandom 68
globalvar name 69
globalvar wasFinalDuel 70
globalvar startingText 71
globalvar arenaType 72
globalvar startingBallSpeed 73
globalvar bouncePadRange 74
globalvar maxRoundsToggle 75
globalvar maxRounds 76
globalvar currentRound 77
globalvar bouncePadToggle 78
globalvar perspectiveMode 79
globalvar rulesetMode 80
globalvar bouncePadCooldownLengthStart 81
globalvar invisibleBall 82
globalvar invisiblePlayers 83
globalvar endlessBall 84
globalvar ballTailColor 85
globalvar tournamentMode 86
globalvar breaksEnabled 87
globalvar breakFrequency 88
globalvar breakLength 89
globalvar stressTorbs 90
globalvar breakInProgress 91
globalvar spawnPoints 92
globalvar gimmickPlayer 93


#Player variables

playervar hasMoved 0
playervar currentUltPercent 1
playervar bouncePadCooldown 2
playervar playerDeflects 4
playervar playerKills 5
playervar playerDeaths 6
playervar playerEffects 7
playervar playerUI 8
playervar isDashEnabled 9
playervar moveSpeed 10
playervar maxBallSpeed 11
playervar antiFloatProtection 12
playervar antiStuckProtection 13
playervar toggleHUD 14
playervar dashNerf 15
playervar passingSignal 16
playervar thirdPerson 17
playervar yeetPlayer 18
playervar latency 19
playervar latencyToggle 20
playervar canDeflect 21


#Subroutine names

subroutine CoolDeathEffects 0
subroutine UpdatedDeathEffects 1
subroutine DeflectFailed 2
subroutine ShortFun 3
subroutine LongFun 4
subroutine StartBreak 5
subroutine ReinTime 6
subroutine BedTime 7
subroutine CovidTime 8


#Activated extensions

#!extension buffAndDebuffSounds
#!extension kineticExplosionEffects
#!extension explosionSounds
#!extension spawnMoreDummyBots


rule "// SETTINGS":
    perspectiveMode = createWorkshopSetting(enum["1st Person", "3rd Person", "Toggle 1st/3rd Person"], "Dodgeball Settings", "Perspective Mode", 2, 0)
    rulesetMode = createWorkshopSetting(enum["Modern", "Retro"], "Dodgeball Settings", "Genji Dodgeball Ruleset", 0, 1)
    arenaType = createWorkshopSetting(enum["Standard", "Airbending", "Earth/waterbending", "Firebending"], "Dodgeball Settings", "Arena Type", 0, 2)
    startingBallSpeed = createWorkshopSetting(int[30:100], "Dodgeball Settings", "Starting Ball Speed", 40, 3)
    maxBallSpeed = createWorkshopSetting(int[100:500], "Dodgeball Settings", "Maximum Ball Speed", 500, 4)
    endlessBall = createWorkshopSetting(bool, "Dodgeball Settings", "Endless Ball", false, 5)
    bouncePadToggle = createWorkshopSetting(bool, "Dodgeball Settings", "Bouncepads", true, 6)
    passingEnabled = createWorkshopSetting(bool, "Dodgeball Settings", "Passing", false, 7)
    torbBall = createWorkshopSetting(enum["Please don't.", "Torb Ball"], "Fun Settings", "Torb Ball", 1, 0)
    ballTailColor = createWorkshopSetting(enum["Sky Blue", "Lethality", "Lethality+"], "Fun Settings", "Ball Tail Color", 0, 1)
    invisibleBall = createWorkshopSetting(bool, "Fun Settings", "Invisible Ball", false, 2)
    invisiblePlayers = createWorkshopSetting(bool, "Fun Settings", "Invisible Players", false, 3)
    tournamentMode = createWorkshopSetting(bool, "Tournament Settings (FFA Only)", "Tournament Mode", false, 0)
    maxRounds = createWorkshopSetting(int[1:50], "Tournament Settings (FFA Only)", "Total Rounds", 30, 1)
    breaksEnabled = createWorkshopSetting(bool, "Tournament Settings (FFA Only)", "Breaks", true, 2)
    breakFrequency = createWorkshopSetting(int[1:25], "Tournament Settings (FFA Only)", "Run Break Every __ Rounds", 10, 3)
    allowMatchEnd = createWorkshopSetting(bool, "Teams Settings", "Allow Match to End At Score", true, 0)
    scoreToWin = createWorkshopSetting(int[1:30], "Teams Settings", "Score to Win", 10, 1)
    passingAuraToggle = createWorkshopSetting(bool, "Teams Settings", "Passing Aura", true, 2)
    #Currently, there is an issue where the server will end, based on how many players there are. If there are less it will take longer to crash. But it WILL crash. This rule simply lets there be a "winner" at the end VS crashing in the middle of Final Duel.
    gameEndEnabled = createWorkshopSetting(bool, "Teams Settings", "Allow Match to End At Time", false, 2)
    watermarkEnabled = createWorkshopSetting(bool, "Visual Settings", "Watermark", true, 0)
    cooldownDashingEnabled = true
    redGreenColorblindMode = createWorkshopSetting(bool, "Visual Settings", "Red/Green Colorblind Mode", false, 2)
    finalDuelNuke = createWorkshopSetting(bool, "Visual Settings", "Final Duel Explosion", true, 3)


rule "// MAP ZONES":
    targetedPlayer = 0


rule "Set Workshop Island":
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    circleCenter = vect(0, 1.199, 0)
    sphereSize = 60


rule "Set Workshop Chamber":
    @Condition getCurrentMap() == Map.WORKSHOP_CHAMBER
    
    circleCenter = vect(0, 1.199, 0)
    sphereSize = 29.7


rule "Set Workshop Expanse Center":
    @Condition (getCurrentMap() == Map.WORKSHOP_EXPANSE or getCurrentMap() == Map.WORKSHOP_EXPANSE_NIGHT) == true
    
    circleCenter = vect(0, 1.199, 0)
    if arenaType == 2:
        sphereSize = 60
    else:
        sphereSize = 20


rule "Set Workshop Green Screen Center":
    @Condition getCurrentMap() == Map.WORKSHOP_GREEN_SCREEN
    
    circleCenter = vect(0, 1.199, 0)
    sphereSize = 20


rule "Set Oasis University Center":
    @Condition getCurrentMap() == Map.OASIS_UNIVERSITY
    
    circleCenter = vect(-192.609, 60.349, 2.252)
    sphereSize = 20


rule "Set Kings Row center (NOTE: Lower the max players! This arena is smaller then the others!)":
    @Condition getCurrentMap() == Map.KINGS_ROW
    
    circleCenter = vect(-20.504, 40.538, -74.601)
    sphereSize = 17


rule "Set Blizz World center (fun fact: you can't use the name of the company who made this game in rule names)":
    @Condition getCurrentMap() == Map.BLIZZ_WORLD
    
    circleCenter = vect(2.554, -4.651, -71.211)
    sphereSize = 20


rule "// INITIALIZATION":


#!include "./init.opy"


#!include "./Tournament.opy"


rule "Enable Scoreboard":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.toggleHUD == true
    
    eventPlayer.disableGamemodeHud()
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 10)
    eventPlayer.toggleHUD = false


rule "Disable Scoreboard":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.toggleHUD == false
    
    eventPlayer.enableGamemodeHud()
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 10)
    eventPlayer.toggleHUD = true


#!include "./BallHero.opy"


rule "// Not enough players testing":
    if not watermarkEnabled:
        goto lbl_0
    hudSubheader(getAllPlayers(), "Original by {0}. Version 7.8.1".format(name), HudPosition.LEFT, -1000, Color.AQUA, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
    lbl_0:


rule "Check for <2 players":
    @Condition getCurrentGamemode() == Gamemode.FFA
    @Condition isGameInProgress() == true
    @Condition getNumberOfHeroes(playerHero, Team.ALL) == 1
    
    isInFinalDuel = false
    hudHeader(getAllPlayers(), "Waiting for more players", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    waitingForPlayersHUD = getLastCreatedText()
    isEnoughPlayersToStart = false
    stopChasingVariable(ballSpawnCountdown)
    if roundInProgress == false:
        goto lbl_0
    ballDeleteRequested = true
    lbl_0:
    roundInProgress = false
    ballPlayerMock = false
    pauseMatchTime()


rule "Check for <2 players - TEAMS":
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition isGameInProgress() == true
    #@Condition getNumberOfHeroes(playerHero, Team.ALL) == 1
    @Condition (getNumberOfPlayers(Team.1) and getNumberOfPlayers(Team.2)) == false
    
    isInFinalDuel = false
    hudHeader(getAllPlayers(), "Waiting for more players", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    waitingForPlayersHUD = getLastCreatedText()
    isEnoughPlayersToStart = false
    stopChasingVariable(ballSpawnCountdown)
    if roundInProgress == false:
        goto lbl_0
    ballDeleteRequested = true
    lbl_0:
    roundInProgress = false
    pauseMatchTime()


rule "Wait for more players":
    @Condition getCurrentGamemode() == Gamemode.FFA
    @Condition getNumberOfHeroes(playerHero, Team.ALL) > 1
    @Condition isEnoughPlayersToStart == false
    
    destroyHudText(waitingForPlayersHUD)
    bigMessage(getAllPlayers(), "Starting game in 5 seconds!")
    wait(5.5)
    if getNumberOfHeroes(playerHero, Team.ALL) < 2:
        return
    unpauseMatchTime()
    isEnoughPlayersToStart = true
    targetedPlayer = -1
    previousTargetedPlayer = -1


rule "Wait for more players - TEAMS":
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition (getNumberOfPlayers(Team.1) and getNumberOfPlayers(Team.2)) == true
    @Condition isEnoughPlayersToStart == false
    
    destroyHudText(waitingForPlayersHUD)
    bigMessage(getAllPlayers(), "Starting game in 5 seconds!")
    wait(5.5)
    if getNumberOfHeroes(playerHero, Team.ALL) < 2:
        return
    unpauseMatchTime()
    isEnoughPlayersToStart = true
    targetedPlayer = -1
    previousTargetedPlayer = -1


rule "// GAME RULES":


rule "Shorten Deflect Length":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.canDeflect == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    wait(0.3)
    eventPlayer.setAbility2Enabled(false)
    wait(0.5)
    eventPlayer.setAbility2Enabled(true)


rule "Unlock dash after using jumppad":
    @Event eachPlayer
    @Hero all
    @Condition bouncepadDashingEnabled == true
    @Condition eventPlayer.isDashEnabled == true
    
    eventPlayer.setAbility1Enabled(true)


rule "Disable dash after using":
    @Event eachPlayer
    @Hero all
    @Condition bouncepadDashingEnabled == true
    @Condition eventPlayer.isUsingAbility2() == true
    
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.isDashEnabled = false


rule "Target random player":
    @Condition isGameInProgress() == true
    @Condition targetedPlayer == -1
    
    wait()
    targetedPlayer = (random.choice([player for player in getLivingPlayers(Team.ALL) if player.hasMoved and player.getCurrentHero() == playerHero]))


rule "Push to circle":
    @Event eachPlayer
    @Hero all
    @Condition distance(eventPlayer.getPosition(), vect(circleCenter.x, eventPlayer.getPosition().y, circleCenter.z)) > sphereSize - 1.5
    #Workshop Island Fix
    @Condition getCurrentMap() != Map.WORKSHOP_ISLAND
    @Condition getCurrentMap() != Map.WORKSHOP_ISLAND_NIGHT
    
    if distance(eventPlayer.getPosition(), vect(circleCenter.x, eventPlayer.getPosition().y, circleCenter.z)) > sphereSize - 1.5 + 2:
        eventPlayer.applyImpulse(vect(directionTowards(eventPlayer.getPosition(), circleCenter).x, 0, directionTowards(eventPlayer.getPosition(), circleCenter).z), 25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    else: 
        eventPlayer.applyImpulse(vect(directionTowards(eventPlayer.getPosition(), circleCenter).x, 0, directionTowards(eventPlayer.getPosition(), circleCenter).z), 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if eventPlayer.isOnGround():
        eventPlayer.applyImpulse(Vector.UP, 3, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.25)
    if RULE_CONDITION:
        goto RULE_START


rule "Put out center":
    @Event eachPlayer
    @Hero all
    @Condition distance(eventPlayer.getPosition(), circleCenter) < centerOffLimitsSize + 0.5
    
    eventPlayer.applyImpulse(directionTowards(circleCenter, eventPlayer), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.applyImpulse(Vector.UP, 1.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.25)
    if RULE_CONDITION:
        goto RULE_START


rule "Player dashes too far out of bounds":
    @Event eachPlayer
    @Hero all
    @Condition distance(eventPlayer.getPosition(), vect(circleCenter.x, eventPlayer.getPosition().y, circleCenter.z)) > sphereSize + 1
    @Condition eventPlayer != ballPlayer
    # No need for a knockdown in Workshop Expanse.
    @Condition not(getCurrentMap() == Map.WORKSHOP_EXPANSE or getCurrentMap() == Map.WORKSHOP_EXPANSE_NIGHT)
    #Workshop Island Fix
    #@Condition (getCurrentMap() != Map.WORKSHOP_ISLAND and getCurrentMap() != Map.WORKSHOP_ISLAND_NIGHT) == true
    
    eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 2.5)
    #eventPlayer.teleport(circleCenter + vect(random.randint(-15, 15), 8, random.randint(-15, 15)))
    eventPlayer.applyImpulse(vect(directionTowards(eventPlayer.getPosition(), circleCenter).x, 0, directionTowards(eventPlayer.getPosition(), circleCenter).z), 20, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(Vector.UP, 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    bigMessage(eventPlayer, "Do not dash out of the arena!")


rule "Player tries to abuse ledge on Workshop Island (push up and to center)":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer not in stressTorbs
    @Condition eventPlayer.getPosition().y < -0.5
    @Condition eventPlayer != ballPlayer
    #Workshop Island Fix
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    #Prevents people from going under the ledge on Workshop Island, which caused ball to go into floor.  Used to be an annoying stunkill
    eventPlayer.applyImpulse(Vector.UP, 2, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(directionTowards(eventPlayer, circleCenter), 2, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.008)
    if RULE_CONDITION:
        goto RULE_START


rule "Player falls off Workshop Island":
    @Event eachPlayer
    @Hero all
    @Condition not eventPlayer.isDummy()
    # This rule might no longer be needed...but I'll be dammed if I ever get rid of this rule. 
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    # Ayy nevermind on that last comment it back baby
    @Condition eventPlayer.getPosition().y < -1.5
    
    waitUntil(eventPlayer.getPosition().y >= 1.5 ,5)
    if not RULE_CONDITION:
        return
    smallMessage(getAllPlayers(), "{0} has glitched themselves under the map!".format(eventPlayer))
    if tournamentMode:
        hudSubtext(hostPlayer, "{0} has undermapped themself".format(eventPlayer), HudPosition.RIGHT, -1, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
    kill(eventPlayer, null)
    #A MAN HAS FALLEN INTO THE LAKE IN WORKSHOP ISLAND! START THE NEW RESCUE RULE! HEY! BUILD THE NEW WORSHOP RULE, AND OFF TO THE RESCUE! PREPARE THE CONDITION, TELEPORT THE PLAYER, AND MAKE THE RESCUE! THE NEW 2.3.0 UPDATE FROM OVERWATCH WORKSHOP!
    eventPlayer.teleport(circleCenter + vect(random.randint(-10, 10), 0, random.randint(-10, 10)))
    if eventPlayer == targetedPlayer:
        if ballIsOut:
            ballDeleteRequested = true


rule "Anti-Bounce Detection Positive X":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.getPosition().y < 0
    @Condition eventPlayer.getPosition().x > 20.5
    #Workshop Island Fix
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    #Busted!
    eventPlayer.antiFloatProtection = true
    wait(0.25)
    if RULE_CONDITION:
        goto RULE_START


rule "Anti-Bounce Detection Netgative X":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.getPosition().y < 0
    @Condition eventPlayer.getPosition().x < -20.5
    #Workshop Island Fix
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    #Busted!
    eventPlayer.antiFloatProtection = true
    wait(0.25)
    if RULE_CONDITION:
        goto RULE_START


rule "Anti-Bounce Detection Positive Z":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.getPosition().y < 0
    @Condition eventPlayer.getPosition().z > 20.5
    #Workshop Island Fix
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    #Busted!
    eventPlayer.antiFloatProtection = true
    wait(0.25)
    if RULE_CONDITION:
        goto RULE_START


rule "Anti-Bounce Detection Negative Z":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.getPosition().y < 0
    @Condition eventPlayer.getPosition().z < -20.5
    #Workshop Island Fix
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    eventPlayer.startForcingThrottle(0, 0, 0, 0, 0, 0)
    #Busted!
    eventPlayer.antiFloatProtection = true
    wait(0.25)
    if RULE_CONDITION:
        goto RULE_START


rule "Disable Anti-Bounce":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.getPosition().y >= 0
    @Condition eventPlayer.antiFloatProtection == true
    #Workshop Island Fix
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    eventPlayer.stopForcingThrottle()
    eventPlayer.antiFloatProtection = false


rule "Anti-Stuck Activation":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer not in stressTorbs
    @Condition eventPlayer.getPosition().y < -4
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    eventPlayer.applyImpulse(Vector.UP, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Bounce when near pad 1":
    @Event eachPlayer
    @Hero all
    @Condition bouncePad1 != null
    @Condition distance(eventPlayer.getPosition(), bouncePad1) <= bouncePadRange
    @Condition eventPlayer.bouncePadCooldown == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.isDashEnabled = true
    if eventPlayer.dashNerf:
        eventPlayer.applyImpulse(Vector.UP, bouncePadStrength - bouncePadSuperjumpNerf, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    else:
        eventPlayer.applyImpulse(Vector.UP, bouncePadStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.bouncePadCooldown = bouncePadCooldownLength
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, bouncePad1, 25)
    eventPlayer.playerEffects[1] = getLastCreatedEntity()
    wait(2)
    destroyEffect(eventPlayer.playerEffects[1])


rule "Bounce when near pad 2":
    @Event eachPlayer
    @Hero all
    @Condition bouncePad2 != null
    @Condition distance(eventPlayer.getPosition(), bouncePad2) <= bouncePadRange
    @Condition eventPlayer.bouncePadCooldown == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.isDashEnabled = true
    if eventPlayer.dashNerf:
        eventPlayer.applyImpulse(Vector.UP, bouncePadStrength - bouncePadSuperjumpNerf, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    else:
        eventPlayer.applyImpulse(Vector.UP, bouncePadStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.bouncePadCooldown = bouncePadCooldownLength
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, bouncePad1, 25)
    eventPlayer.playerEffects[1] = getLastCreatedEntity()
    wait(2)
    destroyEffect(eventPlayer.playerEffects[1])


rule "Bounce when near pad 3":
    @Event eachPlayer
    @Hero all
    @Condition bouncePad3 != null
    @Condition distance(eventPlayer.getPosition(), bouncePad3) <= bouncePadRange
    @Condition eventPlayer.bouncePadCooldown == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.isDashEnabled = true
    if eventPlayer.dashNerf:
        eventPlayer.applyImpulse(Vector.UP, bouncePadStrength - bouncePadSuperjumpNerf, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    else:
        eventPlayer.applyImpulse(Vector.UP, bouncePadStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.bouncePadCooldown = bouncePadCooldownLength
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, bouncePad1, 25)
    eventPlayer.playerEffects[1] = getLastCreatedEntity()
    wait(2)
    destroyEffect(eventPlayer.playerEffects[1])


rule "Bounce when near pad 4":
    @Event eachPlayer
    @Hero all
    @Condition bouncePad4 != null
    @Condition distance(eventPlayer.getPosition(), bouncePad4) <= bouncePadRange
    @Condition eventPlayer.bouncePadCooldown == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    
    eventPlayer.isDashEnabled = true
    if eventPlayer.dashNerf:
        eventPlayer.applyImpulse(Vector.UP, bouncePadStrength - bouncePadSuperjumpNerf, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    else:
        eventPlayer.applyImpulse(Vector.UP, bouncePadStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.bouncePadCooldown = bouncePadCooldownLength
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, bouncePad1, 25)
    eventPlayer.playerEffects[1] = getLastCreatedEntity()
    wait(2)
    destroyEffect(eventPlayer.playerEffects[1])


rule "Ball delete requested":
    @Condition ballDeleteRequested == true
    
    ballDeleteRequested = false
    ballPlayerMock = true
    targetedPlayer = -1
    stopChasingVariable(ballDirection)
    stopChasingVariable(ballPosition)
    stopChasingVariable(ballSpeed)
    ballPosition = vect(0, -1, 0)
    ballDirection = vect(0, 0, 0)
    ballIsOut = false
    previousTargetedPlayer = -1
    ballSpawnCountdown = 2
    prevBallPos = vect(0, 0, 0)
    prevBallPos2 = vect(0, 0, 0)


rule "Only end game when there isn't a round in progress":
    @Condition getMatchTime() == 0
    @Condition roundInProgress == false
    @Condition gameEndEnabled == true
    @Condition tieBreakerActive == false
    
    enableMusic()
    enableGamemodeCompletion()


rule "// ACTIVE GAME":


rule "Start round":
    @Condition getCurrentGamemode() == Gamemode.FFA
    @Condition isEnoughPlayersToStart == true
    @Condition isGameInProgress() == true
    
    chase(ballSpawnCountdown, 0, rate=1, ChaseReeval.NONE)
    roundInProgress = true
    ballPlayerMock = false
    chase(getAllPlayers().bouncePadCooldown, 0, rate=1, ChaseReeval.NONE)
    ballSpawnCountdown = 5


rule "Start round - TEAMS":
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition isEnoughPlayersToStart == true
    @Condition isGameInProgress() == true
    
    chase(ballSpawnCountdown, 0, rate=1, ChaseReeval.NONE)
    roundInProgress = true
    chase(getAllPlayers().bouncePadCooldown, 0, rate=1, ChaseReeval.NONE)
    ballSpawnCountdown = 5


rule "Spawn ball":
    @Condition ballSpawnCountdown == 0
    
    ballPosition = circleCenter
    ballDirection = directionTowards(ballPosition, targetedPlayer.getEyePosition())
    ballDirectionRate = 1.75
    ballSpeed = startingBallSpeed
    ballPlayerMock = false
    ballIsOut = true
    if not ballPlayer.isUsingAbility1():
        wait(0.25)
        ballPlayer.forceButtonPress(Button.ABILITY_1)


rule "Modern ball motion":
    @Condition rulesetMode == 0
    @Condition ballIsOut == true
    
    chase(ballPosition, ballPosition + ballDirection * ballSpeed, rate=ballSpeed, ChaseReeval.DESTINATION_AND_RATE)
    chase(ballDirection, directionTowards(ballPosition, targetedPlayer.getEyePosition()), rate=ballDirectionRate, ChaseReeval.DESTINATION_AND_RATE)
    chase(ballSpeed, maxBallSpeed, rate=0.25, ChaseReeval.DESTINATION_AND_RATE)

rule "Retro ball motion":
    @Condition rulesetMode == 1
    @Condition ballIsOut == true

    chase(ballPosition, targetedPlayer.getEyePosition(), rate=ballSpeed, ChaseReeval.DESTINATION_AND_RATE)
    chase(ballSpeed, maxBallSpeed, rate=0.25, ChaseReeval.DESTINATION_AND_RATE)


rule "Astro ball motion":
    @Condition rulesetMode == 2
    @Condition ballIsOut == true

    chase(ballPosition, updateEveryTick(ballPosition + ballDirection), rate=updateEveryTick(magnitude(ballDirection)), ChaseReeval.DESTINATION_AND_RATE)
    #ballDirection is the ball's velocity
    chase(ballDirection, updateEveryTick(ballDirection * 0.93 + targetedPlayer.getEyePosition() - ballPosition), rate=updateEveryTick(sqrt((ballSpeed - max(dotProduct(ballDirection, directionTowards(ballPosition, targetedPlayer.getEyePosition())), 0)) * ballSpeed) * 3), ChaseReeval.DESTINATION_AND_RATE)
    #ballSpeed is the ball's acceleration coefficient
    chase(ballSpeed, maxBallSpeed, rate=0.25, ChaseReeval.DESTINATION_AND_RATE)
    #Chase client prediction fix
    wait(0.016)
    if RULE_CONDITION:
        goto RULE_START


rule "Update ball postiion":
    @Condition ballIsOut == true

    # This is for the ball tail to be updated.
    prevBallPos2 = prevBallPos
    prevBallPos = ballPosition
    wait(0.05)
    if RULE_CONDITION:
        goto RULE_START


rule "Ball reaches player":
    @Condition getCurrentGamemode() == Gamemode.FFA
    @Condition distance(ballPosition, targetedPlayer.getEyePosition()) <= 1.9
    @Condition ballIsOut == true
    
    if not(targetedPlayer.canDeflect or (targetedPlayer.isUsingAbility2() and rulesetMode != 1)):
        DeflectFailed()
        if rulesetMode == 1:
            wait()
            if RULE_CONDITION:
                goto RULE_START
        return
    if targetedPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        #If they don't have enough health, kill em
        if targetedPlayer.getHealth() <= 100:
            DeflectFailed()
            if rulesetMode == 1:
                wait()
                if RULE_CONDITION:
                    goto RULE_START
            return
    # if targetedPlayer.isUsingAbility2():
    #     ballPlayer.setStatusEffect(null, Status.STUNNED, 0.5)
    # else:
    #     ballPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 0.5)
    if targetedPlayer.isUsingAbility2():
        targetedPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 1)
        targetedPlayer.teleport(ballPosition)
    targetedPlayer.currentUltPercent += 5
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, targetedPlayer.getPosition(), 200)
    targetedPlayer.playerDeflects += 1
    previousTargetedPlayer = targetedPlayer
    ballSpeed = min(maxBallSpeed, ballSpeed * 1.05)
    if ballSpeed > targetedPlayer.maxBallSpeed:
        targetedPlayer.maxBallSpeed = ballSpeed
    ballDirection = targetedPlayer.getFacingDirection() * (ballSpeed if rulesetMode == 2 else 1)
    wait(0.001)
    # Check if player is passing and if passing is enabled
    if previousTargetedPlayer.isHoldingButton(Button.SECONDARY_FIRE) and passingEnabled:
        isPassingTeam1 = true
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, previousTargetedPlayer.getPosition(), 10)
        playEffect(previousTargetedPlayer, DynamicEffect.MOIRA_FADE_DISAPPEAR_SOUND, Color.WHITE, previousTargetedPlayer.getPosition(), 100)
        previousTargetedPlayer.setHealth(passingDamage)
        targetedPlayer = previousTargetedPlayer
    else:
        isPassingTeam1 = false
        heal(previousTargetedPlayer, null, passingDamage)
        targetedPlayer = ((sorted([player for player in getLivingPlayers(Team.ALL) if player != previousTargetedPlayer and player.getCurrentHero() != ballHero and player.getCurrentHero() != gimmickPlayer[0].getCurrentHero()], lambda i: angleBetweenVectors(targetedPlayer.getFacingDirection(), directionTowards(targetedPlayer, i.getPosition()))))[0])
    if rulesetMode == 0:
            ballDirectionRate = 6
            wait(0.05)
            ballDirectionRate = 1.75
    # pls Blizzard let me do if RULE_CONDITION and rulesetMode == 1:
    if rulesetMode == 1:
        if RULE_CONDITION:
            goto RULE_START


rule "Ball reaches player -TEAMS":
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition distance(ballPosition, targetedPlayer.getEyePosition()) <= 1.9
    @Condition ballIsOut == true
    
    if not(targetedPlayer.isUsingAbility2() or (targetedPlayer.isUsingAbility2() and rulesetMode != 1)):
        DeflectFailed()
        if rulesetMode == 1:
            wait()
            if RULE_CONDITION:
                goto RULE_START
        return
    if targetedPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        #If they don't have enough health, kill em
        if targetedPlayer.getHealth() <= 100:
            DeflectFailed()
            if rulesetMode == 1:
                wait()
                if RULE_CONDITION:
                    goto RULE_START
            return
    if targetedPlayer.isUsingAbility2():
        targetedPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 1)
        targetedPlayer.teleport(ballPosition)
    targetedPlayer.currentUltPercent += 5
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, targetedPlayer.getPosition(), 200)
    targetedPlayer.playerDeflects += 1
    previousTargetedPlayer = targetedPlayer
    ballSpeed = min(500, ballSpeed * 1.05)
    if ballSpeed > targetedPlayer.maxBallSpeed:
        targetedPlayer.maxBallSpeed = ballSpeed
    ballDirection = targetedPlayer.getFacingDirection() * (ballSpeed if rulesetMode == 2 else 1)
    wait(0.001)
    # Check if player is passing and if passing is enabled
    if previousTargetedPlayer.isHoldingButton(Button.SECONDARY_FIRE) and passingEnabled:
        #if previousTargetedPlayer.isHoldingButton(Button.SECONDARY_FIRE):
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, previousTargetedPlayer.getPosition(), 10)
        playEffect(previousTargetedPlayer, DynamicEffect.MOIRA_FADE_DISAPPEAR_SOUND, Color.WHITE, previousTargetedPlayer.getPosition(), 100)
        previousTargetedPlayer.setHealth(passingDamage)
        stopAssist(passingAssistId)
        #passingPlayer = null
        #Check which team is passing
        if previousTargetedPlayer.getTeam() == Team.1:
            isPassingTeam1 = true
        else:
            isPassingTeam2 = true
        #If the member is the only one left on their team, self pass
        if len([player for player in getLivingPlayers(previousTargetedPlayer.getTeam()) if true]) == 1:
            # Check if using modern rules. Self passing is disabled in retro rules so it's basically a failed deflect.
            if rulesetMode != 1:
                targetedPlayer = previousTargetedPlayer
            else:
                DeflectFailed()
        #Pass to another teammate
        else:
            passingPlayer = previousTargetedPlayer
            passingPlayer.startGrantingAssistFor(getAllPlayers(), AssistReeval.NONE)
            passingAssistId = getLastAssistID()
            targetedPlayer = ((sorted([player for player in getLivingPlayers(previousTargetedPlayer.getTeam()) if player != previousTargetedPlayer], lambda i: angleBetweenVectors(targetedPlayer.getFacingDirection(), directionTowards(targetedPlayer, i.getPosition()))))[0])
        #Not passing, heal the person deflecting and target someone on the other team
    else:
        # Only clear the passing player if this isn't that passing players ball
        if isPassingTeam1 == false or isPassingTeam2 == false:
            stopAssist(passingAssistId)
            #passingPlayer = null
        heal(previousTargetedPlayer, null, passingDamage)
        isPassingTeam1 = false
        isPassingTeam2 = false
        targetedPlayer = ((sorted([player for player in getLivingPlayers(getOppositeTeam(previousTargetedPlayer.getTeam())) if player != previousTargetedPlayer], lambda i: angleBetweenVectors(targetedPlayer.getFacingDirection(), directionTowards(targetedPlayer, i.getPosition()))))[0])
    if rulesetMode == 0:
        ballDirectionRate = 6
        wait(0.05)
        ballDirectionRate = 1.75
    # Hey, what do you know, that comment I had here for months actually ended up correct when I readded retro!   
    if rulesetMode == 1:
        if RULE_CONDITION:
            goto RULE_START


rule "End assist after a second - TEAMS":
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition passingPlayer != null

    waitUntil(previousTargetedPlayer != passingPlayer, 10)
    wait(1)
    stopAssist(passingAssistId)
    passingPlayer = null


def DeflectFailed():
    @Name "Player Didn't Deflect - Kill"
    
    heal(getLivingPlayers(Team.ALL), null, 200)
    isPassingTeam1 = false
    isPassingTeam2 = false
    targetedPlayer.setStatusEffect(previousTargetedPlayer, Status.STUNNED, 1)
    targetedPlayer.bouncePadCooldown = 0
    previousTargetedPlayer.currentUltPercent += 15
    if ballHero and previousTargetedPlayer == -1:
        previousTargetedPlayer = ballPlayer
    kill(targetedPlayer, previousTargetedPlayer)
    if ballHero and not ballPlayer.hasStatusEffect(Status.FROZEN):
        ballPlayer.stopFacing()
        ballPlayer.setFacing(directionTowards(ballPlayer.getEyePosition(), targetedPlayer.getPosition()), Relativity.TO_WORLD)
    if improvedExplosions == true:
        UpdatedDeathEffects()
    else:
        CoolDeathEffects()
    if passingPlayer and targetedPlayer.getTeam() != passingPlayer.getTeam():
        # Please don't ask me why I need to do this. I don't know either.
        passingPlayerName = passingPlayer
        smallMessage(getAllPlayers(), "Passing assist from {0}!".format(passingPlayerName))
    stopAssist(passingAssistId)
    passingPlayer = null
    targetedPlayer.playerDeaths += 1
    previousTargetedPlayer.playerKills += 1
    if endlessBall:
        # Does this if statement look scary to you? Good. Tremble in fear at my might of writing unnecessarily complex if statements. 
        if (getCurrentGamemode() == Gamemode.FFA and len([player for player in getLivingPlayers(Team.ALL) if player.isAlive() and player.getCurrentHero() != ballHero]) != 1) or (getCurrentGamemode() == Gamemode.TDM and not(getNumberOfLivingPlayers(Team.1) == 0 or getNumberOfLivingPlayers(Team.2) == 0)):
            ballSpeed = min(500, ballSpeed * 1.05)
            # Massive shoutout to DazNachbarzkind#2265 from the GDB EU Discord for making this intelligent targeting logic. You alone made this mode awesome.
            targetedPlayer = (sorted([player for player in getLivingPlayers(Team.ALL) if player.hasMoved and player != ballPlayer], lambda i: angleBetweenVectors(ballDirection, directionTowards(ballPosition, i.getPosition()))))[0]
        else:
            ballDeleteRequested = true
    else:
        ballDeleteRequested = true


def CoolDeathEffects():
    @Name "CoolDeathEffects sub"
    
    createBeam(getAllPlayers(), Beam.BAD, previousTargetedPlayer, targetedPlayer, Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    deathBeam = getLastCreatedEntity()
    deathSpherePos = targetedPlayer.getPosition()
    deathSphereRad = 30
    chase(deathSphereRad, 0, duration=0.25, ChaseReeval.NONE)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.SKY_BLUE, deathSpherePos, 40)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLACK, deathSpherePos, deathSphereRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    deathSphere = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.WHITE, deathSpherePos, 5)
    wait(0.25)
    destroyEffect(deathSphere)
    #playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, deathSpherePos, sphereSize * 1.5)
    #playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, deathSpherePos, 40)
    destroyEffect(deathBeam)


def UpdatedDeathEffects():
    @Name "Updated Death Effects Sub"
    
    deathSpherePos = targetedPlayer.getPosition()
    #Make sure it is final duel AND there are at least 3 or more players
    if getCurrentGamemode() == Gamemode.FFA and getNumberOfLivingPlayers(Team.ALL) == 1 and getNumberOfHeroes(playerHero, Team.ALL) != 2 and finalDuelNuke:
        if targetedPlayer.getAltitude() < 5:
            playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT, Color.WHITE, vect(deathSpherePos.x, 0, deathSpherePos.z), 0)
        else:
            playEffect(getAllPlayers(), DynamicEffect.JUNKRAT_RIP_TIRE_EXPLOSION, Color.WHITE, deathSpherePos, 0)
    elif getCurrentGamemode() == Gamemode.TDM and (getNumberOfLivingPlayers(Team.1) == 0 or getNumberOfLivingPlayers(Team.2) == 0) and getNumberOfHeroes(playerHero, Team.ALL) != 2 and finalDuelNuke:
        if targetedPlayer.getAltitude() < 5:
            playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT, Color.WHITE, vect(deathSpherePos.x, 0, deathSpherePos.z), 0)
        else:
            playEffect(getAllPlayers(), DynamicEffect.JUNKRAT_RIP_TIRE_EXPLOSION, Color.WHITE, deathSpherePos, 0)
    playEffect(getAllPlayers(), DynamicEffect.BASTION_TANK_CANNON_EXPLOSION, Color.WHITE, deathSpherePos, 1)
    if randomExplosionSounds:
        #Pick a random explosion sound
        randomExplosionPicker = random.randint(0, 4)
        if randomExplosionPicker == 0:
            playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT_SOUND, Color.WHITE, deathSpherePos, explosionSoundVolume)
        elif randomExplosionPicker == 1:
            playEffect(getAllPlayers(), DynamicEffect.BASTION_TANK_CANNON_EXPLOSION_SOUND, Color.WHITE, deathSpherePos, explosionSoundVolume)
        elif randomExplosionPicker == 2:
            playEffect(getAllPlayers(), DynamicEffect.ASHE_DYNAMITE_EXPLOSION_SOUND, Color.WHITE, deathSpherePos, explosionSoundVolume)
        elif randomExplosionPicker == 3:
            playEffect(getAllPlayers(), DynamicEffect.PHARAH_BARRAGE_EXPLOSION_SOUND, Color.WHITE, deathSpherePos, explosionSoundVolume)
        elif randomExplosionPicker == 4:
            playEffect(getAllPlayers(), DynamicEffect.JUNKRAT_FRAG_LAUNCHER_EXPLOSION_SOUND, Color.WHITE, deathSpherePos, explosionSoundVolume)
    else:
        #playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT_SOUND, Color.WHITE, deathSpherePos, explosionSoundVolume)
        playEffect(getAllPlayers(), DynamicEffect.JUNKRAT_FRAG_LAUNCHER_EXPLOSION_SOUND, Color.WHITE, deathSpherePos, explosionSoundVolume)


rule "Final duel":
    @Condition getCurrentGamemode() == Gamemode.FFA
    @Condition isGameInProgress() == true
    @Condition len([player for player in getLivingPlayers(Team.ALL) if player.hasMoved and player.getCurrentHero() == playerHero]) == 2
    @Condition isEnoughPlayersToStart == true
    @Condition isInFinalDuel == false
    @Condition not endlessBall
    
    ballSpawnCountdown = 5
    getLivingPlayers(Team.ALL).isDashEnabled = false
    if ballIsOut == false:
        goto lbl_0
    ballDeleteRequested = true
    lbl_0:
    isInFinalDuel = true
    getLivingPlayers(Team.ALL).bouncePadCooldown = 2
    if getNumberOfHeroes(playerHero, Team.ALL) <= 2:
        goto lbl_1
    bigMessage(getAllPlayers(), "Final Duel!")
    lbl_1:
    getLivingPlayers(Team.ALL).applyImpulse(Vector.DOWN, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    getLivingPlayers(Team.ALL).applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    getLivingPlayers(Team.ALL).applyImpulse(Vector.BACKWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    getLivingPlayers(Team.ALL).applyImpulse(Vector.FORWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    getLivingPlayers(Team.ALL).applyImpulse(Vector.RIGHT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    getLivingPlayers(Team.ALL).applyImpulse(Vector.LEFT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT:
        getLivingPlayers(Team.ALL)[0].teleport(circleCenter + vect(-1, 0, 0) * (sphereSize / 4))
        getLivingPlayers(Team.ALL)[1].teleport(circleCenter + vect(1, 0, 0) * (sphereSize / 4))
    else:
        getLivingPlayers(Team.ALL)[0].teleport(circleCenter + vect(-1, 0, 0) * (sphereSize / 1.5))
        getLivingPlayers(Team.ALL)[1].teleport(circleCenter + vect(1, 0, 0) * (sphereSize / 1.5))
    getLivingPlayers(Team.ALL).setStatusEffect(null, Status.ROOTED, 2)
    wait(0.001)
    getLivingPlayers(Team.ALL)[0].setFacing(directionTowards(getLivingPlayers(Team.ALL)[0].getPosition(), circleCenter), Relativity.TO_WORLD)
    getLivingPlayers(Team.ALL)[1].setFacing(directionTowards(getLivingPlayers(Team.ALL)[1].getPosition(), circleCenter), Relativity.TO_WORLD)


rule "Final duel - TEAMS":
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition isGameInProgress() == true
    #@Condition len([player for player in getLivingPlayers(Team.ALL) if player.hasMoved]) == 2
    @Condition (len([player for player in getLivingPlayers(Team.1) if player.hasMoved]) == 1 and len([player for player in getLivingPlayers(Team.2) if player.hasMoved]) == 1) == true
    @Condition isEnoughPlayersToStart == true
    @Condition isInFinalDuel == false
    @Condition not endlessBall
    
    ballSpawnCountdown = 5
    getLivingPlayers(Team.ALL).isDashEnabled = false
    if ballIsOut == false:
        goto lbl_0
    ballDeleteRequested = true
    lbl_0:
    isInFinalDuel = true
    getLivingPlayers(Team.ALL).bouncePadCooldown = 2
    if getNumberOfHeroes(playerHero, Team.ALL) <= 2:
        goto lbl_1
    bigMessage(getAllPlayers(), "Final Duel!")
    lbl_1:
    getLivingPlayers(Team.ALL).applyImpulse(Vector.DOWN, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    getLivingPlayers(Team.ALL).applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    getLivingPlayers(Team.ALL).applyImpulse(Vector.BACKWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    getLivingPlayers(Team.ALL).applyImpulse(Vector.FORWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    getLivingPlayers(Team.ALL).applyImpulse(Vector.RIGHT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    getLivingPlayers(Team.ALL).applyImpulse(Vector.LEFT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    if getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT:
        getLivingPlayers(Team.ALL)[0].teleport(circleCenter + vect(-1, 0, 0) * (sphereSize / 4))
        getLivingPlayers(Team.ALL)[1].teleport(circleCenter + vect(1, 0, 0) * (sphereSize / 4))
    else:
        getLivingPlayers(Team.ALL)[0].teleport(circleCenter + vect(-1, 0, 0) * (sphereSize / 1.5))
        getLivingPlayers(Team.ALL)[1].teleport(circleCenter + vect(1, 0, 0) * (sphereSize / 1.5))
    getLivingPlayers(Team.ALL).setStatusEffect(null, Status.ROOTED, 2)
    wait(0.001)
    getLivingPlayers(Team.ALL)[0].setFacing(directionTowards(getLivingPlayers(Team.ALL)[0].getPosition(), circleCenter), Relativity.TO_WORLD)
    getLivingPlayers(Team.ALL)[1].setFacing(directionTowards(getLivingPlayers(Team.ALL)[1].getPosition(), circleCenter), Relativity.TO_WORLD)


rule "Create passing aura - TEAMS":
    @Event eachPlayer
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE)
    @Condition passingEnabled
    @Condition passingAuraToggle

    createEffect([player for player in getPlayers(eventPlayer.getTeam()) if player != eventPlayer and not player.isDead()], Effect.BAD_AURA, Color.SKY_BLUE, eventPlayer.getEyePosition(), 1.5, EffectReeval.POSITION_AND_RADIUS)
    eventPlayer.passingSignal = getLastCreatedEntity()
    waitUntil(not eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) or eventPlayer.isDead(), 60)
    destroyEffect(eventPlayer.passingSignal)

rule "Check for last player surviving":
    @Condition getCurrentGamemode() == Gamemode.FFA
    @Condition isGameInProgress() == true
    @Condition len([player for player in getLivingPlayers(Team.ALL) if player.isAlive() and player.getCurrentHero() == playerHero]) == 1
    @Condition isEnoughPlayersToStart == true
    
    isInFinalDuel = false
    [player for player in getLivingPlayers(Team.ALL) if player.getCurrentHero() != ballHero].addToScore(1)
    wait(0.25)
    if (getMatchTime() == 0 or tieBreakerActive) and gameEndEnabled:
        #If there is alredy a tiebreaker, then the tiebreaker has ended.
        #if tieBreakerActive:
        #break
        #__end__()
        highestScore = sorted(getAllPlayers(), lambda player: player.getScore()).last().getScore()
        #Check if there is more then 1 person with the highest score
        if len([player for player in getAllPlayers() if player.getScore() == highestScore]) > 1:
            #There is more then 1, activate tie breaker
            tieBreakerActive = true
        else:
            tieBreakerActive = false
    stopChasingVariable(ballSpawnCountdown)
    stopChasingVariable(getAllPlayers().bouncePadCooldown)
    bigMessage(getAllPlayers(), "{0} has won the round!".format([player for player in getLivingPlayers(Team.ALL) if player.getCurrentHero() != ballHero]))
    wait(2)
    if not tieBreakerActive:
        getDeadPlayers(Team.ALL).resurrect()
    else:
        #Kill anyone alive who doesn't have the highest score.
        kill([player for player in getLivingPlayers(Team.ALL) if player.getScore() != highestScore], null)
        #During tiebreaker, only revive the people who have the same score as the highest score.
        ([player for player in getDeadPlayers(Team.ALL) if player.getScore() == highestScore]).resurrect()
        wait(0.25)
        targetedPlayer = -1
        bigMessage(getAllPlayers(), "Tiebreaker!")
    if not isEnoughPlayersToStart:
        return
    roundInProgress = false
    getAllPlayers().bouncePadCooldown = bouncePadCooldownLengthStart
    currentRound += 1
    if currentRound - 1 < maxRounds and (tournamentMode and breaksEnabled and (currentRound - 1) % breakFrequency == 0):
        StartBreak()
    else:
        ballSpawnCountdown = 5
    if currentRound == 5 or currentRound == 15:
        async(ReinTime(), AsyncBehavior.NOOP)
    if currentRound == 10 or currentRound == 20:
            async(BedTime(), AsyncBehavior.NOOP)
    wait(1)
    roundInProgress = true
    if not bouncepadDashingEnabled:
        goto lbl_0
    getAllPlayers().isDashEnabled = false
    getAllPlayers().setAbility1Enabled(false)
    lbl_0:
    chase(ballSpawnCountdown, 0, rate=1, ChaseReeval.NONE)
    chase(getAllPlayers().bouncePadCooldown, 0, rate=1, ChaseReeval.NONE)


rule "Team 1 Last Surviving - TEAMS":
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition isGameInProgress() == true
    @Condition getNumberOfLivingPlayers(Team.2) == 0
    @Condition isEnoughPlayersToStart == true
    
    isInFinalDuel = false
    addToTeamScore(Team.1, 1)
    wait(0.25)
    if (getMatchTime() == 0 or tieBreakerActive) and gameEndEnabled:
        #If there is alredy a tiebreaker, then the tiebreaker has ended.
        #if tieBreakerActive:
        #break
        #__end__()
        highestScore = sorted(getAllPlayers(), lambda player: player.getScore()).last().getScore()
        #Check if there is more then 1 person with the highest score
        if teamScore(Team.1) == teamScore(Team.2):
            #There is more then 1, activate tie breaker
            tieBreakerActive = true
        else:
            tieBreakerActive = false
    stopChasingVariable(ballSpawnCountdown)
    stopChasingVariable(getAllPlayers().bouncePadCooldown)
    bigMessage(getAllPlayers(), "{0} has won the round!".format(Team.1))
    wait(2)
    if not tieBreakerActive:
        getDeadPlayers(Team.ALL).resurrect()
    else:
        #Kill anyone alive who doesn't have the highest score.
        kill([player for player in getLivingPlayers(Team.ALL) if player.getScore() != highestScore], null)
        #During tiebreaker, only revive the people who have the same score as the highest score.
        ([player for player in getDeadPlayers(Team.ALL) if player.getScore() == highestScore]).resurrect()
        wait(0.25)
        targetedPlayer = -1
        bigMessage(getAllPlayers(), "Tiebreaker!")
    heal(getAllPlayers(), null, 200)
    if not isEnoughPlayersToStart:
        return
    roundInProgress = false
    currentRound += 1
    getAllPlayers().bouncePadCooldown = bouncePadCooldownLengthStart
    ballSpawnCountdown = 5
    wait(1)
    roundInProgress = true
    if not bouncepadDashingEnabled:
        goto lbl_0
    getAllPlayers().isDashEnabled = false
    getAllPlayers().setAbility1Enabled(false)
    lbl_0:
    chase(ballSpawnCountdown, 0, rate=1, ChaseReeval.NONE)
    chase(getAllPlayers().bouncePadCooldown, 0, rate=1, ChaseReeval.NONE)


rule "Team 2 Last Surviving - TEAMS":
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition isGameInProgress() == true
    @Condition getNumberOfLivingPlayers(Team.1) == 0
    @Condition isEnoughPlayersToStart == true
    
    isInFinalDuel = false
    addToTeamScore(Team.2, 1)
    wait(0.25)
    if (getMatchTime() == 0 or tieBreakerActive) and gameEndEnabled:
        #If there is alredy a tiebreaker, then the tiebreaker has ended.
        #if tieBreakerActive:
        #break
        #__end__()
        highestScore = sorted(getAllPlayers(), lambda player: player.getScore()).last().getScore()
        #Check if there is more then 1 person with the highest score
        if teamScore(Team.1) == teamScore(Team.2):
            #There is more then 1, activate tie breaker
            tieBreakerActive = true
        else:
            tieBreakerActive = false
    stopChasingVariable(ballSpawnCountdown)
    stopChasingVariable(getAllPlayers().bouncePadCooldown)
    bigMessage(getAllPlayers(), "{0} has won the round!".format(Team.2))
    wait(2)
    if not tieBreakerActive:
        getDeadPlayers(Team.ALL).resurrect()
    else:
        #Kill anyone alive who doesn't have the highest score.
        kill([player for player in getLivingPlayers(Team.ALL) if player.getScore() != highestScore], null)
        #During tiebreaker, only revive the people who have the same score as the highest score.
        ([player for player in getDeadPlayers(Team.ALL) if player.getScore() == highestScore]).resurrect()
        wait(0.25)
        targetedPlayer = -1
        bigMessage(getAllPlayers(), "Tiebreaker!")
    heal(getAllPlayers(), null, 200)
    if not isEnoughPlayersToStart:
        return
    roundInProgress = false
    currentRound += 1
    getAllPlayers().bouncePadCooldown = bouncePadCooldownLengthStart
    ballSpawnCountdown = 5
    wait(1)
    roundInProgress = true
    if not bouncepadDashingEnabled:
        goto lbl_0
    getAllPlayers().isDashEnabled = false
    getAllPlayers().setAbility1Enabled(false)
    lbl_0:
    chase(ballSpawnCountdown, 0, rate=1, ChaseReeval.NONE)
    chase(getAllPlayers().bouncePadCooldown, 0, rate=1, ChaseReeval.NONE)


rule "Player check":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isAlive() == true
    @Condition "{0}".format(eventPlayer) == "daboss"
    
    kill(eventPlayer, null)
    wait(1)
    if RULE_CONDITION:
        goto RULE_START


rule "All players dead failsafe":
    @Condition getNumberOfLivingPlayers(Team.ALL) == 0
    @Condition isGameInProgress() == true
    @Condition tieBreakerActive == false
    
    isInFinalDuel = false
    if ballIsOut == false:
        goto lbl_0
    ballDeleteRequested = true
    lbl_0:
    roundInProgress = false
    stopChasingVariable(ballSpawnCountdown)
    getDeadPlayers(Team.ALL).resurrect()
    smallMessage(getAllPlayers(), "All players detected dead! Resetting game.")
    stopChasingVariable(getAllPlayers().bouncePadCooldown)
    getAllPlayers().bouncePadCooldown = bouncePadCooldownLengthStart
    ballSpawnCountdown = 5
    wait(1)
    if RULE_CONDITION:
        goto RULE_START
    wait(2)
    if not isEnoughPlayersToStart:
        return
    chase(getAllPlayers().bouncePadCooldown, 0, rate=1, ChaseReeval.NONE)
    chase(ballSpawnCountdown, 0, rate=1, ChaseReeval.NONE)
    roundInProgress = true
    ballPosition = vect(0, -1, 0)

rule "Allow one melee":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE)

    wait()
    eventPlayer.canDeflect = true
    eventPlayer.allowButton(Button.PRIMARY_FIRE)
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    wait(0.4)
    eventPlayer.canDeflect = false
    waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), 9999)

rule "dash slow":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isUsingAbility2() == true
    
    if eventPlayer.isOnGround():
        eventPlayer.applyImpulse(Vector.UP, 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        wait()
    eventPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * 20)), 25, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)


rule "Ball bounce off surface":
    @Condition ballIsOut == true
    @Condition isInLoS(ballPosition, ballPosition + ballDirection * (ballSpeed if rulesetMode != 2 else 1) * 0.033, BarrierLos.PASS_THROUGH_BARRIERS) == false
    @Condition getCurrentMap() != Map.WORKSHOP_CHAMBER
    
    #normal of the plane of the surface with which the ball collides, n
    ballCollisionSurfaceNormal = raycast(ballPosition, ballPosition + ballDirection * ballSpeed * 0.066, null, getAllPlayers(), false).getNormal()
    #reflected vector formula --- new v = v - 2 * (v•n)/(n•n) * n
    ballDirection -= 2 * ballDirection * ballCollisionSurfaceNormal / dotProduct(ballCollisionSurfaceNormal, ballCollisionSurfaceNormal) * ballCollisionSurfaceNormal
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, ballPosition, 1)
    wait(0.02)
    if RULE_CONDITION:
        goto RULE_START


rule "Ball no down when y < -0.5":
    @Condition ballIsOut == true
    @Condition ballPosition.y < -0.5
    @Condition ballDirection.y < 0
    
    ballDirection *= vect(1, -1 if rulesetMode == 2 else 0, 1)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.WHITE, ballPosition, 2)


rule "RGB Ball Mode":
    @Condition ballTailColor == 2
    @Condition ballIsOut

    ballTail1 = rgb(random.uniform(0, 255), random.uniform(0, 255), random.uniform(0, 255))
    ballTail2 = rgb(random.uniform(0, 255), random.uniform(0, 255), random.uniform(0, 255))
    wait(0.1)
    if RULE_CONDITION:
        goto RULE_START

rule "Chamber x collision":
    #This collision is the lazy way but its only for chamber so who cares
    @Condition getCurrentMap() == Map.WORKSHOP_CHAMBER
    @Condition ballIsOut == true
    @Condition (ballPosition.x + 0.4 >= 20 or ballPosition.x - 0.4 <= -20) == true
    
    if ballPosition.x + 0.4 >= 20 and ballDirection.x > 0 or ballPosition.x - 0.4 <= -20 and ballDirection.x < 0:
        ballDirection = vect(ballDirection.x * -1, ballDirection.y, ballDirection.z)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, ballPosition, 1)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "Chamber y collision":
    @Condition getCurrentMap() == Map.WORKSHOP_CHAMBER
    @Condition ballIsOut == true
    @Condition (ballPosition.y + 0.4 >= 40) - (ballPosition.y - 0.4 <= 0) == true
    
    if ballPosition.y + 0.4 >= 40 and ballDirection.y > 0 or ballPosition.y - 0.4 <= 0 and ballDirection.y < 0:
        ballDirection = vect(ballDirection.x, ballDirection.y * -1, ballDirection.z)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, ballPosition, 1)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "Chamber z collision":
    @Condition getCurrentMap() == Map.WORKSHOP_CHAMBER
    @Condition ballIsOut == true
    @Condition (ballPosition.z + 0.4 >= 20 or ballPosition.z - 0.4 <= -20) == true
    
    if ballPosition.z + 0.4 >= 20 and ballDirection.z > 0 or ballPosition.z - 0.4 <= -20 and ballDirection.z < 0:
        ballDirection = vect(ballDirection.x, ballDirection.y, ballDirection.z * -1)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, ballPosition, 1)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "Expanse y collision":
    @Condition getCurrentMap() == Map.WORKSHOP_EXPANSE or getCurrentMap() == Map.WORKSHOP_EXPANSE_NIGHT
    @Condition ballIsOut == true
    @Condition ballPosition.y - 0.4 <= 0

    if ballPosition.y - 0.4 <= 0 and ballDirection.y < 0:
        ballDirection = vect(ballDirection.x, ballDirection.y * -1, ballDirection.z)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, ballPosition, 1)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "No Undermaps":
    @Condition getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT
    @Condition ballIsOut == true
    @Condition ballPosition.y < -2.85
    @Condition ballDirection.y < 0
    
    ballDirection *= vect(1, 0, 1)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.WHITE, ballPosition, 2)


rule "Team 1 Win - TEAMS":
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition allowMatchEnd == true
    @Condition teamScore(Team.1) == scoreToWin
    
    enableAnnouncer()
    declareTeamVictory(Team.1)


rule "Team 2 Win - TEAMS":
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition allowMatchEnd == true
    @Condition teamScore(Team.2) == scoreToWin
    
    enableAnnouncer()
    declareTeamVictory(Team.2)

rule "Maximum amount of rounds reached":
    @Condition maxRoundsToggle
    @Condition currentRound > maxRounds
    
    enableGamemodeCompletion()

rule "Toggle 3rd person":
    @Event eachPlayer
    @Condition not breakInProgress
    @Condition eventPlayer.isHoldingButton(Button.RELOAD) == true
    @Condition eventPlayer.isAlive() == true
    @Condition perspectiveMode == 2
    
    if not eventPlayer.thirdPerson:
        eventPlayer.thirdPerson = true
        wait(0.01)
        eventPlayer.startCamera(eventPlayer + worldVector(vect(-0.75, 0.25, -0.25), eventPlayer, Transform.ROTATION) + Vector.UP * 1.5 + eventPlayer.getFacingDirection() * -2, eventPlayer + eventPlayer.getFacingDirection() * 1000, 0)
    else:
        eventPlayer.stopCamera()
        eventPlayer.thirdPerson = false


rule "Player dead 3rd person":
    @Event playerDied
    @Condition eventPlayer.thirdPerson
    
    eventPlayer.stopCamera()


rule "3rd person respawn":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned() == true
    @Condition roundInProgress == false
    @Condition eventPlayer.thirdPerson
    
    eventPlayer.startCamera(eventPlayer + worldVector(vect(-0.75, 0.25, -0.25), eventPlayer, Transform.ROTATION) + Vector.UP * 1.5 + eventPlayer.getFacingDirection() * -2, eventPlayer + eventPlayer.getFacingDirection() * 1000, 0)


rule "Measure Latency":
    @Disabled
    @Event eachPlayer
    @Condition roundInProgress == true
    
    if not eventPlayer.latencyToggle or eventPlayer.isCommunicatingEmote():
        eventPlayer.latency = 0
        return
    eventPlayer.latency = [angleToDirection(eventPlayer.getHorizontalFacingAngle(), eventPlayer.getVerticalFacingAngle() + (eventPlayer.getVerticalFacingAngle() < 0) - 0.5), getTotalTimeElapsed()]
    eventPlayer.startFacing(eventPlayer.latency[0], 100000, Relativity.TO_PLAYER, FacingReeval.NONE)
    waitUntil(eventPlayer.latency[0] == updateEveryTick(eventPlayer.getFacingDirection()), 99999)
    eventPlayer.stopFacing()
    eventPlayer.latency = ((getTotalTimeElapsed() - eventPlayer.latency.last()) * 0.5) * createWorkshopSetting(float[0:1], "Visual Settings", "Client Prediction Amount", 1, 4)


rule "Toggle Latency":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ULTIMATE) == true
    @Condition rulesetMode != 2

    if eventPlayer.latencyToggle:
        eventPlayer.latencyToggle = false
        smallMessage(eventPlayer, "Lag-o-rama disabled, good idea...")
    else:
        eventPlayer.latencyToggle = true
        smallMessage(eventPlayer, "Lag-o-rama activated! You will regret this!")
    wait(0.5)

rule "Lag-O-Rama":
    @Event eachPlayer
    @Condition eventPlayer.latencyToggle

    wait(random.uniform(0.58, 5))
    if random.randint(1, 100) <= 50:
        if random.randint(1, 100) <= 75:
            eventPlayer.teleport(vect(eventPlayer.getPosition().x + random.uniform(-25, 25), eventPlayer.getPosition().y + random.uniform(0, 0.5), eventPlayer.getPosition().z+ random.uniform(-25, 25)))
        else:
            eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, random.uniform(0.25, 0.5))
            wait(random.uniform(0.01, 2.5))
            eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, random.uniform(0.25, 0.5))
            wait(random.uniform(0.01, 2.5))
            eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, random.uniform(0.25, 0.5))
    wait(random.uniform(0, 2.5))
    if random.randint(1, 100) <= 50:
            eventPlayer.setFacing(vect(random.uniform(-1, 1), random.uniform(-1, 1), random.uniform(-1, 1)), Relativity.TO_PLAYER)
    wait(random.uniform(0, 0.5))
    # Make them spam their deflect!
    # if random.randint(1, 100) <= 50:
    #     eventPlayer.forceButtonPress()
    # wait(random.uniform(5, 15))
    if RULE_CONDITION:
        goto RULE_START


rule "Tell player controls":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.ABILITY_1)

    smallMessage(eventPlayer, "Here's a tip:")
    wait(1)
    smallMessage(eventPlayer, "Primary fire aka swing hammer = deflect")
    wait(2)
    smallMessage(eventPlayer, "Ability 2 aka overload = dash")
    wait(3)


rule "Randomly teleport ball":

    waitUntil(ballIsOut, 9999)
    wait(random.uniform(2, 5))
    if random.randint(1, 100) <= 50:
        if not ballIsOut:
            goto RULE_START
        playEffect(getAllPlayers(), DynamicEffect.SOMBRA_LOGO_SOUND, Color.WHITE, ballPosition, 500)
        smallMessage(getAllPlayers(), "Too much skill detected: Randomizing ball location")
        ballPosition = vect(random.uniform(-35, 35), random.uniform(1, 15), random.uniform(-35, 35))
    wait(random.uniform(5, 30))
    goto RULE_START

    

def ReinTime():
    createDummy(Hero.REINHARDT, Team.ALL, 15, vect(0, 0, 0), vect(0, 0, 0))
    gimmickPlayer = getPlayersOnHero(Hero.REINHARDT, Team.ALL)[0]
    gimmickPlayer.startModifyingVoicelinePitch(0.5, false)
    gimmickPlayer.startScalingSize(1.1, false)
    wait(0.25)
    bigMessage(getAllPlayers(), "Oh, hi Reinhart!")
    wait(0.5)
    gimmickPlayer.communicate(Comms.HELLO)
    gimmickPlayer.startFacing(directionTowards(gimmickPlayer.getPosition(), targetedPlayer.getPosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    waitUntil(ballIsOut, 9999)
    while roundInProgress:
        # gimmickPlayer.setUltCharge(100)
        # gimmickPlayer.forceButtonPress(Button.ULTIMATE)
        if gimmickPlayer.isDead() and len(getPlayersOnHero(playerHero, Team.ALL)) > 2:
            wait(0.25)
            gimmickPlayer.resurrect()
        gimmickPlayer.forceButtonPress(Button.ABILITY_1)
        gimmickPlayer.startThrottleInDirection(directionTowards(gimmickPlayer.getPosition(), targetedPlayer.getPosition()), 1, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)
        waitUntil(not gimmickPlayer.isUsingAbility1() or not roundInProgress, 9999)
        gimmickPlayer.stopThrottleInDirection()
        wait(0.25)
        # while gimmickPlayer.isUsingAbility1():
        #     gimmickPlayer.setFacing(directionTowards(gimmickPlayer.getPosition(), targetedPlayer.getPosition()), Relativity.TO_WORLD)
        #     wait()
    if gimmickPlayer.isUsingAbility1():
        gimmickPlayer.forceButtonPress(Button.ABILITY_1)
        wait(0.25)
    wait(0.25)
    gimmickPlayer.communicate(Comms.GOODBYE)
    wait(1)
    destroyDummy(Team.ALL, gimmickPlayer.getSlot())

def BedTime():
    createDummy(Hero.ANA, Team.ALL, 15, vect(0, 0, 0), vect(0, 0, 0))
    createDummy(Hero.ANA, Team.ALL, 16, vect(0, 0, 0), vect(0, 0, 0))
    createDummy(Hero.ANA, Team.ALL, 17, vect(0, 0, 0), vect(0, 0, 0))
    createDummy(Hero.ANA, Team.ALL, 18, vect(0, 0, 0), vect(0, 0, 0))
    gimmickPlayer = getPlayersOnHero(Hero.ANA, Team.ALL)
    wait(0.25)
    bouncePadDistance[0] = random.choice([player for player in getPlayersOnHero(playerHero, Team.ALL) if player.isAlive()])
    bouncePadDistance[1] = random.choice([player for player in getPlayersOnHero(playerHero, Team.ALL) if player.isAlive()])
    bouncePadDistance[2] = random.choice([player for player in getPlayersOnHero(playerHero, Team.ALL) if player.isAlive()])
    bouncePadDistance[3] = random.choice([player for player in getPlayersOnHero(playerHero, Team.ALL) if player.isAlive()])
    gimmickPlayer[0].startFacing(directionTowards(gimmickPlayer[0].getPosition(), bouncePadDistance[0].getPosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    gimmickPlayer[1].startFacing(directionTowards(gimmickPlayer[1].getPosition(), bouncePadDistance[1].getPosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    gimmickPlayer[2].startFacing(directionTowards(gimmickPlayer[2].getPosition(), bouncePadDistance[2].getPosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    gimmickPlayer[3].startFacing(directionTowards(gimmickPlayer[3].getPosition(), bouncePadDistance[3].getPosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    wait(0.5)
    gimmickPlayer.communicate(Comms.HELLO)
    bigMessage(getAllPlayers(), "Grandma says it's bedtime :(")
    waitUntil(ballIsOut, 9999)
    while roundInProgress:
        gimmickPlayer.clearStatusEffect(Status.ASLEEP)
        bouncePadDistance[0] = random.choice([player for player in getPlayersOnHero(playerHero, Team.ALL) if player.isAlive() and not player.hasStatusEffect(Status.ASLEEP)])
        bouncePadDistance[1] = random.choice([player for player in getPlayersOnHero(playerHero, Team.ALL) if player.isAlive() and not player.hasStatusEffect(Status.ASLEEP)])
        bouncePadDistance[2] = random.choice([player for player in getPlayersOnHero(playerHero, Team.ALL) if player.isAlive() and not player.hasStatusEffect(Status.ASLEEP)])
        bouncePadDistance[3] = random.choice([player for player in getPlayersOnHero(playerHero, Team.ALL) if player.isAlive() and not player.hasStatusEffect(Status.ASLEEP)])
        gimmickPlayer[0].startFacing(directionTowards(gimmickPlayer[0].getPosition(), bouncePadDistance[0].getPosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
        gimmickPlayer[1].startFacing(directionTowards(gimmickPlayer[1].getPosition(), bouncePadDistance[1].getPosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
        gimmickPlayer[2].startFacing(directionTowards(gimmickPlayer[2].getPosition(), bouncePadDistance[2].getPosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
        gimmickPlayer[3].startFacing(directionTowards(gimmickPlayer[3].getPosition(), bouncePadDistance[3].getPosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
        wait(random.uniform(0, 0.25))
        gimmickPlayer[0].forceButtonPress(Button.ABILITY_1)
        gimmickPlayer[0].communicate(Comms.SORRY)
        wait(random.uniform(0, 0.25))
        gimmickPlayer[1].forceButtonPress(Button.ABILITY_1)
        gimmickPlayer[1].communicate(Comms.GOODBYE)
        wait(random.uniform(0, 0.25))
        gimmickPlayer[2].forceButtonPress(Button.ABILITY_1)
        gimmickPlayer[2].communicate(Comms.THANKS)
        wait(random.uniform(0, 0.25))
        gimmickPlayer[3].forceButtonPress(Button.ABILITY_1)
        gimmickPlayer[3].communicate(Comms.HELLO)
        waitUntil(not gimmickPlayer.isUsingAbility1(), 9999)
        wait(random.uniform(1, 2))
    wait(0.25)
    gimmickPlayer.resurrect()
    wait(0.25)
    gimmickPlayer.communicate(Comms.GOODBYE)
    wait(1)
    destroyDummy(Team.ALL, gimmickPlayer[0].getSlot())
    destroyDummy(Team.ALL, gimmickPlayer[1].getSlot())
    destroyDummy(Team.ALL, gimmickPlayer[2].getSlot())
    destroyDummy(Team.ALL, gimmickPlayer[3].getSlot())


def CovidTime():
    bigMessage(getAllPlayers(), "Achoo! Think I have a cold guys...")
    wait(0.25)
    smallMessage(getAllPlayers(), "Oh no! That thing that happened two years ago has finally made it to Overwatch!")


rule "Social Distancing":
    @Event eachPlayer
    @Condition distance(eventPlayer.getPosition(), sorted([player for player in getPlayersOnHero(playerHero, Team.ALL) if player != eventPlayer and player.isAlive() and player.getCurrentHero() == playerHero], lambda player: distance(eventPlayer, player))[0]) < 10
    
    eventPlayer.maxBallSpeed = sorted([player for player in getPlayersOnHero(playerHero, Team.ALL) if player != eventPlayer and player.isAlive() and player.getCurrentHero() == playerHero], lambda player: distance(eventPlayer, player))[0]
    eventPlayer.maxBallSpeed.applyImpulse(Vector.UP, 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.maxBallSpeed.applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.maxBallSpeed.getPosition()), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(0.05)
    if RULE_CONDITION:
        goto RULE_START

rule "Rein go too far":
    @Event global
    @Condition gimmickPlayer.antiFloatProtection
    @Condition distance(gimmickPlayer.getPosition(), sorted([player for player in getPlayersOnHero(playerHero, Team.ALL)], lambda player: distance(gimmickPlayer, player))[0]) > 15

    gimmickPlayer.teleport(vect(0, 2, 0))
    

rule "Dummi":
    @Event global

    createDummy(playerHero, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(playerHero, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(playerHero, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(playerHero, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(playerHero, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(playerHero, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(playerHero, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(playerHero, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    