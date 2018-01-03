local component = require("component")
local robot = require("robot")
local computer = component.computer
local inv = component.inventory_controller
local tasks = {}
local hives = {}
local orientation = "X-"
local orientationNum = 4
local XCoord = 0
local YCoord = 0
local ZCoord = 0
local targetGenes = {true, "Beatific", 4, "Cacti", 5, "Both 1", 10, true, "*", 1.7000000476837, "Both 1", {11,8,11}, true}
local serumUsagesLeft = 0
local crazyArray = {
    {"forestry.speciesCommon","Common","forestry.speciesMeadows","forestry.speciesModest"},
    {"forestry.speciesCultivated","Cultivated","forestry.speciesCommon","forestry.speciesModest"},
    {"forestry.speciesNoble","Noble","forestry.speciesCommon","forestry.speciesCultivated"},
    {"forestry.speciesMajestic","Majestic","forestry.speciesNoble","forestry.speciesCultivated"},
    {"forestry.speciesImperial","Imperial","forestry.speciesNoble","forestry.speciesMajestic"},
    {"forestry.speciesDiligent","Diligent","forestry.speciesCommon","forestry.speciesCultivated"},
    {"forestry.speciesUnweary","Unweary","forestry.speciesDiligent","forestry.speciesCultivated"},
    {"forestry.speciesIndustrious","Industrious","forestry.speciesDiligent","forestry.speciesUnweary"},
    {"forestry.speciesHeroic","Heroic","forestry.speciesSteadfast","forestry.speciesValiant","Occurs within a forest biome."},
    {"forestry.speciesSinister","Sinister","forestry.speciesCultivated","forestry.speciesModest","Occurs within a nether biome."},
    {"forestry.speciesFiendish","Fiendish","forestry.speciesSinister","forestry.speciesModest","Occurs within a nether biome."},
    {"forestry.speciesDemonic","Demonic","forestry.speciesSinister","forestry.speciesFiendish","Occurs within a nether biome."},
    {"forestry.speciesFrugal","Frugal","forestry.speciesModest","forestry.speciesSinister","Requires temperature between Hot and Hellish.|Requires Arid humidity."},
    {"forestry.speciesAustere","Austere","forestry.speciesModest","forestry.speciesFrugal","Requires temperature between Hot and Hellish.|Requires Arid humidity."},
    {"forestry.speciesExotic","Exotic","forestry.speciesAustere","forestry.speciesTropical"},
    {"forestry.speciesEdenic","Edenic","forestry.speciesExotic","forestry.speciesTropical"},
    {"forestry.speciesSpectral","Spectral","forestry.speciesHermitic","forestry.speciesEnded"},
    {"forestry.speciesPhantasmal","Phantasmal","forestry.speciesSpectral","forestry.speciesEnded"},
    {"forestry.speciesIcy","Icy","forestry.speciesIndustrious","forestry.speciesWintry","Requires temperature between Icy and Cold."},
    {"forestry.speciesGlacial","Glacial","forestry.speciesIcy","forestry.speciesWintry","Requires temperature between Icy and Cold."},
    {"forestry.speciesVindictive","Vindictive","forestry.speciesMonastic","forestry.speciesDemonic"},
    {"forestry.speciesVengeful","Vengeful","forestry.speciesDemonic","forestry.speciesVindictive"},
    {"forestry.speciesAvenging","Avenging","forestry.speciesVengeful","forestry.speciesVindictive"},
    {"forestry.speciesRural","Rural","forestry.speciesMeadows","forestry.speciesDiligent","Occurs within a plains biome."},
    {"forestry.speciesFarmerly","Farmerly","forestry.speciesRural","forestry.speciesUnweary","Occurs within a plains biome."},
    {"forestry.speciesAgrarian","Agrarian","forestry.speciesFarmerly","forestry.speciesIndustrious","Occurs within a plains biome."},
    {"forestry.speciesMiry","Miry","forestry.speciesMarshy","forestry.speciesNoble","Requires Warm temperature.|Requires Damp humidity."},
    {"forestry.speciesBoggy","Boggy","forestry.speciesMarshy","forestry.speciesMiry","Requires Warm temperature.|Requires Damp humidity."},
    {"forestry.speciesSecluded","Secluded","forestry.speciesMonastic","forestry.speciesAustere"},
    {"forestry.speciesHermitic","Hermitic","forestry.speciesMonastic","forestry.speciesSecluded"},
    {"extrabees.species.arid","Arid","forestry.speciesMeadows","forestry.speciesFrugal"},
    {"extrabees.species.barren","Barren","extrabees.species.arid","forestry.speciesCommon"},
    {"extrabees.species.desolate","Desolate","extrabees.species.arid","extrabees.species.barren"},
    {"extrabees.species.gnawing","Gnawing","extrabees.species.barren","forestry.speciesForest"},
    {"extrabees.species.rotten","Decaying","extrabees.species.desolate","forestry.speciesMeadows"},
    {"extrabees.species.bone","Skeletal","extrabees.species.desolate","forestry.speciesForest"},
    {"extrabees.species.creeper","Creepy","extrabees.species.desolate","forestry.speciesModest"},
    {"extrabees.species.decomposing","Decomposing","extrabees.species.barren","forestry.speciesMarshy"},
    {"extrabees.species.stone","Tolerant","extrabees.species.rock","forestry.speciesDiligent"},
    {"extrabees.species.granite","Robust","extrabees.species.stone","forestry.speciesUnweary"},
    {"extrabees.species.mineral","Resilient","extrabees.species.granite","forestry.speciesIndustrious"},
    {"extrabees.species.iron","Rusty","extrabees.species.mineral","forestry.speciesMeadows"},
    {"extrabees.species.copper","Corroded","extrabees.species.mineral","forestry.speciesModest"},
    {"extrabees.species.tin","Tarnished","extrabees.species.mineral","forestry.speciesTropical"},
    {"extrabees.species.lead","Leaden","extrabees.species.mineral","forestry.speciesModest"},
    {"extrabees.species.zinc","Galvanized","extrabees.species.mineral","forestry.speciesWintry"},
    {"extrabees.species.nickel","Lustered","extrabees.species.mineral","forestry.speciesForest"},
    {"extrabees.species.titanium","Impregnable","extrabees.species.mineral","forestry.speciesCultivated"},
    {"extrabees.species.tungstate","Invincible","extrabees.species.mineral","forestry.speciesCommon"},
    {"extrabees.species.silver","Shining","extrabees.species.tin","forestry.speciesMajestic"},
    {"extrabees.species.gold","Glittering","extrabees.species.iron","forestry.speciesMajestic"},
    {"extrabees.species.platinum","Valuable","extrabees.species.gold","extrabees.species.silver"},
    {"extrabees.species.lapis","Lapis","extrabees.species.mineral","forestry.speciesImperial"},
    {"extrabees.species.emerald","Emerald","extrabees.species.lapis","forestry.speciesForest"},
    {"extrabees.species.ruby","Ruby","extrabees.species.lapis","forestry.speciesModest"},
    {"extrabees.species.sapphire","Sapphire","extrabees.species.lapis","extrabees.species.water"},
    {"extrabees.species.diamond","Diamond","extrabees.species.lapis","forestry.speciesCultivated"},
    {"extrabees.species.unstable","Unstable","extrabees.species.prehistoric","extrabees.species.mineral"},
    {"extrabees.species.nuclear","Nuclear","extrabees.species.unstable","extrabees.species.iron"},
    {"extrabees.species.radioactive","Radioactive","extrabees.species.nuclear","extrabees.species.gold"},
    {"extrabees.species.ancient","Ancient","forestry.speciesNoble","forestry.speciesDiligent"},
    {"extrabees.species.primeval","Primeval","extrabees.species.ancient","forestry.speciesSecluded"},
    {"extrabees.species.prehistoric","Prehistoric","extrabees.species.primeval","extrabees.species.ancient"},
    {"extrabees.species.relic","Relic","extrabees.species.prehistoric","forestry.speciesImperial"},
    {"extrabees.species.coal","Fossilised","extrabees.species.primeval","forestry.speciesRural"},
    {"extrabees.species.resin","Resinous","extrabees.species.primeval","forestry.speciesMiry"},
    {"extrabees.species.oil","Oily","extrabees.species.primeval","extrabees.species.ocean"},
    {"extrabees.species.distilled","Distilled","extrabees.species.oil","forestry.speciesIndustrious"},
    {"extrabees.species.fuel","Refined","extrabees.species.distilled","extrabees.species.oil"},
    {"extrabees.species.creosote","Tarry","extrabees.species.distilled","extrabees.species.coal"},
    {"extrabees.species.latex","Elastic","extrabees.species.distilled","extrabees.species.resin"},
    {"extrabees.species.river","River","extrabees.species.water","forestry.speciesDiligent","Is restricted to RIVER-like biomes."},
    {"extrabees.species.ocean","Ocean","extrabees.species.water","forestry.speciesDiligent","Is restricted to OCEAN-like biomes."},
    {"extrabees.species.ink","Stained","extrabees.species.black","extrabees.species.ocean"},
    {"extrabees.species.growing","Growing","forestry.speciesForest","forestry.speciesDiligent"},
    {"extrabees.species.thriving","Thriving","extrabees.species.growing","forestry.speciesUnweary"},
    {"extrabees.species.blooming","Blooming","extrabees.species.thriving","forestry.speciesIndustrious"},
    {"extrabees.species.sweet","Sweetened","forestry.speciesValiant","forestry.speciesDiligent"},
    {"extrabees.species.sugar","Sugary","extrabees.species.sweet","forestry.speciesRural"},
    {"extrabees.species.ripening","Ripening","extrabees.species.sweet","extrabees.species.growing"},
    {"extrabees.species.fruit","Fruity","extrabees.species.sweet","extrabees.species.thriving"},
    {"extrabees.species.alcohol","Fermented","forestry.speciesFarmerly","forestry.speciesMeadows"},
    {"extrabees.species.farm","Farmed","forestry.speciesFarmerly","forestry.speciesMeadows"},
    {"extrabees.species.milk","Bovine","forestry.speciesFarmerly","extrabees.species.water"},
    {"extrabees.species.coffee","Caffeinated","forestry.speciesFarmerly","forestry.speciesTropical"},
    {"extrabees.species.swamp","Damp","extrabees.species.water","forestry.speciesMiry"},
    {"extrabees.species.boggy","Sodden","extrabees.species.swamp","forestry.speciesBoggy"},
    {"extrabees.species.fungal","Fungal","forestry.speciesBoggy","forestry.speciesMiry"},
    {"extrabees.species.tempered","Furious","extrabees.species.basalt","forestry.speciesFiendish","Is restricted to NETHER-like biomes."},
    {"extrabees.species.volcanic","Volcanic","extrabees.species.tempered","forestry.speciesDemonic","Is restricted to NETHER-like biomes."},
    {"extrabees.species.malicious","Malicious","forestry.speciesSinister","forestry.speciesTropical"},
    {"extrabees.species.infectious","Infectious","extrabees.species.malicious","forestry.speciesTropical"},
    {"extrabees.species.virulent","Virulent","extrabees.species.malicious","extrabees.species.infectious"},
    {"extrabees.species.viscous","Viscous","extrabees.species.water","forestry.speciesExotic"},
    {"extrabees.species.glutinous","Glutinous","extrabees.species.viscous","forestry.speciesExotic"},
    {"extrabees.species.sticky","Sticky","extrabees.species.viscous","extrabees.species.glutinous"},
    {"extrabees.species.corrosive","Corrosive","extrabees.species.malicious","extrabees.species.viscous"},
    {"extrabees.species.caustic","Caustic","extrabees.species.corrosive","forestry.speciesFiendish"},
    {"extrabees.species.acidic","Acidic","extrabees.species.corrosive","extrabees.species.caustic"},
    {"extrabees.species.excited","Excited","forestry.speciesCultivated","forestry.speciesValiant"},
    {"extrabees.species.energetic","Energetic","extrabees.species.excited","forestry.speciesDiligent"},
    {"extrabees.species.artic","Frigid","forestry.speciesWintry","forestry.speciesDiligent"},
    {"extrabees.species.freezing","Absolute","extrabees.species.ocean","extrabees.species.artic"},
    {"extrabees.species.shadow","Shadowed","extrabees.species.rock","forestry.speciesSinister"},
    {"extrabees.species.darkened","Darkened","extrabees.species.shadow","extrabees.species.rock"},
    {"extrabees.species.abyss","Abyssal","extrabees.species.shadow","extrabees.species.darkened"},
    {"extrabees.species.red","Maroon","forestry.speciesForest","forestry.speciesValiant"},
    {"extrabees.species.yellow","Saffron","forestry.speciesMeadows","forestry.speciesValiant"},
    {"extrabees.species.blue","Prussian","extrabees.species.water","forestry.speciesValiant"},
    {"extrabees.species.green","Natural","forestry.speciesTropical","forestry.speciesValiant"},
    {"extrabees.species.black","Ebony","extrabees.species.rock","forestry.speciesValiant"},
    {"extrabees.species.white","Bleached","forestry.speciesWintry","forestry.speciesValiant"},
    {"extrabees.species.brown","Sepia","forestry.speciesMarshy","forestry.speciesValiant"},
    {"extrabees.species.orange","Amber","extrabees.species.red","extrabees.species.yellow"},
    {"extrabees.species.cyan","Turquoise","extrabees.species.green","extrabees.species.blue"},
    {"extrabees.species.purple","Indigo","extrabees.species.red","extrabees.species.blue"},
    {"extrabees.species.gray","Slate","extrabees.species.black","extrabees.species.white"},
    {"extrabees.species.lightblue","Azure","extrabees.species.blue","extrabees.species.white"},
    {"extrabees.species.pink","Lavender","extrabees.species.red","extrabees.species.white"},
    {"extrabees.species.limegreen","Lime","extrabees.species.green","extrabees.species.white"},
    {"extrabees.species.magenta","Fuchsia","extrabees.species.purple","extrabees.species.pink"},
    {"extrabees.species.lightgray","Ashen","extrabees.species.gray","extrabees.species.white"},
    {"extrabees.species.glowstone","Glowering","extrabees.species.tempered","extrabees.species.excited"},
    {"extrabees.species.hazardous","Hazardous","forestry.speciesAustere","extrabees.species.desolate"},
    {"extrabees.species.celebratory","Celebratory","forestry.speciesAustere","extrabees.species.excited"},
    {"extrabees.species.unusual","Abnormal","forestry.speciesSecluded","forestry.speciesEnded"},
    {"extrabees.species.spatial","Spatial","extrabees.species.unusual","forestry.speciesHermitic"},
    {"extrabees.species.quantum","Quantum","extrabees.species.spatial","forestry.speciesSpectral"},
    {"extrabees.species.mystical","Mystical","forestry.speciesNoble","forestry.speciesMonastic"},
    {"computronics.speciesScummy","Scummy","forestry.speciesAgrarian","forestry.speciesExotic","Requires Short Mead as a foundation.|Occurs within biomes like: [ocean"," hot]|Occurs within biomes like: [ocean"," wet]|During the night.|Requires temperature between Warm and Hellish."},
    {"forestry.speciesClay","Clay","forestry.speciesIndustrious","forestry.speciesDiligent"},
    {"forestry.speciesSlimeball","Slimeball","forestry.speciesMarshy","forestry.speciesClay"},
    {"forestry.speciesPeat","Peat","forestry.speciesRural","forestry.speciesClay"},
    {"forestry.speciesStickyresin","Stickyresin","forestry.speciesSlimeball","forestry.speciesPeat"},
    {"forestry.speciesCoal","Coal","forestry.speciesIndustrious","forestry.speciesPeat"},
    {"forestry.speciesOil","Oil","forestry.speciesCoal","forestry.speciesStickyresin"},
    {"forestry.speciesRedstone","Redstone","forestry.speciesIndustrious","forestry.speciesDemonic"},
    {"forestry.speciesLapis","Lapis","forestry.speciesDemonic","forestry.speciesImperial"},
    {"forestry.speciesCertus","Certus","forestry.speciesHermitic","forestry.speciesLapis"},
    {"forestry.speciesRuby","Ruby","forestry.speciesRedstone","forestry.speciesDiamond"},
    {"forestry.speciesSapphire","Sapphire","forestry.speciesCertus","forestry.speciesLapis"},
    {"forestry.speciesDiamond","Diamond","forestry.speciesCertus","forestry.speciesCoal"},
    {"forestry.speciesOlivine","Olivine","forestry.speciesCertus","forestry.speciesEnded"},
    {"forestry.speciesEmerald","Emerald","forestry.speciesOlivine","forestry.speciesDiamond"},
    {"forestry.speciesCopper","Copper","forestry.speciesMajestic","forestry.speciesClay"},
    {"forestry.speciesTin","Tin","forestry.speciesClay","forestry.speciesDiligent"},
    {"forestry.speciesLead","Lead","forestry.speciesCoal","forestry.speciesCopper"},
    {"forestry.speciesIron","Iron","forestry.speciesTin","forestry.speciesCopper"},
    {"forestry.speciesSteel","Steel","forestry.speciesIron","forestry.speciesCoal"},
    {"forestry.speciesNickel","Nickel","forestry.speciesIron","forestry.speciesCopper"},
    {"forestry.speciesZinc","Zinc","forestry.speciesIron","forestry.speciesTin"},
    {"forestry.speciesSilver","Silver","forestry.speciesLead","forestry.speciesTin"},
    {"forestry.speciesGold","Gold","forestry.speciesLead","forestry.speciesCopper"},
    {"forestry.speciesAluminium","Aluminium","forestry.speciesNickel","forestry.speciesZinc"},
    {"forestry.speciesTitanium","Titanium","forestry.speciesRedstone","forestry.speciesAluminium"},
    {"forestry.speciesChrome","Chrome","forestry.speciesTitanium","forestry.speciesRuby","Requires Block of Chrome as a foundation."},
    {"forestry.speciesManganese","Manganese","forestry.speciesTitanium","forestry.speciesAluminium","Requires Block of Manganese as a foundation."},
    {"forestry.speciesTungsten","Tungsten","forestry.speciesHeroic","forestry.speciesManganese","Requires Block of Tungsten as a foundation."},
    {"forestry.speciesPlatinum","Platinum","forestry.speciesDiamond","forestry.speciesChrome","Requires Block of Platinum as a foundation."},
    {"forestry.speciesIridium","Iridium","forestry.speciesTungsten","forestry.speciesPlatinum","Requires Block of Iridium as a foundation."},
    {"forestry.speciesUranium","Uranium","forestry.speciesAvenging","forestry.speciesPlatinum","Requires Block of Uranium 238 as a foundation."},
    {"forestry.speciesPlutonium","Plutonium","forestry.speciesUranium","forestry.speciesEmerald","Requires Block of Plutonium 244 as a foundation."},
    {"forestry.speciesNaquadah","Naquadah","forestry.speciesPlutonium","forestry.speciesIridium","Requires Block of Naquadah as a foundation."},
    {"magicbees.speciesEldritch","Eldritch","magicbees.speciesMystical","forestry.speciesCultivated"},
    {"magicbees.speciesEsoteric","Esoteric","forestry.speciesCultivated","magicbees.speciesEldritch"},
    {"magicbees.speciesMysterious","Mysterious","magicbees.speciesEldritch","magicbees.speciesEsoteric"},
    {"magicbees.speciesArcane","Arcane","magicbees.speciesEsoteric","magicbees.speciesMysterious","Better success between the Waxing Crescent and Waxing Gibbous."},
    {"magicbees.speciesCharmed","Charmed","forestry.speciesCultivated","magicbees.speciesEldritch"},
    {"magicbees.speciesEnchanted","Enchanted","magicbees.speciesEldritch","magicbees.speciesCharmed"},
    {"magicbees.speciesSupernatural","Supernatural","magicbees.speciesCharmed","magicbees.speciesEnchanted","Better success between the Waning Gibbous and Waning Crescent."},
    {"magicbees.speciesEthereal","Ethereal","magicbees.speciesArcane","magicbees.speciesSupernatural"},
    {"magicbees.speciesWindy","Windy","magicbees.speciesSupernatural","magicbees.speciesEthereal","Requires Oak Leaves as a foundation."},
    {"magicbees.speciesWatery","Watery","magicbees.speciesSupernatural","magicbees.speciesEthereal","Requires Water as a foundation."},
    {"magicbees.speciesEarthen","Earthen","magicbees.speciesSupernatural","magicbees.speciesEthereal","Requires Bricks as a foundation."},
    {"magicbees.speciesFirey","Firey","magicbees.speciesSupernatural","magicbees.speciesEthereal","Requires Lava as a foundation."},
    {"magicbees.speciesAware","Aware","magicbees.speciesEthereal","magicbees.speciesAttuned"},
    {"magicbees.speciesSpirit","Spirit","magicbees.speciesEthereal","magicbees.speciesAware"},
    {"magicbees.speciesSoul","Soul","magicbees.speciesAware","magicbees.speciesSpirit"},
    {"magicbees.speciesPupil","Pupil","forestry.speciesMonastic","magicbees.speciesArcane"},
    {"magicbees.speciesScholarly","Scholarly","magicbees.speciesArcane","magicbees.speciesPupil"},
    {"magicbees.speciesSavant","Savant","magicbees.speciesPupil","magicbees.speciesScholarly"},
    {"magicbees.speciesTimely","Timely","forestry.speciesImperial","magicbees.speciesEthereal"},
    {"magicbees.speciesLordly","Lordly","forestry.speciesImperial","magicbees.speciesTimely"},
    {"magicbees.speciesDoctoral","Doctoral","magicbees.speciesTimely","magicbees.speciesLordly"},
    {"magicbees.speciesHateful","Hateful","magicbees.speciesInfernal","magicbees.speciesEldritch","Occurs within a nether biome."},
    {"magicbees.speciesSpiteful","Spiteful","magicbees.speciesInfernal","magicbees.speciesHateful","Occurs within a nether biome."},
    {"magicbees.speciesWithering","Withering","forestry.speciesDemonic","magicbees.speciesSpiteful","Occurs within a nether biome."},
    {"magicbees.speciesSkulking","Skulking","forestry.speciesModest","magicbees.speciesEldritch"},
    {"magicbees.speciesSpidery","Spidery","forestry.speciesTropical","magicbees.speciesSkulking"},
    {"magicbees.speciesGhastly","Ghastly","magicbees.speciesTCBatty","magicbees.speciesEthereal"},
    {"magicbees.speciesSmouldering","Smouldering","magicbees.speciesGhastly","magicbees.speciesHateful","Occurs within a nether biome."},
    {"magicbees.speciesBigBad","Big Bad","magicbees.speciesSkulking","magicbees.speciesMysterious","During the Full Moon"},
    {"magicbees.speciesTCChicken","Poultry","forestry.speciesCommon","magicbees.speciesSkulking","Occurs within a forest biome."},
    {"magicbees.speciesTCBeef","Beefy","forestry.speciesCommon","magicbees.speciesSkulking","Occurs within a plains biome."},
    {"magicbees.speciesTCPork","Porcine","forestry.speciesCommon","magicbees.speciesSkulking","Occurs within a mountain biome."},
    {"magicbees.speciesSheepish","Sheepish","magicbees.speciesTCPork","magicbees.speciesSkulking","Occurs within a plains biome."},
    {"magicbees.speciesHorse","Neighsayer","magicbees.speciesTCBeef","magicbees.speciesSheepish","Occurs within a plains biome."},
    {"magicbees.speciesCatty","Catty","magicbees.speciesTCChicken","magicbees.speciesSpidery","Occurs within a jungle biome."},
    {"magicbees.speciesTCBatty","Batty","magicbees.speciesSkulking","magicbees.speciesWindy"},
    {"magicbees.speciesTCBrainy","Brainy","magicbees.speciesSkulking","magicbees.speciesPupil"},
    {"magicbees.speciesNameless","Nameless","magicbees.speciesEthereal","magicbees.speciesOblivion"},
    {"magicbees.speciesAbandoned","Abandoned","magicbees.speciesOblivion","magicbees.speciesNameless"},
    {"magicbees.speciesForlorn","Forlorn","magicbees.speciesNameless","magicbees.speciesAbandoned"},
    {"magicbees.speciesDraconic","Draconic","forestry.speciesImperial","magicbees.speciesAbandoned","Occurs within a end biome."},
    {"magicbees.speciesMutable","Mutable","magicbees.speciesUnusual","magicbees.speciesEldritch"},
    {"magicbees.speciesTransmuting","Transmuting","magicbees.speciesUnusual","magicbees.speciesMutable"},
    {"magicbees.speciesCrumbling","Crumbling","magicbees.speciesUnusual","magicbees.speciesMutable"},
    {"magicbees.speciesInvisible","Invisible","magicbees.speciesMystical","magicbees.speciesMutable"},
    {"magicbees.speciesCopper","Cuprum","forestry.speciesIndustrious","forestry.speciesMeadows","Requires Copper Block as a foundation."},
    {"magicbees.speciesTin","Stannum","forestry.speciesIndustrious","forestry.speciesForest","Requires Tin Block as a foundation."},
    {"magicbees.speciesIron","Ferrous","forestry.speciesCommon","forestry.speciesIndustrious","Requires Block of Iron as a foundation."},
    {"magicbees.speciesLead","Plumbum","magicbees.speciesTin","forestry.speciesCommon","Requires Lead Block as a foundation."},
    {"magicbees.speciesSilver","Argentum","forestry.speciesImperial","forestry.speciesModest","Requires Silver Block as a foundation."},
    {"magicbees.speciesGold","Auric","forestry.speciesImperial","magicbees.speciesLead","Requires Block of Gold as a foundation."},
    {"magicbees.speciesAluminum","Aluminum","forestry.speciesIndustrious","forestry.speciesCultivated","Requires Aluminum Block as a foundation."},
    {"magicbees.speciesArdite","Ardite","forestry.speciesIndustrious","magicbees.speciesInfernal","Requires Block of Ardite as a foundation."},
    {"magicbees.speciesCobalt","Cobalt","forestry.speciesImperial","magicbees.speciesInfernal","Requires Block of Cobalt as a foundation."},
    {"magicbees.speciesManyullyn","Manyullyn","magicbees.speciesArdite","magicbees.speciesCobalt","Requires Block of Manyullyn as a foundation."},
    {"magicbees.speciesOsmium","Osmium","magicbees.speciesSilver","magicbees.speciesCobalt","Requires Block of Osmium as a foundation."},
    {"magicbees.speciesDiamond","Diamandi","forestry.speciesAustere","magicbees.speciesGold","Requires Block of Diamond as a foundation."},
    {"magicbees.speciesEmerald","Esmeraldi","forestry.speciesAustere","magicbees.speciesSilver","Requires Block of Emerald as a foundation."},
    {"magicbees.speciesApatite","Apatine","forestry.speciesRural","magicbees.speciesCopper","Requires Block of Apatite as a foundation."},
    {"magicbees.speciesSilicon","Silicon","magicbees.speciesAESkystone","magicbees.speciesIron"},
    {"magicbees.speciesCertus","Certus","magicbees.speciesSilicon","magicbees.speciesAESkystone"},
    {"magicbees.speciesFluix","Fluix","magicbees.speciesCertus","magicbees.speciesAESkystone"},
    {"magicbees.speciesTCAir","Aer","magicbees.speciesWindy","magicbees.speciesWindy","Requires Air Crystal Cluster as a foundation."},
    {"magicbees.speciesTCFire","Ignis","magicbees.speciesFirey","magicbees.speciesFirey","Requires Fire Crystal Cluster as a foundation."},
    {"magicbees.speciesTCWater","Aqua","magicbees.speciesWatery","magicbees.speciesWatery","Requires Water Crystal Cluster as a foundation."},
    {"magicbees.speciesTCEarth","Solum","magicbees.speciesEarthen","magicbees.speciesEarthen","Requires Earth Crystal Cluster as a foundation."},
    {"magicbees.speciesTCOrder","Ordered","magicbees.speciesEthereal","magicbees.speciesArcane","Requires Order Crystal Cluster as a foundation."},
    {"magicbees.speciesTCChaos","Chaotic","magicbees.speciesEthereal","magicbees.speciesSupernatural","Requires Entropy Crystal Cluster as a foundation."},
    {"magicbees.speciesTCVis","Vis","magicbees.speciesEthereal","magicbees.speciesInfernal","Occurs between the Waxing Half and Waning Half"},
    {"magicbees.speciesTCRejuvenating","Rejuvenating","magicbees.speciesAttuned","magicbees.speciesTCVis"},
    {"magicbees.speciesTCEmpowering","Empowering","magicbees.speciesTCVis","magicbees.speciesTCRejuvenating","Better success during the Full Moon."},
    {"magicbees.speciesTCNexus","Nexus","magicbees.speciesTCRejuvenating","magicbees.speciesTCEmpowering","Occurs within a magical biome.|Requires Aura Node as a foundation."},
    {"magicbees.speciesTCFlux","Flux","magicbees.speciesTransmuting","magicbees.speciesTCEmpowering","During the New Moon"},
    {"magicbees.speciesTCPure","Pure","magicbees.speciesTransmuting","magicbees.speciesTCRejuvenating","Occurs within a magical biome.|During the New Moon"},
    {"magicbees.speciesTCHungry","Ravening","magicbees.speciesBigBad","magicbees.speciesTCVis"},
    {"magicbees.speciesTCWispy","Wispy","magicbees.speciesEthereal","magicbees.speciesGhastly","Occurs between the Waning Crescent and Waxing Crescent"},
    {"magicbees.speciesTCVoid","Void","magicbees.speciesIron","magicbees.speciesTCFlux","Occurs within a magical biome.|During the night."},
    {"magicbees.speciesRSAFluxed","Fluxed","magicbees.speciesTEElectrum","magicbees.speciesTEDestabilized","Requires Block of Fluxed Electrum as a foundation."},
    {"magicbees.speciesTEBronze","Bronzed","magicbees.speciesTin","magicbees.speciesCopper","Requires Bronze Block as a foundation."},
    {"magicbees.speciesTEElectrum","Electrum","magicbees.speciesGold","magicbees.speciesSilver","Requires Electrum Block as a foundation."},
    {"magicbees.speciesTENickel","Nickel","magicbees.speciesIron","magicbees.speciesEsoteric","Requires Ferrous Block as a foundation."},
    {"magicbees.speciesTEInvar","Invar","magicbees.speciesIron","magicbees.speciesTENickel","Requires Invar Block as a foundation."},
    {"magicbees.speciesTEPlatinum","Platinum","magicbees.speciesTENickel","magicbees.speciesTEInvar","Requires Shiny Block as a foundation."},
    {"magicbees.speciesTEBronze","Bronzed","magicbees.speciesTin","magicbees.speciesCopper","Requires Bronze Block as a foundation."},
    {"magicbees.speciesTECoal","Carbon","magicbees.speciesSpiteful","magicbees.speciesTin","Requires Coal Ore as a foundation."},
    {"magicbees.speciesTEDestabilized","Destabilized","magicbees.speciesSpiteful","forestry.speciesIndustrious","Requires Redstone Ore as a foundation."},
    {"magicbees.speciesTELux","Lux","magicbees.speciesSmouldering","magicbees.speciesInfernal","Requires Glowstone as a foundation."},
    {"magicbees.speciesTEDante","Dante","magicbees.speciesSmouldering","forestry.speciesAustere","Occurs within a nether biome."},
    {"magicbees.speciesTEPyro","Pyro","magicbees.speciesTEDante","magicbees.speciesTECoal","Occurs within a nether biome."},
    {"magicbees.speciesTEBlizzy","Blizzy","magicbees.speciesSkulking","forestry.speciesWintry"},
    {"magicbees.speciesTEGelid","Gelid","magicbees.speciesTEBlizzy","forestry.speciesIcy"},
    {"magicbees.speciesTEShocking","Shocking","magicbees.speciesSmouldering","magicbees.speciesWindy"},
    {"magicbees.speciesTEAmped","Amped","magicbees.speciesTEShocking","magicbees.speciesWindy"},
    {"magicbees.speciesTEGrounded","Grounded","magicbees.speciesSmouldering","magicbees.speciesEarthen"},
    {"magicbees.speciesTERocking","Rockin',magicbees.speciesTEGrounded","magicbees.speciesEarthen"},
    {"magicbees.speciesTEWinsome","Winsome","magicbees.speciesTEPlatinum","magicbees.speciesOblivion"},
    {"magicbees.speciesTEEndearing","Endearing","magicbees.speciesTEWinsome","magicbees.speciesTECoal","Requires Enderium Block as a foundation."},
    {"magicbees.speciesAESkystone","Skystone","magicbees.speciesEarthen","magicbees.speciesWindy","Requires Sky Stone as a foundation."}
}
--component.inventory_controller.getStackInInternalSlot(1).individual.(passive\active)
local beesWithNoRecipe

