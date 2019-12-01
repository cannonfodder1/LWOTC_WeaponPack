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
	
	Templates.AddItem(Passive('WeaponTechKinetic', "img:///UILibrary_WeaponPerkIcons.perk_weaponkinetic"));
	Templates.AddItem(Passive('WeaponTechEnergy', "img:///UILibrary_WeaponPerkIcons.perk_weaponenergy"));
	Templates.AddItem(WeaponReloadingDebuff());
	Templates.AddItem(HeavyReload());
	Templates.AddItem(ExchangeHeatsink());
	Templates.AddItem(HeatDissipation());
	
	Templates.AddItem(Passive('WeaponTypeAssault', "img:///UILibrary_WeaponPerkIcons.perk_rifle"));
	Templates.AddItem(Passive('WeaponTypeShotgun', "img:///UILibrary_WeaponPerkIcons.perk_shotgun"));
	Templates.AddItem(Passive('WeaponTypeCannon', "img:///UILibrary_WeaponPerkIcons.perk_cannon"));
	Templates.AddItem(Passive('WeaponTypeSniper', "img:///UILibrary_WeaponPerkIcons.perk_sniper"));
	Templates.AddItem(Passive('WeaponTypeCarbine', "img:///UILibrary_WeaponPerkIcons.perk_carbine"));
	Templates.AddItem(Passive('WeaponTypeBattle', "img:///UILibrary_WeaponPerkIcons.perk_battle"));
	Templates.AddItem(Passive('WeaponTypeStrike', "img:///UILibrary_WeaponPerkIcons.perk_strike"));

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
	Template = SelfTargetTrigger('WeaponReloadingDebuff', "img:///UILibrary_WeaponPerkIcons.perk_reloadpenalty", false, Effect, 'AbilityActivated');
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
	
	Template.BuildVisualizationFn = BasicSourceFlyover_BuildVisualization;

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
	Template.IconImage = "img:///UILibrary_WeaponPerkIcons.perk_cannonreload";

	// Wipe the ability costs
	Template.AbilityCosts.Length = 0;

	// Turn ending action
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);	
	
	return Template;	
}

static function X2AbilityTemplate ExchangeHeatsink()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;

	Template = class'X2Ability_DefaultAbilitySet'.static.AddReloadAbility('ExchangeHeatsink');
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;
	Template.IconImage = "img:///UILibrary_WeaponPerkIcons.perk_reloadenergy";

	// Wipe the ability costs
	Template.AbilityCosts.Length = 0;

	// Turn ending action
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 2;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);	
	
	return Template;	
}

static function X2AbilityTemplate HeatDissipation()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2Condition_UnitProperty          ShooterPropertyCondition;
	local X2Condition_AbilitySourceWeapon   WeaponCondition;
	local array<name>                       SkipExclusions;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HeatDissipation');
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;

	ShooterPropertyCondition = new class'X2Condition_UnitProperty';	
	ShooterPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(ShooterPropertyCondition);

	WeaponCondition = new class'X2Condition_AbilitySourceWeapon';
	WeaponCondition.WantsReload = true;
	Template.AbilityShooterConditions.AddItem(WeaponCondition);

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'PlayerTurnBegun';
	EventListener.ListenerData.Filter = eFilter_Player;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_WeaponPerkIcons.perk_reloadenergy";
	Template.Hostility = eHostility_Neutral;

	Template.BuildNewGameStateFn = HeatAbility_BuildGameState;
	Template.BuildVisualizationFn = BasicSourceFlyover_BuildVisualization;

	return Template;	
}

simulated function XComGameState HeatAbility_BuildGameState( XComGameStateContext Context )
{
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local XComGameState_Item WeaponState, NewWeaponState;

	NewGameState = `XCOMHISTORY.CreateNewGameState(true, Context);	
	AbilityContext = XComGameStateContext_Ability(Context);	
	AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID( AbilityContext.InputContext.AbilityRef.ObjectID ));

	WeaponState = AbilityState.GetSourceWeapon();
	NewWeaponState = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', WeaponState.ObjectID));

	// increase the weapon's ammo	
	NewWeaponState.Ammo = WeaponState.Ammo + 1;
	
	return NewGameState;	
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
	
	Template = Passive('BattleRifleSteady', "img:///UILibrary_WeaponPerkIcons.perk_battlesteady", false, Effect);
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
	Template = SelfTargetTrigger('StrikeRifleMove', "img:///UILibrary_WeaponPerkIcons.perk_strikemove", false, ActionPointEffect, 'AbilityActivated');
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.bDontDisplayInAbilitySummary = true;
	Template.bDisplayInUITacticalText = false;
	Template.bDisplayInUITooltip = false;

	// Require that the activated ability use the weapon associated with this ability
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);
	
	// Require that the activated ability be shooting
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('SniperStandardFire');
	AddTriggerTargetCondition(Template, NameCondition);
	
	Template.BuildVisualizationFn = BasicSourceFlyover_BuildVisualization;

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
	Template.IconImage = "img:///UILibrary_WeaponPerkIcons.perk_carbineshot";

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

	Template = PurePassive('ShotgunRangeModifier', "img:///UILibrary_WeaponPerkIcons.perk_shotgundropoff", false, 'eAbilitySource_Standard', false);

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

	Template = PurePassive('ShotgunCoverModifier', "img:///UILibrary_WeaponPerkIcons.perk_shotgundropoff", false, 'eAbilitySource_Standard', false);

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
	Template.IconImage = "img:///UILibrary_WeaponPerkIcons.perk_cannonspinup";

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
	Template = SelfTargetTrigger('CannonSpinupAction', "img:///UILibrary_WeaponPerkIcons.perk_cannonspinup", false, ActionPointEffect, 'AbilityActivated');
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
	
	Template.BuildVisualizationFn = BasicSourceFlyover_BuildVisualization;

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

// Plays flyover message on the SourceUnit with ability's LocFlyOverText when the ability is activated
// Stolen from Shiremct's Proficiency Class Pack
simulated function BasicSourceFlyover_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory					History;
	local XComGameStateContext_Ability			AbilityContext;
	local XComGameState_Ability					AbilityState;
	local X2AbilityTemplate						AbilityTemplate;
	local StateObjectReference					SourceUnitRef;
	local VisualizationActionMetadata			ActionMetadata;
	local X2Action_PlaySoundAndFlyOver			SoundAndFlyOver;
	
	History = `XCOMHISTORY;

	AbilityContext = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	SourceUnitRef = AbilityContext.InputContext.SourceObject;
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();
	
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(SourceUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(SourceUnitRef.ObjectID);
	if (ActionMetadata.StateObject_NewState == none)
		ActionMetadata.StateObject_NewState = ActionMetadata.StateObject_OldState;
	ActionMetadata.VisualizeActor = History.GetVisualizer(SourceUnitRef.ObjectID);
	
	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyover'.static.AddToVisualizationTree(ActionMetadata, AbilityContext));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', eColor_Good, AbilityTemplate.IconImage, `DEFAULTFLYOVERLOOKATTIME * 2);
}

defaultproperties
{
	SpinupActionPoint = 'lw_cannonspin';
}