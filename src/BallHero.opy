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
    @Condition ballHero
    @Condition isGameInProgress()
    @Condition eventPlayer.getCurrentHero() == ballHero

    ballPlayer.startForcingOutlineFor([player for player in getAllPlayers() if player != targetedPlayer], true, Color.WHITE, OutlineVisibility.DEFAULT)
    ballPlayer.startForcingOutlineFor([player for player in getAllPlayers() if player == targetedPlayer], true, Color.RED, OutlineVisibility.DEFAULT)
    wait(0.1)
    goto RULE_START


rule "Hero ball do funny thing":
    @Event eachPlayer
    @Condition ballHero
    @Condition eventPlayer.getCurrentHero() == ballHero
    @Condition ballPlayerMock == true

    if (random.randint(0, 100) <= 80):
        if (random.randint(0, 1)):
            ballPlayer.communicate(Comms.SORRY)
        else:
            ballPlayer.communicate(Comms.YOURE_WELCOME)

    if (wasFinalDuel):
        wasFinalDuel = false
        SuperFun()
    elif (not isInFinalDuel):
        ShortFun()
    else:
        wasFinalDuel = true
        ballPlayer.applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        ballPlayer.applyImpulse(Vector.BACKWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        ballPlayer.applyImpulse(Vector.FORWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        ballPlayer.applyImpulse(Vector.RIGHT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        ballPlayer.applyImpulse(Vector.LEFT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        ballPlayer.applyImpulse(Vector.DOWN, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        ballPlayer.teleport(circleCenter + vect(0,5,0))
        ballPlayer.startFacing(directionTowards(ballPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 500, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    waitUntil(not ballPlayerMock, 9999)

    #do a funny thing maybe.
    ballHeroRandom = random.randint(0, 100)
    if (ballHeroRandom <= 3):
        ballPlayer.setStatusEffect(null, Status.FROZEN, random.randint(10, 60))
    elif (ballHeroRandom >= 5 and ballHeroRandom <= 8):
        ballPlayer.setStatusEffect(null, Status.BURNING, random.randint(10, 60))
    elif (ballHeroRandom >= 10 and ballHeroRandom <= 13):
        ballPlayer.setStatusEffect(null, Status.HACKED, random.randint(10, 30))
    if (random.randint(0, 100) <= 10):
        ballPlayer.communicate(Comms.HELLO)
    if (random.randint(0, 100) <= 5):
        ballPlayer.forceButtonPress(Button.ABILITY_2)


def ShortFun():
    @Name "Hero ball do a quick fun thing"
    ballHeroRandom = random.randint(0, 100)
    switch random.randint(1, 6):
        case 1:
            if (ballHeroRandom <= 10):
                ballSpawnCountdown = 5
                # Tbag them
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
            # nice
            elif (ballHeroRandom == 69):
                ballSpawnCountdown = 5
                # HYPER TBAG!
                ballPlayer.setWeapon(2)
                while ballPlayerMock == true:
                    ballPlayer.communicate(Comms.YES)
                    wait(0.05)
                    ballPlayer.startForcingButton(Button.CROUCH)
                    wait(0.05)
                    ballPlayer.stopForcingButton(Button.CROUCH)
            break
        case 2:
            if (ballHeroRandom <= 10):
                ballSpawnCountdown = 5
                # Hammer their dead body
                wait(0.5)
                ballPlayer.communicate(Comms.NO)
                ballPlayer.setWeapon(2)
                if (ballHeroRandom <= 5):
                    ballPlayer.forceButtonPress(Button.ABILITY_1)
                ballPlayer.startForcingButton(Button.PRIMARY_FIRE)
                waitUntil(not ballPlayerMock, 9999)
                ballPlayer.stopForcingButton(Button.PRIMARY_FIRE)
                ballPlayer.setWeapon(random.randint(0, 1))
                ballPlayer.forceButtonPress(Button.INTERACT)
            break
        case 3:
            if (ballHeroRandom <= 10):
                ballSpawnCountdown = 5
                # That was so boring that Torb is going to take a nap
                ballPlayer.setStatusEffect(null, Status.ASLEEP, 9999)
                wait(0.5)
                ballPlayer.communicate(Comms.GOODBYE)
                waitUntil(not ballPlayerMock, 9999)
                ballPlayer.clearStatusEffect(Status.ASLEEP)
            break
        case 4:
            if (ballHeroRandom <= 10):
                ballSpawnCountdown = 5
                # Torb is not joking around.
                ballPlayer.startFacing(directionTowards(ballPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
                waitUntil(targetedPlayer != "-1", 9999)
                createInWorldText(getAllPlayers(), "You're next, {0}.".format(targetedPlayer), ballPlayer.getEyePosition() + vect(0, 0.5, 0), 3, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.ALWAYS)
                ballHeroRegretText = getLastCreatedText()
                waitUntil(not ballPlayerMock, 9999)
                destroyInWorldText(ballHeroRegretText)
            break
        case 5:
            if (ballHeroRandom <= 10):
                ballSpawnCountdown = 5
                # SPEEN
                ballPlayer.setFacing(vect(0, 0, 0), Relativity.TO_PLAYER)
                ballPlayer.startFacing(ballPlayer.getFacingDirection() + Vector.LEFT, 1000, Relativity.TO_PLAYER, FacingReeval.DIRECTION_AND_TURN_RATE)
                wait(1)
                createInWorldText(getAllPlayers(), "Torbcopter, ready for takeoff.", ballPlayer.getPosition(), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.ORANGE, SpecVisibility.ALWAYS)
                ballHeroRegretText = getLastCreatedText()
                while ballPlayerMock:
                    ballPlayer.applyImpulse(Vector.UP, 20, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                    wait(0.5)
                destroyInWorldText(ballHeroRegretText)
            break
        case 6:
            if (ballHeroRandom <= 10):
                ballSpawnCountdown = 5
                waitUntil(targetedPlayer != "-1", 10)
                ballPlayer.setGravity(0)
                ballPlayer.startForcingPosition(targetedPlayer.getEyePosition() + vect(0, 1, 0), true)
                ballPlayer.setFacing(vect(0, -1, 0), Relativity.TO_PLAYER)
                createInWorldText(getAllPlayers(), "{0} is next, don't tell them :)".format(targetedPlayer), ballPlayer.getEyePosition() + vect(0, 0.5, 0), 3, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.SKY_BLUE, SpecVisibility.ALWAYS)
                ballHeroRegretText = getLastCreatedText()
                wait(0.5)
                ballPlayer.communicate(Comms.HELLO)
                waitUntil(not ballPlayerMock, 9999)
                destroyInWorldText(ballHeroRegretText)
                ballPlayer.stopForcingPosition()
            break
