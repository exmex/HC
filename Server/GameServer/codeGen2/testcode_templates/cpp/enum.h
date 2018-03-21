
class /*::ENUM_NAME::*/{
public:
	enum E{
/*::ENUM_ENRY::*/
	};
public:
	static const char* s_szEnumNames[];
	static const char* GetName(/*::ENUM_NAME::*/::E _lpValue);
	/*::ENUM_NAME::*/::E value;
	/*::ENUM_NAME::*/(/*::ENUM_NAME::*/::E _lpValue){
		value = _lpValue;
	}
	inline operator const char*() const {
		return GetName(value);
	}
};

