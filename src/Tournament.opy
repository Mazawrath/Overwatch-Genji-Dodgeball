#!mainFile "./Genji-Dodgeball.opy"

rule "Set Time To 0 in Tourney Mode":
    @Condition isGameInProgress()
    @Condition tournamentMode

    setMatchTime(0)
    enableAnnouncer()


def StartBreak():
    @Name "Start Break"

    breakInProgress = true
    wait(1)
    ballSpawnCountdown = breakLength
    setMatchTime(breakLength - 5)
    bigMessage(getAllPlayers(), "Break Time!")
    chase(getAllPlayers().bouncePadCooldown, 0, rate=2, ChaseReeval.NONE)
    disableScoring()
    # Spawn the stress relief Torbs 
    createDummy(Hero.TORBJORN, Team.ALL, 14, circleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, 15, circleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, 16, circleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)), vect(0,0,0))
    stressTorbs = getPlayersOnHero(Hero.TORBJORN, Team.ALL)
    getAllPlayers().setPrimaryFireEnabled(true)
    getAllPlayers().setSecondaryFireEnabled(true)
    waitUntil(ballSpawnCountdown == 9.5, 9999)
    destroyDummy(Team.ALL, 14)
    destroyDummy(Team.ALL, 15)
    destroyDummy(Team.ALL, 16)


rule "Stress relief Torbs join":
    @Event eachPlayer
    @Condition tournamentMode
    @Condition eventPlayer in stressTorbs

    wait(0.5)
    eventPlayer.enableRespawn()
    eventPlayer.setRespawnTime(5)
    eventPlayer.clearStatusEffect(Status.INVINCIBLE)
    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 9999)
    # eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), sorted([player for player in getLivingPlayers(Team.ALL) if player.getCurrentHero() == playerHero]).getEyePosition()), 200, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    eventPlayer.startFacing(directionTowards(eventPlayer.getEyePosition(), sorted([player for player in getPlayersOnHero(playerHero, Team.ALL)], lambda player: distance(eventPlayer, player))[0].getEyePosition()), 500, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    wait(random.uniform(1, 2))
    eventPlayer.communicate(Comms.NO)
    

rule "Torb must die":
    @Event eachPlayer
    @Hero torbjorn

    @Condition eventPlayer.getHealth() == 1
    if random.randint(1, 4) == 1:
        if random.randint(0,1):
            switch random.randint(1,2):
                case 1:
                    eventPlayer.applyImpulse(Vector.UP, 75, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
                    break
                case 2:
                    eventPlayer.applyImpulse(directionTowards(eventPlayer.getEyePosition(), vect(circleCenter.x, circleCenter.y + 4, circleCenter.z)), 75, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
                    break
        eventPlayer.communicate(Comms.GOODBYE)
        wait(random.uniform(0.016, 0.5))
    else:
        wait()
    eventPlayer.detach()
    eventPlayer.clearStatusEffect(Status.UNKILLABLE)
    kill(eventPlayer, null)
    eventPlayer.setStatusEffect(null, Status.UNKILLABLE, 9999)
    waitUntil(eventPlayer.isAlive(), 9999)
    eventPlayer.teleport(vect(random.randint(-10, 10), 8, random.randint(-10, 10)))
    wait(0.25)
    eventPlayer.communicate(Comms.HELLO)


rule "Yeet Stress relief Torb":
    @Event eachPlayer
    @Condition breakInProgress
    @Condition distance(eventPlayer, sorted([player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if player in stressTorbs and player.isAlive()], lambda player: distance(eventPlayer, player))[0].getPosition()) <= 2
    @Condition eventPlayer.isHoldingButton(Button.RELOAD)

    eventPlayer.yeetPlayer = sorted([player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if player in stressTorbs and player.isAlive()], lambda player: distance(eventPlayer, player))[0]
    eventPlayer.yeetPlayer.attachTo(eventPlayer, vect(0,0.5,1))
    eventPlayer.yeetPlayer.communicate(Comms.HELLO)
    wait(0.5)
    waitUntil(eventPlayer.isHoldingButton(Button.RELOAD), 9999)
    eventPlayer.yeetPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 4)
    eventPlayer.yeetPlayer.detach()
    eventPlayer.yeetPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * 20)), 25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    eventPlayer.yeetPlayer = null
    wait(3)
