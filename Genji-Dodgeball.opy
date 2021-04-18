settings {
    "main": {
        "description": "Genji Dodgeball v7.0.0. Developed by u/Mazawath. Numerous updates by u/FearlessKat, u/Blink, u/TheRedstoneBlaze,  ELIMINATED#1572, and tumtum9000#1232. Deflect the ball when it is red to target someone else! Use jump pads to get air!"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "spectatorSlots": 6,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "workshopIslandNight"
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
            "enabledHeroes": [
                "genji"
            ]
        }
    }
}

#Global variables

globalvar SlotOfTargetedPlayer 0
globalvar SlotOfPreviousTargetedPlayer 1
globalvar BallSpeed 2
globalvar BallPosition 3
globalvar BallSpawnCountdown 4
globalvar BallIsOut 5
globalvar BallDeleteRequested 6
globalvar RoundInProgress 7
globalvar BouncePadCooldownLength 8
globalvar BallSpawnSpeed 9
globalvar MaxBallSpeed 10
globalvar IsInFinalDuel 11
globalvar BallSpawnCountdownHUD 12
globalvar BouncePadDistance 13
globalvar BouncePadStrength 14
globalvar BouncePad1 15
globalvar BouncePad2 16
globalvar BouncePad3 17
globalvar BouncePad4 18
globalvar deathSphere 19
globalvar deathSphereRad 20
globalvar IsEnoughPlayersToStart 21
globalvar WaitingForPlayersHUD 22
globalvar CenterOffLimitsSize 23
globalvar SphereSize 24
globalvar CircleCenter 25
globalvar RedGreenColorblindMode 26
globalvar WatermarkEnabled 27
globalvar BouncepadDashingEnabled 28
globalvar GameEndEnabled 29
globalvar CooldownDashingEnabled 30
globalvar deathSpherePos 31
globalvar deathBeam 32
globalvar BallDirection 33
globalvar BallCollisionSurfaceNormal 34
globalvar PrevBallPos 35
globalvar PrevBallPos2 36
globalvar BallSmoke 37
globalvar BallTail1 38
globalvar BallTail2 39
globalvar BallColor 40
globalvar HighestScore 41
globalvar TieBreakerActive 42
globalvar RandomExplosionPicker 43
globalvar ExplosionSoundVolume 44
globalvar ImprovedExplosions 45
globalvar RandomExplosionSounds 46
globalvar FinalDuelNuke 47
globalvar IncorrectTeam2ConfigCheck 48
globalvar IncorrectTeam1ConfigCheck 49
globalvar IncorrectTeam2ConfigHUDColor 50
globalvar AllowMatchEnd 51
globalvar PassingDamage 52
globalvar IsPassingTeam1 53
globalvar IsPassingTeam2 54
globalvar ScoreToWin 55
globalvar PassingEnabled 56
globalvar BouncePadSuperjumpNerf 57


#Player variables

playervar hasMoved 0
playervar CurrentUltPercent 1
playervar BouncePadCooldown 2
playervar PlayerDeflects 4
playervar PlayerKills 5
playervar PlayerDeaths 6
playervar PlayerEffects 7
playervar PlayerUI 8
playervar IsDashEnabled 9
playervar moveSpeed 10
playervar maxBallSpeed 11
playervar antiFloatProtection 12
playervar antiFloatTimer 13
playervar antiStuckProtection 14
playervar ToggleHUD 15
playervar DashNerf 16


#Subroutine names

subroutine CoolDeathEffects 0
subroutine UpdatedDeathEffects 1
subroutine DeflectFailed 2


#Activated extensions

#!extension buffAndDebuffSounds
#!extension kineticExplosionEffects
#!extension explosionSounds


rule "// SETTINGS":
    PassingEnabled = createWorkshopSetting(bool, "Dodgeball Settings", "Passing Enabled", false, 0)
    AllowMatchEnd = createWorkshopSetting(bool, "Teams Settings", "Allow Match to End At Score", true, 0)
    ScoreToWin = createWorkshopSetting(int[1:30], "Teams Settings", "Score to Win", 10, 1)
    #Currently, there is an issue where the server will end, based on how many players there are. If there are less it will take longer to crash. But it WILL crash. This rule simply lets there be a "winner" at the end VS crashing in the middle of Final Duel.
    GameEndEnabled = createWorkshopSetting(bool, "Teams Settings", "Allow Match to End At Time", false, 2)
    WatermarkEnabled = createWorkshopSetting(bool, "Visual Settings", "Enable Watermark", true, 0)
    CooldownDashingEnabled = true
    RedGreenColorblindMode = createWorkshopSetting(bool, "Visual Settings", "Red/Green Colorblind Mode", false, 2)
    FinalDuelNuke = createWorkshopSetting(bool, "Visual Settings", "Final Duel Explosion", true, 3)


rule "// MAP ZONES":
    SlotOfTargetedPlayer = 0


rule "Set Workshop Island":
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    CircleCenter = vect(0, 1.199, 0)
    SphereSize = 60


rule "Set Workshop Chamber":
    @Condition getCurrentMap() == Map.WORKSHOP_CHAMBER
    
    CircleCenter = vect(0, 1.199, 0)
    SphereSize = 29.7


rule "Set Workshop Expanse Center":
    @Condition getCurrentMap() == Map.WORKSHOP_EXPANSE
    
    CircleCenter = vect(0, 1.199, 0)
    SphereSize = 20


rule "Set Oasis University Center":
    @Condition getCurrentMap() == Map.OASIS_UNIVERSITY
    
    CircleCenter = vect(-192.609, 60.349, 2.252)
    SphereSize = 20


rule "Set Kings Row center (NOTE: Lower the max players! This arena is smaller then the others!)":
    @Condition getCurrentMap() == Map.KINGS_ROW
    
    CircleCenter = vect(-20.504, 40.538, -74.601)
    SphereSize = 17


rule "Set Blizz World center (fun fact: you can't use the name of the company who made this game in rule names)":
    @Condition getCurrentMap() == Map.BLIZZ_WORLD
    
    CircleCenter = vect(2.554, -4.651, -71.211)
    SphereSize = 20


rule "// INITIALIZATION":


rule "Init player variables":
    @Event eachPlayer
    @Hero all
    
    eventPlayer.IsDashEnabled = false
    eventPlayer.setStatusEffect(null, Status.INVINCIBLE, 9999)
    if CooldownDashingEnabled:
        goto lbl_0
    eventPlayer.setAbility1Enabled(false)
    lbl_0:
    eventPlayer.disableRespawn()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.BouncePadCooldown = BouncePadCooldownLength
    eventPlayer.antiFloatProtection = false
    eventPlayer.antiStuckProtection = false
    eventPlayer.ToggleHUD = true
    eventPlayer.DashNerf = false
    waitUntil(eventPlayer.isAlive() and isGameInProgress(), 90)
    wait(3)
    smallMessage(eventPlayer, "Press interact to enable/disable the scoreboard")


rule "Init global variables":
    SlotOfTargetedPlayer = -1
    SlotOfPreviousTargetedPlayer = -1
    BallSpawnCountdown = 3
    disableScoring()
    disableGamemodeCompletion()
    disableMusic()
    disableAnnouncer()
    BouncePadStrength = 30
    BouncePadDistance = 12
    BallSpeed = 30
    BallSpawnSpeed = 30
    MaxBallSpeed = 1000
    CenterOffLimitsSize = 3.5
    IsInFinalDuel = false
    BouncePadCooldownLength = 3
    BouncePadSuperjumpNerf = 6
    BallPosition = vect(0, -1, 0)
    ExplosionSoundVolume = 30
    ImprovedExplosions = true
    RandomExplosionSounds = true
    CooldownDashingEnabled = true
    IncorrectTeam2ConfigCheck = false
    IncorrectTeam2ConfigHUDColor = Color.RED
    PassingDamage = 100
    IsPassingTeam1 = false
    IsPassingTeam2 = false
    if getCurrentGamemode() == Gamemode.FFA:
        GameEndEnabled = true


