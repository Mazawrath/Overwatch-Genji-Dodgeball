#!mainFile "./Genji-Dodgeball.opy"

#This seems to be the only way of differentiating specs from players(except for the Japanese and Taiwanese, sorry!):
#!define isSpectator(player) not (player in getAllPlayers() or strContains("$#@{0}".format(player), "$#@{0} ".format(entityReference.split(" "))))

rule "Init player variables":
    @Event eachPlayer
    @Hero all

    waitUntil(eventPlayer.hasSpawned(), 20)
    if roundInProgress and isGameInProgress():
        eventPlayer.teleport(circleCenter + vect(0, 500, 0))
        eventPlayer.setInvisibility(Invis.ALL)
        wait(0.05)
        kill(eventPlayer, null)
        wait(0.25)
    if eventPlayer.getSlot() <= len(spawnPoints) and getCurrentGamemode() == Gamemode.FFA:
        eventPlayer.teleport(spawnPoints[eventPlayer.getSlot()])
    else:
        eventPlayer.teleport(circleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)))
    wait()
    eventPlayer.hasMoved = true
    if (not isGameInProgress() and eventPlayer != hostPlayer):
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), hostPlayer.getEyePosition()), 100, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    eventPlayer.isDashEnabled = false
    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 9999)
    if cooldownDashingEnabled:
        goto lbl_0
    eventPlayer.setAbility1Enabled(false)
    lbl_0:
    eventPlayer.disableRespawn()
    eventPlayer.enableDeathSpectateAllPlayers()
    eventPlayer.enableDeathSpectateTargetHud()
    eventPlayer.bouncePadCooldown = bouncePadCooldownLengthStart
    eventPlayer.antiFloatProtection = false
    eventPlayer.antiStuckProtection = false
    eventPlayer.toggleHUD = true
    eventPlayer.dashNerf = false
    eventPlayer.latencyToggle = false
    eventPlayer.torbDie = false
    eventPlayer.passingSignal = 0
    chase(eventPlayer.passingSignal, 0, rate=1, ChaseReeval.NONE)
    waitUntil((not roundInProgress or not isGameInProgress()) or eventPlayer.isAlive(), 9999)
    eventPlayer.setInvisibility(Invis.NONE)
    if invisiblePlayers:
        getAllPlayers().setInvisibility(Invis.ALL)
    waitUntil(eventPlayer.isAlive() and isGameInProgress(), 90)
        eventPlayer.stopFacing()
    # Force 3rd person if it's toggled on.
    if (perspectiveMode == 2):
        eventPlayer.thirdPerson = true
        eventPlayer.startCamera(eventPlayer + worldVector(vect(-0.75, 0.25, -0.25), eventPlayer, Transform.ROTATION) + Vector.UP * 1.5 + eventPlayer.getFacingDirection() * -2, eventPlayer + eventPlayer.getFacingDirection() * 1000, 0)
    elif invisiblePlayers:
        eventPlayer.startCamera(updateEveryTick(eventPlayer.getEyePosition()), updateEveryTick(eventPlayer + eventPlayer.getFacingDirection() * 1000), 0)
    wait(3)
    smallMessage(eventPlayer, "Here's a tip:")
    wait(1)
    smallMessage(eventPlayer, "Primary fire aka swing hammer = deflect")
    wait(2)
    smallMessage(eventPlayer, "Ability 2 aka overload = dash")
    wait(3) 