for i = 1, 261 do

end


local function compareGenes(individual)
    local sampleAct = individual.active
    local samplePass = individual.inactive
    local numericalDifference = 0
    local differencesInactive = {}
    local differencesActive = {}
    local foundBetterGene = false
    for i = 1, 13 do
        -- ACTIVE GENES
        if sampleAct[i] ~= targetGenes[i] and i ~= 9 and i ~= 10 and i ~= 11 and i ~= 12 then
            differencesActive[i] = 1;
            numericalDifference = numericalDifference + 1
        elseif i == 6 then
            if sampleAct[6] == "Both 2" then
                foundBetterGene = true
                break
            elseif sampleAct[6] ~= targetGenes[6] then
                differencesActive[6] = 1;
                numericalDifference = numericalDifference + 1
            end
        elseif i == 10 then
            if sampleAct[10] > 1.8 then
                foundBetterGene = true
                break
            elseif sampleAct[10] ~= targetGenes[10] then
                differencesActive[10] = 1;
                numericalDifference = numericalDifference + 1
            end
        elseif i == 11 then
            if sampleAct[11] == "Both 2" then
                foundBetterGene = true
                break
            elseif sampleAct[11] ~= targetGenes[11] then
                differencesActive[11] = 1;
                numericalDifference = numericalDifference + 1
            end
        elseif i == 12 then
            if sampleAct[12][1] ~= targetGenes[12][1] then
                differencesActive[12] = 1;
                numericalDifference = numericalDifference + 1
            end
        end
        -- INACTIVE GENES
        if samplePass[i] ~= targetGenes[i] and i ~= 9 and i ~= 10 and i ~= 11 and i ~= 12 then
            differencesInactive[i] = 1;
        elseif i == 6 then
            if samplePass[6] == "Both 2" then
                foundBetterGene = true
                break
            elseif samplePass[6] ~= targetGenes[6] then
                differencesInactive[6] = 1;
                numericalDifference = numericalDifference + 1
            end
        elseif i == 10 then
            if samplePass[10] > 1.8 then
                foundBetterGene = true
                break
            elseif samplePass[10] ~= targetGenes[10] then
                differencesInactive[10] = 1;
                numericalDifference = numericalDifference + 1
            end
        elseif i == 11 then
            if samplePass[11] == "Both 2" then
                foundBetterGene = true
                break
            elseif samplePass[11] ~= targetGenes[11] then
                differencesInactive[11] = 1;
                numericalDifference = numericalDifference + 1
            end
        elseif i == 12 then
            if samplePass[12][1] ~= targetGenes[12][1] then
                differencesInactive[12] = 1;
                numericalDifference = numericalDifference + 1
            end
        end
        return numericalDifference, differencesActive, differencesInactive, foundBetterGene -- NO PROCESSING OF BEES HERE, FUNCTIONS SHOULD DO EVERYTHING DEPENDING ON THIS BUT INSIDE THEMSELVES
    end