rule "Create game sphere":
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLACK, vect(CircleCenter.x, CircleCenter.y - 0, CircleCenter.z), CenterOffLimitsSize, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Workshop Island doesn't need a circle.
    if getCurrentMap() != Map.WORKSHOP_ISLAND and getCurrentMap() != Map.WORKSHOP_ISLAND_NIGHT:
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.ORANGE, vect(CircleCenter.x, CircleCenter.y - 15, CircleCenter.z), SphereSize, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    else:
        createEffect([player for player in getAllPlayers() if distance(player.getPosition(), CircleCenter) >= SphereSize - 10], Effect.LIGHT_SHAFT, Color.BLUE, vect(CircleCenter.x, CircleCenter.y - 15, CircleCenter.z), SphereSize, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Create global HUD elements":
    #white normal
    hudSubtext([player for player in getAllPlayers() if player != getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL)], "Current Player Targeted: {0}".format(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL)), HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #red when you're targeted
    hudSubtext(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), "Current Player Targeted: {0}".format(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL)), HudPosition.LEFT, -2, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudText(getDeadPlayers(Team.ALL), "Waiting for next round", "You have been eliminated or joined during a round", "You will spawn once the next round starts", HudPosition.TOP, 2, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    if BouncepadDashingEnabled or CooldownDashingEnabled:
        goto lbl_0
    #hudSubtext(getAllPlayers(), "Current Dashing Mode: None", HudPosition.LEFT, -1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #return
    lbl_0:
    #if CooldownDashingEnabled:
    #        goto lbl_1
    #hudSubtext(getAllPlayers(), "Current Dashing Mode: Bouncepad", HudPosition.LEFT, -1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #return
    lbl_1:
    #hudSubtext(getAllPlayers(), "Current Dashing Mode: Cooldown", HudPosition.LEFT, -1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #server load text for lobby owner only
    #hudText(hostPlayer, null, "Server Load", getServerLoad(), HudPosition.RIGHT, 0, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudText(hostPlayer, null, "Server Load Average", getAverageServerLoad(), HudPosition.RIGHT, 0, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudText(hostPlayer, null, "Server Load Peak", getPeakServerLoad(), HudPosition.RIGHT, 0, Color.WHITE, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #gameplay tips text
    #hudSubtext(getAllPlayers(), "Deflect or Dash will deflect the ball to an enemy", HudPosition.RIGHT, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudSubtext(getAllPlayers(), "If you get hit, you die.  Last man standing wins!", HudPosition.RIGHT, -9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #ball speed text color change with speed
    hudSubtext([player for player in getAllPlayers() if BallSpeed < 20], "Current Ball Speed: {0}".format(BallSpeed), HudPosition.LEFT, -3, Color.BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if BallSpeed >= 20 and BallSpeed < 25], "Current Ball Speed: {0}".format(BallSpeed), HudPosition.LEFT, -3, Color.GREEN, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if BallSpeed >= 25 and BallSpeed < 30], "Current Ball Speed: {0}".format(BallSpeed), HudPosition.LEFT, -3, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if BallSpeed >= 30 and BallSpeed < 35], "Current Ball Speed: {0}".format(BallSpeed), HudPosition.LEFT, -3, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if BallSpeed >= 35 and BallSpeed < 55], "Current Ball Speed: {0}".format(BallSpeed), HudPosition.LEFT, -3, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext([player for player in getAllPlayers() if BallSpeed > 55], "Current Ball Speed: {0}".format(BallSpeed), HudPosition.LEFT, -3, Color.PURPLE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #hudSubheader(getAllPlayers(), "Updates by u/FearlessKat, u/Blink, u/TheRedstoneBlaze, tumtum9000#1232,david8686406#1523", HudPosition.LEFT, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubtext(getAllPlayers(), "Discord.gg/GenjiDodgeball", HudPosition.LEFT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    if PassingEnabled:
        if getCurrentGamemode() == Gamemode.TDM:
            hudSubtext(getAllPlayers(), "Hold secondary fire while deflecting to pass the ball to another teammate!", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        elif getCurrentGamemode() == Gamemode.FFA:
            hudSubtext(getAllPlayers(), "Hold secondary fire while deflecting to self pass the ball!", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Create player HUD elements":
    @Event eachPlayer
    @Hero all
    
    #hudText(eventPlayer, eventPlayer.PlayerDeflects, "Deflects", null, HudPosition.LEFT, 1, Color.YELLOW, Color.WHITE, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #eventPlayer.PlayerUI[1] = getLastCreatedEntity()
    #hudText(eventPlayer, eventPlayer.PlayerKills, "Kills", null, HudPosition.LEFT, 2, Color.ORANGE, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #eventPlayer.PlayerUI[2] = getLastCreatedEntity()
    #hudText(eventPlayer, eventPlayer.PlayerDeaths, "Deaths", null, HudPosition.LEFT, 3, Color.SKY_BLUE, Color.WHITE, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #eventPlayer.PlayerUI[3] = getLastCreatedEntity()
    #hudText(eventPlayer, eventPlayer.maxBallSpeed, "Max Deflect Speed", null, HudPosition.LEFT, 4, Color.RED, Color.WHITE, Color.TURQUOISE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #eventPlayer.PlayerUI[4] = getLastCreatedEntity()
    #hudText(eventPlayer, ceil(eventPlayer.BouncePadCooldown), "Bouncepad", "Cooldown", HudPosition.RIGHT, -1, Color.GREEN, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #eventPlayer.PlayerUI[5] = getLastCreatedEntity()


rule "Create bounce pads":
    BouncePad1 = vect(CircleCenter.x + BouncePadDistance, CircleCenter.y, CircleCenter.z)
    BouncePad2 = vect(CircleCenter.x + BouncePadDistance * -1, CircleCenter.y, CircleCenter.z)
    BouncePad3 = vect(CircleCenter.x, CircleCenter.y, CircleCenter.z + BouncePadDistance * 1)
    BouncePad4 = vect(CircleCenter.x, CircleCenter.y, CircleCenter.z + BouncePadDistance * -1)
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown == 0], Effect.RING, Color.SKY_BLUE, BouncePad1, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown == 0], Effect.RING, Color.SKY_BLUE, BouncePad2, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown == 0], Effect.RING, Color.SKY_BLUE, BouncePad3, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown == 0], Effect.RING, Color.SKY_BLUE, BouncePad4, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    if RedGreenColorblindMode:
        goto lbl_0
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown > 0], Effect.RING, Color.WHITE, BouncePad1, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown > 0], Effect.RING, Color.WHITE, BouncePad2, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown > 0], Effect.RING, Color.WHITE, BouncePad3, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown > 0], Effect.RING, Color.WHITE, BouncePad4, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    return
    lbl_0:
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown > 0], Effect.RING, Color.YELLOW, BouncePad1, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown > 0], Effect.RING, Color.YELLOW, BouncePad2, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown > 0], Effect.RING, Color.YELLOW, BouncePad3, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if player.BouncePadCooldown > 0], Effect.RING, Color.YELLOW, BouncePad4, 2, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Create ball & targeted effect":
    @Condition isGameInProgress() == true
    @Condition getCurrentGamemode() == Gamemode.FFA
    
    #Orb for when ball is not getting passed
    createEffect([player for player in getAllPlayers() if player.getSlot() != SlotOfTargetedPlayer], Effect.ORB, Color.WHITE, BallPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Orb for when ball is getting passed
    createEffect([i for i in getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL) if IsPassingTeam1], Effect.ORB, Color.SKY_BLUE, BallPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    if not RedGreenColorblindMode:
        createEffect([i for i in getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL) if not IsPassingTeam1], Effect.ORB, Color.RED, BallPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect([player for player in getAllPlayers() if player.getSlot() != SlotOfTargetedPlayer], Effect.GOOD_AURA, Color.RED, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), Effect.GOOD_AURA, Color.RED, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), Effect.GOOD_AURA, Color.RED, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    else:
        createEffect(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), Effect.ORB, Color.YELLOW, BallPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.YELLOW, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), Effect.GOOD_AURA, Color.YELLOW, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getEyePosition(), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #ball trail change color with speed
    #createEffect(getAllPlayers(), Effect.BAD_AURA, Color.BLUE, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallSmoke = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, BallPosition, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail1 = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, PrevBallPos2, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail2 = getLastCreatedEntity()
    createEffect([i for i in [player for player in getAllPlayers() if player.getSlot() != SlotOfTargetedPlayer] if IsPassingTeam1 or IsPassingTeam2], Effect.GOOD_AURA, Color.SKY_BLUE, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if player.getSlot() != SlotOfTargetedPlayer and (IsPassingTeam1 or IsPassingTeam2)], Effect.GOOD_AURA, Color.SKY_BLUE, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Create ball & targeted effect - TEAMS":
    @Condition isGameInProgress() == true
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    #Team 1 standard ball
    createEffect([player for player in getPlayers(Color.TEAM_1) if player.getSlot() != SlotOfTargetedPlayer and not IsPassingTeam1], Effect.ORB, Color.WHITE, BallPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Team 1 passing ball
    createEffect([player for player in getPlayers(Color.TEAM_1) if IsPassingTeam1], Effect.ORB, Color.SKY_BLUE, BallPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Team 2 standard ball
    createEffect([player for player in getPlayers(Color.TEAM_2) if player.getSlot() != SlotOfTargetedPlayer and not IsPassingTeam2], Effect.ORB, Color.WHITE, BallPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #Team 2 passing ball
    createEffect([player for player in getPlayers(Color.TEAM_2) if IsPassingTeam2], Effect.ORB, Color.SKY_BLUE, BallPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    if not RedGreenColorblindMode:
        #Team 1 Targeted Ball
        createEffect([i for i in getPlayersInSlot(SlotOfTargetedPlayer, Color.TEAM_1) if not IsPassingTeam1], Effect.ORB, Color.RED, BallPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        #Team 2 Targeted Ball
        createEffect([i for i in getPlayersInSlot(SlotOfTargetedPlayer, Color.TEAM_2) if not IsPassingTeam2], Effect.ORB, Color.RED, BallPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect([player for player in getAllPlayers() if player.getSlot() != SlotOfTargetedPlayer], Effect.GOOD_AURA, Color.RED, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), Effect.GOOD_AURA, Color.RED, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), Effect.GOOD_AURA, Color.RED, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    else:
        createEffect(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), Effect.ORB, Color.YELLOW, BallPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getAllPlayers(), Effect.GOOD_AURA, Color.YELLOW, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), Effect.GOOD_AURA, Color.YELLOW, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getEyePosition(), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #ball trail change color with speed
    #createEffect(getAllPlayers(), Effect.BAD_AURA, Color.BLUE, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallSmoke = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, BallPosition, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail1 = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, PrevBallPos2, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail2 = getLastCreatedEntity()
    createEffect([i for i in [player for player in getAllPlayers() if player.getSlot() != SlotOfTargetedPlayer] if IsPassingTeam1 or IsPassingTeam2], Effect.GOOD_AURA, Color.SKY_BLUE, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    createEffect([player for player in getAllPlayers() if player.getSlot() != SlotOfTargetedPlayer and (IsPassingTeam1 or IsPassingTeam2)], Effect.GOOD_AURA, Color.SKY_BLUE, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)


rule "Create ball countdown HUD":
    @Condition BallSpawnCountdown > 0
    
    createInWorldText(getAllPlayers(), "Ball Spawning In: {0}".format(ceil(BallSpawnCountdown)), vect(CircleCenter.x, CircleCenter.y + 2.5, CircleCenter.z), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    BallSpawnCountdownHUD = getLastCreatedText()


rule "Delete ball countdown HUD":
    @Condition BallSpawnCountdown == 0
    
    destroyInWorldText(BallSpawnCountdownHUD)


rule "Enable Scoreboard":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.ToggleHUD == true
    
    eventPlayer.disableGamemodeHud()
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 10)
    eventPlayer.ToggleHUD = false


rule "Disable Scoreboard":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.ToggleHUD == false
    
    eventPlayer.enableGamemodeHud()
    waitUntil(not eventPlayer.isHoldingButton(Button.INTERACT), 10)
    eventPlayer.ToggleHUD = true


rule "// Not enough players testing":
    if not WatermarkEnabled:
        goto lbl_0
    hudSubheader(getAllPlayers(), "Original by u/Mazawrath. Version v7.0.0", HudPosition.LEFT, -1000, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.ALWAYS)
    lbl_0:


rule "Check for <2 players":
    @Condition isGameInProgress() == true
    @Condition getNumberOfPlayers(Team.ALL) == 1
    @Condition getCurrentGamemode() == Gamemode.FFA
    
    IsInFinalDuel = false
    hudHeader(getAllPlayers(), "Waiting for more players", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    WaitingForPlayersHUD = getLastCreatedText()
    IsEnoughPlayersToStart = false
    stopChasingVariable(BallSpawnCountdown)
    if RoundInProgress == false:
        goto lbl_0
    BallDeleteRequested = true
    lbl_0:
    RoundInProgress = false
    pauseMatchTime()


rule "Check for <2 players - TEAMS":
    @Condition isGameInProgress() == true
    #@Condition getNumberOfPlayers(Team.ALL) == 1
    @Condition (getNumberOfPlayers(Color.TEAM_1) and getNumberOfPlayers(Color.TEAM_2)) == false
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    IsInFinalDuel = false
    hudHeader(getAllPlayers(), "Waiting for more players", HudPosition.TOP, 0, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    WaitingForPlayersHUD = getLastCreatedText()
    IsEnoughPlayersToStart = false
    stopChasingVariable(BallSpawnCountdown)
    if RoundInProgress == false:
        goto lbl_0
    BallDeleteRequested = true
    lbl_0:
    RoundInProgress = false
    pauseMatchTime()


rule "Wait for more players":
    @Condition getNumberOfPlayers(Team.ALL) > 1
    @Condition IsEnoughPlayersToStart == false
    @Condition getCurrentGamemode() == Gamemode.FFA
    
    destroyHudText(WaitingForPlayersHUD)
    bigMessage(getAllPlayers(), "Starting game in 5 seconds!")
    wait(5.5)
    if getNumberOfPlayers(Team.ALL) < 2:
        return
    unpauseMatchTime()
    IsEnoughPlayersToStart = true
    SlotOfTargetedPlayer = -1
    SlotOfPreviousTargetedPlayer = -1


rule "Wait for more players - TEAMS":
    @Condition (getNumberOfPlayers(Color.TEAM_1) and getNumberOfPlayers(Color.TEAM_2)) == true
    @Condition IsEnoughPlayersToStart == false
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    destroyHudText(WaitingForPlayersHUD)
    bigMessage(getAllPlayers(), "Starting game in 5 seconds!")
    wait(5.5)
    if getNumberOfPlayers(Team.ALL) < 2:
        return
    unpauseMatchTime()
    IsEnoughPlayersToStart = true
    SlotOfTargetedPlayer = -1
    SlotOfPreviousTargetedPlayer = -1


rule "Check for players in unauthorized slots - Team 1":
    @Condition isGameInProgress() == true
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    #DO NOT DISABLE THIS. Don't say I didn't warn you.
    if getPlayersInSlot(3, Color.TEAM_1) == true or getPlayersInSlot(4, Color.TEAM_1) == true or getPlayersInSlot(5, Color.TEAM_1) == true:
        IncorrectTeam1ConfigCheck = true
    else:
        IncorrectTeam1ConfigCheck = false
    wait(1)
    goto RULE_START


rule "Players in unauthorized slots - Team 1":
    @Condition IncorrectTeam1ConfigCheck == true
    @Condition RoundInProgress == false
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    if getPlayersInSlot(3, Color.TEAM_1) == true:
        smallMessage(getAllPlayers(), "{0} is not allowed in this slot! The game will not function properly with a player in slot 4 on team 1!".format(getPlayersInSlot(3, Color.TEAM_1)))
        wait(1)
    if getPlayersInSlot(4, Color.TEAM_1) == true:
        smallMessage(getAllPlayers(), "{0} is not allowed in this slot! The game will not function properly with a player in slot 5 on team 1!".format(getPlayersInSlot(4, Color.TEAM_1)))
        wait(1)
    if getPlayersInSlot(5, Color.TEAM_1) == true:
        smallMessage(getAllPlayers(), "{0} is not allowed in this slot! The game will not function properly with a player in slot 6 on team 1!".format(getPlayersInSlot(5, Color.TEAM_1)))
        wait(1)
    wait(5)
    if RULE_CONDITION:
        goto RULE_START


rule "Create unauthorized slots HUD - Team 1":
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    hudHeader([player for player in getAllPlayers() if IncorrectTeam1ConfigCheck and not RoundInProgress], "Players are detected in slot(s) 4-6 on team 1! Game will not function in this state!", HudPosition.TOP, 0, IncorrectTeam2ConfigHUDColor, HudReeval.VISIBILITY_AND_COLOR, SpecVisibility.DEFAULT)
    createInWorldText([player for player in getAllPlayers() if IncorrectTeam1ConfigCheck and not RoundInProgress], "The players in slot(s) 4-6 on team 1 must be moved to slots 4-6 or removed from the team!", vect(CircleCenter.x, CircleCenter.y + 1, CircleCenter.z), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_COLOR, IncorrectTeam2ConfigHUDColor, SpecVisibility.DEFAULT)


rule "Check for players in unauthorized slots - Team 2":
    @Condition isGameInProgress() == true
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    #DO NOT DISABLE THIS. Don't say I didn't warn you.
    if getPlayersInSlot(0, Color.TEAM_2) == true or getPlayersInSlot(1, Color.TEAM_2) == true or getPlayersInSlot(2, Color.TEAM_2) == true:
        IncorrectTeam2ConfigCheck = true
    else:
        IncorrectTeam2ConfigCheck = false
    wait(1)
    goto RULE_START


rule "Players in unauthorized slots - Team 2":
    @Condition IncorrectTeam2ConfigCheck == true
    @Condition RoundInProgress == false
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    if getPlayersInSlot(0, Color.TEAM_2) == true:
        smallMessage(getAllPlayers(), "{0} is not allowed in this slot! The game will not function properly with a player in slot 1 on team 2!".format(getPlayersInSlot(0, Color.TEAM_2)))
        wait(1)
    if getPlayersInSlot(1, Color.TEAM_2) == true:
        smallMessage(getAllPlayers(), "{0} is not allowed in this slot! The game will not function properly with a player in slot 2 on team 2!".format(getPlayersInSlot(1, Color.TEAM_2)))
        wait(1)
    if getPlayersInSlot(2, Color.TEAM_2) == true:
        smallMessage(getAllPlayers(), "{0} is not allowed in this slot! The game will not function properly with a player in slot 3 on team 2!".format(getPlayersInSlot(2, Color.TEAM_2)))
        wait(1)
    wait(5)
    if RULE_CONDITION:
        goto RULE_START


rule "Create unauthorized slots HUD - Team 2":
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    hudHeader([player for player in getAllPlayers() if IncorrectTeam2ConfigCheck and not RoundInProgress], "Players are detected in slot(s) 1-3 on team 2! Game will not function in this state!", HudPosition.TOP, 0, IncorrectTeam2ConfigHUDColor, HudReeval.VISIBILITY_AND_COLOR, SpecVisibility.DEFAULT)
    createInWorldText([player for player in getAllPlayers() if IncorrectTeam2ConfigCheck and not RoundInProgress], "The players in slot(s) 1-3 on team 2 must be moved to slots 4-6 or removed from the team!", vect(CircleCenter.x, CircleCenter.y + 0, CircleCenter.z), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_COLOR, IncorrectTeam2ConfigHUDColor, SpecVisibility.DEFAULT)


rule "Pulse HUD color":
    @Condition (IncorrectTeam1ConfigCheck or IncorrectTeam2ConfigCheck) == true
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    if IncorrectTeam2ConfigHUDColor == Color.WHITE:
        IncorrectTeam2ConfigHUDColor = Color.RED
    else:
        IncorrectTeam2ConfigHUDColor = Color.WHITE
    wait(1.5)
    if RULE_CONDITION:
        goto RULE_START


rule "// GAME RULES":


rule "Player joins game":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.hasMoved == false
    #@Condition isGameInProgress() == true
    @Condition eventPlayer.hasSpawned() == true
    
    if not RoundInProgress or not isGameInProgress():
        goto lbl_0
    kill(eventPlayer, null)
    lbl_0:
    eventPlayer.teleport(CircleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)))
    eventPlayer.hasMoved = true


rule "Shorten Deflect Length":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isUsingAbility2() == true
    @Condition eventPlayer.isUsingUltimate() == false
    
    wait(0.3)
    eventPlayer.setAbility2Enabled(false)
    eventPlayer.setAbility1Enabled(false)
    wait(0.5)
    eventPlayer.setAbility2Enabled(true)
    eventPlayer.setAbility1Enabled(true)


rule "Unlock dash after using jumppad":
    @Event eachPlayer
    @Hero all
    @Condition BouncepadDashingEnabled == true
    @Condition eventPlayer.IsDashEnabled == true
    
    eventPlayer.setAbility1Enabled(true)


rule "Disable dash after using":
    @Event eachPlayer
    @Hero all
    @Condition BouncepadDashingEnabled == true
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.IsDashEnabled = false


rule "Target random player":
    @Condition isGameInProgress() == true
    @Condition SlotOfTargetedPlayer == -1
    
    SlotOfTargetedPlayer = (random.choice([player for player in getLivingPlayers(Team.ALL) if player.hasMoved and SlotOfPreviousTargetedPlayer != getPlayersInSlot(player, Team.ALL).getSlot()])).getSlot()


rule "Push to circle":
    @Event eachPlayer
    @Hero all
    @Condition distance(eventPlayer.getPosition(), vect(CircleCenter.x, eventPlayer.getPosition().y, CircleCenter.z)) > SphereSize - 1.5
    #Workshop Island Fix
    @Condition getCurrentMap() != Map.WORKSHOP_ISLAND
    @Condition getCurrentMap() != Map.WORKSHOP_ISLAND_NIGHT
    
    eventPlayer.applyImpulse(vect(directionTowards(eventPlayer.getPosition(), CircleCenter).x, 0, directionTowards(eventPlayer.getPosition(), CircleCenter).z), 6, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(Vector.UP, 3, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.25)
    if RULE_CONDITION:
        goto RULE_START


rule "Put out center":
    @Event eachPlayer
    @Hero all
    @Condition distance(eventPlayer.getPosition(), CircleCenter) < CenterOffLimitsSize + 0.5
    
    eventPlayer.applyImpulse(directionTowards(CircleCenter, eventPlayer), 10, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    eventPlayer.applyImpulse(Vector.UP, 1.5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.25)
    if RULE_CONDITION:
        goto RULE_START


rule "Player dashes too far out of bounds":
    @Event eachPlayer
    @Hero all
    @Condition distance(eventPlayer.getPosition(), vect(CircleCenter.x, eventPlayer.getPosition().y, CircleCenter.z)) > SphereSize + 1
    #Workshop Island Fix
    #@Condition (getCurrentMap() != Map.WORKSHOP_ISLAND and getCurrentMap() != Map.WORKSHOP_ISLAND_NIGHT) == true
    
    eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 2.5)
    #eventPlayer.teleport(CircleCenter + vect(random.randint(-15, 15), 8, random.randint(-15, 15)))
    eventPlayer.applyImpulse(vect(directionTowards(eventPlayer.getPosition(), CircleCenter).x, 0, directionTowards(eventPlayer.getPosition(), CircleCenter).z), 20, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(Vector.UP, 3, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    bigMessage(eventPlayer, "Do not dash out of the arena!")


rule "Player tries to abuse ledge on Workshop Island (push up and to center)":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.getPosition().y < -0.5
    @Condition eventPlayer.isAlive() == true
    #Workshop Island Fix
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    #Prevents people from going under the ledge on Workshop Island, which caused ball to go into floor.  Used to be an annoying stunkill
    eventPlayer.applyImpulse(Vector.UP, 2, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.applyImpulse(directionTowards(eventPlayer, CircleCenter), 2, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
    wait(0.008)
    if RULE_CONDITION:
        goto RULE_START


rule "Player falls off Workshop Island":
    @Event eachPlayer
    @Hero all
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    @Condition eventPlayer.getPosition().y < -0.25
    
    #A MAN HAS FALLEN INTO THE LAKE IN WORKSHOP ISLAND! START THE NEW RESCUE RULE! HEY! BUILD THE NEW WORSHOP RULE, AND OFF TO THE RESCUE! PREPARE THE CONDITION, TELEPORT THE PLAYER, AND MAKE THE RESCUE! THE NEW 2.3.0 UPDATE FROM OVERWATCH WORKSHOP!
    if not eventPlayer.isAlive():
        eventPlayer.teleport(CircleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)))
        if eventPlayer.getSlot() == SlotOfTargetedPlayer:
            if BallIsOut:
                BallDeleteRequested = true
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Anti-Bounce Detection Positive X":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.getPosition().y < 0
    @Condition eventPlayer.getPosition().x > 20.5
    #Workshop Island Fix
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    chase(eventPlayer.antiFloatTimer, 0.01, rate=1, ChaseReeval.DESTINATION_AND_RATE)
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
    
    chase(eventPlayer.antiFloatTimer, 0.01, rate=1, ChaseReeval.DESTINATION_AND_RATE)
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
    
    chase(eventPlayer.antiFloatTimer, 0.01, rate=1, ChaseReeval.DESTINATION_AND_RATE)
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
    
    chase(eventPlayer.antiFloatTimer, 0.01, rate=1, ChaseReeval.DESTINATION_AND_RATE)
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
    @Condition eventPlayer.getPosition().y < -4
    @Condition (getCurrentMap() == Map.WORKSHOP_ISLAND or getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT) == true
    
    eventPlayer.applyImpulse(Vector.UP, 5, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION_XYZ)
    wait(0.5)
    if RULE_CONDITION:
        goto RULE_START


rule "Bounce when near pad 1":
    @Event eachPlayer
    @Hero all
    @Condition distance(eventPlayer.getPosition(), BouncePad1) <= 2.75
    @Condition eventPlayer.BouncePadCooldown == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) == false
    
    eventPlayer.IsDashEnabled = true
    if eventPlayer.DashNerf:
        eventPlayer.applyImpulse(Vector.UP, BouncePadStrength - BouncePadSuperjumpNerf, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    else:
        eventPlayer.applyImpulse(Vector.UP, BouncePadStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.BouncePadCooldown = BouncePadCooldownLength
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, BouncePad1, 25)
    eventPlayer.PlayerEffects[1] = getLastCreatedEntity()
    wait(2)
    destroyEffect(eventPlayer.PlayerEffects[1])


rule "Bounce when near pad 2":
    @Event eachPlayer
    @Hero all
    @Condition distance(eventPlayer.getPosition(), BouncePad2) <= 2.75
    @Condition eventPlayer.BouncePadCooldown == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) == false
    
    eventPlayer.IsDashEnabled = true
    if eventPlayer.DashNerf:
        eventPlayer.applyImpulse(Vector.UP, BouncePadStrength - BouncePadSuperjumpNerf, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    else:
        eventPlayer.applyImpulse(Vector.UP, BouncePadStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.BouncePadCooldown = BouncePadCooldownLength
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, BouncePad1, 25)
    eventPlayer.PlayerEffects[1] = getLastCreatedEntity()
    wait(2)
    destroyEffect(eventPlayer.PlayerEffects[1])


rule "Bounce when near pad 3":
    @Event eachPlayer
    @Hero all
    @Condition distance(eventPlayer.getPosition(), BouncePad3) <= 2.75
    @Condition eventPlayer.BouncePadCooldown == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) == false
    
    eventPlayer.IsDashEnabled = true
    if eventPlayer.DashNerf:
        eventPlayer.applyImpulse(Vector.UP, BouncePadStrength - BouncePadSuperjumpNerf, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    else:
        eventPlayer.applyImpulse(Vector.UP, BouncePadStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.BouncePadCooldown = BouncePadCooldownLength
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, BouncePad1, 25)
    eventPlayer.PlayerEffects[1] = getLastCreatedEntity()
    wait(2)
    destroyEffect(eventPlayer.PlayerEffects[1])


rule "Bounce when near pad 4":
    @Event eachPlayer
    @Hero all
    @Condition distance(eventPlayer.getPosition(), BouncePad4) <= 2.75
    @Condition eventPlayer.BouncePadCooldown == 0
    @Condition eventPlayer.isAlive() == true
    @Condition eventPlayer.isHoldingButton(Button.JUMP) == true
    @Condition eventPlayer.hasStatusEffect(Status.KNOCKED_DOWN) == false
    
    eventPlayer.IsDashEnabled = true
    if eventPlayer.DashNerf:
        eventPlayer.applyImpulse(Vector.UP, BouncePadStrength - BouncePadSuperjumpNerf, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    else:
        eventPlayer.applyImpulse(Vector.UP, BouncePadStrength, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.BouncePadCooldown = BouncePadCooldownLength
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.WHITE, BouncePad1, 25)
    eventPlayer.PlayerEffects[1] = getLastCreatedEntity()
    wait(2)
    destroyEffect(eventPlayer.PlayerEffects[1])


rule "Ball delete requested":
    @Condition BallDeleteRequested == true
    
    BallDeleteRequested = false
    SlotOfTargetedPlayer = -1
    stopChasingVariable(BallDirection)
    stopChasingVariable(BallPosition)
    stopChasingVariable(BallSpeed)
    BallPosition = vect(0, -1, 0)
    BallDirection = vect(0, 0, 0)
    BallIsOut = false
    SlotOfPreviousTargetedPlayer = -1
    BallSpawnCountdown = 2
    PrevBallPos = vect(0, 0, 0)
    PrevBallPos2 = vect(0, 0, 0)


rule "Only end game when there isn't a round in progress":
    @Condition getMatchTime() == 0
    @Condition RoundInProgress == false
    @Condition GameEndEnabled == true
    @Condition TieBreakerActive == false
    
    enableMusic()
    enableGamemodeCompletion()


rule "primary = dash":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    @Condition "{0}".format(eventPlayer) != "bytestats"
    
    eventPlayer.forceButtonPress(Button.ABILITY_1)


rule "secondary = deflect":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    @Condition "{0}".format(eventPlayer) != "bytestats"
    @Condition PassingEnabled == false
    
    eventPlayer.forceButtonPress(Button.ABILITY_2)


rule "// ACTIVE GAME":


rule "Start round":
    @Condition IsEnoughPlayersToStart == true
    @Condition isGameInProgress() == true
    @Condition getCurrentGamemode() == Gamemode.FFA
    
    chase(BallSpawnCountdown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    RoundInProgress = true
    chase(getAllPlayers().BouncePadCooldown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    BallSpawnCountdown = 5


rule "Start round - TEAMS":
    @Condition IsEnoughPlayersToStart == true
    @Condition IncorrectTeam1ConfigCheck == false
    @Condition IncorrectTeam2ConfigCheck == false
    @Condition isGameInProgress() == true
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    chase(BallSpawnCountdown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    RoundInProgress = true
    chase(getAllPlayers().BouncePadCooldown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    BallSpawnCountdown = 5


rule "Spawn ball":
    @Condition BallSpawnCountdown == 0
    
    BallPosition = CircleCenter
    BallDirection = directionTowards(BallPosition, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getEyePosition())
    BallSpeed = min(30, BallSpeed)
    BallIsOut = true


rule "ball motion (has to be done weird due to chase vector variable bugs)":
    @Condition BallIsOut == true
    
    PrevBallPos2 = PrevBallPos
    PrevBallPos = BallPosition
    chase(BallPosition, BallPosition + BallDirection * BallSpeed * 1, rate=BallSpeed, ChaseReeval.DESTINATION_AND_RATE)
    chase(BallDirection, directionTowards(BallPosition, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getEyePosition()), rate=1.75, ChaseReeval.DESTINATION_AND_RATE)
    chase(BallSpeed, MaxBallSpeed, rate=0.25, ChaseReeval.DESTINATION_AND_RATE)
    wait(0.05)
    if RULE_CONDITION:
        goto RULE_START


rule "Ball reaches player":
    @Condition distance(BallPosition, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getEyePosition()) <= 1.9
    @Condition BallIsOut == true
    @Condition getCurrentGamemode() == Gamemode.FFA
    
    if getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isHoldingButton(Button.SECONDARY_FIRE):
        #If they don't have enough health, kill em
        if getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getHealth() <= 100:
            DeflectFailed()
            return
    if getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isUsingAbility2() or getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isUsingAbility1():
        goto lbl_0
    DeflectFailed()
    return
    lbl_0:
    #if getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isUsingAbility2() or getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isUsingAbility1():
    #        goto lbl_1
    if getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isUsingAbility1():
        getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).setStatusEffect(null, Status.KNOCKED_DOWN, 1)
        getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).teleport(BallPosition)
    getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).CurrentUltPercent += 5
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getPosition(), 200)
    getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).PlayerDeflects += 1
    SlotOfPreviousTargetedPlayer = SlotOfTargetedPlayer
    BallSpeed = min(500, BallSpeed * 1.05)
    if BallSpeed > getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).maxBallSpeed:
        getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).maxBallSpeed = BallSpeed
    stopChasingVariable(BallDirection)
    lbl_1:
    BallDirection = getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getFacingDirection()
    wait(0.001)
    if getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).isHoldingButton(Button.SECONDARY_FIRE) and PassingEnabled:
        IsPassingTeam1 = true
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).getPosition(), 10)
        playEffect(getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL), DynamicEffect.MOIRA_FADE_DISAPPEAR_SOUND, Color.WHITE, getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).getPosition(), 100)
        getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).setHealth(PassingDamage)
        SlotOfTargetedPlayer = SlotOfPreviousTargetedPlayer
    else:
        IsPassingTeam1 = false
        heal(getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL), null, PassingDamage)
        SlotOfTargetedPlayer = ((sorted([player for player in getLivingPlayers(Team.ALL) if player.getSlot() != SlotOfPreviousTargetedPlayer], lambda i: angleBetweenVectors(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getFacingDirection(), directionTowards(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), i.getPosition()))))[0]).getSlot()
    chase(BallDirection, directionTowards(BallPosition, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getEyePosition()), rate=6, ChaseReeval.DESTINATION_AND_RATE)
    #if RULE_CONDITION:
    #        goto RULE_START


