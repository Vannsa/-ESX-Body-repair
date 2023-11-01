Config = {}

-------------------------------------Blip-------------------------------------
Config.BlipName = "Body repair" --Blip Name
Config.BlipLoaction = vector3(501.3866, -1337.31, 28.89431) --Location on the Map

-------------------------------------Ped-------------------------------------
Config.PedSpawn ={ x = 495.850555, y = -1340.597778, z = 29.296753, h = 36.850395} --Location where the ped is gonna spawn
Config.PedDespawn = { x = 495.850555, y = -1340.597778, z = 29.296753 } --Location where the ped is gonna despawn
Config.pedModel = "mp_m_waremech_01" 
Config.Animation = "WORLD_HUMAN_WELDING" 
Config.PedName = "Jeremy the mechanic" --Default message ingame https://prnt.sc/rPW7c-8JHDMP
Config.PedSubject = "Repair"
Config.PedMessage = "Your body has been repaired. Be careful next time!"
Config.PedPicture = "CHAR_MP_MECHANIC"
Config.WalkTime = 5000
Config.PedAnimationTime = 8000

-------------------------------------Job and Money-------------------------------------
Config.LSRequired = 1 
Config.LSJobName = "mechanic" 
Config.Society = "society_mechanic" 
Config.SharedAccount = true 
Config.Money = 1500 

-------------------------------------Translation-------------------------------------
Strings = {
    HelpNotification = "Press ~INPUT_CONTEXT~ to repair the body of your car",
    OnFoot           = "Get into your Vehicle to do this",
    NoMoney          = "You don't have enough money you need " .. Config.Money .. " to do this",
    GetIn            = "Get into your vehicle to do this",
    MechanicsonDuty  = "There are mechanics on duty"
}

-------------------------------------Don't touch :)-------------------------------------
Config.UsingESXLegacy = false --Just leave it as is