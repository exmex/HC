#include "DDSLoaderHelp.h"

bool tIsValid(tDXGI_FORMAT fmt)
{
	return (static_cast<int>(fmt) >= 1 && static_cast<int>(fmt) <= 120);
}

bool tIsPalettized(tDXGI_FORMAT fmt)
{
	switch (fmt)
	{
	case tDXGI_FORMAT_AI44:
	case tDXGI_FORMAT_IA44:
	case tDXGI_FORMAT_P8:
	case tDXGI_FORMAT_A8P8:
		return true;

	default:
		return false;
	}
}

bool tIsVideo(tDXGI_FORMAT fmt)
{
	switch (fmt)
	{
	case tDXGI_FORMAT_AYUV:
	case tDXGI_FORMAT_Y410:
	case tDXGI_FORMAT_Y416:
	case tDXGI_FORMAT_NV12:
	case tDXGI_FORMAT_P010:
	case tDXGI_FORMAT_P016:
	case tDXGI_FORMAT_YUY2:
	case tDXGI_FORMAT_Y210:
	case tDXGI_FORMAT_Y216:
	case tDXGI_FORMAT_NV11:
		// These video formats can be used with the 3D pipeline through special view mappings

	case tDXGI_FORMAT_420_OPAQUE:
	case tDXGI_FORMAT_AI44:
	case tDXGI_FORMAT_IA44:
	case tDXGI_FORMAT_P8:
	case tDXGI_FORMAT_A8P8:
		// These are limited use video formats not usable in any way by the 3D pipeline
		return true;

	default:
		return false;
	}
}

bool tIsDepthStencil(tDXGI_FORMAT fmt)
{
	switch (static_cast<int>(fmt))
	{
	case tDXGI_FORMAT_D32_FLOAT_S8X24_UINT:
	case tDXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS:
	case tDXGI_FORMAT_X32_TYPELESS_G8X24_UINT:
	case tDXGI_FORMAT_D32_FLOAT:
	case tDXGI_FORMAT_D24_UNORM_S8_UINT:
	case tDXGI_FORMAT_R24_UNORM_X8_TYPELESS:
	case tDXGI_FORMAT_X24_TYPELESS_G8_UINT:
	case tDXGI_FORMAT_D16_UNORM:
	case 118 /* DXGI_FORMAT_D16_UNORM_S8_UINT */:
	case 119 /* DXGI_FORMAT_R16_UNORM_X8_TYPELESS */:
	case 120 /* DXGI_FORMAT_X16_TYPELESS_G8_UINT */:
		return true;

	default:
		return false;
	}
}

bool tIsCompressed(tDXGI_FORMAT fmt)
{
	switch (fmt)
	{
	case tDXGI_FORMAT_BC1_TYPELESS:
	case tDXGI_FORMAT_BC1_UNORM:
	case tDXGI_FORMAT_BC1_UNORM_SRGB:
	case tDXGI_FORMAT_BC2_TYPELESS:
	case tDXGI_FORMAT_BC2_UNORM:
	case tDXGI_FORMAT_BC2_UNORM_SRGB:
	case tDXGI_FORMAT_BC3_TYPELESS:
	case tDXGI_FORMAT_BC3_UNORM:
	case tDXGI_FORMAT_BC3_UNORM_SRGB:
	case tDXGI_FORMAT_BC4_TYPELESS:
	case tDXGI_FORMAT_BC4_UNORM:
	case tDXGI_FORMAT_BC4_SNORM:
	case tDXGI_FORMAT_BC5_TYPELESS:
	case tDXGI_FORMAT_BC5_UNORM:
	case tDXGI_FORMAT_BC5_SNORM:
	case tDXGI_FORMAT_BC6H_TYPELESS:
	case tDXGI_FORMAT_BC6H_UF16:
	case tDXGI_FORMAT_BC6H_SF16:
	case tDXGI_FORMAT_BC7_TYPELESS:
	case tDXGI_FORMAT_BC7_UNORM:
	case tDXGI_FORMAT_BC7_UNORM_SRGB:
		return true;

	default:
		return false;
	}
}

bool tIsPacked(tDXGI_FORMAT fmt)
{
	switch (fmt)
	{
	case tDXGI_FORMAT_R8G8_B8G8_UNORM:
	case tDXGI_FORMAT_G8R8_G8B8_UNORM:
	case tDXGI_FORMAT_YUY2: // 4:2:2 8-bit
	case tDXGI_FORMAT_Y210: // 4:2:2 10-bit
	case tDXGI_FORMAT_Y216: // 4:2:2 16-bit
		return true;

	default:
		return false;
	}
}