rule "Ball reaches player -TEAMS":
    @Condition distance(BallPosition, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getEyePosition()) <= 1.9
    @Condition BallIsOut == true
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    if getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isHoldingButton(Button.SECONDARY_FIRE):
        #If they don't have enough health, kill em
        if getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getHealth() <= 100:
            DeflectFailed()
            return
    if getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isUsingAbility2() or getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isUsingAbility1():
        goto lbl_0
    DeflectFailed()
    return
    lbl_0:
    #if getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isUsingAbility2() or getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isUsingAbility1():
    #        goto lbl_1
    if getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).isUsingAbility1():
        getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).setStatusEffect(null, Status.KNOCKED_DOWN, 1)
        getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).teleport(BallPosition)
    getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).CurrentUltPercent += 5
    playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getPosition(), 200)
    getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).PlayerDeflects += 1
    SlotOfPreviousTargetedPlayer = SlotOfTargetedPlayer
    BallSpeed = min(500, BallSpeed * 1.05)
    if BallSpeed > getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).maxBallSpeed:
        getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).maxBallSpeed = BallSpeed
    stopChasingVariable(BallDirection)
    lbl_1:
    BallDirection = getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getFacingDirection()
    wait(0.001)
    if getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).isHoldingButton(Button.SECONDARY_FIRE) and PassingEnabled:
        #if getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).isHoldingButton(Button.SECONDARY_FIRE):
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.SKY_BLUE, getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).getPosition(), 10)
        playEffect(getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL), DynamicEffect.MOIRA_FADE_DISAPPEAR_SOUND, Color.WHITE, getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).getPosition(), 100)
        getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).setHealth(PassingDamage)
        #Check which team is passing
        if getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).getTeam() == Color.TEAM_1:
            IsPassingTeam1 = true
        else:
            IsPassingTeam2 = true
        #If the member is the only one left on their team, self pass
        if len([player for player in getLivingPlayers(getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).getTeam()) if true]) == 1:
            SlotOfTargetedPlayer = SlotOfPreviousTargetedPlayer
            #Pass to another teammate
        else:
            SlotOfTargetedPlayer = ((sorted([player for player in getLivingPlayers(getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).getTeam()) if player.getSlot() != SlotOfPreviousTargetedPlayer], lambda i: angleBetweenVectors(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getFacingDirection(), directionTowards(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), i.getPosition()))))[0]).getSlot()
        #Not passing, heal the person deflecting and target someone on the other team
    else:
        heal(getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL), null, PassingDamage)
        IsPassingTeam1 = false
        IsPassingTeam2 = false
        SlotOfTargetedPlayer = ((sorted([player for player in getLivingPlayers(getOppositeTeam(getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).getTeam())) if player.getSlot() != SlotOfPreviousTargetedPlayer], lambda i: angleBetweenVectors(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getFacingDirection(), directionTowards(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), i.getPosition()))))[0]).getSlot()
    chase(BallDirection, directionTowards(BallPosition, getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getEyePosition()), rate=6, ChaseReeval.DESTINATION_AND_RATE)
    #If deflecting and stuff breaks...disabling this is why.
    #if RULE_CONDITION:
    #        goto RULE_START


