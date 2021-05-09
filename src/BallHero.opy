rule "Create hero ball":
    @Condition ballHero != null

    createDummy(ballHero, Team.ALL, 14, circleCenter, vect(0, 0, 0))


rule "Init ball":
    @Event eachPlayer
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero

    eventPlayer.startForcingPosition(ballPosition, true)