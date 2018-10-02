class X2Item_Schematic_LWBeam extends X2Item_Schematic_LongWar config(LW_WeaponPack);

var config int SMG_Beam_Schematic_SupplyCost;
var config int SMG_Beam_Schematic_AlloyCost;
var config int SMG_Beam_Schematic_EleriumCost;

var config int MarksmanRifle_Beam_Schematic_SupplyCost;
var config int MarksmanRifle_Beam_Schematic_AlloyCost;
var config int MarksmanRifle_Beam_Schematic_EleriumCost;

var config int SAW_Beam_Schematic_SupplyCost;
var config int SAW_Beam_Schematic_AlloyCost;
var config int SAW_Beam_Schematic_EleriumCost;

var name SMGBeamSchematic;
var name MarksmanRifleBeamSchematic;
var name SAWBeamSchematic;

defaultproperties
{
	SMGBeamSchematic = "SMG_BM_Schematic"
	MarksmanRifleBeamSchematic = "MarksmanRifle_BM_Schematic"
	SAWBeamSchematic = "SAW_BM_Schematic"
}

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Schematics;
	Schematics.AddItem(Create_SMG_Beam_Schematic(default.SMGBeamSchematic));
	Schematics.AddItem(Create_MarksmanRifle_Beam_Schematic(default.MarksmanRifleBeamSchematic));
	Schematics.AddItem(Create_SAW_Beam_Schematic(default.SAWBeamSchematic));
	return Schematics;
}

static function Create_Beam_Schematic(out X2SchematicTemplate Template, name RequiredTech)
{
	Template.ItemCat = 'weapon';
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.PointsToComplete = 0;
	Template.Tier = 4;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	Template.Requirements.RequiredTechs.AddItem(RequiredTech);
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
}


static function X2DataTemplate Create_SMG_Beam_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Beam_Schematic(Template, 'PlasmaRifle');
	Template.strImage = "img:///UILibrary_SMG.Beam.Inv_LWBeamSMG";
	Template.Requirements.RequiredEngineeringScore = 20;

	Template.ItemsToUpgrade.AddItem('SMG_CV');
	Template.ItemsToUpgrade.AddItem('SMG_MG');
	Template.ItemsToUpgrade.AddItem('SMG_LS');
	Template.ItemsToUpgrade.AddItem('SMG_CG');
	Template.ReferenceItemTemplate = 'SMG_BM';

	CreateTemplateCost(Template, default.SMG_Beam_Schematic_SupplyCost, default.SMG_Beam_Schematic_AlloyCost, default.SMG_Beam_Schematic_EleriumCost);
	return Template;
}

static function X2DataTemplate Create_MarksmanRifle_Beam_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Beam_Schematic(Template, 'PlasmaSniper');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Beam_Sniper_Rifle";
	Template.Requirements.RequiredEngineeringScore = 25;

	Template.ItemsToUpgrade.AddItem('MarksmanRifle_CV');
	Template.ItemsToUpgrade.AddItem('MarksmanRifle_MG');
	Template.ItemsToUpgrade.AddItem('MarksmanRifle_LS');
	Template.ItemsToUpgrade.AddItem('MarksmanRifle_CG');
	Template.ReferenceItemTemplate = 'MarksmanRifle_BM';

	CreateTemplateCost(Template, default.MarksmanRifle_Beam_Schematic_SupplyCost, default.MarksmanRifle_Beam_Schematic_AlloyCost, default.MarksmanRifle_Beam_Schematic_EleriumCost);
	return Template;
}

static function X2DataTemplate Create_SAW_Beam_Schematic(name TemplateName)
{
	local X2SchematicTemplate Template;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, TemplateName);
	Create_Beam_Schematic(Template, 'PlasmaRifle');
	Template.strImage = "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_Base";
	Template.Requirements.RequiredEngineeringScore = 25;

	Template.ItemsToUpgrade.AddItem('SAW_CV');
	Template.ItemsToUpgrade.AddItem('SAW_MG');
	Template.ItemsToUpgrade.AddItem('SAW_LS');
	Template.ItemsToUpgrade.AddItem('SAW_CG');
	Template.ReferenceItemTemplate = 'SAW_BM';

	CreateTemplateCost(Template, default.SAW_Beam_Schematic_SupplyCost, default.SAW_Beam_Schematic_AlloyCost, default.SAW_Beam_Schematic_EleriumCost);
	return Template;
}