def DeflectFailed():
    @Name "Player Didn't Deflect - Kill"
    
    heal(getLivingPlayers(Team.ALL), null, 200)
    IsPassingTeam1 = false
    IsPassingTeam2 = false
    getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).setStatusEffect(getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL), Status.STUNNED, 1)
    if ImprovedExplosions == true:
        UpdatedDeathEffects()
    else:
        CoolDeathEffects()
    getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).BouncePadCooldown = 0
    getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).CurrentUltPercent += 15
    kill(getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL))
    getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).PlayerDeaths += 1
    getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL).PlayerKills += 1
    BallDeleteRequested = true
    return


def CoolDeathEffects():
    @Name "CoolDeathEffects sub"
    
    createBeam(getAllPlayers(), Beam.BAD, getPlayersInSlot(SlotOfPreviousTargetedPlayer, Team.ALL), getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL), Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    deathBeam = getLastCreatedEntity()
    deathSpherePos = getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getPosition()
    deathSphereRad = 30
    chase(deathSphereRad, 0, duration=0.25, ChaseReeval.DESTINATION_AND_DURATION)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.SKY_BLUE, deathSpherePos, 40)
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLACK, deathSpherePos, deathSphereRad, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    deathSphere = getLastCreatedEntity()
    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.WHITE, deathSpherePos, 5)
    wait(0.25)
    destroyEffect(deathSphere)
    #playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, deathSpherePos, SphereSize * 1.5)
    #playEffect(getAllPlayers(), DynamicEffect.EXPLOSION_SOUND, Color.WHITE, deathSpherePos, 40)
    destroyEffect(deathBeam)


