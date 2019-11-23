class XMBValue_ActionPoints extends XMBValue;

var array<int> TypeMultipliers;

function float GetValue(XComGameState_Effect EffectState, XComGameState_Unit UnitState, XComGameState_Unit TargetState, XComGameState_Ability AbilityState)
{
	local array<name> AllowedActionPoints;
	local float Value;
	local name ActionPoint;
	local int Index;
	local bool SkippedPoint;
	
	AllowedActionPoints.AddItem(class'X2CharacterTemplateManager'.default.StandardActionPoint);
	AllowedActionPoints.AddItem(class'X2CharacterTemplateManager'.default.MoveActionPoint);
	AllowedActionPoints.AddItem(class'X2CharacterTemplateManager'.default.RunAndGunActionPoint);

	`Log("Counting Aim Bonuses");
	SkippedPoint = false;
	foreach UnitState.ActionPoints(ActionPoint)
	{
		Index = AllowedActionPoints.Find(ActionPoint);
		if (Index > -1)
		{
			if (ActionPoint == class'X2CharacterTemplateManager'.default.StandardActionPoint && SkippedPoint == false)
			{
				SkippedPoint = true;
				continue;
			}

			`Log("Adding Aim Bonus = " $ TypeMultipliers[Index]);
			Value += TypeMultipliers[Index];
		}
	}

	if (SkippedPoint == false) Value -= TypeMultipliers[2];

	return Value;
}