rule "Init global variables":
    disableCenter = false
    targetedPlayer = -1
    previousTargetedPlayer = -1
    ballSpawnCountdown = 30
    if tournamentMode and getCurrentGamemode() != Gamemode.FFA:
        tournamentMode = false
        hudText(hostPlayer, null, null, "Tournament mode is only supported in FFA", HudPosition.LEFT, -20, null, null, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
    disableScoring()
    disableGamemodeCompletion()
    disableMusic()
    disableAnnouncer()
    disableInspector()
    # Set the countdown to be a bit longer to let players who haven't loaded the map yet load in
    setMatchTime(10)
    createInWorldText(getAllPlayers(), "I'm so sorry. (I'm not sorry)", hostPlayer.getEyePosition() + vect(0, 0.5, 0), 5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, Color.ORANGE, SpecVisibility.ALWAYS)
    ballHeroRegretText = getLastCreatedText()
    if torbBall == 1 and getCurrentGamemode() == Gamemode.FFA:
        ballHero = Hero.HAMMOND
        name = ballHero
    else:
        # No touchy. I'm talking to you, person thinking it's funny to put your name here. Only Torbjörn can steal credit for making my game.
        name = "Mazawrath"
        ballHero = null
    # TODO get this working
    # playerHero = [hero for hero in getAllHeroes() if hero != ballHero]
    playerHero = Hero.TORBJORN
    bouncePadStrength = 30
    ballSpeed = startingBallSpeed
    ballSpawnSpeed = 30
    if arenaType == 2:
        if (getCurrentMap() == Map.WORKSHOP_EXPANSE or getCurrentMap() == Map.WORKSHOP_EXPANSE_NIGHT) == true:
            centerOffLimitsSize = 20
        else: 
            centerOffLimitsSize = 12.5
    else:
        centerOffLimitsSize = 3.5
    spawnPoints = [vect(circleCenter.x + 12, circleCenter.y, 0), vect(circleCenter.x - 12, circleCenter.y, 0), vect(0, circleCenter.y, circleCenter.z + 12), vect(0, circleCenter.y, circleCenter.z - 12), vect(circleCenter.x + 12, circleCenter.y, circleCenter.z + 12), vect(circleCenter.x + 12, circleCenter.y, circleCenter.z - 12), vect(circleCenter.x - 12, circleCenter.y, circleCenter.z + 12), vect(circleCenter.x - 12, circleCenter.y, circleCenter.z - 12), vect(circleCenter.x + 12, circleCenter.y, circleCenter.z + 6), vect(circleCenter.x - 12, circleCenter.y, circleCenter.z - 6), vect(circleCenter.x + 12, circleCenter.y, circleCenter.z - 6), vect(circleCenter.x - 12, circleCenter.y, circleCenter.z + 6)]
    isInFinalDuel = false
    bouncePadCooldownLengthStart = 3
    bouncePadCooldownLength = 3
    bouncePadSuperjumpNerf = 6
    ballPosition = vect(0, -1, 0)
    explosionSoundVolume = 30
    improvedExplosions = true
    randomExplosionSounds = true
    cooldownDashingEnabled = true
    passingDamage = 100
    isPassingTeam1 = false
    isPassingTeam2 = false
    passingPlayer = null
    currentRound = 1
    breakLength = 120
    maxRoundsToggle = false
    gimmickName = "Nothing"
    if getCurrentGamemode() == Gamemode.FFA:
        if tournamentMode:
            maxRoundsToggle = true
            gameEndEnabled = false
        else:    
            gameEndEnabled = true
    # Using passing with retro ruleset DOES NOT work
    if rulesetMode == 1 and passingEnabled and getCurrentGamemode() == Gamemode.FFA:
        passingEnabled = false
        hudSubtext(hostPlayer, "Hi host. Very clever idea but sorry retro rules totally breaks self passing. Like, what do you think it can even do? The ball can only go in a straight direction and self passing sends the ball away from you and then curves around so in this case where would it even go? In your head. That's where it goes. I tested it. So you don't have to.", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    createEffect([], Effect.SPHERE, false, Vector.DOWN, false, EffectReeval.NONE)
    destroyEffect(getLastCreatedEntity())
    entityReference = getLastCreatedEntity()


rule "Create game sphere":
    createEffect(getAllPlayers(), Effect.SPHERE, Color.BLACK, vect(circleCenter.x, circleCenter.y - 0, circleCenter.z), centerOffLimitsSize, EffectReeval.VISIBILITY)
    #Workshop Island doesn't need a circle.
    if getCurrentMap() != Map.WORKSHOP_ISLAND and getCurrentMap() != Map.WORKSHOP_ISLAND_NIGHT:
        createEffect(getAllPlayers(), Effect.LIGHT_SHAFT, Color.ORANGE, vect(circleCenter.x, circleCenter.y - 25, circleCenter.z), sphereSize, EffectReeval.VISIBILITY)
    else:
        createEffect([player for player in getAllPlayers() if distance(player.getPosition(), circleCenter) >= sphereSize - 10], Effect.LIGHT_SHAFT, Color.BLUE, vect(circleCenter.x, circleCenter.y - 15, circleCenter.z), sphereSize, EffectReeval.VISIBILITY)


rule "Create global HUD elements":
    # hudText(getAllPlayers(), null, null, "BETA BUILD - NOT FULLY TESTED - CHANGES ARE NOT FINAL", HudPosition.LEFT, -20, null, null, Color.AQUA, HudReeval.VISIBILITY, SpecVisibility.ALWAYS)
    if getCurrentGamemode() == Gamemode.FFA:
        #white normal
        hudSubheader(getAllPlayers().exclude(targetedPlayer) if localPlayer in getAllPlayers() else [], "Current Player Targeted: {0}".format(targetedPlayer), HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    if getCurrentGamemode() == Gamemode.TDM:
        #white normal
        hudSubheader([player for player in getAllPlayers() if player != targetedPlayer and player.getTeam() != targetedPlayer.getTeam()], "Current Player Targeted: {0}".format(targetedPlayer), HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
        #sky blue targeting teammate
        hudSubheader([player for player in getAllPlayers() if player != targetedPlayer and player.getTeam() == targetedPlayer.getTeam()], "Current Player Targeted: {0}".format(targetedPlayer), HudPosition.LEFT, -2, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #red when you're targeted
    hudSubheader(targetedPlayer if localPlayer in getAllPlayers() else [], "Current Player Targeted: {0}".format(targetedPlayer), HudPosition.LEFT, -2, Color.RED, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    if bouncepadDashingEnabled or cooldownDashingEnabled:
        goto lbl_0
    #hudSubtext(getAllPlayers(), "Current Dashing Mode: None", HudPosition.LEFT, -1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #return
    lbl_0:
    #if cooldownDashingEnabled:
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
    hudSubtext(getAllPlayers(), "Current Ball Speed: {0}".format(ballSpeed), HudPosition.LEFT, -3, rgb(max(0,min(4000 / 3 / (maxBallSpeed - ballSpawnSpeed) * (ballSpeed - ballSpawnSpeed) - 200, 200)) + 55 * (ballSpeed != maxBallSpeed), max(55, min(455 - 2000 / 3 / (maxBallSpeed - ballSpawnSpeed) * (ballSpeed - ballSpawnSpeed), 255)) + min(2000 / 3 / (maxBallSpeed - ballSpawnSpeed) * (ballSpeed - ballSpawnSpeed) - 100, 0), max(55, 500 / (maxBallSpeed - ballSpawnSpeed) * (ballSpeed - ballSpawnSpeed) - 245) - min(1600000 / 27 / (maxBallSpeed - ballSpawnSpeed)**3 * (ballSpeed - ballSpawnSpeed)**3 - 200, 0)), HudReeval.VISIBILITY_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    #hudSubheader(getAllPlayers(), "Updates by u/FearlessKat, u/Blink, u/TheRedstoneBlaze, tumtum9000#1232,david8686406#1523", HudPosition.LEFT, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    hudSubheader(getAllPlayers(), "Current Gimimck: {0}".format(gimmickName), HudPosition.LEFT, 0, [Color.LIME_GREEN if gimmickName == "Nothing" else ballTail1], HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.DEFAULT)
    createInWorldText([player for player in getAllPlayers() if ballSpawnCountdown != 0 and player != targetedPlayer], "Ball Spawning In: {0}".format(ceil(ballSpawnCountdown)), vect(circleCenter.x, circleCenter.y + 2.5, circleCenter.z), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_STRING_AND_COLOR, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    createInWorldText([player for player in targetedPlayer if ballSpawnCountdown != 0], "Ball Spawning In: {0}".format(ceil(ballSpawnCountdown)), updateEveryTick(vect(circleCenter.x, circleCenter.y + 2.5, circleCenter.z) + directionTowards(vect(circleCenter.x, circleCenter.y + 2.5, circleCenter.z), targetedPlayer.getEyePosition()) / 50), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, rgb(255 , 50, 50), SpecVisibility.DEFAULT)
    if rulesetMode == 1:
        if getCurrentGamemode() == Gamemode.FFA:
            hudSubheader(getAllPlayers(), "Retro ruleset. Dash deflecting is disabled.", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
        else:
            hudSubheader(getAllPlayers(), "Retro ruleset. Dash deflecting & self passing are disabled.", HudPosition.RIGHT, 0, Color.WHITE, HudReeval.VISIBILITY, SpecVisibility.DEFAULT)
    if tournamentMode:
        hudSubheader(getAllPlayers(), "Tourney Mode. Rounds Remaining: {0}".format(maxRounds - currentRound + 1), HudPosition.LEFT, -10, Color.AQUA, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "Create player HUD elements":
    @Event eachPlayer
    @Hero all
    @Condition rulesetMode != 2

    hudSubheader(eventPlayer if localPlayer in getAllPlayers() else [], "Lag o-rama (DO NOT TOUCH!!!!!) [{0}]: {1}".format(buttonString(Button.ULTIMATE), "On" if eventPlayer.latencyToggle else "Off"), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    if (perspectiveMode == 0):
        hudSubheader(eventPlayer if localPlayer in getAllPlayers() else [], "Third person: [{0}]".format(buttonString(Button.RELOAD)), HudPosition.LEFT, 1, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    #hudText(eventPlayer, eventPlayer.playerDeflects, "Deflects", null, HudPosition.LEFT, 1, Color.YELLOW, Color.WHITE, Color.YELLOW, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #eventPlayer.playerUI[1] = getLastCreatedEntity()
    #hudText(eventPlayer, eventPlayer.playerKills, "Kills", null, HudPosition.LEFT, 2, Color.ORANGE, Color.WHITE, Color.ORANGE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #eventPlayer.playerUI[2] = getLastCreatedEntity()
    #hudText(eventPlayer, eventPlayer.playerDeaths, "Deaths", null, HudPosition.LEFT, 3, Color.SKY_BLUE, Color.WHITE, Color.SKY_BLUE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #eventPlayer.playerUI[3] = getLastCreatedEntity()
    #hudText(eventPlayer, eventPlayer.maxBallSpeed, "Max Deflect Speed", null, HudPosition.LEFT, 4, Color.RED, Color.WHITE, Color.TURQUOISE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #eventPlayer.playerUI[4] = getLastCreatedEntity()
    #hudText(eventPlayer, ceil(eventPlayer.bouncePadCooldown), "Bouncepad", "Cooldown", HudPosition.RIGHT, -1, Color.GREEN, Color.WHITE, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    #eventPlayer.playerUI[5] = getLastCreatedEntity()


rule "Create bounce pads":
    @Condition bouncePadToggle
    
    if arenaType == 0:
        bouncePadDistance = 12
        bouncePadRange = 2.75

        bouncePad1 = vect(circleCenter.x + bouncePadDistance, circleCenter.y, circleCenter.z)
        bouncePad2 = vect(circleCenter.x + bouncePadDistance * -1, circleCenter.y, circleCenter.z)
        bouncePad3 = vect(circleCenter.x, circleCenter.y, circleCenter.z + bouncePadDistance * 1)
        bouncePad4 = vect(circleCenter.x, circleCenter.y, circleCenter.z + bouncePadDistance * -1)

        # Bouncepad ready
        createEffect([player for player in getAllPlayers() if player.bouncePadCooldown == 0], Effect.RING, Color.SKY_BLUE, bouncePad1, 2, EffectReeval.VISIBILITY)
        createEffect([player for player in getAllPlayers() if player.bouncePadCooldown == 0], Effect.RING, Color.SKY_BLUE, bouncePad2, 2, EffectReeval.VISIBILITY)
        createEffect([player for player in getAllPlayers() if player.bouncePadCooldown == 0], Effect.RING, Color.SKY_BLUE, bouncePad3, 2, EffectReeval.VISIBILITY)
        createEffect([player for player in getAllPlayers() if player.bouncePadCooldown == 0], Effect.RING, Color.SKY_BLUE, bouncePad4, 2, EffectReeval.VISIBILITY)

        # Bouncepad not ready
        createEffect([player for player in getAllPlayers() if player.bouncePadCooldown > 0], Effect.RING, Color.WHITE, bouncePad1, 2, EffectReeval.VISIBILITY)
        createEffect([player for player in getAllPlayers() if player.bouncePadCooldown > 0], Effect.RING, Color.WHITE, bouncePad2, 2, EffectReeval.VISIBILITY)
        createEffect([player for player in getAllPlayers() if player.bouncePadCooldown > 0], Effect.RING, Color.WHITE, bouncePad3, 2, EffectReeval.VISIBILITY)
        createEffect([player for player in getAllPlayers() if player.bouncePadCooldown > 0], Effect.RING, Color.WHITE, bouncePad4, 2, EffectReeval.VISIBILITY)
    elif arenaType == 1:
        bouncePadDistance = 0
        bouncePadRange = 20.75
        
        bouncePad1 = vect(circleCenter.x + bouncePadDistance, circleCenter.y, circleCenter.z)

        #Bouncepad ready
        createEffect([player for player in getAllPlayers() if player.bouncePadCooldown == 0], Effect.RING, Color.SKY_BLUE, bouncePad1, 20, EffectReeval.VISIBILITY)

        #Bouncepad not ready
        createEffect([player for player in getAllPlayers() if player.bouncePadCooldown > 0], Effect.RING, Color.WHITE, bouncePad1, 20, EffectReeval.VISIBILITY)


rule "Create ball & targeted effect":
    @Condition isGameInProgress() == true
    @Condition getCurrentGamemode() == Gamemode.FFA
    
    if not ballHero and not invisibleBall:
        #Orb for when ball is not getting passed
        createEffect(updateEveryTick(getAllPlayers().exclude(targetedPlayer) if not isSpectator(localPlayer) and localPlayer.isAlive() and localPlayer.latencyToggle else []), Effect.ORB, ballTail1, updateEveryTick(ballPosition), 0.4, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
        createEffect(updateEveryTick(getAllPlayers().exclude(targetedPlayer) if not (isSpectator(localPlayer) or (localPlayer.isAlive() and localPlayer.latencyToggle)) else []), Effect.ORB, ballTail1, ballPosition, 0.4, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
        createEffect(updateEveryTick(targetedPlayer if not isSpectator(localPlayer) and localPlayer.isAlive() and localPlayer.latencyToggle else []), Effect.ORB, Color.YELLOW if redGreenColorblindMode else Color.RED, updateEveryTick(ballPosition + ballSpeed * normalize(ballDirection) * (localPlayer.latency if ballSpawnCountdown == 0 else 0)), 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(updateEveryTick(targetedPlayer if not (isSpectator(localPlayer) or (localPlayer.isAlive() and localPlayer.latencyToggle)) else []), Effect.ORB, Color.YELLOW if redGreenColorblindMode else Color.RED, ballPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    if not invisiblePlayers:
        createEffect(getAllPlayers().exclude(targetedPlayer), Effect.GOOD_AURA, Color.YELLOW if redGreenColorblindMode else Color.RED, updateEveryTick(targetedPlayer.getPosition() + Vector.UP), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        # Can't have an else if for deciding the color, only if else so just make a basic check for colorblind mode otherwise use the more complex first/third color
        if redGreenColorblindMode:
            createEffect(targetedPlayer, Effect.GOOD_AURA, Color.YELLOW, updateEveryTick(targetedPlayer.getPosition() + Vector.UP), 0.5 if targetedPlayer.thirdPerson else 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        else:
            createEffect(targetedPlayer, Effect.GOOD_AURA, Color.RED, updateEveryTick(targetedPlayer.getPosition() + Vector.UP), 0.5 if targetedPlayer.thirdPerson else 1, EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
    if not invisibleBall:
        createEffect(updateEveryTick(targetedPlayer if localPlayer in getAllPlayers() and localPlayer.isAlive() and localPlayer.latencyToggle else []), Effect.GOOD_AURA, Color.YELLOW if redGreenColorblindMode else Color.RED, updateEveryTick(ballPosition + ballSpeed * normalize(ballDirection) * (localPlayer.latency if ballSpawnCountdown == 0 else 0)), 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
        createEffect(updateEveryTick(targetedPlayer if localPlayer in getAllPlayers() and not (localPlayer.isAlive() and localPlayer.latencyToggle) else []), Effect.GOOD_AURA, Color.YELLOW if redGreenColorblindMode else Color.RED, ballPosition, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)

    createEffect(getAllPlayers(), Effect.BAD_AURA_SOUND, Color.AQUA, ballPosition, 1000, EffectReeval.POSITION_AND_RADIUS)


rule "Ball tail effects":
    @Condition not invisibleBall

    createBeam(updateEveryTick(getAllPlayers() if not isSpectator(localPlayer) and localPlayer.isAlive() and localPlayer.latencyToggle else []), Beam.BAD, prevBallPos, [updateEveryTick(i) if distance(localPlayer.getEyePosition(), i) < 17.8 else i for i in (ballPosition + ballSpeed * normalize(ballDirection) * localPlayer.latency if targetedPlayer == localPlayer and ballSpawnCountdown == 0 else ballPosition)], [Color.SKY_BLUE, Color.YELLOW, ballTail1][ballTailColor], EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
    createBeam(updateEveryTick([not (not isSpectator(localPlayer) and localPlayer.isAlive() and localPlayer.latencyToggle)]), Beam.BAD, prevBallPos, ballPosition, [Color.SKY_BLUE, Color.YELLOW, ballTail2][ballTailColor], EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR)
    createBeam(getAllPlayers(), Beam.BAD, prevBallPos2, prevBallPos, [Color.SKY_BLUE, Color.YELLOW, ballTail2][ballTailColor], EffectReeval.VISIBILITY_POSITION_RADIUS_AND_COLOR) 


rule "Spectator effects and HUD":
    hudSubheader(updateEveryTick([isSpectator(localPlayer)]), "Current Player Targeted: {0}".format(targetedPlayer), HudPosition.LEFT, -2, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)
    createInWorldText(updateEveryTick([ballSpawnCountdown != 0 and isSpectator(localPlayer)]), "Ball Spawning In: {0}".format(ceil(ballSpawnCountdown)), vect(circleCenter.x, circleCenter.y + 2.5, circleCenter.z), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_STRING, Color.SKY_BLUE, SpecVisibility.DEFAULT)
    if ballHero or invisibleBall:
        return
    waitUntil(isGameInProgress(), 99999)
    createEffect(updateEveryTick([isSpectator(localPlayer)]), Effect.ORB, Color.WHITE, ballPosition, 0.4, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
     

rule "Set time to 0 if teams and game end disabled":
    @Condition getCurrentGamemode() == Gamemode.TDM
    @Condition not gameEndEnabled
    @Condition isGameInProgress()

    setMatchTime(0)