def UpdatedDeathEffects():
    @Name "Updated Death Effects Sub"
    
    deathSpherePos = getPlayersInSlot(SlotOfTargetedPlayer, Team.ALL).getPosition()
    #Make sure it is final duel AND there are at least 3 or more players
    if getNumberOfLivingPlayers(Team.ALL) == 2 and getNumberOfPlayers(Team.ALL) != 2:
        if FinalDuelNuke:
            playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT, Color.WHITE, vect(deathSpherePos.x, 0, deathSpherePos.z), 0)
    playEffect(getAllPlayers(), DynamicEffect.BASTION_TANK_CANNON_EXPLOSION, Color.WHITE, deathSpherePos, 1)
    if RandomExplosionSounds:
        #Pick a random explosion sound
        RandomExplosionPicker = random.randint(0, 4)
        if RandomExplosionPicker == 0:
            playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT_SOUND, Color.WHITE, deathSpherePos, ExplosionSoundVolume)
        elif RandomExplosionPicker == 1:
            playEffect(getAllPlayers(), DynamicEffect.BASTION_TANK_CANNON_EXPLOSION_SOUND, Color.WHITE, deathSpherePos, ExplosionSoundVolume)
        elif RandomExplosionPicker == 2:
            playEffect(getAllPlayers(), DynamicEffect.ASHE_DYNAMITE_EXPLOSION_SOUND, Color.WHITE, deathSpherePos, ExplosionSoundVolume)
        elif RandomExplosionPicker == 3:
            playEffect(getAllPlayers(), DynamicEffect.PHARAH_BARRAGE_EXPLOSION_SOUND, Color.WHITE, deathSpherePos, ExplosionSoundVolume)
        elif RandomExplosionPicker == 4:
            playEffect(getAllPlayers(), DynamicEffect.JUNKRAT_FRAG_LAUNCHER_EXPLOSION_SOUND, Color.WHITE, deathSpherePos, ExplosionSoundVolume)
    else:
        #playEffect(getAllPlayers(), DynamicEffect.DOOMFIST_METEOR_STRIKE_IMPACT_SOUND, Color.WHITE, deathSpherePos, ExplosionSoundVolume)
        playEffect(getAllPlayers(), DynamicEffect.JUNKRAT_FRAG_LAUNCHER_EXPLOSION_SOUND, Color.WHITE, deathSpherePos, ExplosionSoundVolume)


