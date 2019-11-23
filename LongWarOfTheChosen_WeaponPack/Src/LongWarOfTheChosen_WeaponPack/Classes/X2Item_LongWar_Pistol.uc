class X2Item_LongWar_Pistol extends X2Item_LongWar_Weapon config(LongWar_WeaponPack_Pistol);

var config array<WeaponDamageValue> Pistol_Damage;
var config array<int> Pistol_Aim;
var config array<int> Pistol_CritChance;
var config array<int> Pistol_ClipSize;
var config array<int> Pistol_SoundRange;
var config array<int> Pistol_EnvironmentDamage;
var config array<int> Pistol_SellValue;
var config array<int> Pistol_UpgradeSlots;
var config array<int> Pistol_SupplyCost;
var config array<int> Pistol_AlloyCost;
var config array<int> Pistol_EleriumCost;
var config array<int> Pistol_Engineering;
var config array<name> Pistol_RequiredTech;
var config array<string> Pistol_ImagePath;
var config array<name> Pistol_BaseItem;

var name PistolLaser;
var name PistolCoil;

defaultproperties
{
	PistolLaser = "Pistol_LS"
	PistolCoil = "Pistol_CG"
	bShouldCreateDifficultyVariants = true
}

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;
	Weapons.AddItem(Create_Pistol_Laser(default.PistolLaser));
	Weapons.AddItem(Create_Pistol_Coil(default.PistolCoil));
	return Weapons;
}

static function Create_Pistol_Template(out X2WeaponTemplate Template, int tier)
{
	//Default Settings
	Template.WeaponCat = 'pistol';
	Template.ItemCat = 'weapon';
	Template.iPhysicsImpulse = 5;
	Template.Tier = tier;
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Pistol';
	Template.strImage = "img:///" $ default.Pistol_ImagePath[tier];
	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;
	Template.bHideClipSizeStat = true;
	Assign_Tier_Values(Template);
	// Overrides
	Template.WeaponPanelImage = "_Pistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";

	//Abilities
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotBeamA'); // TODO : update with new animation if necessary

	//Stats
	Template.RangeAccuracy = default.LW_CLOSE_RANGE;
	Template.BaseDamage = default.Pistol_Damage[tier];
	Template.Aim = default.Pistol_Aim[tier];
	Template.CritChance = default.Pistol_CritChance[tier];
	Template.iClipSize = default.Pistol_ClipSize[tier];
	Template.iSoundRange = default.Pistol_SoundRange[tier];
	Template.iEnvironmentDamage = default.Pistol_EnvironmentDamage[tier];
	Template.TradingPostValue = default.Pistol_SellValue[tier];
	Template.NumUpgradeSlots = default.Pistol_UpgradeSlots[tier];
	
	// Building info
	if (BuildWeaponSchematics(Template))
	{
		Template.CreatorTemplateName = name(string(Template.DataName) $ string('_Schematic')); // The schematic which creates this item
		Template.BaseItem = GetBaseItem("Pistol", tier); //default.Pistol_BaseItem[tier]; // Which item this will be upgraded from
	}
	else
	{
		CreateTemplateCost(Template, default.Pistol_RequiredTech[Template.Tier], 
			default.Pistol_SupplyCost[tier], default.Pistol_AlloyCost[Template.Tier], 
			default.Pistol_EleriumCost[tier], default.Pistol_Engineering[Template.Tier]);
	}
}

static function Modify_Pistol(name TemplateName, int Tier)
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
		Create_Pistol_Template(Template, Tier);
	}
	else
	{
		`Redscreen("LW WeaponPack : failed to find template " $ string(TemplateName));
	}
}

static function X2DataTemplate Create_Pistol_Laser(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	Create_Pistol_Template(Template, 1);

	// Model
	Template.GameArchetype = "LWPistol_LS.Archetype.WP_Pistol_LS";

	return Template;
}

static function X2DataTemplate Create_Pistol_Coil(name TemplateName)
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, TemplateName);
	Create_Pistol_Template(Template, 3);

	// Model
	Template.GameArchetype = "LWPistol_CG.Archetypes.WP_Pistol_CG";

	return Template;
}