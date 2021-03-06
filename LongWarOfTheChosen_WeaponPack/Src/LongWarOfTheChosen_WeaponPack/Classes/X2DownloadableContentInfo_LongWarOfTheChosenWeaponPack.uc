//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_LWOTCWeaponPack.uc
//  AUTHOR:  Amineri / Pavonis Interactive
//  PURPOSE: Initializes Officer mod settings on campaign start or when loading campaign without mod previously active
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_LongWarOfTheChosenWeaponPack extends X2DownloadableContentInfo;

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed. When a new campaign is started the initial state of the world
/// is contained in a strategy start state. Never add additional history frames inside of InstallNewCampaign, add new state objects to the start state
/// or directly modify start state objects
/// </summary>
//static event InstallNewCampaign(XComGameState StartState);

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{
	UpdateConventionalStorage();
	AddLaserAndCoilTechGameStates();
}
/// <summary>
/// This method is run when the player loads a saved game directly into Strategy while this DLC is installed
/// </summary>
static event OnLoadedSavedGameToStrategy()
{
	AddLaserAndCoilTechGameStates();
}

// ******** HANDLE UPDATING STORAGE ************* //
// This handles updating storage in order to create conventional weapons
static function UpdateConventionalStorage()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2ItemTemplateManager ItemTemplateMgr;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Item NewItemState;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ Storage to add SMGs");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);
	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	//add Conventional SMG always
	`Log("LW SMGPack : Updated Conventional SMG");
	ItemTemplate = ItemTemplateMgr.FindItemTemplate('SMG_CV');
	if(ItemTemplate != none)
	{
		`Log("LW SMGPack : Found SMG_CV item template");
		if (!XComHQ.HasItem(ItemTemplate))
		{
			`Log("LW SMGPack : SMG_CV not found, adding to inventory");
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			XComHQ.AddItemToHQInventory(NewItemState);
			History.AddGameStateToHistory(NewGameState);
		} else {
			`Log("LW SMGPack : SMG_CV found, skipping inventory add");
			History.CleanupPendingGameState(NewGameState);
		}
	}

	//add Conventional Marksman Rifle always
	`Log("LWOTC WeaponPack : Updated Conventional MR");
	ItemTemplate = ItemTemplateMgr.FindItemTemplate('MarksmanRifle_CV');
	if(ItemTemplate != none)
	{
		`Log("LW SMGPack : Found MarksmanRifle_CV item template");
		if (!XComHQ.HasItem(ItemTemplate))
		{
			`Log("LW SMGPack : MarksmanRifle_CV not found, adding to inventory");
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			XComHQ.AddItemToHQInventory(NewItemState);
			History.AddGameStateToHistory(NewGameState);
		} else {
			`Log("LW SMGPack : MarksmanRifle_CV found, skipping inventory add");
			History.CleanupPendingGameState(NewGameState);
		}
	}

	//add Conventional SAW always
	`Log("LWOTC WeaponPack : Updated Conventional SAW");
	ItemTemplate = ItemTemplateMgr.FindItemTemplate('BattleRifle_CV');
	if(ItemTemplate != none)
	{
		`Log("LW SAWPack : Found SAW item template");
		if (!XComHQ.HasItem(ItemTemplate))
		{
			`Log("LW SAWPack : SAW_CV not found, adding to inventory");
			NewItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(NewItemState);
			XComHQ.AddItemToHQInventory(NewItemState);
			History.AddGameStateToHistory(NewGameState);
		} else {
			`Log("LW SAWPack : SAW_CV found, skipping inventory add");
			History.CleanupPendingGameState(NewGameState);
		}
	}

	//schematics should be handled already, as the BuildItem UI draws from ItemTemplates, which are automatically loaded
}