rule "Final duel":
    @Condition isGameInProgress() == true
    @Condition len([player for player in getLivingPlayers(Team.ALL) if player.hasMoved]) == 2
    @Condition IsEnoughPlayersToStart == true
    @Condition IsInFinalDuel == false
    @Condition getCurrentGamemode() == Gamemode.FFA
    
    getLivingPlayers(Team.ALL).IsDashEnabled = false
    if BallIsOut == false:
        goto lbl_0
    BallDeleteRequested = true
    lbl_0:
    IsInFinalDuel = true
    getLivingPlayers(Team.ALL).BouncePadCooldown = 2
    if getNumberOfPlayers(Team.ALL) <= 2:
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
        getLivingPlayers(Team.ALL)[0].teleport(CircleCenter + vect(-1, 0, 0) * (SphereSize / 4))
        getLivingPlayers(Team.ALL)[1].teleport(CircleCenter + vect(1, 0, 0) * (SphereSize / 4))
    else:
        getLivingPlayers(Team.ALL)[0].teleport(CircleCenter + vect(-1, 0, 0) * (SphereSize / 1.5))
        getLivingPlayers(Team.ALL)[1].teleport(CircleCenter + vect(1, 0, 0) * (SphereSize / 1.5))
    getLivingPlayers(Team.ALL).setStatusEffect(null, Status.ROOTED, 2)
    wait(0.001)
    getLivingPlayers(Team.ALL)[0].setFacing(directionTowards(getLivingPlayers(Team.ALL)[0].getPosition(), CircleCenter), Relativity.TO_WORLD)
    getLivingPlayers(Team.ALL)[1].setFacing(directionTowards(getLivingPlayers(Team.ALL)[1].getPosition(), CircleCenter), Relativity.TO_WORLD)


