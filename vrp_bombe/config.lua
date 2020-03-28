--[[              
  /     \  _____     __| _/  ____   \______   \ ___.__.   ____    /     \  _____   _______ |  | __  ____  ________
 /  \ /  \ \__  \   / __ | _/ __ \   |    |  _/<   |  |  /  _ \  /  \ /  \ \__  \  \_  __ \|  |/ /_/ __ \ \___   /
/    Y    \ / __ \_/ /_/ | \  ___/   |    |   \ \___  | (  <_> )/    Y    \ / __ \_ |  | \/|    < \  ___/  /    / 
\____|__  /(____  /\____ |  \___  >  |______  / / ____|  \____/ \____|__  /(____  / |__|   |__|_ \ \___  >/_____ \
        \/      \/      \/      \/          \/  \/                      \/      \/              \/     \/       \/
------------------------CREDITS------------------------
-- Copyright 2019-2020 ©oMarkez. All rights reserved --
-------------------------------------------------------
]]
config = {}

config = {
    maxTimer = 1200, -- I SEKUNDER
    items = {
        bombeItem = "bombe", -- itemet der skal bruges for at kunne lægge en bombe
        defuseItem = "defusekit" -- itemet der skal bruges for at kunne defuse bomben.
    },
    menu = {
        titel = "Læg Bombe",
        prompt = "Hvor lang tid skal timeren være? (sekunder)",
        deskription = "Læg en bombe i en taske.",
        forLangTid = "Lunten er for lang, den kan max være 1200 sekunder."
    },
    bombe = {
        defuseChance = {1,2}, -- hvis der er {} så tager den et tilfældigt tal mellem de to tal og sammenligner med 1. dvs. hvis den er {1,4} så er chancen for at man kan defuse bombem 25%, hvis du vil ha den til at defuse hver gang så bare sæt den til {1,1}
        sletBombe = true, -- sletter bombem (altså tasken på jorden) efter den er blevet defused
        defuseAnim = "PROP_HUMAN_BUM_BIN",
        skalHaveLOS = true, -- Om man skal have LOS for at kunne se 3d teksten (LOS er Line of sight, dvs. man skulle kunne se bombem. Så hvis der er en væg mellem en og bombem, så kan man ikke se 3d teksten)
        defuseTid = 8, -- I SEKUNDER
        successTekst = "Du disarmerede bombem!",
        mislykkedesTekst = "Disarmeringsforsøg misslykkedes!"
    }
}