// This handles creating necessary XCGS_Tech items, which are used to load templates in various places
static function AddLaserAndCoilTechGameStates()
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local X2StrategyElementTemplateManager StrategyElementTemplateMgr;
	local XComGameState_Tech TechState;
	local X2TechTemplate TechTemplate;
	local name TechName;
	local bool bFoundTech;

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Adding Laser Weapon Techs");
	StrategyElementTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();


	// Grab all new Tech Templates
	foreach class'X2StrategyElement_LaserTechs'.default.LaserWeaponTech_Tier(TechName)
	{
		bFoundTech = false;
		TechTemplate = X2TechTemplate(StrategyElementTemplateMgr.FindStrategyElementTemplate(TechName));
		if(TechTemplate == none)
		{
			`REDSCREEN("X2DLCInfo_LWLaserPack: Unable to find template" @ string(TechName));
			continue;
		}

		foreach History.IterateByClassType(class'XComGameState_Tech', TechState)
		{
			if(TechState.GetMyTemplateName() == TechName)
			{
				bFoundTech = true;
				break;
			}
		}
		if(bFoundTech)
			continue;

		//`LOG("X2DLCInfo_LWLaserPack: Create Tech GameState from" @ string(TechName));
		TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
		TechState.OnCreation(TechTemplate);
		NewGameState.AddStateObject(TechState);
	}

	// Grab all new Tech Templates
	foreach class'X2StrategyElement_CoilTechs'.default.CoilWeaponTech_Tier(TechName)
	{
		bFoundTech = false;
		TechTemplate = X2TechTemplate(StrategyElementTemplateMgr.FindStrategyElementTemplate(TechName));
		if(TechTemplate == none)
		{
			`REDSCREEN("X2DLCInfo_LWLaserPack: Unable to find template" @ string(TechName));
			continue;
		}

		foreach History.IterateByClassType(class'XComGameState_Tech', TechState)
		{
			if(TechState.GetMyTemplateName() == TechName)
			{
				bFoundTech = true;
				break;
			}
		}
		if(bFoundTech)
			continue;

		//`LOG("X2DLCInfo_LWLaserPack: Create Tech GameState from" @ string(TechName));
		TechState = XComGameState_Tech(NewGameState.CreateStateObject(class'XComGameState_Tech'));
		TechState.OnCreation(TechTemplate);
		NewGameState.AddStateObject(TechState);
	}

	if(NewGameState.GetNumGameStateObjects() > 0)
		History.AddGameStateToHistory(NewGameState);
	else
		History.CleanupPendingGameState(NewGameState);
}

/// <summary>
/// Called after the Templates have been created (but before they are validated) while this DLC / Mod is installed.
/// </summary>
static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager ItemTemplateManager;

	//get access to item template manager to update existing upgrades
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	if (ItemTemplateManager == none) {
		`Redscreen("LW SMGPack : failed to retrieve ItemTemplateManager to configure upgrades");
		return;
	}
	
	class'X2Item_LongWar_AssaultRifle'.static.Modify_AssaultRifle('AssaultRifle_CV', 0);
	class'X2Item_LongWar_AssaultRifle'.static.Modify_AssaultRifle('AssaultRifle_MG', 2);
	class'X2Item_LongWar_AssaultRifle'.static.Modify_AssaultRifle('AssaultRifle_BM', 4);
	
	class'X2Item_LongWar_SniperRifle'.static.Modify_SniperRifle('SniperRifle_CV', 0);
	class'X2Item_LongWar_SniperRifle'.static.Modify_SniperRifle('SniperRifle_MG', 2);
	class'X2Item_LongWar_SniperRifle'.static.Modify_SniperRifle('SniperRifle_BM', 4);
	
	class'X2Item_LongWar_Shotgun'.static.Modify_Shotgun('Shotgun_CV', 0);
	class'X2Item_LongWar_Shotgun'.static.Modify_Shotgun('Shotgun_MG', 2);
	class'X2Item_LongWar_Shotgun'.static.Modify_Shotgun('Shotgun_BM', 4);
	
	class'X2Item_LongWar_Cannon'.static.Modify_Cannon('Cannon_CV', 0);
	class'X2Item_LongWar_Cannon'.static.Modify_Cannon('Cannon_MG', 2);
	class'X2Item_LongWar_Cannon'.static.Modify_Cannon('Cannon_BM', 4);
	
	class'X2Item_LongWar_Pistol'.static.Modify_Pistol('Pistol_CV', 0);
	class'X2Item_LongWar_Pistol'.static.Modify_Pistol('Pistol_MG', 2);
	class'X2Item_LongWar_Pistol'.static.Modify_Pistol('Pistol_BM', 4);

	class'X2Override_Attachments_SMG'.static.UpdateSMGAttachmentTemplates(ItemTemplateManager);
	class'X2Override_Attachments_BattleRifle'.static.UpdateBattleRifleAttachmentTemplates(ItemTemplateManager);
	class'X2Override_Attachments_MarksmanRifle'.static.UpdateMarksmanRifleAttachmentTemplates(ItemTemplateManager);
	class'X2Override_Attachments_Laser'.static.UpdateLaserAttachmentTemplates(ItemTemplateManager);
	class'X2Override_Attachments_Coil'.static.UpdateCoilAttachmentTemplates(ItemTemplateManager);
	
	class'X2Override_LongWar_Tech'.static.UpdateBaseGameLaserAndCoilTechTemplates();
	class'X2Override_LongWar_Tech'.static.UpdateWeaponTemplates(ItemTemplateManager);

	AddSchematicLoc (ItemTemplateManager);
	AddAbilitiesToActionPoints();
}

// This adds the soldier class to the schematic string [SHARPSHOOTER UPGRADE] draws from vanilla so we don't have to rewrite a ton of loc
static function AddSchematicLoc (X2ItemTemplateManager ItemTemplateMgr)
{
	CopySchematicLoc (ItemTemplateMgr, 'AssaultRifle_LS_Schematic', 'AssaultRifle_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'AssaultRifle_CG_Schematic', 'AssaultRifle_MG_Schematic');

	CopySchematicLoc (ItemTemplateMgr, 'Bullpup_LS_Schematic', 'Bullpup_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'Bullpup_CG_Schematic', 'Bullpup_MG_Schematic');

	CopySchematicLoc (ItemTemplateMgr, 'Cannon_LS_Schematic', 'Cannon_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'Cannon_CG_Schematic', 'Cannon_MG_Schematic');

	CopySchematicLoc (ItemTemplateMgr, 'MarksmanRifle_LS_Schematic', 'SniperRifle_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'MarksmanRifle_MG_Schematic', 'SniperRifle_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'MarksmanRifle_CG_Schematic', 'SniperRifle_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'MarksmanRifle_BM_Schematic', 'SniperRifle_MG_Schematic');

	CopySchematicLoc (ItemTemplateMgr, 'Sidearm_LS_Schematic', 'Sidearm_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'Sidearm_CG_Schematic', 'Sidearm_MG_Schematic');

	CopySchematicLoc (ItemTemplateMgr, 'Pistol_LS_Schematic', 'Pistol_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'Pistol_CG_Schematic', 'Pistol_MG_Schematic');

	CopySchematicLoc (ItemTemplateMgr, 'SAW_LS_Schematic', 'Cannon_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'SAW_MG_Schematic', 'Cannon_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'SAW_CG_Schematic', 'Cannon_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'SAW_BM_Schematic', 'Cannon_MG_Schematic');

	CopySchematicLoc (ItemTemplateMgr, 'Shotgun_LS_Schematic', 'Shotgun_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'Shotgun_CG_Schematic', 'Shotgun_MG_Schematic');

	CopySchematicLoc (ItemTemplateMgr, 'SMG_LS_Schematic', 'AssaultRifle_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'SMG_MG_Schematic', 'AssaultRifle_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'SMG_CG_Schematic', 'AssaultRifle_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'SMG_BM_Schematic', 'AssaultRifle_MG_Schematic');

	CopySchematicLoc (ItemTemplateMgr, 'SniperRifle_LS_Schematic', 'SniperRifle_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'SniperRifle_CG_Schematic', 'SniperRifle_MG_Schematic');

	CopySchematicLoc (ItemTemplateMgr, 'SparkRifle_LS_Schematic', 'SparkRifle_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'SparkRifle_CG_Schematic', 'SparkRifle_MG_Schematic');

	CopySchematicLoc (ItemTemplateMgr, 'Vektor_LS_Schematic', 'VektorRifle_MG_Schematic');
	CopySchematicLoc (ItemTemplateMgr, 'Vektor_CG_Schematic', 'VektorRifle_MG_Schematic');
}

static function CopySchematicLoc (X2ItemTemplateManager ItemTemplateMgr, Name NewItem, Name BaseItem)
{
	local X2SchematicTemplate NewTemplate, BaseTemplate;

	BaseTemplate = X2SchematicTemplate (ItemTemplateMgr.FindItemTemplate (BaseItem));
	NewTemplate = X2SchematicTemplate (ItemTemplateMgr.FindItemTemplate (NewItem));

	if (NewTemplate != none && BaseTemplate != none)
	{
		NewTemplate.m_strClassLabel = BaseTemplate.m_strClassLabel;
	}
	else
	{
		`REDSCREEN ("Missing something from" @ NewItem @ BaseItem);
	}
}

