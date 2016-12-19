-- all tags that are not specific to a weapon type

toSet = {
    -- we set these tags for all weapons
    cameraShake = false,
}

toDefault = {
    -- tags that we don't worry about
    cegTag = 1,
    myGravity = 1,
    impactOnly = 1,
    noExplode = 1,
    fireTolerance = 1,
    interceptedByShieldType = 1,
    avoidGround = 1,
    avoidFriendly = 1,
    avoidNeutral = 1,
    collideEnemy = 1,
    collideFriendly = 1,
    collideFeature = 1,
    collideNeutral = 1,
    collideGround = 1,
    collisionSize = 1,
    commandFire = 1,
    canAttackGround = 1,
    targetBorder = 1,
    cylinderTargeting = 1,
    allowNonBlockingAim = 1,
    targetMoveError = 1,
    leadLimit = 1,
    leadBonus = 1,
    predictBoost = 1,
    heightMod = 1,
    proximityPriority = 1,
    accuracy = 1,
    movingAccuracy = 1,
    ownerExpAccWeight = 1,
    targetable = 1,
    interceptor = 1,
    interceptSolo = 1,
    coverage = 1,
    bounceSlip = 1,
    craterAreaOfEffect = 1,
    explosionSpeed = 1,
    craterMult = 1,
    craterBoost = 1,
    dynDamageExp = 1,
    dynDamageMin = 1,
    dynDamageRange = 1,
    dynDamageInverted = 1,
    explosionScar = 1,
    alwaysVisible = 1,
    texture1 = 1,
    texture2 = 1,
    texture3 = 1,
    texture4 = 1,

    turret = 1,
}

toChooseTags = {
    -- we modify these tags

    range = "float",
    reloadTime = "float",

    weaponVelocity = "float",
    
    burnBlow = "bool",
    fireStarter = "bool",

    stockpile = "bool",
    stockpileTime = "float",
    metalPerShot = "float",
    energyPerShot = "float",    

    tolerance = "float",
    waterWeapon = "bool",
    fireSubmersed = "bool",
    
    paralyzer = "bool",
    paralyzeTime = "float",

    waterBounce = "bool",
    groundBounce = "bool",
    bounceRebound = "proportion",
    numBounce = "natural",

    areaOfEffect = "float",
    edgeEffectiveness = "proportion",
    impulseFactor = "float",
    impulseBoost = "float",
    
    burst = "natural",
    burstRate = "float",
    projectiles = "natural",
    sprayAngle = "float",   
    
    intensity = "float",
} 

toChooseSounds = {
    -- we modify these tags with sounds
    soundTrigger = 1,
    soundStart = 1,
    soundHitDry = 1,
    soundHitWet = 1,
}

toChooseCEGS = {
    -- we modify these tags with CEGs
    explosionGenerator = 1,
    bounceExplosionGenerator = 1,
}

toChooseSpecial = {
    -- we set these tags specially
    name = true,
 
    model = 1, 

    rgbColor = 1,

    damage = "subtable",
    shield = "subtable",
}