end
local function addTask( name, endT, prio )
	if tasks[name] == nil then
		tasks[name] = {endT,prio}
	end
end
local function lookForTask()
	local task
	local bestScore
	for k, v in pairs(tasks) do
		if os.time / 72 > v[1] then
			local newBestScore = (v[1] - (os.time() / 72)) / v[2]
			if task == nil or newBestScore > bestScore then
				bestScore = newBestScore
				task = k
			end
			if v[2] <= 1 then
				task = k
			end
		end
	end
	tasks[task] = nil
	if task == "recharge" then
		recharge(XCoord,YCoord,ZCoord)
	elseif task == "finishConverting" then
		finishConverting()
 	elseif task == "startConverting" then
		convertBee()
	elseif task == "combine" then
        combineBees()
	elseif task == "finishConverting2" then
		finishConverting2()
	end
end
local function recharge(X,Y,Z)
    GoToCoords(0,0,0)
	os.sleep(8)
	GoToCoords(X,Y,Z)
end
local function SetEndOrientation(delta)
	orientationNum = orientationNum + delta
	if orientationNum == 0 then
		orientationNum = 4
		orientation = "X-"
	elseif orientationNum == 1 then
		orientation = "Z+"
	elseif orientationNum == 2 then
		orientation = "X+"
	elseif orientationNum == 3 then
		orientation = "Z-"
	elseif orientationNum == 4 then
		orientation = "X-"
	elseif orientationNum == 5 then
		orientationNum = 1
		orientation = "Z+"
	elseif orientationNum == -1 then
		orientationNum = 3
		orientation = "Z-"
	elseif orientationNum == 6 then
		orientationNum = 2
		orientation = "X+"
	end