static function AddAbilitiesToActionPoints()
{
	local name AbilityName;

	foreach class'X2Ability_WeaponAbilities'.default.SPINUP_VALID_ABILITIES(AbilityName)
	{
		AddActionPointType(AbilityName, class'X2Ability_WeaponAbilities'.default.SpinupActionPoint);
	}
}

static function AddActionPointType(name AbilityName, name ActionPointType)
{
	local X2AbilityTemplateManager				AbilityTemplateMgr;
	local array<X2AbilityTemplate>				AbilityTemplateArray;
	local X2AbilityTemplate						AbilityTemplate;
	local X2AbilityCost_ActionPoints			ActionPointCost;
    local X2AbilityCost							Cost;

	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplateMgr.FindAbilityTemplateAllDifficulties(AbilityName, AbilityTemplateArray);
	foreach AbilityTemplateArray(AbilityTemplate)
	{
		foreach AbilityTemplate.AbilityCosts(Cost)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Cost);
			if (ActionPointCost != none)
			{
				ActionPointCost.AllowedTypes.AddItem(ActionPointType);
			}
		}
	}
}

// Create localization variables so I don't have to copy paste this shit into XComGame.int a million times
static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);

	switch(Type)
	{
	case 'Basic':
		OutString = "The troops would appreciate it if we got them better weaponry as soon as possible.";
		return true;
	case 'Magnetic':
		OutString = "Magnetic weapons grant +10 crit and +1 crit damage, but have a -5 aim penalty.";
		return true;
	case 'Coilgun':
		OutString = "Coil weapons grant +20 crit and +1 crit damage.";
		return true;
	case 'Laser':
		OutString = "Laser weapons grant +5 aim and +1 pierce, but have a -1 mobility penalty.";
		return true;
	case 'Plasma':
		OutString = "Plasma weapons grant +10 aim and +1 pierce.";
		return true;

	case 'Assault':
		OutString = "Assault Rifles are mid-ranged, decently powerful weapons with no major strengths or weaknesses.";
		return true;
	case 'Shotgun':
		OutString = "Shotguns are close range brutes perfect for exploiting flanks, but they have terrible stability and precision.";
		return true;
	case 'SMG':
		OutString = "Carbines are lightweight weapons that are less damaging and weak against armor, but they have excellent handling and mobility.";
		return true;
	case 'SAW':
		OutString = "Battle Rifles are a heavier alternative to the Assault Rifle, trading mobility and handling for damage and stability.";
		return true;
	case 'DMR':
		OutString = "Marksman Rifles are precise weapons that sacrifice the Sniper Rifle's damage in return for higher mobility, handling, and stability.";
		return true;
	case 'LMG':
		OutString = "Light Machine Guns are mid to long range powerhouses with immense damage, but must set up before firing or face a massive aim penalty.";
		return true;
	case 'Sniper':
		OutString = "Sniper Rifles are long ranged high damage weapons that have innate armour piercing and unlimited range, but terrible handling.";
		return true;
	case 'Pistol':
		OutString = "Pistols are backup short range weapons that have perfect handling and stability, but they have low damage and are weak against armor.";
		return true;
	}
	return false;
}
