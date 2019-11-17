class XMBValue_WeaponAttribute extends XMBValue;

var EWeaponAttributeType AttributeType; 

function float GetValue(XComGameState_Effect EffectState, XComGameState_Unit UnitState, XComGameState_Unit TargetState, XComGameState_Ability AbilityState)
{
	local XComGameState_Item WeaponState;
	local int AttributeValue;

	WeaponState = AbilityState.GetSourceWeapon();

	// get the weapon upgrades from the itemstate here

	AttributeValue = class'X2WeaponAttributeManager'.static.GetWeaponAttribute(AttributeType, WeaponState.GetMyTemplateName()) - 50;

	`Log("EVALUATING " $ WeaponState.GetMyTemplateName() $ " FOR " $ AbilityState.GetMyTemplateName());
	
	if (AttributeValue == -1) return 0;
	
	if (AttributeValue > 0) AttributeValue = 0;

	if (AttributeValue < -50) AttributeValue = -50;

	`Log(" PENALTY: " $ AttributeValue);

	return AttributeValue * -1;
}
