settings {
    "main": {
        "modeName": "Genji Dodgeball v7.9.1",
        "description": "Genji Dodgeball v7.9.1. Developed by Mazawrath. Credit for others avaliable in GitHub repository https://github.com/Mazawrath/Overwatch-Genji-Dodgeball. Deflect the ball when it is red to target someone else! Use jump pads to get air!"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "enableMatchVoiceChat": true,
        "spectatorSlots": 6,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false,
        "teamBalancing": "afterGame"
    },
    "gamemodes": {
        "ffa": {
            "enabledMaps": [
                "workshopIslandNight"
            ],
            "gameLengthInMn": 15,
            "enableSelfInitiatedRespawn": false
        },
        "tdm": {
            "enabled": false,
            "gameLengthInMn": 15,
            "needsImbalancedTeamScoreToWin": true,
            "team1ScoreToWin": 10,
            "team2ScoreToWin": 10
        },
        "general": {
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableRandomHeroes": true
        }
    },
    "heroes": {
        "allTeams": {
            "genji": {
                "ability2Cooldown%": 0,
                "enableInfiniteAmmo": true,
                "enablePrimaryFire": false,
                "enableMelee": false,
                "enableSecondaryFire": false,
                "ability1Cooldown%": 38,
                "combatUltGen%": 0,
                "passiveUltGen%": 0
            },
            "torbjorn": {
                "ability2Duration%": 300
            },
            "enabledHeroes": [
                "torbjorn"
            ]
        }
    }
}

globalvar gimmickPlayer 1
globalvar wonPlayer 2
globalvar endlessBall 3
globalvar ballTail2 4
globalvar ballSpeed 5
globalvar torbBall 6

subroutine TheEnding 0

#!extension spawnMoreDummyBots

rule "Guh?":
    @Event global

    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))
    createDummy(Hero.TORBJORN, Team.ALL, -1, vect(0,0,0), vect(0,0,0))

rule "Start Ending":
	@Event eachPlayer
	@Condition eventPlayer.isHoldingButton(Button.CROUCH)

	TheEnding()

