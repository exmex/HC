sendLanguageToServer = false
needRestart = false
langs = 
{
	--[[
en-US	英语					LANG_ENGLISH	kLanguageEnglish
de-DE	德语					LANG_GERMAN		kLanguageGerman
es-ES	西班牙语				LANG_SPANISH	kLanguageSpanish
fr-FR	法语					LANG_FRENCH		kLanguageFrench
id-ID	印度尼西亚语			LANG_INDONESIAN	kLanguageIndonesian

it-IT	意大利语(意大利)		LANG_ITALIAN	kLanguageItalian
ja-JP	日语					LANG_JAPANESE	kLanguageJapanese
ko-KR	朝鲜语					LANG_KOREAN		kLanguageKorean
ms-MY	马来语(马来西亚)		LANG_MALAY		kLanguageMalay
nb-NO	挪威语(伯克梅尔)(挪威)	LANG_NORWEGIAN		kLanguageNorwegian

nl-NL	荷兰语(荷兰)			LANG_DUTCH			kLanguageDutch
pt-BR	葡萄牙语(巴西)			LANG_PORTUGUESE		kLanguagePortuguese
ru-RU	俄语					LANG_RUSSIAN		kLanguageRussian
th-TH	泰语					LANG_THAI			kLanguageThai
tr-TR	土耳其语				LANG_TURKISH		kLanguageTurkish

vi-VN	越南语					LANG_VIETNAMESE		kLanguageVietnamese
	]]--
	["en-US"] = require("language/en-US"),
	["zh-CN"] = require("language/en-US"),
	["de-DE"] = require("language/de-DE"),
	["es-ES"] = require("language/en-US"),
	["fr-FR"] = require("language/en-US"),
	["id-ID"] = require("language/en-US"),

	["it-IT"] = require("language/en-US"),
	["ja-JP"] = require("language/en-US"),
	["ko-KR"] = require("language/ko-KR"),
	["ms-MY"] = require("language/en-US"),
	["nb-NO"] = require("language/en-US"),

	["nl-NL"] = require("language/en-US"),
	["pt-BR"] = require("language/pt-BR"),
	["ru-RU"] = require("language/ru-RU"),
	["th-TH"] = require("language/en-US"),
	["tr-TR"] = require("language/tr-TR"),

	["vi-VN"] = require("language/en-US"),
}

languageEum = {
	[0] = "en-US",
	[1] = "zh-CN",
	[2] = "fr-FR",
	[3] = "it-IT",
	[4] = "de-DE",
	[5] = "es-ES",
	[6] = "ru-RU",
	[7] = "ko-KR",
	[8] = "ja-JP",

	[10] = "pt-BR",

	[12] = "ms-MY",
	[13] = "nb-NO",
	[14] = "nl-NL",
	[15] = "th-TH",
	[16] = "tr-TR",
	[17] = "vi-VN",
	[18] = "id-ID",
}

function getLanguagePng(key)
	return "UI/alpha/HVGA/lang/"..key..".png"
end

function LSTR(key)
	str = langs[currentLang][key]
	if nil == str then
		return key
	end
	return str
end


function getDeviceLanguage()
	local la = CCApplication:sharedApplication():getCurrentLanguage()
	local languageType = "zh-CN"
	if languageEum[la] then
		languageType = languageEum[la]
	end
	return languageType
end

function checkCurrentLanguage()
	sendLanguageToServer = true
	local platformTag=GetPlatformOS()
	local lang = CCUserDefault:sharedUserDefault():getStringForKey("client_language")
	--win32
	if (platformTag ~= 3) or (string.len(lang) == 0) then
		lang = getDeviceLanguage()
	end
	
	--add by xinghui
	if platformTag ~=3 and lang=="zh-CN" then
		lang = "en-US"
	end
	
	currentLang = lang	
	saveCurrentLanguage()
	return lang
end
function saveCurrentLanguage()
	CCUserDefault:sharedUserDefault():setStringForKey("client_language",currentLang)
end
	
currentLang = checkCurrentLanguage()
function checkLanguageUpdate()
	if sendLanguageToServer then
	  	local systemSetting = ed.upmsg.system_setting()
	  	systemSetting._change = {}
		systemSetting._change.key = "language"
		systemSetting._change.value = currentLang
		ed.send(systemSetting, "system_setting")
	end
end
