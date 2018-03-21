#ifndef tDDS_LOADER_HELP_h
#define tDDS_LOADER_HELP_h

#include <stdlib.h>
#include <string>

#define tDDS_FOURCC      0x00000004  // DDPF_FOURCC
#define tDDS_RGB         0x00000040  // DDPF_RGB
#define tDDS_RGBA        0x00000041  // DDPF_RGB | DDPF_ALPHAPIXELS
#define tDDS_LUMINANCE   0x00020000  // DDPF_LUMINANCE
#define tDDS_LUMINANCEA  0x00020001  // DDPF_LUMINANCE | DDPF_ALPHAPIXELS
#define tDDS_ALPHA       0x00000002  // DDPF_ALPHA
#define tDDS_PAL8        0x00000020  // DDPF_PALETTEINDEXED8

#define tDDS_HEADER_FLAGS_TEXTURE        0x00001007  // DDSD_CAPS | DDSD_HEIGHT | DDSD_WIDTH | DDSD_PIXELFORMAT 
#define tDDS_HEADER_FLAGS_MIPMAP         0x00020000  // DDSD_MIPMAPCOUNT
#define tDDS_HEADER_FLAGS_VOLUME         0x00800000  // DDSD_DEPTH
#define tDDS_HEADER_FLAGS_PITCH          0x00000008  // DDSD_PITCH
#define tDDS_HEADER_FLAGS_LINEARSIZE     0x00080000  // DDSD_LINEARSIZE

#define tDDS_HEIGHT 0x00000002 // DDSD_HEIGHT
#define tDDS_WIDTH  0x00000004 // DDSD_WIDTH

#define tDDS_SURFACE_FLAGS_TEXTURE 0x00001000 // DDSCAPS_TEXTURE
#define tDDS_SURFACE_FLAGS_MIPMAP  0x00400008 // DDSCAPS_COMPLEX | DDSCAPS_MIPMAP
#define tDDS_SURFACE_FLAGS_CUBEMAP 0x00000008 // DDSCAPS_COMPLEX

#define tDDS_CUBEMAP_POSITIVEX 0x00000600 // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_POSITIVEX
#define tDDS_CUBEMAP_NEGATIVEX 0x00000a00 // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_NEGATIVEX
#define tDDS_CUBEMAP_POSITIVEY 0x00001200 // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_POSITIVEY
#define tDDS_CUBEMAP_NEGATIVEY 0x00002200 // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_NEGATIVEY
#define tDDS_CUBEMAP_POSITIVEZ 0x00004200 // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_POSITIVEZ
#define tDDS_CUBEMAP_NEGATIVEZ 0x00008200 // DDSCAPS2_CUBEMAP | DDSCAPS2_CUBEMAP_NEGATIVEZ

#define tDDS_CUBEMAP_ALLFACES ( tDDS_CUBEMAP_POSITIVEX | tDDS_CUBEMAP_NEGATIVEX |\
	tDDS_CUBEMAP_POSITIVEY | tDDS_CUBEMAP_NEGATIVEY | \
	tDDS_CUBEMAP_POSITIVEZ | tDDS_CUBEMAP_NEGATIVEZ)

#define tDDS_CUBEMAP 0x00000200 // DDSCAPS2_CUBEMAP
#define tDDS_FLAGS_VOLUME 0x00200000 // DDSCAPS2_VOLUME

#define INT32  int
#define UINT32 unsigned int
#define UINT16 unsigned short

