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
        LongFun()
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


def LongFun():
    @Name "Hero ball do a long super fun thing"
    ballHeroRandom = random.randint(0, 100)
    # Only have a 50% chance of doing a fun thing
    if random.randint(0,1):
        return
    switch random.randint(1, 10):
        case 1:
            # SPEEN
            ballPlayer.setFacing(vect(0, 0, 0), Relativity.TO_PLAYER)
            ballPlayer.startFacing(ballPlayer.getFacingDirection() + Vector.LEFT, 1000, Relativity.TO_PLAYER, FacingReeval.DIRECTION_AND_TURN_RATE)
            wait(1.5)
            createInWorldText(getAllPlayers(), "Torbcopter, ready for takeoff.", ballPlayer.getPosition(), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.ORANGE, SpecVisibility.ALWAYS)
            ballHeroRegretText = getLastCreatedText()
            while ballPlayerMock:
                ballPlayer.applyImpulse(Vector.UP, 10, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                wait(0.5)
            destroyInWorldText(ballHeroRegretText)
            break
        case 2:
            # Hammer their dead body
            wait(0.5)
            ballPlayer.communicate(Comms.NO)
            ballPlayer.setWeapon(2)
            ballPlayer.forceButtonPress(Button.ABILITY_1)
            ballPlayer.startForcingButton(Button.PRIMARY_FIRE)
            waitUntil(not ballPlayerMock, 9999)
            ballPlayer.stopForcingButton(Button.PRIMARY_FIRE)
            ballPlayer.setWeapon(random.randint(0, 1))
            ballPlayer.forceButtonPress(Button.INTERACT)
            break
        case 3:
            # That was so boring that Torb is going to take a nap
            ballPlayer.setStatusEffect(null, Status.ASLEEP, 9999)
            wait(0.5)
            ballPlayer.communicate(Comms.GOODBYE)
            waitUntil(not ballPlayerMock, 9999)
            ballPlayer.clearStatusEffect(Status.ASLEEP)
            break
        case 4:
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
        case 5:
            ballPlayer.setUltCharge(100)
            ballPlayer.startForcingButton(Button.ULTIMATE)
            ballPlayer.setGravity(0)
            ballPlayer.applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.BACKWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.FORWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.RIGHT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.LEFT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.DOWN, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.teleport(circleCenter + vect(0,5,0))
            wait(1)
            while ballPlayer.isUsingUltimate() and ballPlayerMock:
                ballPlayer.setFacing(directionTowards(ballPlayer.getEyePosition(), vect(random.uniform(-20, 20), random.uniform(0, 5), random.uniform(-20, 20))), Relativity.TO_WORLD)
                wait(0.05)
                ballPlayer.stopForcingButton(Button.ULTIMATE)
                ballPlayer.forceButtonPress(Button.PRIMARY_FIRE)
            ballPlayer.startFacing(ballPlayer.getFacingDirection() + Vector.LEFT, 500, Relativity.TO_PLAYER, FacingReeval.DIRECTION_AND_TURN_RATE)
            break
        case 6:
            ballPlayer.setMoveSpeed(500)
            ballHeroRandom = vect(random.uniform(-20, 20), 1, random.uniform(-20, 20))
            ballPlayer.startThrottleInDirection(directionTowards(ballPlayer.getPosition(), ballHeroRandom), 1, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)
            ballPlayer.startFacing(directionTowards(ballPlayer.getEyePosition(), ballHeroRandom), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
            createInWorldText(getAllPlayers(), "Zip zoom".format(ballHeroRandom), ballPlayer.getEyePosition() + vect(0, 1, 0), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, Color.ORANGE, SpecVisibility.ALWAYS)
            ballHeroRegretText = getLastCreatedText()
            while ballPlayerMock:
                if (distance(ballPlayer.getPosition(), ballHeroRandom) <  7):
                    ballHeroRandom = vect(random.uniform(-20, 20), 1, random.uniform(-20, 20))
                wait(0.1)
            destroyInWorldText(ballHeroRegretText)
            ballPlayer.stopThrottleInDirection()
            ballPlayer.setMoveSpeed(100)
            break
        case 7:
            # nice
            if (ballHeroRandom == 69):
                # HYPER TBAG!
                ballPlayer.setWeapon(2)
                while ballPlayerMock == true:
                    ballPlayer.communicate(Comms.YES)
                    wait(0.05)
                    ballPlayer.startForcingButton(Button.CROUCH)
                    wait(0.05)
                    ballPlayer.stopForcingButton(Button.CROUCH)
            else:
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
            break
        case 8:
            wait(1)
            ballHeroRandom = random.choice(getPlayersOnHero(playerHero, Team.ALL))
            ballPlayer.enablePlayerCollision()
            ballPlayer.setMoveSpeed(150)
            ballPlayer.startThrottleInDirection(directionTowards(ballPlayer.getPosition(), ballHeroRandom.getPosition()), 1, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)
            ballPlayer.startFacing(directionTowards(ballPlayer.getEyePosition(), ballHeroRandom.getEyePosition()), 500, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
            ballPlayer.setWeapon(2)
            ballPlayer.startForcingButton(Button.PRIMARY_FIRE)
            createInWorldText(getAllPlayers(), "Come here {0}, I'll fix you right up!".format(ballHeroRandom), ballPlayer.getEyePosition() + vect(0, 1, 0), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, Color.ORANGE, SpecVisibility.ALWAYS)
            ballHeroRegretText = getLastCreatedText()
            waitUntil(not ballPlayerMock, 9999)
            ballPlayer.disablePlayerCollision()
            ballPlayer.stopThrottleInDirection()
            ballPlayer.setMoveSpeed(100)
            ballPlayer.stopForcingButton(Button.PRIMARY_FIRE)
            ballPlayer.setWeapon(random.randint(0, 1))
            destroyInWorldText(ballHeroRegretText)
            break
        case 9:
            ballPlayer.applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.BACKWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.FORWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.RIGHT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.LEFT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.DOWN, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.teleport(circleCenter + vect(0,5,0))
            ballPlayer.stopFacing()
            ballHeroRandom = 0
            chase(ballHeroRandom, 2, duration=7.5, ChaseReeval.NONE)
            ballHeroRegretText = 0.75
            ballPlayer.startScalingSize(ballHeroRandom, true)
            ballPlayer.startModifyingVoicelinePitch(ballHeroRandom, true)
            ballHeroRegretText = 0.75
            chase(ballHeroRegretText, 0.05, duration=15, ChaseReeval.NONE)
            while ballPlayerMock:
                ballPlayer.setFacing(directionTowards(ballPlayer.getEyePosition(), random.choice(getPlayersOnHero(playerHero, Team.ALL)).getEyePosition()), Relativity.TO_WORLD)
                ballPlayer.communicate(Comms.HELLO)
                waitUntil(not ballPlayerMock, ballHeroRegretText)
            ballPlayer.startScalingSize(1, false)
            stopChasingVariable(ballHeroRandom)
            stopChasingVariable(ballHeroRegretText)
            break
        case 10:
            wait(0.25)
            ballHeroRandom = targetedPlayer
            ballPlayer.startForcingPosition(ballHeroRandom.getEyePosition() + (ballHeroRandom.getFacingDirection() * 1), true)
            ballPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 9999)
            smallMessage(ballHeroRandom, "Press reload to yeet Torbjörn")
            waitUntil(ballHeroRandom.isHoldingButton(Button.RELOAD) or not ballPlayerMock, 5)
            ballPlayer.stopForcingPosition()
            ballPlayer.applyImpulse(directionTowards(ballPlayer.getPosition(), raycast(ballHeroRandom.getEyePosition(), ballHeroRandom.getEyePosition() + (ballHeroRandom.getFacingDirection() * 100), getPlayersOnHero(playerHero, Team.ALL), [ballHeroRandom, ballPlayer], true).getHitPosition()), 75    , Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            waitUntil(not ballPlayerMock, 5)
            ballPlayer.clearStatusEffect(Status.KNOCKED_DOWN)



def ShortFun():
    @Name "Hero ball do a quick fun thing"

    # Only have a 10% chance of doing a fun thing
    if (random.randint(1, 100) <= 90):
        return
    ballHeroRandom = random.randint(0, 100)
    switch random.randint(1, 6):
        case 1:
            # nice
            if (ballHeroRandom == 69):
                ballSpawnCountdown = 5
                # HYPER TBAG!
                ballPlayer.setWeapon(2)
                while ballPlayerMock == true:
                    ballPlayer.communicate(Comms.YES)
                    wait(0.05)
                    ballPlayer.startForcingButton(Button.CROUCH)
                    wait(0.05)
                    ballPlayer.stopForcingButton(Button.CROUCH)
            else:
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
            break
        case 2:
            # Hammer their dead body
            wait(0.5)
            ballPlayer.communicate(Comms.NO)
            ballPlayer.setWeapon(2)
            ballPlayer.startForcingButton(Button.PRIMARY_FIRE)
            waitUntil(not ballPlayerMock, 9999)
            ballPlayer.stopForcingButton(Button.PRIMARY_FIRE)
            ballPlayer.setWeapon(random.randint(0, 1))
            ballPlayer.forceButtonPress(Button.INTERACT)
            break
        case 3:
            # That was so boring Torb is going to take a nap
            ballPlayer.setStatusEffect(null, Status.ASLEEP, 9999)
            wait(0.5)
            ballPlayer.communicate(Comms.GOODBYE)
            waitUntil(not ballPlayerMock, 9999)
            ballPlayer.clearStatusEffect(Status.ASLEEP)
            break
        case 4:
            # Torb is not joking around.
            ballPlayer.startFacing(directionTowards(ballPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
            waitUntil(targetedPlayer != "-1", 9999)
            createInWorldText(getAllPlayers(), "You're next, {0}.".format(targetedPlayer), ballPlayer.getEyePosition() + vect(0, 0.5, 0), 3, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.RED, SpecVisibility.ALWAYS)
            ballHeroRegretText = getLastCreatedText()
            waitUntil(not ballPlayerMock, 9999)
            destroyInWorldText(ballHeroRegretText)
            break
        case 5:
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
        case 6:
            # SPEEN
            ballPlayer.setFacing(vect(0, 0, 0), Relativity.TO_PLAYER)
            ballPlayer.startFacing(ballPlayer.getFacingDirection() + Vector.LEFT, 500, Relativity.TO_PLAYER, FacingReeval.DIRECTION_AND_TURN_RATE) 
