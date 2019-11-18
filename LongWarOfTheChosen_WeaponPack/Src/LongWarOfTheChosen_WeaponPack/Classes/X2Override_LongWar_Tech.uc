class X2Override_LongWar_Tech extends X2Override_LongWar;

// rewire tech tree
static function UpdateBaseGameLaserAndCoilTechTemplates()
{
	local X2TechTemplate TechTemplate;
	local array<X2TechTemplate> TechTemplates;

	if (class'X2Item_Schematic_LongWar'.default.USE_SCHEMATICS)
	{
		FindTechTemplateAllDifficulties('Tech_Elerium', TechTemplates);
		foreach TechTemplates(TechTemplate)
		{
			TechTemplate.Requirements.RequiredTechs.Length = 0;
			TechTemplate.Requirements.RequiredTechs.AddItem('PlatedArmor');
			TechTemplate.Requirements.SpecialRequirementsFn = IsEleriumTechVisible_LW;
		}
		FindTechTemplateAllDifficulties('PlasmaRifle', TechTemplates);
		foreach TechTemplates(TechTemplate)
		{
			TechTemplate.Requirements.RequiredTechs.AddItem(class'X2StrategyElement_LaserTechs'.default.LaserWeaponTech_Tier[1]);
		}
	}
}

static function bool IsEleriumTechVisible_LW()
{
	local array<name> TechNames;
	
	TechNames.AddItem('PlatedArmor');

	return AreTechRequirementsMet_LW(TechNames);
}

static function bool AreTechRequirementsMet_LW(array<name> TechNames)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	return XComHQ.MeetsTechRequirements(TechNames);
}

static function UpdateWeaponTemplates(X2ItemTemplateManager ItemTemplateManager)
{
	if (class'X2Item_Schematic_LongWar'.default.USE_SCHEMATICS)
	{
		//update Plasma templates so they upgrade from Lasers
		SetWeaponBaseItem(ItemTemplateManager, 'AssaultRifle_BM', 'AssaultRifle_LS');
		SetWeaponBaseItem(ItemTemplateManager, 'Cannon_BM', 'Cannon_LS');
		SetWeaponBaseItem(ItemTemplateManager, 'MarksmanRifle_BM', 'MarksmanRifle_LS');
		SetWeaponBaseItem(ItemTemplateManager, 'Pistol_BM', 'Pistol_LS');
		SetWeaponBaseItem(ItemTemplateManager, 'SAW_BM', 'SAW_LS');
		SetWeaponBaseItem(ItemTemplateManager, 'Shotgun_BM', 'Shotgun_LS');
		SetWeaponBaseItem(ItemTemplateManager, 'SMG_BM', 'SMG_LS');
		SetWeaponBaseItem(ItemTemplateManager, 'SniperRifle_BM', 'SniperRifle_LS');
		SetWeaponBaseItem(ItemTemplateManager, 'SparkRifle_BM', 'SparkRifle_LS');

		//update Mag schematics so they are hidden if Coil tier is purchased
		SetSchematicOverriddenBy(ItemTemplateManager, 'AssaultRifle_MG_Schematic', 'AssaultRifle_CG');
		SetSchematicOverriddenBy(ItemTemplateManager, 'Cannon_MG_Schematic', 'Cannon_CG');
		SetSchematicOverriddenBy(ItemTemplateManager, 'MarksmanRifle_MG_Schematic', 'MarksmanRifle_CG');
		SetSchematicOverriddenBy(ItemTemplateManager, 'Pistol_MG_Schematic', 'Pistol_CG');
		SetSchematicOverriddenBy(ItemTemplateManager, 'SAW_MG_Schematic', 'SAW_CG');
		SetSchematicOverriddenBy(ItemTemplateManager, 'Shotgun_MG_Schematic', 'Shotgun_CG');
		SetSchematicOverriddenBy(ItemTemplateManager, 'SMG_MG_Schematic', 'SMG_CG');
		SetSchematicOverriddenBy(ItemTemplateManager, 'SniperRifle_MG_Schematic', 'SniperRifle_CG');
		SetSchematicOverriddenBy(ItemTemplateManager, 'SparkRifle_MG_Schematic', 'SparkRifle_CG');
	}
}

static function SetWeaponBaseItem(X2ItemTemplateManager ItemTemplateMgr, name Weapon, name BaseItem)
{
	local array<X2ItemTemplate> ItemTemplates;
	local X2WeaponTemplate WeaponTemplate;
	local X2ItemTemplate ItemTemplate;

	FindItemTemplateAllDifficulties(Weapon, ItemTemplates, ItemTemplateMgr);

	foreach ItemTemplates(ItemTemplate)
	{
		WeaponTemplate = X2WeaponTemplate(ItemTemplate);
		if(WeaponTemplate!=none)
		{
			WeaponTemplate.BaseItem = BaseItem; // Which item this will be upgraded from
		}
	}
}

static function SetSchematicOverriddenBy(X2ItemTemplateManager ItemTemplateMgr, name Schematic, name HideIfPurchased)
{
	local array<X2ItemTemplate> ItemTemplates;
	local X2SchematicTemplate SchematicTemplate;
	local X2ItemTemplate ItemTemplate;

	FindItemTemplateAllDifficulties(Schematic, ItemTemplates, ItemTemplateMgr);

	foreach ItemTemplates(ItemTemplate)
	{
		SchematicTemplate = X2SchematicTemplate(ItemTemplate);
		if(SchematicTemplate!=none)
		{
			SchematicTemplate.HideIfPurchased = HideIfPurchased;
		}
	}
}