end
local function RobotForward()
    if computer.maxEnergy() / 4 > computer.energy() then
        recharge()
    end
    if orientation == "Z-" then
        ZCoord = ZCoord - 1
    elseif orientation == "Z+" then
        ZCoord = ZCoord + 1
    elseif orientation == "X-" then
        XCoord = XCoord - 1
    elseif orientation == "X+" then
        XCoord = XCoord + 1
    end
    robot.forward()
end
local function RobotDown()
    if computer.maxEnergy() / 4 > computer.energy() then
        recharge()
    end
    YCoord = YCoord - 1
    robot.down()
end
local function RobotUp()
    if computer.maxEnergy() / 4 > computer.energy() then
        recharge()
    end
    YCoord = YCoord + 1
    robot.up()
end
local function RobotTurnLeft()
    robot.turnLeft()
    SetEndOrientation(-1)
end
local function RobotTurnRight()
    robot.turnRight()
    SetEndOrientation(1)
end
local function RobotTurnAround()
    robot.turnAround()
    SetEndOrientation(-2)
end
local function SetOrientation(Target)
	local TargetNum
	if Target == "Z+" then
		TargetNum = 1
	elseif Target == "X+" then
		TargetNum = 2
	elseif Target == "Z-" then
		TargetNum = 3
	elseif Target == "X-" then
		TargetNum = 4
	end
	local Diff = TargetNum - orientationNum

	if Diff == -1 or Diff == 3 then
		RobotTurnLeft()
	elseif Diff == 1 or Diff == -3 then
		RobotTurnRight()
	elseif Diff == 2 or Diff == -2 then
		RobotTurnAround()
	end
