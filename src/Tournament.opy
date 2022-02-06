#!mainFile "./Genji-Dodgeball.opy"

rule "Set Time To 0 in Tourney Mode":
    @Condition isGameInProgress()
    @Condition tournamentMode

    setMatchTime(0)