class X2Item_LongWar_SniperRifle extends X2Item_LongWar_Weapon config(LongWar_WeaponPack_SniperRifle);

var config array<WeaponDamageValue> SniperRifle_Damage;
var config array<int> SniperRifle_Aim;
var config array<int> SniperRifle_CritChance;
var config array<int> SniperRifle_ClipSize;
var config array<int> SniperRifle_SoundRange;
var config array<int> SniperRifle_EnvironmentDamage;
var config array<int> SniperRifle_SellValue;
var config array<int> SniperRifle_UpgradeSlots;
var config array<int> SniperRifle_SupplyCost;
var config array<int> SniperRifle_AlloyCost;
var config array<int> SniperRifle_EleriumCost;
var config array<int> SniperRifle_Engineering;
var config array<name> SniperRifle_RequiredTech;
var config array<string> SniperRifle_ImagePath;
var config array<name> SniperRifle_BaseItem;

var name SniperRifleLaser;
var name SniperRifleCoil;

defaultproperties
{
	SniperRifleLaser = "SniperRifle_LS"
	SniperRifleCoil = "SniperRifle_CG"
	bShouldCreateDifficultyVariants = true
}

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;
	Weapons.AddItem(Create_SniperRifle_Laser(default.SniperRifleLaser));
	Weapons.AddItem(Create_SniperRifle_Coil(default.SniperRifleCoil));
	return Weapons;
}

static function Create_SniperRifle_Template(out X2WeaponTemplate Template, int tier)
{
	//Default Settings
	Template.WeaponCat = 'sniper_rifle';
	Template.ItemCat = 'weapon';
	Template.iPhysicsImpulse = 5;
	Template.Tier = tier;
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';
	Template.strImage = "img:///" $ default.SniperRifle_ImagePath[tier];
	Assign_Tier_Values(Template);

	//Abilities
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.iTypicalActionCost = 2;
	Template.Abilities.AddItem('SniperStandardFire');
	Template.Abilities.AddItem('SniperRifleOverwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('WeaponReloadingDebuff');
	Template.Abilities.AddItem('WeaponTypeSniper');

	//Stats
	Template.RangeAccuracy = default.LW_LONG_RANGE;
	Template.BaseDamage = default.SniperRifle_Damage[tier];
	Template.Aim = default.SniperRifle_Aim[tier];
	Template.CritChance = default.SniperRifle_CritChance[tier];
	Template.iClipSize = default.SniperRifle_ClipSize[tier];
	Template.iSoundRange = default.SniperRifle_SoundRange[tier];
	Template.iEnvironmentDamage = default.SniperRifle_EnvironmentDamage[tier];
	Template.TradingPostValue = default.SniperRifle_SellValue[tier];
	Template.NumUpgradeSlots = default.SniperRifle_UpgradeSlots[tier];
	
	// Building info
	if (BuildWeaponSchematics(Template))
	{
		Template.CreatorTemplateName = name(string(Template.DataName) $ string('_Schematic')); // The schematic which creates this item
		Template.BaseItem = GetBaseItem("SniperRifle", tier); //default.SniperRifle_BaseItem[tier]; // Which item this will be upgraded from
	}
	else
	{
		CreateTemplateCost(Template, default.SniperRifle_RequiredTech[Template.Tier], 
			default.SniperRifle_SupplyCost[tier], default.SniperRifle_AlloyCost[Template.Tier], 
			default.SniperRifle_EleriumCost[tier], default.SniperRifle_Engineering[Template.Tier]);
	}
}

static function Modify_SniperRifle(name TemplateName, int Tier)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2WeaponTemplate Template;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	if (ItemTemplateManager == none) {
		`Redscreen("LW WeaponPack : failed to retrieve ItemTemplateManager");
		return;
	}
	
	Template = X2WeaponTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	if(Template != none)
	{
		Template.Abilities.Length = 0;
		Create_SniperRifle_Template(Template, Tier);
	}
	else
	{
		`Redscreen("LW WeaponPack : failed to find template " $ string(TemplateName));
	}
}

static function X2DataTemplate Create_SniperRifle_Laser(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	Create_SniperRifle_Template(Template, 1);

	// Model
	Template.GameArchetype = "LWSniperRifle_LS.Archetype.WP_SniperRifle_LS";
	Template.AddDefaultAttachment('Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_A", , "img:///UILibrary_LW_LaserPack.LaserSniper_MagA");
	Template.AddDefaultAttachment('Stock', "LWAttachments_LS.Meshes.SK_Laser_Stock_A", , "img:///UILibrary_LW_LaserPack.LaserSniper_StockA");
	Template.AddDefaultAttachment('Reargrip', "LWAttachments_LS.Meshes.SK_Laser_Trigger_A", , "img:///UILibrary_LW_LaserPack.LaserSniper_TriggerA");
	Template.AddDefaultAttachment('Foregrip', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_A", , "img:///UILibrary_LW_LaserPack.LaserSniper_ForegripA");
	Template.AddDefaultAttachment('Optic', "LWSniperRifle_LS.Meshes.SK_LaserSniper_Optic_A", , "img:///UILibrary_LW_LaserPack.LaserSniper_OpticA");

	return Template;
}

static function X2DataTemplate Create_SniperRifle_Coil(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	Create_SniperRifle_Template(Template, 3);

	// Model
	Template.GameArchetype = "LWSniperRifle_CG.Archetypes.WP_SniperRifle_CG";
	Template.AddDefaultAttachment('Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagA", , "img:///UILibrary_LW_Coilguns.InventoryArt.CoilSniperRifle_MagA");
	Template.AddDefaultAttachment('Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticA", , "img:///UILibrary_LW_Coilguns.InventoryArt.CoilSniperRifle_OpticA");
	Template.AddDefaultAttachment('Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", , "img:///UILibrary_LW_Coilguns.InventoryArt.CoilSniperRifle_StockB");
	Template.AddDefaultAttachment('Reargrip', "LWAccessories_CG.Meshes.LW_Coil_ReargripA", , "img:///UILibrary_LW_Coilguns.InventoryArt.CoilSniperRifle_ReargripA");
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight

	return Template;
}