end
local function GoToX(X)
	if X < XCoord then
		SetOrientation("X-")
		while XCoord > X do
			RobotForward()
		end
	elseif X > XCoord then
		SetOrientation("X+")
		while XCoord < X do
			RobotForward()
		end
	end
end
local function GoToY(Y)
	if Y < YCoord then
		while YCoord > Y do
			RobotDown()
		end
	elseif Y > YCoord then
		while YCoord < Y do
			RobotUp()
		end
	end
end
local function GoToZ(Z)
	if Z < ZCoord then
		SetOrientation("Z-")
		while ZCoord > Z do
			RobotForward()
		end
	elseif Z > ZCoord then
		SetOrientation("Z+")
		while ZCoord < Z do
			RobotForward()
		end
	end
end
local function GoToCoords(X,Y,Z)
    GoToY(0)
	GoToZ(0)
	GoToX(X)
	GoToZ(Z)
	GoToY(Y)
end
local function goTo(machine)
	if machine == "incubator" then
        GoToCoords(-10, 0, 1)
	elseif machine == "polymeriser" then
        GoToCoords(-10, 0, -1)
	elseif machine == "analyzer" then
        GoToCoords(-8, 0, -1)
	elseif machine == "inoculator" then
        GoToCoords(-2, 0, -1)
	elseif machine == "hatchery" then
        GoToCoords(-12, 0, 1)
    elseif machine == "alveary" then
        GoToCoords(-12, 1, 1)
    elseif machine == "api1" then
        GoToCoords(-11, 0, -1)
    elseif machine == "api2" then
        GoToCoords(-12, 0, -1)
    elseif machine == "api3" then
        GoToCoords(-13, 0, -1)
	elseif machine == "beeChest1" then
		GoToCoords()
	elseif machine == "beeChest2" then
		GoToCoords()
	elseif machine == "beeChest3" then
		GoToCoords()
	elseif machine == "beeChest4" then
		GoToCoords()
	elseif machine == "beeChest5" then
		GoToCoords()
	elseif machine == "beeChest6" then
		GoToCoords()
	elseif machine == "beeChest7" then
		GoToCoords()
	elseif machine == "beeChest8" then
		GoToCoords()
	end