enum tDXGI_FORMAT
{
	tDXGI_FORMAT_UNKNOWN = 0,
	tDXGI_FORMAT_R32G32B32A32_TYPELESS = 1,
	tDXGI_FORMAT_R32G32B32A32_FLOAT = 2,
	tDXGI_FORMAT_R32G32B32A32_UINT = 3,
	tDXGI_FORMAT_R32G32B32A32_SINT = 4,
	tDXGI_FORMAT_R32G32B32_TYPELESS = 5,
	tDXGI_FORMAT_R32G32B32_FLOAT = 6,
	tDXGI_FORMAT_R32G32B32_UINT = 7,
	tDXGI_FORMAT_R32G32B32_SINT = 8,
	tDXGI_FORMAT_R16G16B16A16_TYPELESS = 9,
	tDXGI_FORMAT_R16G16B16A16_FLOAT = 10,
	tDXGI_FORMAT_R16G16B16A16_UNORM = 11,
	tDXGI_FORMAT_R16G16B16A16_UINT = 12,
	tDXGI_FORMAT_R16G16B16A16_SNORM = 13,
	tDXGI_FORMAT_R16G16B16A16_SINT = 14,
	tDXGI_FORMAT_R32G32_TYPELESS = 15,
	tDXGI_FORMAT_R32G32_FLOAT = 16,
	tDXGI_FORMAT_R32G32_UINT = 17,
	tDXGI_FORMAT_R32G32_SINT = 18,
	tDXGI_FORMAT_R32G8X24_TYPELESS = 19,
	tDXGI_FORMAT_D32_FLOAT_S8X24_UINT = 20,
	tDXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS = 21,
	tDXGI_FORMAT_X32_TYPELESS_G8X24_UINT = 22,
	tDXGI_FORMAT_R10G10B10A2_TYPELESS = 23,
	tDXGI_FORMAT_R10G10B10A2_UNORM = 24,
	tDXGI_FORMAT_R10G10B10A2_UINT = 25,
	tDXGI_FORMAT_R11G11B10_FLOAT = 26,
	tDXGI_FORMAT_R8G8B8A8_TYPELESS = 27,
	tDXGI_FORMAT_R8G8B8A8_UNORM = 28,
	tDXGI_FORMAT_R8G8B8A8_UNORM_SRGB = 29,
	tDXGI_FORMAT_R8G8B8A8_UINT = 30,
	tDXGI_FORMAT_R8G8B8A8_SNORM = 31,
	tDXGI_FORMAT_R8G8B8A8_SINT = 32,
	tDXGI_FORMAT_R16G16_TYPELESS = 33,
	tDXGI_FORMAT_R16G16_FLOAT = 34,
	tDXGI_FORMAT_R16G16_UNORM = 35,
	tDXGI_FORMAT_R16G16_UINT = 36,
	tDXGI_FORMAT_R16G16_SNORM = 37,
	tDXGI_FORMAT_R16G16_SINT = 38,
	tDXGI_FORMAT_R32_TYPELESS = 39,
	tDXGI_FORMAT_D32_FLOAT = 40,
	tDXGI_FORMAT_R32_FLOAT = 41,
	tDXGI_FORMAT_R32_UINT = 42,
	tDXGI_FORMAT_R32_SINT = 43,
	tDXGI_FORMAT_R24G8_TYPELESS = 44,
	tDXGI_FORMAT_D24_UNORM_S8_UINT = 45,
	tDXGI_FORMAT_R24_UNORM_X8_TYPELESS = 46,
	tDXGI_FORMAT_X24_TYPELESS_G8_UINT = 47,
	tDXGI_FORMAT_R8G8_TYPELESS = 48,
	tDXGI_FORMAT_R8G8_UNORM = 49,
	tDXGI_FORMAT_R8G8_UINT = 50,
	tDXGI_FORMAT_R8G8_SNORM = 51,
	tDXGI_FORMAT_R8G8_SINT = 52,
	tDXGI_FORMAT_R16_TYPELESS = 53,
	tDXGI_FORMAT_R16_FLOAT = 54,
	tDXGI_FORMAT_D16_UNORM = 55,
	tDXGI_FORMAT_R16_UNORM = 56,
	tDXGI_FORMAT_R16_UINT = 57,
	tDXGI_FORMAT_R16_SNORM = 58,
	tDXGI_FORMAT_R16_SINT = 59,
	tDXGI_FORMAT_R8_TYPELESS = 60,
	tDXGI_FORMAT_R8_UNORM = 61,
	tDXGI_FORMAT_R8_UINT = 62,
	tDXGI_FORMAT_R8_SNORM = 63,
	tDXGI_FORMAT_R8_SINT = 64,
	tDXGI_FORMAT_A8_UNORM = 65,
	tDXGI_FORMAT_R1_UNORM = 66,
	tDXGI_FORMAT_R9G9B9E5_SHAREDEXP = 67,
	tDXGI_FORMAT_R8G8_B8G8_UNORM = 68,
	tDXGI_FORMAT_G8R8_G8B8_UNORM = 69,
	tDXGI_FORMAT_BC1_TYPELESS = 70,
	tDXGI_FORMAT_BC1_UNORM = 71,
	tDXGI_FORMAT_BC1_UNORM_SRGB = 72,
	tDXGI_FORMAT_BC2_TYPELESS = 73,
	tDXGI_FORMAT_BC2_UNORM = 74,
	tDXGI_FORMAT_BC2_UNORM_SRGB = 75,
	tDXGI_FORMAT_BC3_TYPELESS = 76,
	tDXGI_FORMAT_BC3_UNORM = 77,
	tDXGI_FORMAT_BC3_UNORM_SRGB = 78,
	tDXGI_FORMAT_BC4_TYPELESS = 79,
	tDXGI_FORMAT_BC4_UNORM = 80,
	tDXGI_FORMAT_BC4_SNORM = 81,
	tDXGI_FORMAT_BC5_TYPELESS = 82,
	tDXGI_FORMAT_BC5_UNORM = 83,
	tDXGI_FORMAT_BC5_SNORM = 84,
	tDXGI_FORMAT_B5G6R5_UNORM = 85,
	tDXGI_FORMAT_B5G5R5A1_UNORM = 86,
	tDXGI_FORMAT_B8G8R8A8_UNORM = 87,
	tDXGI_FORMAT_B8G8R8X8_UNORM = 88,
	tDXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM = 89,
	tDXGI_FORMAT_B8G8R8A8_TYPELESS = 90,
	tDXGI_FORMAT_B8G8R8A8_UNORM_SRGB = 91,
	tDXGI_FORMAT_B8G8R8X8_TYPELESS = 92,
	tDXGI_FORMAT_B8G8R8X8_UNORM_SRGB = 93,
	tDXGI_FORMAT_BC6H_TYPELESS = 94,
	tDXGI_FORMAT_BC6H_UF16 = 95,
	tDXGI_FORMAT_BC6H_SF16 = 96,
	tDXGI_FORMAT_BC7_TYPELESS = 97,
	tDXGI_FORMAT_BC7_UNORM = 98,
	tDXGI_FORMAT_BC7_UNORM_SRGB = 99,
	tDXGI_FORMAT_AYUV = 100,
	tDXGI_FORMAT_Y410 = 101,
	tDXGI_FORMAT_Y416 = 102,
	tDXGI_FORMAT_NV12 = 103,
	tDXGI_FORMAT_P010 = 104,
	tDXGI_FORMAT_P016 = 105,
	tDXGI_FORMAT_420_OPAQUE = 106,
	tDXGI_FORMAT_YUY2 = 107,
	tDXGI_FORMAT_Y210 = 108,
	tDXGI_FORMAT_Y216 = 109,
	tDXGI_FORMAT_NV11 = 110,
	tDXGI_FORMAT_AI44 = 111,
	tDXGI_FORMAT_IA44 = 112,
	tDXGI_FORMAT_P8 = 113,
	tDXGI_FORMAT_A8P8 = 114,
	tDXGI_FORMAT_B4G4R4A4_UNORM = 115,
	tDXGI_FORMAT_FORCE_UINT = 0xffffffff
};

