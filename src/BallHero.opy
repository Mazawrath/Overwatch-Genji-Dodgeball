rule "Create hero ball":
    @Condition ballHero != null

    #getAllPlayers().startFacing(directionTowards([getAllPlayers() player in player], getPlayersOnHero(ballHero)), 1000, Relativity.TO_WORLD, FacingReeval.NONE)
    createDummy(ballHero, Team.ALL, 14, circleCenter, vect(0, 0, 0))
    waitUntil(hostPlayer.hasSpawned(), 9999)
    getPlayersOnHero(ballHero, Team.ALL).startFacing(directionTowards(getPlayersOnHero(ballHero, Team.ALL).getEyePosition(), hostPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    ballPlayer = getPlayersOnHero(ballHero, Team.ALL)[0]
    createInWorldText(getAllPlayers(), "You have just made the biggest mistake in your life", ballPlayer.getEyePosition() + vect(0, 0.5, 0), 5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, Color.RED, SpecVisibility.ALWAYS)
    ballHeroRegretText = getLastCreatedText()

rule "Init hero ball":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero

    destroyInWorldText(ballHeroRegretText)
    eventPlayer.stopFacing()
    eventPlayer.setGravity(0)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    # eventPlayer.startForcingPosition(updateEveryTick(ballPosition) + vect(0, -1, 0) , true)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)


rule "Teleport hero ball":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero

    if (ballPlayerMock == true):
        eventPlayer.setGravity(100)
        waitUntil(ballPlayerMock == false, 9999)
        eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
        eventPlayer.setGravity(0)
    eventPlayer.teleport(ballPosition - vect(0, 1, 0))
    wait(0.001)
    goto RULE_START


rule "Set hero ball outline":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero

    ballPlayer.startForcingOutlineFor([player for player in getAllPlayers() if player != targetedPlayer], true, Color.WHITE, OutlineVisibility.DEFAULT)
    ballPlayer.startForcingOutlineFor([player for player in getAllPlayers() if player == targetedPlayer], true, Color.RED, OutlineVisibility.DEFAULT)
    wait(0.1)
    goto RULE_START


rule "Hero ball tbag":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == ballHero
    @Condition ballPlayerMock == true

    if (random.randint(0, 100) <= 5):
        ballPlayer.communicate(Comms.YES)
        ballPlayer.setWeapon(2)
        ballPlayer.startForcingButton(Button.PRIMARY_FIRE)
        while ballPlayerMock == true:
            wait(0.1)
            ballPlayer.startForcingButton(Button.CROUCH)
            wait(0.1)
            ballPlayer.stopForcingButton(Button.CROUCH)
        ballPlayer.stopForcingButton(Button.PRIMARY_FIRE)
        ballPlayer.setWeapon(random.randint(0, 1))


rule "Hero ball whack":
    @Event eachPlayer
    @Condition eventPlayer.getCurrentHero() == ballHero
    @Condition ballPlayerMock == true

    if (random.randint(0, 100) <= 10):
        wait(0.5)
        ballPlayer.communicate(Comms.YES)
        ballPlayer.setWeapon(2)
        ballPlayer.startForcingButton(Button.PRIMARY_FIRE)
        waitUntil(not ballPlayerMock, 9999)
        ballPlayer.stopForcingButton(Button.PRIMARY_FIRE)
        ballPlayer.setWeapon(random.randint(0, 1))