bool tIsPlanar(tDXGI_FORMAT fmt)
{
	switch (static_cast<int>(fmt))
	{
	case tDXGI_FORMAT_NV12:      // 4:2:0 8-bit
	case tDXGI_FORMAT_P010:      // 4:2:0 10-bit
	case tDXGI_FORMAT_P016:      // 4:2:0 16-bit
	case tDXGI_FORMAT_420_OPAQUE:// 4:2:0 8-bit
	case tDXGI_FORMAT_NV11:      // 4:1:1 8-bit
		return true;
	case 118 /* tDXGI_FORMAT_D16_UNORM_S8_UINT */:
	case 119 /* tDXGI_FORMAT_R16_UNORM_X8_TYPELESS */:
	case 120 /* tDXGI_FORMAT_X16_TYPELESS_G8_UINT */:
		// These are Xbox One platform specific types
		return true;
	default:
		return false;
	}
}

int tBitsPerPixel(tDXGI_FORMAT fmt)
{
	switch (static_cast<int>(fmt))
	{
	case tDXGI_FORMAT_R32G32B32A32_TYPELESS:
	case tDXGI_FORMAT_R32G32B32A32_FLOAT:
	case tDXGI_FORMAT_R32G32B32A32_UINT:
	case tDXGI_FORMAT_R32G32B32A32_SINT:
		return 128;

	case tDXGI_FORMAT_R32G32B32_TYPELESS:
	case tDXGI_FORMAT_R32G32B32_FLOAT:
	case tDXGI_FORMAT_R32G32B32_UINT:
	case tDXGI_FORMAT_R32G32B32_SINT:
		return 96;

	case tDXGI_FORMAT_R16G16B16A16_TYPELESS:
	case tDXGI_FORMAT_R16G16B16A16_FLOAT:
	case tDXGI_FORMAT_R16G16B16A16_UNORM:
	case tDXGI_FORMAT_R16G16B16A16_UINT:
	case tDXGI_FORMAT_R16G16B16A16_SNORM:
	case tDXGI_FORMAT_R16G16B16A16_SINT:
	case tDXGI_FORMAT_R32G32_TYPELESS:
	case tDXGI_FORMAT_R32G32_FLOAT:
	case tDXGI_FORMAT_R32G32_UINT:
	case tDXGI_FORMAT_R32G32_SINT:
	case tDXGI_FORMAT_R32G8X24_TYPELESS:
	case tDXGI_FORMAT_D32_FLOAT_S8X24_UINT:
	case tDXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS:
	case tDXGI_FORMAT_X32_TYPELESS_G8X24_UINT:
	case tDXGI_FORMAT_Y416:
	case tDXGI_FORMAT_Y210:
	case tDXGI_FORMAT_Y216:
		return 64;

	case tDXGI_FORMAT_R10G10B10A2_TYPELESS:
	case tDXGI_FORMAT_R10G10B10A2_UNORM:
	case tDXGI_FORMAT_R10G10B10A2_UINT:
	case tDXGI_FORMAT_R11G11B10_FLOAT:
	case tDXGI_FORMAT_R8G8B8A8_TYPELESS:
	case tDXGI_FORMAT_R8G8B8A8_UNORM:
	case tDXGI_FORMAT_R8G8B8A8_UNORM_SRGB:
	case tDXGI_FORMAT_R8G8B8A8_UINT:
	case tDXGI_FORMAT_R8G8B8A8_SNORM:
	case tDXGI_FORMAT_R8G8B8A8_SINT:
	case tDXGI_FORMAT_R16G16_TYPELESS:
	case tDXGI_FORMAT_R16G16_FLOAT:
	case tDXGI_FORMAT_R16G16_UNORM:
	case tDXGI_FORMAT_R16G16_UINT:
	case tDXGI_FORMAT_R16G16_SNORM:
	case tDXGI_FORMAT_R16G16_SINT:
	case tDXGI_FORMAT_R32_TYPELESS:
	case tDXGI_FORMAT_D32_FLOAT:
	case tDXGI_FORMAT_R32_FLOAT:
	case tDXGI_FORMAT_R32_UINT:
	case tDXGI_FORMAT_R32_SINT:
	case tDXGI_FORMAT_R24G8_TYPELESS:
	case tDXGI_FORMAT_D24_UNORM_S8_UINT:
	case tDXGI_FORMAT_R24_UNORM_X8_TYPELESS:
	case tDXGI_FORMAT_X24_TYPELESS_G8_UINT:
	case tDXGI_FORMAT_R9G9B9E5_SHAREDEXP:
	case tDXGI_FORMAT_R8G8_B8G8_UNORM:
	case tDXGI_FORMAT_G8R8_G8B8_UNORM:
	case tDXGI_FORMAT_B8G8R8A8_UNORM:
	case tDXGI_FORMAT_B8G8R8X8_UNORM:
	case tDXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM:
	case tDXGI_FORMAT_B8G8R8A8_TYPELESS:
	case tDXGI_FORMAT_B8G8R8A8_UNORM_SRGB:
	case tDXGI_FORMAT_B8G8R8X8_TYPELESS:
	case tDXGI_FORMAT_B8G8R8X8_UNORM_SRGB:
	case tDXGI_FORMAT_AYUV:
	case tDXGI_FORMAT_Y410:
	case tDXGI_FORMAT_YUY2:
	case 116 /* tDXGI_FORMAT_R10G10B10_7E3_A2_FLOAT */:
	case 117 /* tDXGI_FORMAT_R10G10B10_6E4_A2_FLOAT */:
		return 32;

	case tDXGI_FORMAT_P010:
	case tDXGI_FORMAT_P016:
	case 118 /* tDXGI_FORMAT_D16_UNORM_S8_UINT */:
	case 119 /* tDXGI_FORMAT_R16_UNORM_X8_TYPELESS */:
	case 120 /* tDXGI_FORMAT_X16_TYPELESS_G8_UINT */:
		return 24;

	case tDXGI_FORMAT_R8G8_TYPELESS:
	case tDXGI_FORMAT_R8G8_UNORM:
	case tDXGI_FORMAT_R8G8_UINT:
	case tDXGI_FORMAT_R8G8_SNORM:
	case tDXGI_FORMAT_R8G8_SINT:
	case tDXGI_FORMAT_R16_TYPELESS:
	case tDXGI_FORMAT_R16_FLOAT:
	case tDXGI_FORMAT_D16_UNORM:
	case tDXGI_FORMAT_R16_UNORM:
	case tDXGI_FORMAT_R16_UINT:
	case tDXGI_FORMAT_R16_SNORM:
	case tDXGI_FORMAT_R16_SINT:
	case tDXGI_FORMAT_B5G6R5_UNORM:
	case tDXGI_FORMAT_B5G5R5A1_UNORM:
	case tDXGI_FORMAT_A8P8:
	case tDXGI_FORMAT_B4G4R4A4_UNORM:
		return 16;

	case tDXGI_FORMAT_NV12:
	case tDXGI_FORMAT_420_OPAQUE:
	case tDXGI_FORMAT_NV11:
		return 12;

	case tDXGI_FORMAT_R8_TYPELESS:
	case tDXGI_FORMAT_R8_UNORM:
	case tDXGI_FORMAT_R8_UINT:
	case tDXGI_FORMAT_R8_SNORM:
	case tDXGI_FORMAT_R8_SINT:
	case tDXGI_FORMAT_A8_UNORM:
	case tDXGI_FORMAT_AI44:
	case tDXGI_FORMAT_IA44:
	case tDXGI_FORMAT_P8:
		return 8;

	case tDXGI_FORMAT_R1_UNORM:
		return 1;

	case tDXGI_FORMAT_BC1_TYPELESS:
	case tDXGI_FORMAT_BC1_UNORM:
	case tDXGI_FORMAT_BC1_UNORM_SRGB:
	case tDXGI_FORMAT_BC4_TYPELESS:
	case tDXGI_FORMAT_BC4_UNORM:
	case tDXGI_FORMAT_BC4_SNORM:
		return 4;

	case tDXGI_FORMAT_BC2_TYPELESS:
	case tDXGI_FORMAT_BC2_UNORM:
	case tDXGI_FORMAT_BC2_UNORM_SRGB:
	case tDXGI_FORMAT_BC3_TYPELESS:
	case tDXGI_FORMAT_BC3_UNORM:
	case tDXGI_FORMAT_BC3_UNORM_SRGB:
	case tDXGI_FORMAT_BC5_TYPELESS:
	case tDXGI_FORMAT_BC5_UNORM:
	case tDXGI_FORMAT_BC5_SNORM:
	case tDXGI_FORMAT_BC6H_TYPELESS:
	case tDXGI_FORMAT_BC6H_UF16:
	case tDXGI_FORMAT_BC6H_SF16:
	case tDXGI_FORMAT_BC7_TYPELESS:
	case tDXGI_FORMAT_BC7_UNORM:
	case tDXGI_FORMAT_BC7_UNORM_SRGB:
		return 8;

	default:
		return 0;
	}
}