enum tCP_FLAGS
{
	tCP_FLAGS_NONE = 0x0,      // Normal operation
	tCP_FLAGS_LEGACY_DWORD = 0x1,      // Assume pitch is UINT32 aligned instead of BYTE aligned
	tCP_FLAGS_PARAGRAPH = 0x2,      // Assume pitch is 16-byte aligned instead of BYTE aligned
	tCP_FLAGS_24BPP = 0x10000,  // Override with a legacy 24 bits-per-pixel format size
	tCP_FLAGS_16BPP = 0x20000,  // Override with a legacy 16 bits-per-pixel format size
	tCP_FLAGS_8BPP = 0x40000,  // Override with a legacy 8 bits-per-pixel format size
};

struct tDDS_PIXELFORMAT
{
	UINT32    dwSize;
	UINT32    dwFlags;
	UINT32    dwFourCC;
	UINT32    dwRGBBitCount;
	UINT32    dwRBitMask;
	UINT32    dwGBitMask;
	UINT32    dwBBitMask;
	UINT32    dwABitMask;
};

struct tDDS_HEADER
{
	UINT32    dwSize;
	UINT32    dwFlags;
	UINT32    dwHeight;
	UINT32    dwWidth;
	UINT32    dwPitchOrLinearSize;
	UINT32    dwDepth; // only if tDDS_HEADER_FLAGS_VOLUME is set in dwFlags
	UINT32    dwMipMapCount;
	UINT32    dwReserved1[11];
	tDDS_PIXELFORMAT ddspf;
	UINT32    dwCaps;
	UINT32    dwCaps2;
	UINT32    dwCaps3;
	UINT32    dwCaps4;
	UINT32    dwReserved2;
};

