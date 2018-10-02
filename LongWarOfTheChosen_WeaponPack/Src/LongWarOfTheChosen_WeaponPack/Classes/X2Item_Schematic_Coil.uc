class X2Item_Schematic_Coil extends X2Item_Schematic_LongWar config(LW_WeaponPack);

var config int AssaultRifle_Coil_Schematic_SupplyCost;
var config int AssaultRifle_Coil_Schematic_AlloyCost;
var config int AssaultRifle_Coil_Schematic_EleriumCost;

var config int SMG_Coil_Schematic_SupplyCost;
var config int SMG_Coil_Schematic_AlloyCost;
var config int SMG_Coil_Schematic_EleriumCost;

var config int Shotgun_Coil_Schematic_SupplyCost;
var config int Shotgun_Coil_Schematic_AlloyCost;
var config int Shotgun_Coil_Schematic_EleriumCost;

var config int Cannon_Coil_Schematic_SupplyCost;
var config int Cannon_Coil_Schematic_AlloyCost;
var config int Cannon_Coil_Schematic_EleriumCost;

var config int SniperRifle_Coil_Schematic_SupplyCost;
var config int SniperRifle_Coil_Schematic_AlloyCost;
var config int SniperRifle_Coil_Schematic_EleriumCost;

var config int MarksmanRifle_Coil_Schematic_SupplyCost;
var config int MarksmanRifle_Coil_Schematic_AlloyCost;
var config int MarksmanRifle_Coil_Schematic_EleriumCost;

var config int SAW_Coil_Schematic_SupplyCost;
var config int SAW_Coil_Schematic_AlloyCost;
var config int SAW_Coil_Schematic_EleriumCost;

var config int Pistol_Coil_Schematic_SupplyCost;
var config int Pistol_Coil_Schematic_AlloyCost;
var config int Pistol_Coil_Schematic_EleriumCost;

var config int Sidearm_Coil_Schematic_SupplyCost;
var config int Sidearm_Coil_Schematic_AlloyCost;
var config int Sidearm_Coil_Schematic_EleriumCost;

var name AssaultRifleCoilSchematic;
var name SMGCoilSchematic;
var name ShotgunCoilSchematic;
var name CannonCoilSchematic;
var name SniperRifleCoilSchematic;
var name MarksmanRifleCoilSchematic;
var name SAWCoilSchematic;
var name PistolCoilSchematic;
var name SidearmCoilSchematic;

defaultproperties
{
	AssaultRifleCoilSchematic = "AssaultRifle_CG_Schematic"
	SMGCoilSchematic = "SMG_CG_Schematic"
	ShotgunCoilSchematic = "Shotgun_CG_Schematic"
	CannonCoilSchematic = "Cannon_CG_Schematic"
	SniperRifleCoilSchematic = "SniperRifle_CG_Schematic"
	MarksmanRifleCoilSchematic = "MarksmanRifle_CG_Schematic"
	SAWCoilSchematic = "SAW_CG_Schematic"
	PistolCoilSchematic = "Pistol_CG_Schematic"
	SidearmCoilSchematic = "Sidearm_CG_Schematic"
}

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Schematics;
	Schematics.AddItem(Create_AssaultRifle_Coil_Schematic(default.AssaultRifleCoilSchematic));
	Schematics.AddItem(Create_SMG_Coil_Schematic(default.SMGCoilSchematic));
	Schematics.AddItem(Create_Shotgun_Coil_Schematic(default.ShotgunCoilSchematic));
	Schematics.AddItem(Create_Cannon_Coil_Schematic(default.CannonCoilSchematic));
	Schematics.AddItem(Create_SniperRifle_Coil_Schematic(default.SniperRifleCoilSchematic));
	Schematics.AddItem(Create_MarksmanRifle_Coil_Schematic(default.MarksmanRifleCoilSchematic));
	Schematics.AddItem(Create_SAW_Coil_Schematic(default.SAWCoilSchematic));
	Schematics.AddItem(Create_Pistol_Coil_Schematic(default.PistolCoilSchematic));
	Schematics.AddItem(Create_Sidearm_Coil_Schematic(default.SidearmCoilSchematic));
	return Schematics;
}

static function Create_Coil_Schematic(out X2SchematicTemplate Template, name RequiredTech)
{
	Template.ItemCat = 'weapon';
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	Template.Requirements.RequiredTechs.AddItem(RequiredTech);
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
}

static function X2DataTemplate Create_AssaultRifle_Coil_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Coil_Schematic(Template, class'X2StrategyElement_CoilTechs'.default.CoilWeaponTech_Tier[0]);
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.strImage = "img:///UILibrary_LW_Coilguns.InventoryArt.Inv_Coil_AssaultRifle";
	
	Template.ReferenceItemTemplate = 'AssaultRifle_CG';
	Template.HideIfPurchased = 'AssaultRifle_BM';

	CreateTemplateCost(Template, default.AssaultRifle_Coil_Schematic_SupplyCost, default.AssaultRifle_Coil_Schematic_AlloyCost, default.AssaultRifle_Coil_Schematic_EleriumCost);
	return Template;
}

