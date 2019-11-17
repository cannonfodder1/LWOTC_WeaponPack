class X2Ability_WeaponAttributeAbilities extends XMBAbility;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(WeaponMovementDebuff());
	Templates.AddItem(WeaponReloadingDebuff());
	Templates.AddItem(WeaponShootingDebuff());

	return Templates;
}

static function X2AbilityTemplate WeaponMovementDebuff()
{
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;
	local XMBEffect_ConditionalBonus Effect;
	local XMBValue_WeaponAttribute Value;
	 
	// Create a value that will count the unit's weapon attribute
	Value = new class'XMBValue_WeaponAttribute';
	Value.AttributeType = eWepAtt_Handling;

	// Create a stat change effect that will scale based on the weapon attribute
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(-1);
	Effect.ScaleValue = Value;
	Effect.ScaleBase = 0;
	Effect.ScaleMultiplier = 0.5;
	Effect.ScaleMax = 50;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);

	// Debuff unit whenever it moves
	Template = SelfTargetTrigger('WeaponMovementDebuff', "img:///UILibrary_PerkIcons.UIPerk_command", false, Effect, 'UnitMoveFinished');
	
	return Template;
}

static function X2AbilityTemplate WeaponReloadingDebuff()
{
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;
	local XMBEffect_ConditionalBonus Effect;
	local XMBValue_WeaponAttribute Value;
	 
	// Create a value that will count the unit's weapon attribute
	Value = new class'XMBValue_WeaponAttribute';
	Value.AttributeType = eWepAtt_Handling;

	// Create a stat change effect that will scale based on the weapon attribute
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(-1);
	Effect.ScaleValue = Value;
	Effect.ScaleBase = 0;
	Effect.ScaleMax = 50;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);

	// Debuff unit whenever it activates an ability
	Template = SelfTargetTrigger('WeaponReloadingDebuff', "img:///UILibrary_PerkIcons.UIPerk_command", false, Effect, 'AbilityActivated');

	// Require that the activated ability use the weapon associated with this ability
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);
	
	// Require that the activated ability be reloading
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('Reload');
	AddTriggerTargetCondition(Template, NameCondition);

	return Template;
}

static function X2AbilityTemplate WeaponShootingDebuff()
{
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;
	local XMBEffect_ConditionalBonus Effect;
	local XMBValue_WeaponAttribute Value;
	 
	// Create a value that will count the unit's weapon attribute
	Value = new class'XMBValue_WeaponAttribute';
	Value.AttributeType = eWepAtt_Stability;

	// Create a stat change effect that will scale based on the weapon attribute
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddToHitModifier(-1);
	Effect.ScaleValue = Value;
	Effect.ScaleBase = 0;
	Effect.ScaleMax = 50;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);

	// Debuff unit whenever it activates an ability
	Template = SelfTargetTrigger('WeaponShootingDebuff', "img:///UILibrary_PerkIcons.UIPerk_command", false, Effect, 'AbilityActivated');

	// Require that the activated ability use the weapon associated with this ability
	AddTriggerTargetCondition(Template, default.MatchingWeaponCondition);
	
	// Require that the activated ability be shooting
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('StandardShot');
	NameCondition.IncludeAbilityNames.AddItem('OverwatchShot');
	AddTriggerTargetCondition(Template, NameCondition);

	return Template;
}