void tComputePitch(tDXGI_FORMAT fmt, int width, int height, int& rowPitch, int& slicePitch, unsigned int flags)
{
	if (tIsCompressed(fmt))
	{
		int bpb = (fmt == tDXGI_FORMAT_BC1_TYPELESS
			|| fmt == tDXGI_FORMAT_BC1_UNORM
			|| fmt == tDXGI_FORMAT_BC1_UNORM_SRGB
			|| fmt == tDXGI_FORMAT_BC4_TYPELESS
			|| fmt == tDXGI_FORMAT_BC4_UNORM
			|| fmt == tDXGI_FORMAT_BC4_SNORM) ? 8 : 16;
		int nbw = 1 > int((width + 3) / 4) ? 1 : int((width + 3) / 4);
		int nbh = 1 > int((height + 3) / 4) ? 1 : int((height + 3) / 4);
		rowPitch = nbw * bpb;

		slicePitch = rowPitch * nbh;
	}
	else if (tIsPacked(fmt))
	{
		int bpe = (fmt == tDXGI_FORMAT_Y210 || fmt == tDXGI_FORMAT_Y216) ? 8 : 4;
		rowPitch = ((width + 1) >> 1) * bpe;

		slicePitch = rowPitch * height;
	}
	else if (fmt == tDXGI_FORMAT_NV11)
	{
		rowPitch = ((width + 3) >> 2) * 4;

		// Direct3D makes this simplifying assumption, although it is larger than the 4:1:1 data
		slicePitch = rowPitch * height * 2;
	}
	else if (tIsPlanar(fmt))
	{
		int bpe = (fmt == tDXGI_FORMAT_P010 || fmt == tDXGI_FORMAT_P016
			|| fmt == tDXGI_FORMAT(118 /* tDXGI_FORMAT_D16_UNORM_S8_UINT */)
			|| fmt == tDXGI_FORMAT(119 /* tDXGI_FORMAT_R16_UNORM_X8_TYPELESS */)
			|| fmt == tDXGI_FORMAT(120 /* tDXGI_FORMAT_X16_TYPELESS_G8_UINT */)) ? 4 : 2;
		rowPitch = ((width + 1) >> 1) * bpe;

		slicePitch = rowPitch * (height + ((height + 1) >> 1));
	}
	else
	{
		int bpp;

		if (flags & tCP_FLAGS_24BPP)
			bpp = 24;
		else if (flags & tCP_FLAGS_16BPP)
			bpp = 16;
		else if (flags & tCP_FLAGS_8BPP)
			bpp = 8;
		else
			bpp = tBitsPerPixel(fmt);

		if (flags & tCP_FLAGS_LEGACY_DWORD)
		{
			// Special computation for some incorrectly created DDS files based on
			// legacy DirectDraw assumptions about pitch alignment
			rowPitch = ((width * bpp + 31) / 32) * sizeof(unsigned int);
			slicePitch = rowPitch * height;
		}
		else if (flags & tCP_FLAGS_PARAGRAPH)
		{
			rowPitch = ((width * bpp + 127) / 128) * 16;
			slicePitch = rowPitch * height;
		}
		else
		{
			rowPitch = (width * bpp + 7) / 8;
			slicePitch = rowPitch * height;
		}
	}
}

