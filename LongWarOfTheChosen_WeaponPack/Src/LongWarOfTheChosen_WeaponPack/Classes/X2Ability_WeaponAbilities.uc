class X2Ability_WeaponAbilities extends XMBAbility config(LW_WeaponPack_Abilities);

var config int RELOAD_PENALTY;
var config int BR_NORMAL_ACTION_CONVERSION;
var config int BR_MOVEMENT_ACTION_CONVERSION;
var config int BR_RUNANDGUN_ACTION_CONVERSION;
var config float SHOTGUN_DAMAGE_HALFCOVER;
var config float SHOTGUN_DAMAGE_FULLCOVER;
var config array<int> SHOTGUN_DAMAGE_FALLOFF;
var config array<name> SPINUP_VALID_ABILITIES;

var name SpinupActionPoint;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(WeaponReloadingDebuff());
	Templates.AddItem(HeavyReload());
	Templates.AddItem(BattleRifleSteady());
	Templates.AddItem(StrikeRifleMove());
	Templates.AddItem(CarbineShot());
	Templates.AddItem(ShotgunRangeMod());
	Templates.AddItem(ShotgunCoverMod());
	Templates.AddItem(CannonSpinupShot());
	Templates.AddItem(CannonSpinupAction());
	Templates.AddItem(CannonRotaryShot());

	return Templates;
}

static function X2AbilityTemplate WeaponReloadingDebuff()
{
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;
	local XMBEffect_ConditionalBonus Effect;
	
	// Create a stat change effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(-1 * default.RELOAD_PENALTY);
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	
	// This ability will trigger when another ability is activated
	Template = SelfTargetTrigger('WeaponReloadingDebuff', "img:///UILibrary_PerkIcons.UIPerk_command", false, Effect, 'AbilityActivated');
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;

	// Require that the activated ability use the weapon associated with this ability
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);
	
	// Require that the activated ability be reloading
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('Reload');
	AddTriggerTargetCondition(Template, NameCondition);

	return Template;
}

static function X2AbilityTemplate HeavyReload()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;

	Template = class'X2Ability_DefaultAbilitySet'.static.AddReloadAbility('HeavyReload');
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;

	// Wipe the ability costs
	Template.AbilityCosts.Length = 0;

	// Turn ending action
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	
	
	return Template;	
}

static function X2AbilityTemplate BattleRifleSteady()
{
	local X2AbilityTemplate Template;
	local XMBValue_ActionPoints APValue;
	local XMBEffect_ConditionalBonus Effect;
	
	// Track the unit's action points
	APValue = new class'XMBValue_ActionPoints';
	APValue.TypeMultipliers.AddItem(default.BR_NORMAL_ACTION_CONVERSION);
	APValue.TypeMultipliers.AddItem(default.BR_MOVEMENT_ACTION_CONVERSION);
	APValue.TypeMultipliers.AddItem(default.BR_RUNANDGUN_ACTION_CONVERSION);

	// Create a stat change effect that will scale based on the available action points
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(1);
	Effect.ScaleValue = APValue;
	Effect.ScaleBase = 0;
	Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);
	Effect.BuildPersistentEffect(1, true);
	
	Template = Passive('BattleRifleSteady', "img:///UILibrary_PerkIcons.UIPerk_command", false, Effect);
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;

	return Template;
}

static function X2AbilityTemplate StrikeRifleMove()
{
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;
	local X2Effect_GrantActionPoints ActionPointEffect;
	
	// Create an action point change effect
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.bApplyOnlyWhenOut = true;

	// This ability will trigger when another ability is activated
	Template = SelfTargetTrigger('StrikeRifleMove', "img:///UILibrary_PerkIcons.UIPerk_command", false, ActionPointEffect, 'AbilityActivated');
	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';

	// Require that the activated ability use the weapon associated with this ability
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);
	
	// Require that the activated ability be shooting
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('SniperStandardFire');
	AddTriggerTargetCondition(Template, NameCondition);

	return Template;
}

