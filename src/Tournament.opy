#!mainFile "./Genji-Dodgeball.opy"

rule "Set Time To 0 in Tourney Mode":
    @Condition isGameInProgress()
    @Condition tournamentMode

    setMatchTime(0)


def StartBreak():
    @Name "Tournament Break"

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
    smallMessage(getAllPlayers(), "Press {0} to pick up a torb".format(buttonString(Button.RELOAD)))
    wait(2)
    smallMessage(getAllPlayers(), "Press {0} again to yeet them!".format(buttonString(Button.RELOAD)))
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


rule "Torb must die":
    @Event eachPlayer
    @Hero torbjorn

    @Condition eventPlayer.getHealth() == 1
    if random.randint(1, 3) == 1:
            switch random.randint(1,2):
                case 1:
                    eventPlayer.applyImpulse(Vector.UP, 75, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
                    break
                case 2:
                    eventPlayer.applyImpulse(directionTowards(eventPlayer.getEyePosition(), vect(circleCenter.x, circleCenter.y + 4, circleCenter.z)), 75, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
                    break
        eventPlayer.communicate(Comms.GOODBYE)
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


# rule "Player leaves during tourney":
#     @Disabled
    
#     @Event playerLeft
#     @Condition tournamentMode
#     @Condition not eventPlayer.isDummy()

#     smallMessage(hostPlayer, "{0}, Kills: {1}, Deaths {2}. slot {3}".format(eventPlayer, eventPlayer.getNumberOfElims(), eventPlayer.getNumberOfDeaths(), eventPlayer.getSlot()))
#     hudSubtext(hostPlayer, "{0}, Kills: {1}, Deaths {2}".format(eventPlayer, eventPlayer.getNumberOfElims(), eventPlayer.getNumberOfDeaths()), HudPosition.RIGHT, -1, Color.WHITE, HudReeval.NONE, SpecVisibility.NEVER)