struct tLegacyDDS
{
	tDXGI_FORMAT		format;
	unsigned int		convFlags;
	tDDS_PIXELFORMAT	ddpf;
};

const tLegacyDDS t_g_LegacyDDSMap[] =
{
	{ tDXGI_FORMAT_BC1_UNORM, tCONV_FLAGS_NONE, DDSPF_DXT1 }, // D3DFMT_DXT1
	{ tDXGI_FORMAT_BC2_UNORM, tCONV_FLAGS_NONE, DDSPF_DXT3 }, // D3DFMT_DXT3
	{ tDXGI_FORMAT_BC3_UNORM, tCONV_FLAGS_NONE, DDSPF_DXT5 }, // D3DFMT_DXT5

	{ tDXGI_FORMAT_BC2_UNORM, tCONV_FLAGS_PMALPHA, DDSPF_DXT2 }, // D3DFMT_DXT2
	{ tDXGI_FORMAT_BC3_UNORM, tCONV_FLAGS_PMALPHA, DDSPF_DXT4 }, // D3DFMT_DXT4

	{ tDXGI_FORMAT_BC4_UNORM, tCONV_FLAGS_NONE, DDSPF_BC4_UNORM },
	{ tDXGI_FORMAT_BC4_SNORM, tCONV_FLAGS_NONE, DDSPF_BC4_SNORM },
	{ tDXGI_FORMAT_BC5_UNORM, tCONV_FLAGS_NONE, DDSPF_BC5_UNORM },
	{ tDXGI_FORMAT_BC5_SNORM, tCONV_FLAGS_NONE, DDSPF_BC5_SNORM },

	{ tDXGI_FORMAT_BC4_UNORM, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('A', 'T', 'I', '1'), 0, 0, 0, 0, 0 } },
	{ tDXGI_FORMAT_BC5_UNORM, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('A', 'T', 'I', '2'), 0, 0, 0, 0, 0 } },

	{ tDXGI_FORMAT_R8G8_B8G8_UNORM, tCONV_FLAGS_NONE, DDSPF_R8G8_B8G8 }, // D3DFMT_R8G8_B8G8
	{ tDXGI_FORMAT_G8R8_G8B8_UNORM, tCONV_FLAGS_NONE, DDSPF_G8R8_G8B8 }, // D3DFMT_G8R8_G8B8

	{ tDXGI_FORMAT_B8G8R8A8_UNORM, tCONV_FLAGS_NONE, DDSPF_A8R8G8B8 }, // D3DFMT_A8R8G8B8 (uses DXGI 1.1 format)
	{ tDXGI_FORMAT_B8G8R8X8_UNORM, tCONV_FLAGS_NONE, DDSPF_X8R8G8B8 }, // D3DFMT_X8R8G8B8 (uses DXGI 1.1 format)
	{ tDXGI_FORMAT_R8G8B8A8_UNORM, tCONV_FLAGS_NONE, DDSPF_A8B8G8R8 }, // D3DFMT_A8B8G8R8
	{ tDXGI_FORMAT_R8G8B8A8_UNORM, tCONV_FLAGS_NOALPHA, DDSPF_X8B8G8R8 }, // D3DFMT_X8B8G8R8
	{ tDXGI_FORMAT_R16G16_UNORM, tCONV_FLAGS_NONE, DDSPF_G16R16 }, // D3DFMT_G16R16

	{ tDXGI_FORMAT_R10G10B10A2_UNORM, tCONV_FLAGS_SWIZZLE, { sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 32, 0x000003ff, 0x000ffc00, 0x3ff00000, 0xc0000000 } }, // D3DFMT_A2R10G10B10 (D3DX reversal issue workaround)
	{ tDXGI_FORMAT_R10G10B10A2_UNORM, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 32, 0x3ff00000, 0x000ffc00, 0x000003ff, 0xc0000000 } }, // D3DFMT_A2B10G10R10 (D3DX reversal issue workaround)

	{ tDXGI_FORMAT_R8G8B8A8_UNORM, tCONV_FLAGS_EXPAND
	| tCONV_FLAGS_NOALPHA
	| tCONV_FLAGS_888, DDSPF_R8G8B8 }, // D3DFMT_R8G8B8

	{ tDXGI_FORMAT_B5G6R5_UNORM, tCONV_FLAGS_565, DDSPF_R5G6B5 }, // D3DFMT_R5G6B5
	{ tDXGI_FORMAT_B5G5R5A1_UNORM, tCONV_FLAGS_5551, DDSPF_A1R5G5B5 }, // D3DFMT_A1R5G5B5
	{ tDXGI_FORMAT_B5G5R5A1_UNORM, tCONV_FLAGS_5551
	| tCONV_FLAGS_NOALPHA, { sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 16, 0x7c00, 0x03e0, 0x001f, 0x0000 } }, // D3DFMT_X1R5G5B5

	{ tDXGI_FORMAT_R8G8B8A8_UNORM, tCONV_FLAGS_EXPAND
	| tCONV_FLAGS_8332, { sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 16, 0x00e0, 0x001c, 0x0003, 0xff00 } }, // D3DFMT_A8R3G3B2
	{ tDXGI_FORMAT_B5G6R5_UNORM, tCONV_FLAGS_EXPAND
	| tCONV_FLAGS_332, { sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 8, 0xe0, 0x1c, 0x03, 0x00 } }, // D3DFMT_R3G3B2

	{ tDXGI_FORMAT_R8_UNORM, tCONV_FLAGS_NONE, DDSPF_L8 }, // D3DFMT_L8
	{ tDXGI_FORMAT_R16_UNORM, tCONV_FLAGS_NONE, DDSPF_L16 }, // D3DFMT_L16
	{ tDXGI_FORMAT_R8G8_UNORM, tCONV_FLAGS_NONE, DDSPF_A8L8 }, // D3DFMT_A8L8

	{ tDXGI_FORMAT_A8_UNORM, tCONV_FLAGS_NONE, DDSPF_A8 }, // D3DFMT_A8

	{ tDXGI_FORMAT_R16G16B16A16_UNORM, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, 36, 0, 0, 0, 0, 0 } }, // D3DFMT_A16B16G16R16
	{ tDXGI_FORMAT_R16G16B16A16_SNORM, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, 110, 0, 0, 0, 0, 0 } }, // D3DFMT_Q16W16V16U16
	{ tDXGI_FORMAT_R16_FLOAT, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, 111, 0, 0, 0, 0, 0 } }, // D3DFMT_R16F
	{ tDXGI_FORMAT_R16G16_FLOAT, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, 112, 0, 0, 0, 0, 0 } }, // D3DFMT_G16R16F
	{ tDXGI_FORMAT_R16G16B16A16_FLOAT, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, 113, 0, 0, 0, 0, 0 } }, // D3DFMT_A16B16G16R16F
	{ tDXGI_FORMAT_R32_FLOAT, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, 114, 0, 0, 0, 0, 0 } }, // D3DFMT_R32F
	{ tDXGI_FORMAT_R32G32_FLOAT, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, 115, 0, 0, 0, 0, 0 } }, // D3DFMT_G32R32F
	{ tDXGI_FORMAT_R32G32B32A32_FLOAT, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, 116, 0, 0, 0, 0, 0 } }, // D3DFMT_A32B32G32R32F

	{ tDXGI_FORMAT_R32_FLOAT, tCONV_FLAGS_NONE, { sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 32, 0xffffffff, 0x00000000, 0x00000000, 0x00000000 } }, // D3DFMT_R32F (D3DX uses FourCC 114 instead)

	{ tDXGI_FORMAT_R8G8B8A8_UNORM, tCONV_FLAGS_EXPAND
	| tCONV_FLAGS_PAL8
	| tCONV_FLAGS_A8P8, { sizeof(tDDS_PIXELFORMAT), tDDS_PAL8, 0, 16, 0, 0, 0, 0 } }, // D3DFMT_A8P8
	{ tDXGI_FORMAT_R8G8B8A8_UNORM, tCONV_FLAGS_EXPAND
	| tCONV_FLAGS_PAL8, { sizeof(tDDS_PIXELFORMAT), tDDS_PAL8, 0, 8, 0, 0, 0, 0 } }, // D3DFMT_P8

	{ tDXGI_FORMAT_B4G4R4A4_UNORM, tCONV_FLAGS_4444, DDSPF_A4R4G4B4 }, // D3DFMT_A4R4G4B4 (uses DXGI 1.2 format)
	{ tDXGI_FORMAT_B4G4R4A4_UNORM, tCONV_FLAGS_NOALPHA
	| tCONV_FLAGS_4444, { sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 16, 0x0f00, 0x00f0, 0x000f, 0x0000 } }, // D3DFMT_X4R4G4B4 (uses DXGI 1.2 format)
	{ tDXGI_FORMAT_B4G4R4A4_UNORM, tCONV_FLAGS_EXPAND
	| tCONV_FLAGS_44, { sizeof(tDDS_PIXELFORMAT), tDDS_LUMINANCE, 0, 8, 0x0f, 0x00, 0x00, 0xf0 } }, // D3DFMT_A4L4 (uses DXGI 1.2 format)

	{ tDXGI_FORMAT_YUY2, tCONV_FLAGS_NONE, DDSPF_YUY2 }, // D3DFMT_YUY2 (uses DXGI 1.2 format)
	{ tDXGI_FORMAT_YUY2, tCONV_FLAGS_SWIZZLE, { sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('U', 'Y', 'V', 'Y'), 0, 0, 0, 0, 0 } }, // D3DFMT_UYVY (uses DXGI 1.2 format)
};