rule "Final duel - TEAMS":
    @Condition isGameInProgress() == true
    #@Condition len([player for player in getLivingPlayers(Team.ALL) if player.hasMoved]) == 2
    @Condition (len([player for player in getLivingPlayers(Color.TEAM_1) if player.hasMoved]) == 1 and len([player for player in getLivingPlayers(Color.TEAM_2) if player.hasMoved]) == 1) == true
    @Condition IsEnoughPlayersToStart == true
    @Condition IsInFinalDuel == false
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    getLivingPlayers(Team.ALL).IsDashEnabled = false
    if BallIsOut == false:
        goto lbl_0
    BallDeleteRequested = true
    lbl_0:
    IsInFinalDuel = true
    getLivingPlayers(Team.ALL).BouncePadCooldown = 2
    if getNumberOfPlayers(Team.ALL) <= 2:
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
        getLivingPlayers(Team.ALL)[0].teleport(CircleCenter + vect(-1, 0, 0) * (SphereSize / 4))
        getLivingPlayers(Team.ALL)[1].teleport(CircleCenter + vect(1, 0, 0) * (SphereSize / 4))
    else:
        getLivingPlayers(Team.ALL)[0].teleport(CircleCenter + vect(-1, 0, 0) * (SphereSize / 1.5))
        getLivingPlayers(Team.ALL)[1].teleport(CircleCenter + vect(1, 0, 0) * (SphereSize / 1.5))
    getLivingPlayers(Team.ALL).setStatusEffect(null, Status.ROOTED, 2)
    wait(0.001)
    getLivingPlayers(Team.ALL)[0].setFacing(directionTowards(getLivingPlayers(Team.ALL)[0].getPosition(), CircleCenter), Relativity.TO_WORLD)
    getLivingPlayers(Team.ALL)[1].setFacing(directionTowards(getLivingPlayers(Team.ALL)[1].getPosition(), CircleCenter), Relativity.TO_WORLD)


rule "Check for last player surviving":
    @Condition isGameInProgress() == true
    @Condition getNumberOfLivingPlayers(Team.ALL) == 1
    @Condition IsEnoughPlayersToStart == true
    @Condition getCurrentGamemode() == Gamemode.FFA
    
    IsInFinalDuel = false
    getLivingPlayers(Team.ALL).addToScore(1)
    wait(0.25)
    if (getMatchTime() == 0 or TieBreakerActive) and GameEndEnabled:
        #If there is alredy a tiebreaker, then the tiebreaker has ended.
        #if TieBreakerActive:
        #break
        #__end__()
        HighestScore = sorted(getAllPlayers(), lambda player: player.getScore()).last().getScore()
        #Check if there is more then 1 person with the highest score
        if len([player for player in getAllPlayers() if player.getScore() == HighestScore]) > 1:
            #There is more then 1, activate tie breaker
            TieBreakerActive = true
        else:
            TieBreakerActive = false
    stopChasingVariable(BallSpawnCountdown)
    stopChasingVariable(getAllPlayers().BouncePadCooldown)
    bigMessage(getAllPlayers(), "{0} has won the round!".format(getLivingPlayers(Team.ALL)[0]))
    wait(2)
    if not TieBreakerActive:
        getDeadPlayers(Team.ALL).resurrect()
    else:
        #Kill anyone alive who doesn't have the highest score.
        kill([player for player in getLivingPlayers(Team.ALL) if player.getScore() != HighestScore], null)
        #During tiebreaker, only revive the people who have the same score as the highest score.
        ([player for player in getDeadPlayers(Team.ALL) if player.getScore() == HighestScore]).resurrect()
        wait(0.25)
        SlotOfTargetedPlayer = -1
        bigMessage(getAllPlayers(), "Tiebreaker!")
    if not IsEnoughPlayersToStart:
        return
    RoundInProgress = false
    getAllPlayers().BouncePadCooldown = BouncePadCooldownLength
    SlotOfTargetedPlayer = -1
    BallSpawnCountdown = 5
    wait(1)
    RoundInProgress = true
    if not BouncepadDashingEnabled:
        goto lbl_0
    getAllPlayers().IsDashEnabled = false
    getAllPlayers().setAbility1Enabled(false)
    lbl_0:
    chase(BallSpawnCountdown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    chase(getAllPlayers().BouncePadCooldown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)


rule "Team 1 Last Surviving":
    @Condition isGameInProgress() == true
    @Condition getNumberOfLivingPlayers(Color.TEAM_2) == 0
    @Condition IsEnoughPlayersToStart == true
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    IsInFinalDuel = false
    addToTeamScore(Color.TEAM_1, 1)
    wait(0.25)
    if (getMatchTime() == 0 or TieBreakerActive) and GameEndEnabled:
        #If there is alredy a tiebreaker, then the tiebreaker has ended.
        #if TieBreakerActive:
        #break
        #__end__()
        HighestScore = sorted(getAllPlayers(), lambda player: player.getScore()).last().getScore()
        #Check if there is more then 1 person with the highest score
        if teamScore(Color.TEAM_1) == teamScore(Color.TEAM_2):
            #There is more then 1, activate tie breaker
            TieBreakerActive = true
        else:
            TieBreakerActive = false
    stopChasingVariable(BallSpawnCountdown)
    stopChasingVariable(getAllPlayers().BouncePadCooldown)
    bigMessage(getAllPlayers(), "{0} has won the round!".format(Color.TEAM_1))
    wait(2)
    if not TieBreakerActive:
        getDeadPlayers(Team.ALL).resurrect()
    else:
        #Kill anyone alive who doesn't have the highest score.
        kill([player for player in getLivingPlayers(Team.ALL) if player.getScore() != HighestScore], null)
        #During tiebreaker, only revive the people who have the same score as the highest score.
        ([player for player in getDeadPlayers(Team.ALL) if player.getScore() == HighestScore]).resurrect()
        wait(0.25)
        SlotOfTargetedPlayer = -1
        bigMessage(getAllPlayers(), "Tiebreaker!")
    heal(getAllPlayers(), null, 200)
    if not IsEnoughPlayersToStart:
        return
    RoundInProgress = false
    if IncorrectTeam1ConfigCheck:
        return
    if IncorrectTeam2ConfigCheck:
        return
    getAllPlayers().BouncePadCooldown = BouncePadCooldownLength
    SlotOfTargetedPlayer = -1
    BallSpawnCountdown = 5
    wait(1)
    RoundInProgress = true
    if not BouncepadDashingEnabled:
        goto lbl_0
    getAllPlayers().IsDashEnabled = false
    getAllPlayers().setAbility1Enabled(false)
    lbl_0:
    chase(BallSpawnCountdown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    chase(getAllPlayers().BouncePadCooldown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)


rule "Team 2 Last Surviving":
    @Condition isGameInProgress() == true
    @Condition getNumberOfLivingPlayers(Color.TEAM_1) == 0
    @Condition IsEnoughPlayersToStart == true
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    IsInFinalDuel = false
    addToTeamScore(Color.TEAM_2, 1)
    wait(0.25)
    if (getMatchTime() == 0 or TieBreakerActive) and GameEndEnabled:
        #If there is alredy a tiebreaker, then the tiebreaker has ended.
        #if TieBreakerActive:
        #break
        #__end__()
        HighestScore = sorted(getAllPlayers(), lambda player: player.getScore()).last().getScore()
        #Check if there is more then 1 person with the highest score
        if teamScore(Color.TEAM_1) == teamScore(Color.TEAM_2):
            #There is more then 1, activate tie breaker
            TieBreakerActive = true
        else:
            TieBreakerActive = false
    stopChasingVariable(BallSpawnCountdown)
    stopChasingVariable(getAllPlayers().BouncePadCooldown)
    bigMessage(getAllPlayers(), "{0} has won the round!".format(Color.TEAM_2))
    wait(2)
    if not TieBreakerActive:
        getDeadPlayers(Team.ALL).resurrect()
    else:
        #Kill anyone alive who doesn't have the highest score.
        kill([player for player in getLivingPlayers(Team.ALL) if player.getScore() != HighestScore], null)
        #During tiebreaker, only revive the people who have the same score as the highest score.
        ([player for player in getDeadPlayers(Team.ALL) if player.getScore() == HighestScore]).resurrect()
        wait(0.25)
        SlotOfTargetedPlayer = -1
        bigMessage(getAllPlayers(), "Tiebreaker!")
    heal(getAllPlayers(), null, 200)
    if not IsEnoughPlayersToStart:
        return
    RoundInProgress = false
    if IncorrectTeam1ConfigCheck:
        return
    if IncorrectTeam2ConfigCheck:
        return
    getAllPlayers().BouncePadCooldown = BouncePadCooldownLength
    SlotOfTargetedPlayer = -1
    BallSpawnCountdown = 5
    wait(1)
    RoundInProgress = true
    if not BouncepadDashingEnabled:
        goto lbl_0
    getAllPlayers().IsDashEnabled = false
    getAllPlayers().setAbility1Enabled(false)
    lbl_0:
    chase(BallSpawnCountdown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    chase(getAllPlayers().BouncePadCooldown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)


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
    @Condition TieBreakerActive == false
    
    IsInFinalDuel = false
    if BallIsOut == false:
        goto lbl_0
    BallDeleteRequested = true
    lbl_0:
    RoundInProgress = false
    stopChasingVariable(BallSpawnCountdown)
    getDeadPlayers(Team.ALL).resurrect()
    smallMessage(getAllPlayers(), "All players detected dead! Resetting game.")
    stopChasingVariable(getAllPlayers().BouncePadCooldown)
    getAllPlayers().BouncePadCooldown = BouncePadCooldownLength
    BallSpawnCountdown = 5
    wait(1)
    if RULE_CONDITION:
        goto RULE_START
    wait(2)
    if not IsEnoughPlayersToStart:
        return
    chase(getAllPlayers().BouncePadCooldown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    chase(BallSpawnCountdown, 0, rate=1, ChaseReeval.DESTINATION_AND_RATE)
    RoundInProgress = true
    BallPosition = vect(0, -1, 0)


rule "dash slow":
    @Event eachPlayer
    @Hero all
    @Condition eventPlayer.isUsingAbility1() == true
    
    eventPlayer.DashNerf = true
    eventPlayer.moveSpeed = 0
    chase(eventPlayer.moveSpeed, 100, rate=max(eventPlayer.moveSpeed, 16) ** 1.25, ChaseReeval.DESTINATION_AND_RATE)
    while eventPlayer.moveSpeed != 100:
        eventPlayer.setMoveSpeed(eventPlayer.moveSpeed)
        eventPlayer.setGravity(eventPlayer.moveSpeed)
        wait(0.1)
    eventPlayer.setMoveSpeed(100)
    eventPlayer.setGravity(100)
    eventPlayer.DashNerf = false


rule "Ball bounce off surface":
    @Condition BallIsOut == true
    @Condition raycast(BallPosition, BallPosition + BallDirection * BallSpeed * 0.033, null, getAllPlayers(), false).getHitPosition() != BallPosition + BallDirection * BallSpeed * 0.033
    @Condition getCurrentMap() != Map.WORKSHOP_CHAMBER
    
    #normal of the plane of the surface with which the ball collides, n
    BallCollisionSurfaceNormal = raycast(BallPosition, BallPosition + BallDirection * BallSpeed * 0.066, null, getAllPlayers(), false).getNormal()
    #reflected vector formula --- new v = v - 2 * (v•n)/(n•n) * n
    BallDirection = BallDirection - 2 * BallDirection * BallCollisionSurfaceNormal / dotProduct(BallCollisionSurfaceNormal, BallCollisionSurfaceNormal) * BallCollisionSurfaceNormal
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, BallPosition, 1)
    wait(0.02)
    if RULE_CONDITION:
        goto RULE_START


rule "Ball no down when y < -0.5":
    @Condition BallIsOut == true
    @Condition BallPosition.y < -0.5
    @Condition BallDirection.y < 0
    
    BallDirection *= vect(1, 0, 1)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.WHITE, BallPosition, 2)


rule "Ball change color":
    #if BallColor != 0 and BallSpeed < 20 and true:
    #destroyEffect(BallSmoke)
    #destroyEffect(BallTail1)
    #destroyEffect(BallTail2)
    #createEffect(getAllPlayers(), Effect.BAD_AURA, Color.BLUE, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallSmoke = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, BallPosition, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail1 = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, PrevBallPos2, Color.BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail2 = getLastCreatedEntity()
    #BallColor = 0
    #elif BallColor != 1 and BallSpeed >= 20 and BallSpeed < 25:
    #destroyEffect(BallSmoke)
    #destroyEffect(BallTail1)
    #destroyEffect(BallTail2)
    #createEffect(getAllPlayers(), Effect.BAD_AURA, Color.GREEN, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallSmoke = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, BallPosition, Color.GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail1 = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, PrevBallPos2, Color.GREEN, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail2 = getLastCreatedEntity()
    #BallColor = 1
    #elif BallColor != 2 and BallSpeed >= 25 and BallSpeed < 30:
    destroyEffect(BallSmoke)
    destroyEffect(BallTail1)
    destroyEffect(BallTail2)
    #createEffect(getAllPlayers(), Effect.BAD_AURA, Color.YELLOW, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallSmoke = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, BallPosition, Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    BallTail1 = getLastCreatedEntity()
    createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, PrevBallPos2, Color.SKY_BLUE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    BallTail2 = getLastCreatedEntity()
    BallColor = 2
    #elif BallColor != 3 and BallSpeed >= 30 and BallSpeed < 35:
    #destroyEffect(BallSmoke)
    #destroyEffect(BallTail1)
    #destroyEffect(BallTail2)
    #createEffect(getAllPlayers(), Effect.BAD_AURA, Color.ORANGE, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallSmoke = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, BallPosition, Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail1 = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, PrevBallPos2, Color.ORANGE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail2 = getLastCreatedEntity()
    #BallColor = 3
    #elif BallColor != 4 and BallSpeed >= 35 and BallSpeed < 55:
    #destroyEffect(BallSmoke)
    #destroyEffect(BallTail1)
    #destroyEffect(BallTail2)
    #createEffect(getAllPlayers(), Effect.BAD_AURA, Color.RED, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallSmoke = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, BallPosition, Color.RED, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail1 = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, PrevBallPos2, Color.RED, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail2 = getLastCreatedEntity()
    #BallColor = 4
    #elif BallColor != 5 and BallSpeed >= 55 and true:
    #destroyEffect(BallSmoke)
    #destroyEffect(BallTail1)
    #destroyEffect(BallTail2)
    #createEffect(getAllPlayers(), Effect.BAD_AURA, Color.PURPLE, BallPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallSmoke = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, BallPosition, Color.PURPLE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail1 = getLastCreatedEntity()
    #createBeam(getAllPlayers(), Beam.BAD, PrevBallPos, PrevBallPos2, Color.PURPLE, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    #BallTail2 = getLastCreatedEntity()
    #BallColor = 5
    #__end__()
    wait(1)
    if RULE_CONDITION:
        goto RULE_START
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.GREEN, BallPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.YELLOW, BallPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.ORANGE, BallPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.RED, BallPosition, 2)
    playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.PURPLE, BallPosition, 4)


