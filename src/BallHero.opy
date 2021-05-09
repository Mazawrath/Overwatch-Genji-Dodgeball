rule "Create hero ball":
    @Condition ballHero != null

    #getAllPlayers().startFacing(directionTowards([getAllPlayers() player in player], getPlayersOnHero(ballHero)), 1000, Relativity.TO_WORLD, FacingReeval.NONE)
    createDummy(ballHero, Team.ALL, 14, circleCenter, vect(0, 0, 0))
    waitUntil(hostPlayer.hasSpawned(), 9999)
    getPlayersOnHero(ballHero, Team.ALL).startFacing(directionTowards(getPlayersOnHero(ballHero, Team.ALL).getEyePosition(), hostPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    ballPlayer = getPlayersOnHero(ballHero, Team.ALL)[0]

rule "Init ball":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero

    eventPlayer.stopFacing()
    eventPlayer.setGravity(0)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    #eventPlayer.startForcingPosition(updateEveryTick(ballPosition) + vect(0, -1, 0) , true)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)


rule "Teleport ball":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero

    eventPlayer.teleport(ballPosition - vect(0, 1, 0))
    wait(0.001)
    goto RULE_START