tDXGI_FORMAT _tGetDXGIFormat(const tDDS_PIXELFORMAT& ddpf, UINT32 flags, UINT32& convFlags)
{
	const int MAP_SIZE = sizeof(t_g_LegacyDDSMap) / sizeof(tLegacyDDS);
	int index = 0;
	for (index = 0; index < MAP_SIZE; ++index)
	{
		const tLegacyDDS* entry = &t_g_LegacyDDSMap[index];

		if (ddpf.dwFlags & entry->ddpf.dwFlags)
		{
			if (entry->ddpf.dwFlags & tDDS_FOURCC)
			{
				if (ddpf.dwFourCC == entry->ddpf.dwFourCC)
					break;
			}
			else if (entry->ddpf.dwFlags & tDDS_PAL8)
			{
				if (ddpf.dwRGBBitCount == entry->ddpf.dwRGBBitCount)
					break;
			}
			else if (ddpf.dwRGBBitCount == entry->ddpf.dwRGBBitCount)
			{
				// RGB, RGBA, ALPHA, LUMINANCE
				if (ddpf.dwRBitMask == entry->ddpf.dwRBitMask
					&& ddpf.dwGBitMask == entry->ddpf.dwGBitMask
					&& ddpf.dwBBitMask == entry->ddpf.dwBBitMask
					&& ddpf.dwABitMask == entry->ddpf.dwABitMask)
					break;
			}
		}
	}

	if (index >= MAP_SIZE)
		return tDXGI_FORMAT_UNKNOWN;

	UINT32 cflags = t_g_LegacyDDSMap[index].convFlags;
	tDXGI_FORMAT format = t_g_LegacyDDSMap[index].format;

	if ((cflags & tCONV_FLAGS_EXPAND) && (flags & tDDS_FLAGS_NO_LEGACY_EXPANSION))
		return tDXGI_FORMAT_UNKNOWN;

	if ((format == tDXGI_FORMAT_R10G10B10A2_UNORM) && (flags & tDDS_FLAGS_NO_R10B10G10A2_FIXUP))
	{
		cflags ^= tCONV_FLAGS_SWIZZLE;
	}

	convFlags = cflags;

	return format;
}

