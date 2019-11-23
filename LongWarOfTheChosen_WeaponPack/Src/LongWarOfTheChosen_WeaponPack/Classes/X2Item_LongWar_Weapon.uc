class X2Item_LongWar_Weapon extends X2Item config(LongWar_WeaponPack_Range);

var config array<int> LW_CLOSE_RANGE;
var config array<int> LW_MIDCLOSE_RANGE;
var config array<int> LW_MEDIUM_RANGE;
var config array<int> LW_MIDLONG_RANGE;
var config array<int> LW_LONG_RANGE;
var config array<int> LW_FLAT_RANGE;

static function CreateTemplateCost(out X2WeaponTemplate Template, name requiredTech, int supplyCost, int alloyCost, int eleriumCost, int engineeringCost)
{
	local ArtifactCost Resources;

	if (supplyCost > 0)
	{
		Resources.ItemTemplateName = 'Supplies';
		Resources.Quantity = supplyCost;
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	if (alloyCost > 0)
	{
		Resources.ItemTemplateName = 'AlienAlloy';
		Resources.Quantity = alloyCost;
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	if (eleriumCost > 0)
	{
		Resources.ItemTemplateName = 'EleriumDust';
		Resources.Quantity = eleriumCost;
		Template.Cost.ResourceCosts.AddItem(Resources);
	}

	Template.Requirements.RequiredTechs.AddItem(requiredTech);
	Template.Requirements.RequiredEngineeringScore = engineeringCost;
}

static function bool BuildWeaponSchematics(out X2WeaponTemplate Template)
{
	local bool UseSchematics;

	UseSchematics = class'X2Item_Schematic_LongWar'.default.USE_SCHEMATICS;

	Template.CanBeBuilt = !UseSchematics;
	Template.bInfiniteItem = UseSchematics;
	return UseSchematics;
}

static function Assign_Tier_Values(out X2WeaponTemplate Template)
{
	if (Template.Tier == 0)
	{
		Template.WeaponTech = 'conventional';
		Template.EquipSound = "Conventional_Weapon_Equip";
		Template.DamageTypeTemplateName = 'Projectile_Conventional';
		Template.WeaponPanelImage = "_ConventionalRifle";
	}
	if (Template.Tier == 1)
	{
		Template.WeaponTech = 'beam'; //'pulse'; // TODO: fix up any effects that rely on hard-coded techs
		Template.EquipSound = "Beam_Weapon_Equip";
		Template.DamageTypeTemplateName = 'Projectile_BeamXCom';  // TODO : update with new damage type
		Template.WeaponPanelImage = "_BeamRifle"; // used by the UI. Probably determines iconview of the weapon.
	}
	if (Template.Tier == 2)
	{
		Template.WeaponTech = 'magnetic';
		Template.EquipSound = "Magnetic_Weapon_Equip";
		Template.DamageTypeTemplateName = 'Projectile_MagXCom';
		Template.WeaponPanelImage = "_MagneticRifle";
	}
	if (Template.Tier == 3)
	{
		Template.WeaponTech = 'magnetic';
		Template.EquipSound = "Magnetic_Weapon_Equip";
		Template.WeaponPanelImage = "_MagneticRifle";
		Template.DamageTypeTemplateName = 'Projectile_MagXCom';
	}
	if (Template.Tier == 4)
	{
		Template.WeaponTech = 'beam';
		Template.EquipSound = "Beam_Weapon_Equip";
		Template.DamageTypeTemplateName = 'Projectile_BeamXCom';
		Template.WeaponPanelImage = "_BeamRifle";
	}
}

static function name GetBaseItem(string WeaponType, int Tier)
{
	local string TierStr;

	switch(Tier)
	{
		case 0:
			return '';
		case 1:
			TierStr = "_CV";
		case 2:
			TierStr = "_CV";
		case 3:
			TierStr = "_MG";
		case 4:
			TierStr = "_LS";
		default:
			return '';
	}

	return name(WeaponType $ TierStr);
}