struct tDDS_HEADER_DXT10
{
	tDXGI_FORMAT dxgiFormat;
	UINT32    resourceDimension;
	UINT32    miscFlag; // see tDDS_RESOURCE_MISC_FLAG
	UINT32    arraySize;
	UINT32    miscFlags2; // see tDDS_MISC_FLAGS2
};

enum tCONVERSION_FLAGS
{
	tCONV_FLAGS_NONE = 0x0,
	tCONV_FLAGS_EXPAND = 0x1,      // Conversion requires expanded pixel size
	tCONV_FLAGS_NOALPHA = 0x2,      // Conversion requires setting alpha to known value
	tCONV_FLAGS_SWIZZLE = 0x4,      // BGR/RGB order swizzling required
	tCONV_FLAGS_PAL8 = 0x8,      // Has an 8-bit palette
	tCONV_FLAGS_888 = 0x10,     // Source is an 8:8:8 (24bpp) format
	tCONV_FLAGS_565 = 0x20,     // Source is a 5:6:5 (16bpp) format
	tCONV_FLAGS_5551 = 0x40,     // Source is a 5:5:5:1 (16bpp) format
	tCONV_FLAGS_4444 = 0x80,     // Source is a 4:4:4:4 (16bpp) format
	tCONV_FLAGS_44 = 0x100,    // Source is a 4:4 (8bpp) format
	tCONV_FLAGS_332 = 0x200,    // Source is a 3:3:2 (8bpp) format
	tCONV_FLAGS_8332 = 0x400,    // Source is a 8:3:3:2 (16bpp) format
	tCONV_FLAGS_A8P8 = 0x800,    // Has an 8-bit palette with an alpha channel
	tCONV_FLAGS_DX10 = 0x10000,  // Has the 'DX10' extension header
	tCONV_FLAGS_PMALPHA = 0x20000,  // Contains premultiplied alpha data
	tCONV_FLAGS_L8 = 0x40000,  // Source is a 8 luminance format 
	tCONV_FLAGS_L16 = 0x80000,  // Source is a 16 luminance format 
	tCONV_FLAGS_A8L8 = 0x100000, // Source is a 8:8 luminance format 
};

enum tDDS_FLAGS
{
	tDDS_FLAGS_NONE = 0x0,

	tDDS_FLAGS_LEGACY_DWORD = 0x1,
	// Assume pitch is UINT32 aligned instead of BYTE aligned (used by some legacy DDS files)

	tDDS_FLAGS_NO_LEGACY_EXPANSION = 0x2,
	// Do not implicitly convert legacy formats that result in larger pixel sizes (24 bpp, 3:3:2, A8L8, A4L4, P8, A8P8) 

	tDDS_FLAGS_NO_R10B10G10A2_FIXUP = 0x4,
	// Do not use work-around for long-standing D3DX DDS file format issue which reversed the 10:10:10:2 color order masks

	tDDS_FLAGS_FORCE_RGB = 0x8,
	// Convert DXGI 1.1 BGR formats to tDXGI_FORMAT_R8G8B8A8_UNORM to avoid use of optional WDDM 1.1 formats

	tDDS_FLAGS_NO_16BPP = 0x10,
	// Conversions avoid use of 565, 5551, and 4444 formats and instead expand to 8888 to avoid use of optional WDDM 1.2 formats

	tDDS_FLAGS_EXPAND_LUMINANCE = 0x20,
	// When loading legacy luminance formats expand replicating the color channels rather than leaving them packed (L8, L16, A8L8)

	tDDS_FLAGS_FORCE_DX10_EXT = 0x10000,
	// Always use the 'DX10' header extension for DDS writer (i.e. don't try to write DX9 compatible DDS files)

	tDDS_FLAGS_FORCE_DX10_EXT_MISC2 = 0x20000,
	// tDDS_FLAGS_FORCE_DX10_EXT including miscFlags2 information (result may not be compatible with D3DX10 or D3DX11)
};