//-------------------------------------------------------------------------------------
// Decodes DDS header including optional DX10 extended header
//-------------------------------------------------------------------------------------
bool tDecodeDDSHeader(tDDS_HEADER* pHeader,UINT32 flags, tTexMetadata& metadata, UINT32& convFlags)
{
	memset(&metadata, 0, sizeof(tTexMetadata));

	if (pHeader->dwSize != sizeof(tDDS_HEADER)|| pHeader->ddspf.dwSize != sizeof(tDDS_PIXELFORMAT))
	{
		return false;
	}

	metadata.mipLevels = pHeader->dwMipMapCount;
	if (metadata.mipLevels == 0)
		metadata.mipLevels = 1;

	// Check for DX10 extension
	if ((pHeader->ddspf.dwFlags & tDDS_FOURCC)&& (tMAKEFOURCC('D', 'X', '1', '0') == pHeader->ddspf.dwFourCC))
	{
		return false;
	}
	else
	{
		metadata.arraySize = 1;

		if (pHeader->dwFlags & tDDS_HEADER_FLAGS_VOLUME)
		{
			metadata.width = pHeader->dwWidth;
			metadata.height = pHeader->dwHeight;
			metadata.depth = pHeader->dwDepth;
			metadata.dimension = tTEX_DIMENSION_TEXTURE3D;
		}
		else
		{
			if (pHeader->dwCaps2 & tDDS_CUBEMAP)
			{
				// We require all six faces to be defined
				if ((pHeader->dwCaps2 & tDDS_CUBEMAP_ALLFACES) != tDDS_CUBEMAP_ALLFACES)
					return false;

				metadata.arraySize = 6;
				metadata.miscFlags |= tTEX_MISC_TEXTURECUBE;
			}

			metadata.width = pHeader->dwWidth;
			metadata.height = pHeader->dwHeight;
			metadata.depth = 1;
			metadata.dimension = tTEX_DIMENSION_TEXTURE2D;

			// Note there's no way for a legacy Direct3D 9 DDS to express a '1D' texture
		}

		metadata.format = _tGetDXGIFormat(pHeader->ddspf, flags, convFlags);

		if (metadata.format == tDXGI_FORMAT_UNKNOWN)
			return false;

		if (convFlags & tCONV_FLAGS_PMALPHA)
			metadata.miscFlags2 |= tTEX_ALPHA_MODE_PREMULTIPLIED;

		// Special flag for handling LUMINANCE legacy formats
		if (flags & tDDS_FLAGS_EXPAND_LUMINANCE)
		{
			switch (metadata.format)
			{
			case tDXGI_FORMAT_R8_UNORM:
				metadata.format = tDXGI_FORMAT_R8G8B8A8_UNORM;
				convFlags |= tCONV_FLAGS_L8 | tCONV_FLAGS_EXPAND;
				break;

			case tDXGI_FORMAT_R8G8_UNORM:
				metadata.format = tDXGI_FORMAT_R8G8B8A8_UNORM;
				convFlags |= tCONV_FLAGS_A8L8 | tCONV_FLAGS_EXPAND;
				break;

			case tDXGI_FORMAT_R16_UNORM:
				metadata.format = tDXGI_FORMAT_R16G16B16A16_UNORM;
				convFlags |= tCONV_FLAGS_L16 | tCONV_FLAGS_EXPAND;
				break;
			}
		}
	}

	// Special flag for handling BGR DXGI 1.1 formats
	if (flags & tDDS_FLAGS_FORCE_RGB)
	{
		switch (metadata.format)
		{
		case tDXGI_FORMAT_B8G8R8A8_UNORM:
			metadata.format = tDXGI_FORMAT_R8G8B8A8_UNORM;
			convFlags |= tCONV_FLAGS_SWIZZLE;
			break;

		case tDXGI_FORMAT_B8G8R8X8_UNORM:
			metadata.format = tDXGI_FORMAT_R8G8B8A8_UNORM;
			convFlags |= tCONV_FLAGS_SWIZZLE | tCONV_FLAGS_NOALPHA;
			break;

		case tDXGI_FORMAT_B8G8R8A8_TYPELESS:
			metadata.format = tDXGI_FORMAT_R8G8B8A8_TYPELESS;
			convFlags |= tCONV_FLAGS_SWIZZLE;
			break;

		case tDXGI_FORMAT_B8G8R8A8_UNORM_SRGB:
			metadata.format = tDXGI_FORMAT_R8G8B8A8_UNORM_SRGB;
			convFlags |= tCONV_FLAGS_SWIZZLE;
			break;

		case tDXGI_FORMAT_B8G8R8X8_TYPELESS:
			metadata.format = tDXGI_FORMAT_R8G8B8A8_TYPELESS;
			convFlags |= tCONV_FLAGS_SWIZZLE | tCONV_FLAGS_NOALPHA;
			break;

		case tDXGI_FORMAT_B8G8R8X8_UNORM_SRGB:
			metadata.format = tDXGI_FORMAT_R8G8B8A8_UNORM_SRGB;
			convFlags |= tCONV_FLAGS_SWIZZLE | tCONV_FLAGS_NOALPHA;
			break;
		}
	}

	// Special flag for handling 16bpp formats
	if (flags & tDDS_FLAGS_NO_16BPP)
	{
		switch (metadata.format)
		{
		case tDXGI_FORMAT_B5G6R5_UNORM:
		case tDXGI_FORMAT_B5G5R5A1_UNORM:
		case tDXGI_FORMAT_B4G4R4A4_UNORM:
			metadata.format = tDXGI_FORMAT_R8G8B8A8_UNORM;
			convFlags |= tCONV_FLAGS_EXPAND;
			if (metadata.format == tDXGI_FORMAT_B5G6R5_UNORM)
				convFlags |= tCONV_FLAGS_NOALPHA;
		}
	}

	return true;
}

