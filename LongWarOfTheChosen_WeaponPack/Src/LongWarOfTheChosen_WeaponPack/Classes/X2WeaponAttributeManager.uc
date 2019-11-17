class X2WeaponAttributeManager extends Object config(LW_WeaponPack_Attributes);

enum EWeaponAttributeType {
	eWepAtt_Handling,
	eWepAtt_Stability,
	eWepAtt_Precision,
};

struct WeaponAttributeContainer {
	var name WeaponName;
	var int Handling;
	var int Stability;
	var int Precision;
};

var config array<WeaponAttributeContainer> ArrWeaponAttributes;
/*
static function AddWeaponAttribute (WeaponAttributeContainer NewAttributes)
{
	local WeaponAttributeContainer Container;

	foreach ArrWeaponAttributes(Container)
	{
		if (Container.WeaponName == NewAttributes.WeaponName)
		{
			Container.Handling = NewAttributes.Handling;
			Container.Stability = NewAttributes.Stability;
			Container.Precision = NewAttributes.Precision;
			return;
		}
	}

	ArrWeaponAttributes.AddItem(NewAttributes);
}

static function bool EditWeaponAttribute (EWeaponAttributeType AttributeType, name TargetWeapon, int NewValue)
{
	local WeaponAttributeContainer Container;

	foreach ArrWeaponAttributes(Container)
	{
		if (Container.WeaponName == TargetWeapon)
		{
			switch(AttributeType)
			{
				case eWepAtt_Handling:
					Container.Handling = NewValue; return true;
				case eWepAtt_Stability:
					Container.Stability = NewValue; return true;
				case eWepAtt_Precision:
					Container.Precision = NewValue; return true;
			}
		}
	}

	return false;
}
*/
static function int GetWeaponAttribute (EWeaponAttributeType AttributeType, name TargetWeapon)
{
	local WeaponAttributeContainer Container;

	foreach default.ArrWeaponAttributes(Container)
	{
		if (Container.WeaponName == TargetWeapon)
		{
			switch(AttributeType)
			{
				case eWepAtt_Handling:
					return Container.Handling;
				case eWepAtt_Stability:
					return Container.Stability;
				case eWepAtt_Precision:
					return Container.Precision;
			}
		}
	}

	return -1;
}
