#!mainFile "./Genji-Dodgeball.opy"

rule "Create hero ball":
    @Condition ballHero != null

    #getAllPlayers().startFacing(directionTowards([getAllPlayers() player in player], getPlayersOnHero(ballHero)), 1000, Relativity.TO_WORLD, FacingReeval.NONE)
    createDummy(ballHero, Team.ALL, 14, circleCenter, vect(0, 0, 0))
    waitUntil(hostPlayer.hasSpawned(), 9999)
    getPlayersOnHero(ballHero, Team.ALL).startFacing(directionTowards(getPlayersOnHero(ballHero, Team.ALL).getEyePosition(), hostPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    ballPlayer = getPlayersOnHero(ballHero, Team.ALL)[0]
    switch random.randint(1, 21):
        case 1:
            startingText = "People always underestimate the engineers!"
            break
        case 2:
            startingText = "I'm giving it all I've got!"
            break
        case 3:
            startingText = "I'd rather be the hammer, than the nail."
            break
        case 4:
            startingText = "My baby!"
            break
        case 5:
            startingText = "Build 'em up, break 'em down!"
            break
        case 6:
            startingText = "Heh, time to roll up my sleeves!"
            break
        case 7:
            startingText = "Time to get my hands dirty."
            break
        case 8:
            startingText = "Torbjörn! Ready to work!"
            break
        case 9:
            startingText = "You're making a chicken out of a feather."
            break
        case 10:
            startingText = "Du gör en höna av en fjäder."
            break
        case 11:
            startingText = "Fastna inte med skägget i brevlådan."
            break
        case 12:
            startingText = "Köp inte grisen i säcken."
            break
        case 13:
            startingText = "De är som en katt som går runt het gröt!"
            break
        case 14:
            startingText = "Too hot for you?"
            break
        case 15:
            startingText = "Bingo!"
            break
        case 16:
            startingText = "For the last time, I'm Swedish!"
            break
        case 17:
            startingText = "Ha ha! There's more where that came from."
            break
        case 18:
            startingText = "Tehh... Poor craftsmen blames their tools..."
            break
        case 19:
            startingText = "Just start hammering."
            break
        case 20:
            startingText = "I smell trouble brewing"
            break
        case 21:
            startingText = "There's no prize for coming in second"
            break
    createInWorldText(getAllPlayers(), startingText, ballPlayer.getEyePosition() + vect(0, 0.5, 0), 5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, Color.ORANGE, SpecVisibility.ALWAYS)
    ballHeroRegretText = getLastCreatedText()


rule "Init hero ball":
    @Event eachPlayer
    @Condition ballHero
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero

    destroyInWorldText(ballHeroRegretText)
    eventPlayer.stopFacing()
    eventPlayer.setGravity(0)
    eventPlayer.disablePlayerCollision()
    # eventPlayer.startForcingPosition(updateEveryTick(ballPosition) + vect(0, -1, 0) , true)
    wait(0.5)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)


rule "Teleport hero ball":
    @Event eachPlayer
    @Condition ballHero
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero
    @Condition not ballPlayerMock

    eventPlayer.teleport(ballPosition - vect(0, 1, 0))
    wait(0.001)
    if RULE_CONDITION:
        goto RULE_START


rule "Don't move while ball isn't in play":
    @Event eachPlayer
    @Condition ballHero
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero
    @Condition ballPlayerMock

    eventPlayer.setGravity(100)
    waitUntil(not ballPlayerMock, 9999)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    eventPlayer.setGravity(0)


rule "Set hero ball outline":
    @Event eachPlayer
    @Condition ballHero
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero

    ballPlayer.startForcingOutlineFor([player for player in getAllPlayers() if player != targetedPlayer], true, Color.WHITE, OutlineVisibility.DEFAULT)
    ballPlayer.startForcingOutlineFor([player for player in getAllPlayers() if player == targetedPlayer], true, Color.RED, OutlineVisibility.DEFAULT)
    wait(0.1)
    goto RULE_START


#!include "./Fun.opy"