//
//--- mipmap (1D/2D) levels computation ---
int tCountMips( int width,  int height)
{
	int mipLevels = 1;

	while (height > 1 || width > 1)
	{
		if (height > 1)
			height >>= 1;

		if (width > 1)
			width >>= 1;

		++mipLevels;
	}

	return mipLevels;
}

bool tCalculateMipLevels( int width,  int height,int& mipLevels)
{
	if (mipLevels > 1)
	{
		int maxMips = tCountMips(width, height);
		if (mipLevels > maxMips)
			return false;
	}
	else if (mipLevels == 0)
	{
		mipLevels = tCountMips(width, height);
	}
	else
	{
		mipLevels = 1;
	}
	return true;
}

//--- volume mipmap (3D) levels computation ---
int tCountMips3D( int width,  int height,  int depth)
{
	int mipLevels = 1;

	while (height > 1 || width > 1 || depth > 1)
	{
		if (height > 1)
			height >>= 1;

		if (width > 1)
			width >>= 1;

		if (depth > 1)
			depth >>= 1;

		++mipLevels;
	}

	return mipLevels;
}

bool tCalculateMipLevels3D( int width,  int height,  int depth, int& mipLevels)
{
	if (mipLevels > 1)
	{
		int maxMips = tCountMips3D(width, height, depth);
		if (mipLevels > maxMips)
			return false;
	}
	else if (mipLevels == 0)
	{
		mipLevels = tCountMips3D(width, height, depth);
	}
	else
	{
		mipLevels = 1;
	}
	return true;
}