enum tTEX_DIMENSION// Subset here matches D3D10_RESOURCE_DIMENSION and D3D11_RESOURCE_DIMENSION
{
	tTEX_DIMENSION_TEXTURE1D = 2,
	tTEX_DIMENSION_TEXTURE2D = 3,
	tTEX_DIMENSION_TEXTURE3D = 4,
};

enum tTEX_MISC_FLAG// Subset here matches D3D10_RESOURCE_MISC_FLAG and D3D11_RESOURCE_MISC_FLAG
{
	tTEX_MISC_TEXTURECUBE = 0x4L,
};

enum tTEX_MISC_FLAG2
{
	tTEX_MISC2_ALPHA_MODE_MASK = 0x7L,
};

enum tTEX_ALPHA_MODE// Matches DDS_ALPHA_MODE, encoded in MISC_FLAGS2
{
	tTEX_ALPHA_MODE_UNKNOWN = 0,
	tTEX_ALPHA_MODE_STRAIGHT = 1,
	tTEX_ALPHA_MODE_PREMULTIPLIED = 2,
	tTEX_ALPHA_MODE_OPAQUE = 3,
	tTEX_ALPHA_MODE_CUSTOM = 4,
};

#define tMAKEFOURCC(ch0, ch1, ch2, ch3)                              \
	((UINT32)(char)(ch0) | ((UINT32)(char)(ch1) << 8) | \
	((UINT32)(char)(ch2) << 16) | ((UINT32)(char)(ch3) << 24))

const tDDS_PIXELFORMAT DDSPF_DXT1 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('D', 'X', 'T', '1'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_DXT2 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('D', 'X', 'T', '2'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_DXT3 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('D', 'X', 'T', '3'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_DXT4 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('D', 'X', 'T', '4'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_DXT5 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('D', 'X', 'T', '5'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_BC4_UNORM =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('B', 'C', '4', 'U'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_BC4_SNORM =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('B', 'C', '4', 'S'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_BC5_UNORM =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('B', 'C', '5', 'U'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_BC5_SNORM =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('B', 'C', '5', 'S'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_R8G8_B8G8 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('R', 'G', 'B', 'G'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_G8R8_G8B8 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('G', 'R', 'G', 'B'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_YUY2 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_FOURCC, tMAKEFOURCC('Y', 'U', 'Y', '2'), 0, 0, 0, 0, 0 };

const tDDS_PIXELFORMAT DDSPF_A8R8G8B8 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_RGBA, 0, 32, 0x00ff0000, 0x0000ff00, 0x000000ff, 0xff000000 };

const tDDS_PIXELFORMAT DDSPF_X8R8G8B8 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 32, 0x00ff0000, 0x0000ff00, 0x000000ff, 0x00000000 };

const tDDS_PIXELFORMAT DDSPF_A8B8G8R8 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_RGBA, 0, 32, 0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000 };

const tDDS_PIXELFORMAT DDSPF_X8B8G8R8 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 32, 0x000000ff, 0x0000ff00, 0x00ff0000, 0x00000000 };

const tDDS_PIXELFORMAT DDSPF_G16R16 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 32, 0x0000ffff, 0xffff0000, 0x00000000, 0x00000000 };

const tDDS_PIXELFORMAT DDSPF_R5G6B5 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 16, 0x0000f800, 0x000007e0, 0x0000001f, 0x00000000 };

const tDDS_PIXELFORMAT DDSPF_A1R5G5B5 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_RGBA, 0, 16, 0x00007c00, 0x000003e0, 0x0000001f, 0x00008000 };

const tDDS_PIXELFORMAT DDSPF_A4R4G4B4 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_RGBA, 0, 16, 0x00000f00, 0x000000f0, 0x0000000f, 0x0000f000 };

const tDDS_PIXELFORMAT DDSPF_R8G8B8 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_RGB, 0, 24, 0x00ff0000, 0x0000ff00, 0x000000ff, 0x00000000 };

const tDDS_PIXELFORMAT DDSPF_L8 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_LUMINANCE, 0, 8, 0xff, 0x00, 0x00, 0x00 };

const tDDS_PIXELFORMAT DDSPF_L16 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_LUMINANCE, 0, 16, 0xffff, 0x0000, 0x0000, 0x0000 };

const tDDS_PIXELFORMAT DDSPF_A8L8 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_LUMINANCEA, 0, 16, 0x00ff, 0x0000, 0x0000, 0xff00 };

