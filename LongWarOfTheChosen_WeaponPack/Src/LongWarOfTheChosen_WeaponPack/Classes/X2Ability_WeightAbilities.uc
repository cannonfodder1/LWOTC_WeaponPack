class X2Ability_WeightAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config(LW_WeaponPack_Abilities);

var array<name> Text;
var config array<int> Mobility;
var config array<float> Detection;

DefaultProperties
{
	Text[0]="Ultralight Weapon" //SMG
	Text[1]="Light Weapon" //Shotgun
	Text[2]="Heavy Weapon" //SAW and Sniper
	Text[3]="Superheavy Weapon" //LMG
	Text[4]="Laser Weapon" //Laser weapons have -1 mobility
}

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	Templates.AddItem(AddMobility(1, false));
	Templates.AddItem(AddMobility(2, false));
	Templates.AddItem(AddMobility(3, false));
	Templates.AddItem(AddMobility(4, false));
	Templates.AddItem(AddMobility(5, true));
	return Templates;
}

static function X2AbilityTemplate AddMobility(int x, bool hide)
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.Text[x-1]);
	Template.IconImage = "img:///gfxXComIcons.NanofiberVest";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.bDontDisplayInAbilitySummary = hide;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", Template.IconImage, false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.Mobility[x-1]);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.Detection[x-1]);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}