static function X2DataTemplate Create_SMG_Coil_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Coil_Schematic(Template, class'X2StrategyElement_CoilTechs'.default.CoilWeaponTech_Tier[0]);
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.strImage = "img:///UILibrary_LW_Coilguns.InventoryArt.Inv_Coil_SMG";

	Template.ReferenceItemTemplate = 'SMG_CG';
	Template.HideIfPurchased = 'SMG_BM';

	CreateTemplateCost(Template, default.SMG_Coil_Schematic_SupplyCost, default.SMG_Coil_Schematic_AlloyCost, default.SMG_Coil_Schematic_EleriumCost);
	return Template;
}

static function X2DataTemplate Create_Shotgun_Coil_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Coil_Schematic(Template, class'X2StrategyElement_CoilTechs'.default.CoilWeaponTech_Tier[1]);
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.strImage = "img:///UILibrary_LW_Coilguns.InventoryArt.Inv_Coil_Shotgun";

	Template.ReferenceItemTemplate = 'Shotgun_CG';
	Template.HideIfPurchased = 'Shotgun_BM';

	CreateTemplateCost(Template, default.Shotgun_Coil_Schematic_SupplyCost, default.Shotgun_Coil_Schematic_AlloyCost, default.Shotgun_Coil_Schematic_EleriumCost);
	return Template;
}

static function X2DataTemplate Create_Cannon_Coil_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Coil_Schematic(Template, class'X2StrategyElement_CoilTechs'.default.CoilWeaponTech_Tier[1]);
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.strImage = "img:///UILibrary_LW_Coilguns.InventoryArt.Inv_Coil_Cannon";

	Template.ReferenceItemTemplate = 'Cannon_CG';
	Template.HideIfPurchased = 'Cannon_BM';

	CreateTemplateCost(Template, default.Cannon_Coil_Schematic_SupplyCost, default.Cannon_Coil_Schematic_AlloyCost, default.Cannon_Coil_Schematic_EleriumCost);
	return Template;
}

static function X2DataTemplate Create_SniperRifle_Coil_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Coil_Schematic(Template, class'X2StrategyElement_CoilTechs'.default.CoilWeaponTech_Tier[1]);
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.strImage = "img:///UILibrary_LW_Coilguns.InventoryArt.Inv_Coil_SniperRifle";

	Template.ReferenceItemTemplate = 'SniperRifle_CG';
	Template.HideIfPurchased = 'SniperRifle_BM';

	CreateTemplateCost(Template, default.SniperRifle_Coil_Schematic_SupplyCost, default.SniperRifle_Coil_Schematic_AlloyCost, default.SniperRifle_Coil_Schematic_EleriumCost);
	return Template;
}

static function X2DataTemplate Create_MarksmanRifle_Coil_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Coil_Schematic(Template, class'X2StrategyElement_CoilTechs'.default.CoilWeaponTech_Tier[1]);
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.strImage = "img:///UILibrary_LW_Coilguns.InventoryArt.Inv_Coil_SniperRifle"; 

	Template.ReferenceItemTemplate = 'MarksmanRifle_CG';
	Template.HideIfPurchased = 'MarksmanRifle_BM';

	CreateTemplateCost(Template, default.MarksmanRifle_Coil_Schematic_SupplyCost, default.MarksmanRifle_Coil_Schematic_AlloyCost, default.MarksmanRifle_Coil_Schematic_EleriumCost);
	return Template;
}

static function X2DataTemplate Create_SAW_Coil_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Coil_Schematic(Template, class'X2StrategyElement_CoilTechs'.default.CoilWeaponTech_Tier[1]);
	Template.Requirements.RequiredEngineeringScore = 20;
	Template.strImage = "img:///UILibrary_LW_Coilguns.InventoryArt.Inv_Coil_Cannon";

	Template.ReferenceItemTemplate = 'SAW_CG';
	Template.HideIfPurchased = 'SAW_BM';

	CreateTemplateCost(Template, default.SAW_Coil_Schematic_SupplyCost, default.SAW_Coil_Schematic_AlloyCost, default.SAW_Coil_Schematic_EleriumCost);
	return Template;
}

static function X2DataTemplate Create_Pistol_Coil_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Coil_Schematic(Template, class'X2StrategyElement_CoilTechs'.default.CoilWeaponTech_Tier[0]);
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.strImage = "img:///UILibrary_LW_Coilguns.InventoryArt.Inv_Coil_Pistol";

	Template.ReferenceItemTemplate = 'Pistol_CG';
	Template.HideIfPurchased = 'Pistol_BM';

	CreateTemplateCost(Template, default.Pistol_Coil_Schematic_SupplyCost, default.Pistol_Coil_Schematic_AlloyCost, default.Pistol_Coil_Schematic_EleriumCost);
	return Template;
}

static function X2DataTemplate Create_Sidearm_Coil_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Coil_Schematic(Template, class'X2StrategyElement_CoilTechs'.default.CoilWeaponTech_Tier[0]);
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_MagTPistol_Base";

	Template.ReferenceItemTemplate = 'Sidearm_CG';
	Template.HideIfPurchased = 'Sidearm_BM';
	Template.Requirements.RequiredSoldierClass = 'Templar';

	CreateTemplateCost(Template, default.Sidearm_Coil_Schematic_SupplyCost, default.Sidearm_Coil_Schematic_AlloyCost, default.Sidearm_Coil_Schematic_EleriumCost);
	return Template;
}