end
local function convertBee()
    goTo("")--beeChest
	--TODO:scanforbeesinchest
	--TODO:takeBee
	goTo("analyzer")
	robot.select(1)
	robot.drop()
	robot.select(2)
	robot.drop()
	goTo("analyzer")
	while inv.getStackInSlot(3,10) == nil do
		os.sleep(5)
	end
	robot.select(1)
	robot.suck(3);robot.suck(3)
	goTo("alveary")
	robot.drop();robot.drop()
	local convertingDone = false
	while convertingDone == false do
		while inv.getStackInSlot(3,1) ~= nil do
			os.sleep(5)
		end
		goTo("hatchery")
		if inv.getStackInSlot(3,5) == nil then
			goTo("alveary")
			local droppedDrone = false
			for i=3, inv.getInventorySize(3) do
				if inv.getStackInSlot(3, i).name == "Forestry:beePrincessGE" then
					robot.select(16)
					inv.suckFromSlot(3,i)
					robot.drop()
				elseif inv.getStackInSlot(3, i).name == "Forestry:beeDroneGE" and droppedDrone == false then
					robot.select(16)
					inv.suckFromSlot(3,i)
					robot.drop()
					droppedDrone = true
				else
					robot.select(16)
					inv.suckFromSlot(3,i)
					robot.dropUp()
				end
			end
		else
			robot.select(1)
			robot.suck(3);robot.suck(3);robot.suck(3);robot.suck(3);robot.suck(3);
			goTo("polymeriser")
			robot.select(6)
			while robot.suck(3) == false do
				os.sleep(5)
			end
			goTo("inoculator")
			robot.select(1);robot.drop()robot.select(2);robot.drop()robot.select(3);robot.drop()robot.select(4);robot.drop()robot.select(5);robot.drop()robot.select(6);robot.drop()
            addTask("finishConverting", os.time/72 + 5*5*11*60, 2) --priority high because task takes a lot of time, but recharging should be priority 1
		end
	end