def TheEnding():
    destroyAllHudTexts()
    destroyAllEffects()
    destroyAllHudTexts()
    getAllPlayers().disableHeroHud()
    getAllPlayers().disableGamemodeHud()
	wonPlayer = hostPlayer
	getAllPlayers().preloadHero(Hero.GENJI)
	smallMessage(getAllPlayers(), "Wow, what a great game, {0} won!".format(wonPlayer))
	wait(1.5)
    getAllPlayers().disablePlayerCollision()
    # TODO: UNCOMMENT
	# destroyAllDummies()
	bigMessage(getAllPlayers(), "Now, it's time for the big event!")
	wait(2)
	getAllPlayers().startForcingHero(Hero.GENJI)
	getAllPlayers().setAbility1Enabled(false)
	getAllPlayers().setAbility2Enabled(false)
	wait(2)
	getAllPlayers().setStatusEffect(null, Status.ROOTED, 9999)
	createDummy(Hero.TORBJORN, Team.ALL, -1, [0, 0, 0], [0,0,0])
    wait()
	gimmickPlayer = getPlayersOnHero(Hero.TORBJORN, Team.ALL)
    gimmickPlayer.startScalingSize(50, false)
    gimmickPlayer.teleport(vect(0, 0, -100))
    endlessBall = 5
    getAllPlayers().clearStatusEffect(Status.UNKILLABLE)
    getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(gimmickPlayer.getEyePosition() + gimmickPlayer.getFacingDirection() * endlessBall, gimmickPlayer.getEyePosition(), 5000)
    chase(endlessBall, 30, duration=4, ChaseReeval.NONE)
    bigMessage(getAllPlayers(), "{0} gets to preview the S-E-X update! (Release date 2030)".format(wonPlayer))
    wait(7)
    getAllPlayers().disableRespawn()
    gimmickPlayer.setWeapon(2)
    gimmickPlayer.setUltCharge(100)
    getPlayersOnHero(Hero.GENJI, Team.ALL).enablePlayerCollision()
    getPlayersOnHero(Hero.GENJI, Team.ALL).teleport(vect(15, 0, 0))
    wonPlayer.setGravity(0)
    wonPlayer.teleport(vect(-20, 10, 0))
    wonPlayer.disablePlayerCollision()
    getPlayersOnHero(Hero.GENJI, Team.ALL).startFacing(directionTowards(vect(19, 0, 0), vect(0, 50, 0)), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    wonPlayer.setFacing(directionTowards(wonPlayer.getPosition(), vect(0, 10, 0)), Relativity.TO_WORLD)
    wonPlayer.startFacing(directionTowards(wonPlayer.getPosition(), vect(0, 11.6, 0)), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    wait(0.5)
    gimmickPlayer.teleport(vect(-5, 0, -5.5))
    # ballTail2 = vect(wonPlayer.getEyePosition().x + wonPlayer.getFacingDirection().x * 0.65, (wonPlayer.getEyePosition().y + wonPlayer.getFacingDirection().y * 0.65) + 0.4, (wonPlayer.getEyePosition().z + wonPlayer.getFacingDirection().z * 0.65) + 0.25)
    ballTail2 = vect(-19.5, 11.6, 0.25)
    getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(ballTail2, vect(wonPlayer.getEyePosition().x, wonPlayer.getEyePosition().y + 0.3, wonPlayer.getEyePosition().z), 0)
    gimmickPlayer.setFacing(vect(-15, 0, 15), Relativity.TO_PLAYER)
    wait(2)
    getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(ballTail2, vect(-10.82, 10, -1.88), 0.33)
    wait(5)
    getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(ballTail2, vect(wonPlayer.getEyePosition().x, wonPlayer.getEyePosition().y + 0.3, wonPlayer.getEyePosition().z), 3)
    wait(4)
    wonPlayer.startFacing(directionTowards(wonPlayer.getEyePosition(), ballTail2), 15, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    wait(4)
    gimmickPlayer.setFacing(vect(0,0,0), Relativity.TO_PLAYER)
    gimmickPlayer.teleport(vect(-5, 0, -5))
    smallMessage(getAllPlayers(), "Are you ready for the S-E-X update {0}?".format(wonPlayer))
    wait(1)
    wonPlayer.startFacing(directionTowards(wonPlayer.getEyePosition(), vect(random.uniform(-25, 30), random.uniform(-5, 15), random.uniform(-5, 5))), 1500, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    getAllPlayers().communicate(Comms.NO)
    wait(0.5)
    getAllPlayers().communicate(Comms.NO)
    wait(0.5)
    getAllPlayers().communicate(Comms.NO)
    wait(0.5)
    getAllPlayers().communicate(Comms.NO)
    wait(0.5)
    getAllPlayers().communicate(Comms.NO)
    wait(5)
    getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(vect(-12, ballTail2.y, 17), wonPlayer.getEyePosition(), 3)
    wait(4)
    getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(vect(-12, ballTail2.y, 17), wonPlayer.getEyePosition(), 10)
    ballSpeed = 6
    torbBall = 1
    wonPlayer.setMoveSpeed(250)
    wonPlayer.applyImpulse(directionTowards(wonPlayer.getPosition(), vect(0, wonPlayer.getPosition().y, 0)), ballSpeed, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
    while true:
        waitUntil(wonPlayer.getPosition().x >= -8, 9999)
        wonPlayer.applyImpulse(directionTowards(wonPlayer.getPosition(), vect(-20, wonPlayer.getPosition().y, 0)), ballSpeed, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION)
        gimmickPlayer.setStatusEffect(null, Status.STUNNED, 0.25)
        waitUntil(wonPlayer.getPosition().x <= -20, 9999)
        wonPlayer.applyImpulse(directionTowards(wonPlayer.getPosition(), vect(0, wonPlayer.getPosition().y, 0)), ballSpeed, Relativity.TO_WORLD, Impulse.CANCEL_CONTRARY_MOTION) 
        gimmickPlayer.startModifyingVoicelinePitch(torbBall, true)
        ballSpeed += 2
        torbBall += 0.05
        if ballSpeed > 16 and ballSpeed < 36:
            wonPlayer.startFacing(directionTowards(wonPlayer.getEyePosition(), vect(0, wonPlayer.getEyePosition().y, 0)), 1500, Relativity.TO_WORLD, FacingReeval.NONE)
            getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(vect(wonPlayer.getEyePosition().x + wonPlayer.getFacingDirection().x * 0.65, (wonPlayer.getEyePosition().y + wonPlayer.getFacingDirection().y * 0.65) + 0.4, (wonPlayer.getEyePosition().z + wonPlayer.getFacingDirection().z * 0.65) + 0.25), vect(wonPlayer.getEyePosition().x, wonPlayer.getEyePosition().y + 0.3, wonPlayer.getEyePosition().z), 50)
        elif ballSpeed > 36 and ballSpeed < 45:
            getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(vect(-12, ballTail2.y, 17), vect(-12, ballTail2.y, 0), 10)
        elif ballSpeed > 45 and ballSpeed < 50:
            getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(vect(11.98, 4, 1.72), vect(15, 0, 0), 0)
        elif ballSpeed > 60 and ballSpeed < 70:
            # getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(vect(9, 22, -7), vect(-3, 20, -4), 0)
            getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(vect(9, 21.5, -7), vect(0.58, 19.5, -7.35), 0)
        elif ballSpeed > 70:
            break
    ballSpeed = 0
    chase(ballSpeed, 6, duration=1, ChaseReeval.NONE)
    getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(vect(-12, ballTail2.y, 17), vect(-12, ballTail2.y, 0), 0)
    gimmickPlayer.startFacing(directionTowards(gimmickPlayer.getEyePosition(), vect(19.5 + ballSpeed, 0, 0.5)), 1000, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    gimmickPlayer.forceButtonPress(Button.ULTIMATE)
    gimmickPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(1.5)
    waitUntil(not gimmickPlayer.isUsingUltimate(), 9999)
    gimmickPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    wait(1.5)
    gimmickPlayer.startModifyingVoicelinePitch(0, false)
    wait()
    kill(gimmickPlayer, null)
    wait(5)
    ballSpeed = 0
    chase(ballSpeed, 15, duration=8, ChaseReeval.NONE)
    getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(vect(10, 15 + ballSpeed, -10), vect(10, 0, -10), 0)
    wait(5)
    declarePlayerVictory(hostPlayer)

    # getPlayersOnHero(Hero.GENJI, Team.ALL).startCamera(vect(13, 22, -7), vect(-3, 20, -4), 0)
    # getAllPlayers().stopCamera()
    # getAllPlayers().stopFacing()
    # getAllPlayers().clearStatusEffect(Status.ROOTED)
    # hudHeader(getAllPlayers(), hostPlayer.getEyePosition(), HudPosition.LEFT, 0, Color.BLUE, HudReeval.STRING, SpecVisibility.ALWAYS)
