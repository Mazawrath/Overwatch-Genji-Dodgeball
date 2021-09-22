#!mainFile "./Genji-Dodgeball.opy"

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

    if wasFinalDuel or getNumberOfHeroes(playerHero, Team.ALL) <= 2:
        wasFinalDuel = false
        if not eventPlayer.hasStatusEffect(Status.FROZEN):
            LongFun()
    elif not isInFinalDuel:
        if not eventPlayer.hasStatusEffect(Status.FROZEN):
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
        if not eventPlayer.hasStatusEffect(Status.FROZEN):
            ballPlayer.startFacing(directionTowards(ballPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 500, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    waitUntil(not ballPlayerMock, 9999)

    #do a funny thing maybe.
    ballHeroRandom = random.randint(0, 100)
    if (ballHeroRandom <= 3):
        ballPlayer.setStatusEffect(null, Status.FROZEN, random.randint(5, 15))
    elif (ballHeroRandom >= 5 and ballHeroRandom <= 8):
        ballPlayer.setStatusEffect(null, Status.BURNING, random.randint(10, 60))
    elif (ballHeroRandom >= 10 and ballHeroRandom <= 13):
        ballPlayer.setStatusEffect(null, Status.HACKED, random.randint(10, 30))
    if (random.randint(0, 100) <= 10):
        ballPlayer.communicate(Comms.HELLO)
    if (random.randint(0, 100) <= 5):
        ballPlayer.forceButtonPress(Button.ABILITY_2)
    if (random.randint(0, 100) <= 5):
        ballPlayer.startModifyingVoicelinePitch(random.uniform(0, 2), false)
    else:
        ballPlayer.startModifyingVoicelinePitch(1, false)


def LongFun():
    @Name "Hero ball do a long super fun thing"
    ballHeroRandom = random.randint(0, 100)
    # Have an 8.3% chance of doing a fun thing for each player, up to 45%, minus torb
    if random.randint(0, 100) >= min(getNumberOfPlayers(Team.ALL) * 9.5 - 9.5, 60):
        return
    switch random.randint(1, 11):
        case 1:
            # I think this one is easily my favorite.
            ballPlayer.setFacing(vect(0, 0, 0), Relativity.TO_PLAYER)
            ballPlayer.startFacing(ballPlayer.getFacingDirection() + Vector.LEFT, 1000, Relativity.TO_PLAYER, FacingReeval.DIRECTION_AND_TURN_RATE)
            wait(1.5)
            createInWorldText(getAllPlayers(), "Torbcopter, ready for takeoff.", ballPlayer.getPosition(), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.ORANGE, SpecVisibility.ALWAYS)
            ballHeroRegretText = getLastCreatedText()
            while ballPlayerMock:
                ballPlayer.applyImpulse(Vector.UP, 5.5, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
                waitUntil(not ballPlayerMock,0.25)
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
            wait(2.25)
            ballPlayer.setGravity(0)
            ballPlayer.startForcingPosition(targetedPlayer.getEyePosition() + vect(0, 1, 0), true)
            ballPlayer.setFacing(vect(0, -1, 0), Relativity.TO_PLAYER)
            createInWorldText(getAllPlayers(), "{0} is next, don't tell them :)".format(targetedPlayer), ballPlayer.getEyePosition() + vect(0, 0.5, 0), 3, Clip.SURFACES, WorldTextReeval.VISIBILITY_POSITION_AND_STRING, Color.ORANGE, SpecVisibility.ALWAYS)
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
            # Torb got a case of the zoomies.
            ballPlayer.setMoveSpeed(500)
            ballHeroRandom = vect(random.uniform(-18, 18), 1, random.uniform(-18, 18))
            ballPlayer.startThrottleInDirection(directionTowards(ballPlayer.getPosition(), ballHeroRandom), 1, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)
            ballPlayer.startFacing(directionTowards(ballPlayer.getEyePosition(), ballHeroRandom), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
            createInWorldText(getAllPlayers(), "Zip zoom".format(ballHeroRandom), updateEveryTick(ballPlayer.getEyePosition()) + vect(0, 1, 0), 2, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, Color.ORANGE, SpecVisibility.ALWAYS)
            ballHeroRegretText = getLastCreatedText()
            while ballPlayerMock:
                if (distance(ballPlayer.getPosition(), ballHeroRandom) <  2):
                    ballHeroRandom = vect(random.uniform(-18, 18), 1, random.uniform(-18, 18))
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
            # Torb thinks one Genji in specific is broken.
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
            # Pretty sure this variable literally does nothing, I added this when I started develpoment and couldn't even get it to work...
            ballPlayer.currentUltPercent = 4
            chase(ballPlayer.currentUltPercent, 0, duration=7.5, ChaseReeval.NONE)
            ballHeroRegretText = 0.75
            ballPlayer.startScalingSize(ballPlayer.currentUltPercent, true)
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
            # Get the chance to let your anger out and yeet torb.
            wait(0.25)
            ballHeroRandom = targetedPlayer
            ballPlayer.communicate(Comms.NO)
            ballPlayer.setGravity(0)
            ballPlayer.startForcingPosition((updateEveryTick(ballHeroRandom.getEyePosition()) + vect(0, -1.1, 0)) + (ballHeroRandom.getFacingDirection() * 2), true)
            ballPlayer.startFacing(directionTowards(ballPlayer.getEyePosition(), ballHeroRandom.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
            createInWorldText(ballHeroRandom, "Press reload to yeet {0}".format(ballHero), (updateEveryTick(ballHeroRandom.getEyePosition()) + vect(0, -0.06, 0)) + (ballHeroRandom.getFacingDirection() * 0.5), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, Color.ORANGE, SpecVisibility.ALWAYS)
            waitUntil(ballHeroRandom.isHoldingButton(Button.RELOAD) or not ballPlayerMock, 5)
            ballPlayer.setGravity(100)
            destroyInWorldText(getLastCreatedText())
            ballPlayer.stopForcingPosition()
            ballPlayer.stopFacing()
            ballPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 9999)
            ballPlayer.applyImpulse(directionTowards(ballPlayer.getPosition(), ballHeroRandom.getEyePosition() + (ballHeroRandom.getFacingDirection() * 20)), 75, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            waitUntil(not ballPlayerMock, 4)
            ballPlayer.clearStatusEffect(Status.KNOCKED_DOWN)
            break
        case 11:
            wait()
            ballPlayer.setGravity(100)
            ballPlayer.applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.BACKWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.FORWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.RIGHT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.LEFT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.DOWN, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.teleport(circleCenter + vect(0,5,0))
            ballPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
            ballPlayer.communicate(Comms.HELLO)
            break



def ShortFun():
    @Name "Hero ball do a quick fun thing"

    # Only have a 10% chance of doing a fun thing
    if (random.randint(1, 100) >= 10):
        return
    ballHeroRandom = random.randint(0, 100)
    switch random.randint(1, 10):
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
            break
        case 7:
            # To the person who keeps telling me to remove the center orb.
            ballPlayer.startForcingPosition(circleCenter + vect(random.uniform(-centerOffLimitsSize + 1, centerOffLimitsSize - 1), -circleCenter.y, random.uniform(-centerOffLimitsSize + 1, centerOffLimitsSize - 1)), true)
            eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
            wait()
            createInWorldText(getAllPlayers(), "Jealous that I can be in here and you can't? :)", ballPlayer.getEyePosition() + vect(0, 0.5, 0), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY, Color.ORANGE, SpecVisibility.ALWAYS)
            ballHeroRegretText = getLastCreatedText()
            wait(0.5)
            ballPlayer.communicate(Comms.HELLO)
            waitUntil(not ballPlayerMock, 9999)
            destroyInWorldText(ballHeroRegretText)
            ballPlayer.stopForcingPosition()
            break
        case 8:
            wait()
            ballHeroRandom = ballPlayer.getPosition()
            chase(ballHeroRandom, targetedPlayer.getEyePosition(), rate=20, ChaseReeval.DESTINATION_AND_RATE)
            createEffect(getAllPlayers(), Effect.ORB, Color.RED, ballHeroRandom, 1, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
            ballHeroRegretText = getLastCreatedEntity()
            ballPlayer.startFacing(directionTowards(ballPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 500, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
            createInWorldText(getAllPlayers(), "Think fast!", ballHeroRandom + vect(0, 0.5, 0), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, Color.ORANGE, SpecVisibility.ALWAYS)
            waitUntil(distance(ballHeroRandom, targetedPlayer.getEyePosition()) < 1.9 or not ballPlayerMock, 9999)
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.SKY_BLUE, ballHeroRandom, 40)
            playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.WHITE, ballHeroRandom, 2)
            destroyEffect(ballHeroRegretText)
            destroyInWorldText(getLastCreatedText())
            break
        case 9:
            # Torb horror game.
            wait()
            ballHeroRandom = random.choice([player for player in getLivingPlayers(Team.ALL) if player.getCurrentHero() != ballHero])
            ballPlayer.setGravity(0)
            ballPlayer.startForcingPosition((updateEveryTick(ballHeroRandom.getEyePosition()) + vect(0, -1.1, 0)) + (ballHeroRandom.getFacingDirection() * 0.75), true)
            ballPlayer.startFacing(directionTowards(ballPlayer.getEyePosition(), ballHeroRandom.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
            createInWorldText(getAllPlayers(), "Boo!", ballPlayer.getEyePosition() + vect(0, 0.5, 0), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, Color.ORANGE, SpecVisibility.ALWAYS)
            waitUntil(not ballPlayerMock, 9999)
            ballPlayer.stopForcingPosition()
            destroyInWorldText(getLastCreatedText())
            break
        case 10:
            ballPlayer.applyImpulse(Vector.UP, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.BACKWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.FORWARD, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.RIGHT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.LEFT, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.applyImpulse(Vector.DOWN, 0.001, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
            ballPlayer.teleport(circleCenter + vect(0,5,0))
            ballPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
            ballPlayer.communicate(Comms.HELLO)
            break
        # case 9:
        #     wait()
        #     createBeam(getAllPlayers(), Beam.GRAPPLE, updateEveryTick(ballPlayer.getEyePosition()), updateEveryTick(targetedPlayer.getPosition()), null, EffectReeval.POSITION_AND_RADIUS)
        #     ballHeroRandom = getLastCreatedEntity()
        #     ballPlayer.startFacing(directionTowards(ballPlayer.getEyePosition(), targetedPlayer.getEyePosition()), 500, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
        #     createInWorldText(getAllPlayers(), "Get over here!", updateEveryTick(ballPlayer.getPosition()) + vect(0, 1, 0), 2.5, Clip.SURFACES, WorldTextReeval.VISIBILITY_AND_POSITION, Color.ORANGE, SpecVisibility.ALWAYS)
        #     while ballPlayerMock:
        #         ballPlayer.applyImpulse(directionTowards(ballPlayer.getPosition(), targetedPlayer.getPosition()), 2, Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)
        #         wait()
        #         waitUntil(distance(ballPlayer.getPosition(), targetedPlayer.getPosition()) > 2, 9999)
        #     destroyEffect(ballHeroRandom)
        #     destroyInWorldText(getLastCreatedText())
        #     break
