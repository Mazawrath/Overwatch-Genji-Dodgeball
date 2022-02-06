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