end
-- TODO: SERUMS ARE IMPOSSIBLE TO TAKE OUT BEFORE THEY ARE EMPTY
local function finishConverting()
	goTo("inoculator")
	robot.select(1)
	robot.suck(3);robot.suck(3)robot.suck(3);robot.suck(3);robot.suck(3)
	goTo("alveary")
	for i = 3, inv.getInventorySize(3) do
		robot.select(16)
		inv.suckFromSlot(3,i)
		robot.dropUp()
	end
	robot.select(1)
	robot.drop()
    for i = 1, 5 do
        while inv.getStackInSlot(3,1).name == "Forestry:beeQueenGE" do
            os.sleep(5)
        end
        if i == 1 then
            for i=3, inv.getInventorySize(3) do
                if inv.getStackInSlot(3, i).name == "Forestry:beePrincessGE" then
                    robot.select(16)
                    inv.suckFromSlot(3,i)
                    robot.drop()
                else
                    robot.select(16)
                    inv.suckFromSlot(3,i)
                    robot.dropUp()
                end
            end
        else
            local goodDrones = 0
            local dronesTaken = 0
            for i=3, inv.getInventorySize(3) do
                if inv.getStackInSlot(3, i).name == "Forestry:beePrincessGE" then
                    robot.select(5)
                    inv.suckFromSlot(3,i)
                    goTo("analyzer")
                    robot.drop()
                    os.sleep(35)
                    robot.suck(3)
                    local numericalDiff,_,_,_ = compareGenes(inv.getStackInInternalSlot(5).individual)
                    if numericalDiff == 0 then
						goTo("alveary")
						robot.drop()
                        if i == 5 and goodDrones == 0 then
                            goTo("hatchery")
                            robot.select(6)
                            robot.suck(3)
                            goTo("polymeriser")
							robot.drop()
							addTask("finishConverting2", os.time/72 + 5*11*60, 2)
                        elseif (i == 5 and goodDrones > 0) or i < 5 then
							finishConverting3()
						end
                    end
                elseif inv.getStackInSlot(3, i).name == "Forestry:beeDroneGE" then
                    robot.select(15-dronesTaken)
                    inv.suckFromSlot(3,i)
				else
					robot.select(16)
					inv.suckFromSlot(3,i)
					robot.dropUp()
				end
            end
            if dronesTaken > 0 then
                goTo("analyzer")
                for i = 1, dronesTaken do
                    robot.select(16-i)
                    robot.drop()
                    os.sleep(32)
                    robot.select(4)
                    robot.suck(3)
                    local numericalDiff,_,_,_ = compareGenes(inv.getStackInInternalSlot(4).individual)
                    if numericalDiff == 0 then
                        goodDrones = goodDrones + 1
                        goTo("alveary")
                        robot.drop()
                        goTo("analyzer")
                    else
                       robot.dropUp()
                    end
                end
            end
        end
	end