const tDDS_PIXELFORMAT DDSPF_A8 =
{ sizeof(tDDS_PIXELFORMAT), tDDS_ALPHA, 0, 8, 0x00, 0x00, 0x00, 0xff };

struct tTexMetadata
{
	int          width;
	int          height;     // Should be 1 for 1D textures
	int          depth;      // Should be 1 for 1D or 2D textures
	int          arraySize;  // For cubemap, this is a multiple of 6
	int          mipLevels;
	unsigned int        miscFlags;
	unsigned int        miscFlags2;
	tDXGI_FORMAT     format;
	tTEX_DIMENSION   dimension;

	int ComputeIndex( int mip, int item, int slice) const;
	bool IsCubemap() const { return (miscFlags & tTEX_MISC_TEXTURECUBE) != 0; }
	bool IsPMAlpha() const { return ((miscFlags2 & tTEX_MISC2_ALPHA_MODE_MASK) == tTEX_ALPHA_MODE_PREMULTIPLIED) != 0; }
	void SetAlphaMode(tTEX_ALPHA_MODE mode) { miscFlags2 = (miscFlags2 & ~tTEX_MISC2_ALPHA_MODE_MASK) | static_cast<unsigned int>(mode); }
	bool IsVolumemap() const { return (dimension == tTEX_DIMENSION_TEXTURE3D); }
};


// Bitmap image container
struct tImage
{
	int      width;
	int      height;
	tDXGI_FORMAT format;
	int      rowPitch;
	int      slicePitch;
	unsigned char*    pixels;
};

class tScratchImage
{
public:
	tScratchImage()
		: _nimages(0), _size(0), _image(0), _memory(0)
	{}
	~tScratchImage() 
	{ 
		Release(); 
	}

	tScratchImage& operator= (tScratchImage&& moveFrom);

	int Initialize(  const tTexMetadata& mdata,   UINT32 flags = tCP_FLAGS_NONE);

	int Initialize1D(  tDXGI_FORMAT fmt,   int length,   int arraySize,   int mipLevels,   UINT32 flags = tCP_FLAGS_NONE);
	int Initialize2D(  tDXGI_FORMAT fmt,   int width,   int height,   int arraySize,   int mipLevels,   UINT32 flags = tCP_FLAGS_NONE);
	int Initialize3D(  tDXGI_FORMAT fmt,   int width,   int height,   int depth,   int mipLevels,   UINT32 flags = tCP_FLAGS_NONE);
	int InitializeCube(  tDXGI_FORMAT fmt,   int width,   int height,   int nCubes,   int mipLevels,   UINT32 flags = tCP_FLAGS_NONE);

	void Release();

	bool OverrideFormat(  tDXGI_FORMAT f);

	const tTexMetadata& GetMetadata() const { return _metadata; }
	const tImage* GetImage(  int mip,   int item,   int slice) const;

	const tImage* GetImages() const { return _image; }
	int GetImageCount() const { return _nimages; }

	unsigned char* GetPixels() const { return _memory; }
	int GetPixelsSize() const { return _size; }

private:
	int				_nimages;
	int				_size;
	tTexMetadata	_metadata;
	tImage*			_image;
	unsigned char*  _memory;

	// Hide copy constructor and assignment operator
	tScratchImage(const tScratchImage&);
	tScratchImage& operator=(const tScratchImage&);
};

bool tIsValid(tDXGI_FORMAT fmt);
bool tIsVideo(tDXGI_FORMAT fmt);
bool tIsPalettized(tDXGI_FORMAT fmt);
bool tIsDepthStencil(tDXGI_FORMAT fmt);
bool tIsCompressed(tDXGI_FORMAT fmt);
bool tIsPacked(tDXGI_FORMAT fmt);
bool tIsPlanar(tDXGI_FORMAT fmt);

int tBitsPerPixel(tDXGI_FORMAT fmt);
void tComputePitch(tDXGI_FORMAT fmt, int width, int height, int& rowPitch, int& slicePitch, unsigned int flags);
bool tDecodeDDSHeader(tDDS_HEADER* pHeader,UINT32 flags, tTexMetadata& metadata, UINT32& convFlags);

int tCountMips(int width, int height);
bool tCalculateMipLevels(int width, int height, int& mipLevels);

int tCountMips3D(int width, int height, int depth);
bool tCalculateMipLevels3D(int width, int height, int depth, int& mipLevels);

#endif