static function X2AbilityTemplate CarbineShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_Ammo                AmmoCost;

	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot('CarbineShot');
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;

	// Wipe the ability costs
	Template.AbilityCosts.Length = 0;

	// Action Point, but not turn ending
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);	
	
	// Cooldown
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true;

	return Template;	
}

static function X2AbilityTemplate ShotgunRangeMod()
{
	local X2AbilityTemplate Template;
	local X2Effect_DamageModifierRange RangeEffect;

	Template = PurePassive('ShotgunRangeModifier', "img:///UILibrary_PerkIcons.UIPerk_command", false, 'eAbilitySource_Standard', false);

	RangeEffect = new class'X2Effect_DamageModifierRange';
	RangeEffect.BuildPersistentEffect(1, true, true, false, eGameRule_TacticalGameStart);
	RangeEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,, Template.AbilitySourceName);
	RangeEffect.DamageFalloff = default.SHOTGUN_DAMAGE_FALLOFF;
	Template.AddTargetEffect(RangeEffect);
	
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;

	return Template;
}

static function X2AbilityTemplate ShotgunCoverMod()
{
	local X2AbilityTemplate Template;
	local X2Effect_DamageModifierCoverType CoverTypeEffect;

	Template = PurePassive('ShotgunCoverModifier', "img:///UILibrary_PerkIcons.UIPerk_command", false, 'eAbilitySource_Standard', false);

	CoverTypeEffect = new class'X2Effect_DamageModifierCoverType';
	CoverTypeEffect.BuildPersistentEffect(1, true, true, false, eGameRule_TacticalGameStart);
	CoverTypeEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, false,, Template.AbilitySourceName);
	CoverTypeEffect.HalfCovertModifier = default.SHOTGUN_DAMAGE_HALFCOVER;
	CoverTypeEffect.FullCovertModifier = default.SHOTGUN_DAMAGE_FULLCOVER;
	Template.AddTargetEffect(CoverTypeEffect);
	
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;

	return Template;
}

static function X2AbilityTemplate CannonSpinupShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityCost_Ammo                AmmoCost;
	
	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot('CannonSpinupShot');
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailableOrNoTargets;

	// Wipe the ability costs
	Template.AbilityCosts.Length = 0;

	// Action Point, but not turn ending
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	
	
	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	Template.bAllowAmmoEffects = true;
	
	return Template;
}

static function X2AbilityTemplate CannonSpinupAction()
{
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;
	local X2Effect_GrantActionPoints ActionPointEffect;
	
	// Create an action point change effect
	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.PointType = default.SpinupActionPoint;
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.bApplyOnlyWhenOut = false;

	// This ability will trigger when another ability is activated
	Template = SelfTargetTrigger('CannonSpinupAction', "img:///UILibrary_PerkIcons.UIPerk_command", false, ActionPointEffect, 'AbilityActivated');
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.AbilitySourceName = 'eAbilitySource_Standard';

	// Require that the activated ability use the weapon associated with this ability
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);
	
	// Require that the activated ability be shooting
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('CannonSpinupShot');
	AddTriggerTargetCondition(Template, NameCondition);

	return Template;
}

static function X2AbilityTemplate CannonRotaryShot()
{
	local X2AbilityTemplate                 Template;	
	local X2Condition_UnitActionPoints		ActionPointCondition;
	
	Template = class'X2Ability_WeaponCommon'.static.Add_StandardShot('CannonRotaryShot');
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailableOrNoTargets;

	// This shot can only be fired with the extra action point from the spinup shot
	ActionPointCondition = new class'X2Condition_UnitActionPoints';
	ActionPointCondition.AddActionPointCheck(1, default.SpinupActionPoint);
	Template.AbilityShooterConditions.AddItem(ActionPointCondition);

	return Template;
}

defaultproperties
{
	SpinupActionPoint = 'lw_cannonspin';
}