rule "Chamber x collision":
    #This collision is the lazy way but its only for chamber so who cares
    @Condition getCurrentMap() == Map.WORKSHOP_CHAMBER
    @Condition BallIsOut == true
    @Condition (BallPosition.x + 0.4 >= 20 or BallPosition.x - 0.4 <= -20) == true
    
    if BallPosition.x + 0.4 >= 20 and BallDirection.x > 0 or BallPosition.x - 0.4 <= -20 and BallDirection.x < 0:
        BallDirection = vect(BallDirection.x * -1, BallDirection.y, BallDirection.z)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, BallPosition, 1)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "Chamber y collision":
    @Condition getCurrentMap() == Map.WORKSHOP_CHAMBER
    @Condition BallIsOut == true
    @Condition (BallPosition.y + 0.4 >= 40) - (BallPosition.y - 0.4 <= 0) == true
    
    if BallPosition.y + 0.4 >= 40 and BallDirection.y > 0 or BallPosition.y - 0.4 <= 0 and BallDirection.y < 0:
        BallDirection = vect(BallDirection.x, BallDirection.y * -1, BallDirection.z)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, BallPosition, 1)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "Chamber z collision":
    @Condition getCurrentMap() == Map.WORKSHOP_CHAMBER
    @Condition BallIsOut == true
    @Condition (BallPosition.z + 0.4 >= 20 or BallPosition.z - 0.4 <= -20) == true
    
    if BallPosition.z + 0.4 >= 20 and BallDirection.z > 0 or BallPosition.z - 0.4 <= -20 and BallDirection.z < 0:
        BallDirection = vect(BallDirection.x, BallDirection.y, BallDirection.z * -1)
        playEffect(getAllPlayers(), DynamicEffect.BAD_EXPLOSION, Color.WHITE, BallPosition, 1)
    wait()
    if RULE_CONDITION:
        goto RULE_START


rule "No Undermaps":
    @Condition getCurrentMap() == Map.WORKSHOP_ISLAND_NIGHT
    @Condition BallIsOut == true
    @Condition BallPosition.y < -2.85
    @Condition BallDirection.y < 0
    
    BallDirection *= vect(1, 0, 1)
    playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.WHITE, BallPosition, 2)


rule "Team 1 Win":
    @Condition AllowMatchEnd == true
    @Condition teamScore(Color.TEAM_1) == ScoreToWin
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    enableAnnouncer()
    declareTeamVictory(Color.TEAM_1)


rule "Team 2 Win":
    @Condition AllowMatchEnd == true
    @Condition teamScore(Color.TEAM_2) == ScoreToWin
    @Condition getCurrentGamemode() == Gamemode.TDM
    
    enableAnnouncer()
    declareTeamVictory(Color.TEAM_2)