end
local function finishConverting2()
	robot.select(6)
	goTo("polymeriser")
	robot.suck(3)
	goTo("alveary")
	robot.drop()
	finishConverting3()
end
local function finishConverting3()
	for i = 1, 21 do
		while inv.getStackInSlot(3,1).name == "Forestry:beeQueenGE" do
			os.sleep(5)
        end
		for ii = 1, inv.getInventorySize(3) do
			local dronesTaken = 0
			if inv.getStackInSlot(3, ii).name == "Forestry:beePrincessGE" then
				robot.select(5)
				inv.suckFromSlot(3,ii)
                if i < 21 then
                    robot.drop()
                end
			elseif inv.getStackInSlot(3, ii).name == "Forestry:beeDroneGE" then
				robot.select(6)
                inv.suckFromSlot(3,ii,3)
                robot.select(7)
                inv.suckFromSlot(3,ii,1)
                robot.drop()
			else
				robot.select(16)
				inv.suckFromSlot(3,ii)
				robot.dropUp()
			end
        end
    end
    goTo("hatchery")
    robot.select(16)
    for i = 1, 5 do
        inv.suckFromSlot(3,i)
        robot.dropUp()
    end
    --TODO: GOTO BEE CHESTS AND UNLOAD
end
local function combineBees()

end
while true do
	lookForTask()
end

-- TODO: STACKS MAY CONTAIN MORE THAN ONE DRONE