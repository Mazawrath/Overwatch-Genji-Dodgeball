#!mainFile "./Genji-Dodgeball.opy"

rule "Set Time To 0 in Tourney Mode":
    @Condition isGameInProgress()
    @Condition tournamentMode

    setMatchTime(0)


def StartBreak():
    @Name "Start Break"

    breakInProgress = true
    wait(1)
    ballSpawnCountdown = breakLength
    chase(ballSpawnCountdown, 0, rate=1, ChaseReeval.NONE)
    chase(getAllPlayers().bouncePadCooldown, 0, rate=1, ChaseReeval.NONE)
    enableAnnouncer()
    setMatchTime(breakLength)
    bigMessage(getAllPlayers(), "Break Time!")
    chase(getAllPlayers().bouncePadCooldown, 0, rate=2, ChaseReeval.NONE)
    disableScoring()
    # Spawn the stress relief Torbs
    if getCurrentGamemode() == Gamemode.FFA:
        createDummy(Hero.TORBJORN, Team.ALL, 15, circleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)), vect(0,0,0))
        createDummy(Hero.TORBJORN, Team.ALL, 16, circleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)), vect(0,0,0))
        createDummy(Hero.TORBJORN, Team.ALL, 17, circleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)), vect(0,0,0))
    elif getCurrentGamemode() == Gamemode.TDM:
        createDummy(Hero.TORBJORN, Team.1, 15, circleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)), vect(0,0,0))
        createDummy(Hero.TORBJORN, Team.1, 16, circleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)), vect(0,0,0))
        createDummy(Hero.TORBJORN, Team.2, 17, circleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)), vect(0,0,0))
        createDummy(Hero.TORBJORN, Team.2, 18, circleCenter + vect(random.randint(-10, 10), 8, random.randint(-10, 10)), vect(0,0,0))
    stressTorbs = [player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if player != ballPlayer]
    stressTorbs.startForcingName("Stress Relief Torb")
    getAllPlayers().setPrimaryFireEnabled(true)
    getAllPlayers().setSecondaryFireEnabled(true)
    wait(1)
    bigMessage(getAllPlayers(), "Weapons activated")
    wait(2)
    smallMessage(getAllPlayers(), "Press reload to pick up a torb")
    wait(2)
    smallMessage(getAllPlayers(), "Press reload again to yeet them!")
    waitUntil(ballSpawnCountdown <= 10, 9999)
    breakInProgress = false
    if getCurrentGamemode() == Gamemode.FFA:
        destroyDummy(Team.ALL, stressTorbs[0].getSlot())
        destroyDummy(Team.ALL, stressTorbs[1].getSlot())
        destroyDummy(Team.ALL, stressTorbs[2].getSlot())
    elif getCurrentGamemode() == Gamemode.TDM:
        destroyDummy(Team.1, stressTorbs[0].getSlot())
        destroyDummy(Team.1, stressTorbs[1].getSlot())
        destroyDummy(Team.2, stressTorbs[2].getSlot())
        destroyDummy(Team.2, stressTorbs[3].getSlot())
    getAllPlayers().setPrimaryFireEnabled(false)
    getAllPlayers().setSecondaryFireEnabled(false)
    disableAnnouncer()


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
    waitUntil(eventPlayer.isHoldingButton(Button.RELOAD) or not breakInProgress, 9999)
    eventPlayer.yeetPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 4)
    eventPlayer.yeetPlayer.detach()
    eventPlayer.yeetPlayer.applyImpulse(directionTowards(eventPlayer.getPosition(), eventPlayer.getEyePosition() + (eventPlayer.getFacingDirection() * 20)), 25, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    wait(1)
    eventPlayer.yeetPlayer = null


rule "Get knocked down by yeeted Torb":
    @Event eachPlayer
    @Condition breakInProgress
    # Only knock the player down if the stress torb is in the air (hopefully only when getting yeeted)
    @Condition sorted([player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if player in stressTorbs and player.isAlive()], lambda player: distance(eventPlayer.getEyePosition(), player))[0].isInAir()
    @Condition sorted([player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if player in stressTorbs and player.isAlive()], lambda player: distance(eventPlayer.getEyePosition(), player))[0].hasStatusEffect(Status.KNOCKED_DOWN)
    # Chceck for the nearest stress torb
    @Condition distance(eventPlayer, sorted([player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if player in stressTorbs and player.isAlive()], lambda player: distance(eventPlayer.getEyePosition(), player))[0].getPosition()) <= 1.5
    @Condition sorted([player for player in getPlayersOnHero(Hero.TORBJORN, Team.ALL) if player in stressTorbs and player.isAlive()], lambda player: distance(eventPlayer.getEyePosition(), player))[0] != eventPlayer.yeetPlayer

    eventPlayer.setStatusEffect(null, Status.KNOCKED_DOWN, 1.5)