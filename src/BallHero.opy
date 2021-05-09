rule "Create hero ball":
    @Condition ballHero != null

    #getAllPlayers().startFacing(directionTowards([getAllPlayers() player in player], getPlayersOnHero(ballHero)), 1000, Relativity.TO_WORLD, FacingReeval.NONE)
    createDummy(ballHero, Team.ALL, 14, circleCenter, vect(0, 0, 0))


rule "Init ball":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero

    eventPlayer.setGravity(0)
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 9999)
    eventPlayer.startForcingPosition(ballPosition, true)