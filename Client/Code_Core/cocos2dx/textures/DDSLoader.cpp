#include "DDSLoader.h"

bool LoadDDS(const char* _fileName, tScratchImage& tImage)
{
	if (!_fileName)
		return false;

	FILE* fp = fopen(_fileName, "rb");

	if (fp == NULL)
		return false;

	fseek(fp, 0, SEEK_END);
	int tFileSize = ftell(fp);
	fseek(fp, 0, SEEK_SET);

	int tOff = 0;

	UINT32 dwMagic;
	tDDS_HEADER tHead;

	fread(&dwMagic, sizeof(UINT32), 1, fp);
	tOff += sizeof(UINT32);
	fread(&tHead, sizeof(tDDS_HEADER), 1, fp);
	tOff += sizeof(tDDS_HEADER);

	if ((tHead.ddspf.dwFlags & tDDS_FOURCC) && (tMAKEFOURCC('D', 'X', '1', '0') == tHead.ddspf.dwFourCC))
	{
		fclose(fp);
		return false;
	}
	int remain = tFileSize - tOff;

	unsigned int tConvFlag;
	tTexMetadata tMeta;
	tDecodeDDSHeader(&tHead, 0, tMeta, tConvFlag);

	tImage.Initialize(tMeta);

	fread(tImage.GetPixels(), tImage.GetPixelsSize(), 1, fp);

	fclose(fp);

	return true;
}

bool LoadDDS(const wchar_t* _fileName, tScratchImage& tImage)
{
	size_t len = wcslen(_fileName) + 1;
	size_t converted = 0;
	char* tFileName = (char*)malloc(len*sizeof(char));
	wcstombs_s(&converted, tFileName, len, _fileName, _TRUNCATE);

	bool flag = LoadDDS(tFileName, tImage);

	free(tFileName);

	return flag;
}
