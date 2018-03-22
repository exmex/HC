#include "DDSLoaderHelp.h"

void tDetermineImageArray( const tTexMetadata& metadata, UINT32 cpFlags,int& nImages, int& pixelSize )
{
    int _pixelSize = 0;
    int _nimages = 0;

    switch( metadata.dimension )
    {
    case tTEX_DIMENSION_TEXTURE1D:
    case tTEX_DIMENSION_TEXTURE2D:
        for( int item = 0; item < metadata.arraySize; ++item )
        {
            int w = metadata.width;
            int h = metadata.height;

            for( int level=0; level < metadata.mipLevels; ++level )
            {
                int rowPitch, slicePitch;
                tComputePitch( metadata.format, w, h, rowPitch, slicePitch, cpFlags );

                _pixelSize += slicePitch;
                ++_nimages;

                if ( h > 1 )
                    h >>= 1;

                if ( w > 1 )
                    w >>= 1;
            }
        }
        break;

    case tTEX_DIMENSION_TEXTURE3D:
        {
            int w = metadata.width;
            int h = metadata.height;
            int d = metadata.depth;

            for( int level=0; level < metadata.mipLevels; ++level )
            {
                int rowPitch, slicePitch;
                tComputePitch( metadata.format, w, h, rowPitch, slicePitch, cpFlags );

                for( int slice=0; slice < d; ++slice )
                {
                    _pixelSize += slicePitch;
                    ++_nimages;
                }

                if ( h > 1 )
                    h >>= 1;

                if ( w > 1 )
                    w >>= 1;

                if ( d > 1 )
                    d >>= 1;
            }
        }
        break;

    default:
        break;
    }
    nImages = _nimages;
    pixelSize = _pixelSize;
}


bool tSetupImageArray( unsigned char *pMemory, int pixelSize,const tTexMetadata& metadata, UINT32 cpFlags,tImage* images, int nImages )
{

    if ( !images )
        return false;

    int index = 0;
    unsigned char* pixels = pMemory;
    const unsigned char* pEndBits = pMemory + pixelSize;

    switch( metadata.dimension )
    {
    case tTEX_DIMENSION_TEXTURE1D:
    case tTEX_DIMENSION_TEXTURE2D:
        if (metadata.arraySize == 0 || metadata.mipLevels == 0)
        {
            return false;
        }

        for( int item = 0; item < metadata.arraySize; ++item )
        {
            int w = metadata.width;
            int h = metadata.height;

            for( int level=0; level < metadata.mipLevels; ++level )
            {
                if ( index >= nImages )
                {
                    return false;
                }

                int rowPitch, slicePitch;
                tComputePitch( metadata.format, w, h, rowPitch, slicePitch, cpFlags );

                images[index].width = w;
                images[index].height = h;
                images[index].format = metadata.format;
                images[index].rowPitch = rowPitch;
                images[index].slicePitch = slicePitch;
                images[index].pixels = pixels;
                ++index;

                pixels += slicePitch;
                if ( pixels > pEndBits )
                {
                    return false;
                }
            
                if ( h > 1 )
                    h >>= 1;

                if ( w > 1 )
                    w >>= 1;
            }
        }
        return true;

    case tTEX_DIMENSION_TEXTURE3D:
        {
            if (metadata.mipLevels == 0 || metadata.depth == 0)
            {
                return false;
            }

            int w = metadata.width;
            int h = metadata.height;
            int d = metadata.depth;

            for( int level=0; level < metadata.mipLevels; ++level )
            {
                int rowPitch, slicePitch;
                tComputePitch( metadata.format, w, h, rowPitch, slicePitch, cpFlags );

                for( int slice=0; slice < d; ++slice )
                {
                    if ( index >= nImages )
                    {
                        return false;
                    }

                    // We use the same memory organization that Direct3D 11 needs for D3D11_SUBRESOURCE_DATA
                    // with all slices of a given miplevel being continuous in memory
                    images[index].width = w;
                    images[index].height = h;
                    images[index].format = metadata.format;
                    images[index].rowPitch = rowPitch;
                    images[index].slicePitch = slicePitch;
                    images[index].pixels = pixels;
                    ++index;

                    pixels += slicePitch;
                    if ( pixels > pEndBits )
                    {
                        return false;
                    }
                }
            
                if ( h > 1 )
                    h >>= 1;

                if ( w > 1 )
                    w >>= 1;

                if ( d > 1 )
                    d >>= 1;
            }
        }
        return true;

    default:
        return false;
    }
}

tScratchImage& tScratchImage::operator= (tScratchImage&& moveFrom)
{
    if ( this != &moveFrom )
    {
        Release();

        _nimages = moveFrom._nimages;
        _size = moveFrom._size;
        _metadata = moveFrom._metadata;
        _image = moveFrom._image;
        _memory = moveFrom._memory;

        moveFrom._nimages = 0;
        moveFrom._size = 0;
        moveFrom._image = nullptr;
        moveFrom._memory = nullptr;
    }
    return *this;
}

int tScratchImage::Initialize( const tTexMetadata& mdata, UINT32 flags )
{
    int mipLevels = mdata.mipLevels;

    switch( mdata.dimension )
    {
    case tTEX_DIMENSION_TEXTURE1D:
        if ( !mdata.width || mdata.height != 1 || mdata.depth != 1 || !mdata.arraySize )
            return false;

        if ( tIsVideo(mdata.format) )
            return false;

        if ( !tCalculateMipLevels(mdata.width,1,mipLevels) )
            return false;
        break;

    case tTEX_DIMENSION_TEXTURE2D:
        if ( !mdata.width || !mdata.height || mdata.depth != 1 || !mdata.arraySize )
            return false;

        if ( mdata.IsCubemap() )
        {
            if ( (mdata.arraySize % 6) != 0 )
                return false;

            if ( tIsVideo(mdata.format) )
                return false;
        }

        if ( !tCalculateMipLevels(mdata.width,mdata.height,mipLevels) )
            return false;
        break;

    case tTEX_DIMENSION_TEXTURE3D:
        if ( !mdata.width || !mdata.height || !mdata.depth || mdata.arraySize != 1 )
            return false;
        
        if ( tIsVideo(mdata.format) || tIsPlanar(mdata.format) || tIsDepthStencil(mdata.format) )
            return false;

        if ( !tCalculateMipLevels3D(mdata.width,mdata.height,mdata.depth,mipLevels) )
            return false;
        break;

    default:
        return false;
    }

    Release();

    _metadata.width = mdata.width;
    _metadata.height = mdata.height;
    _metadata.depth = mdata.depth;
    _metadata.arraySize = mdata.arraySize;
    _metadata.mipLevels = mipLevels;
    _metadata.miscFlags = mdata.miscFlags;
    _metadata.miscFlags2 = mdata.miscFlags2;
    _metadata.format = mdata.format;
    _metadata.dimension = mdata.dimension;

    int pixelSize, nimages;
    tDetermineImageArray( _metadata, flags, nimages, pixelSize );

    _image = new tImage[ nimages ];
    if ( !_image )
        return false;

    _nimages = nimages;
    memset( _image, 0, sizeof(tImage) * nimages );

    _memory = reinterpret_cast<unsigned char*>( _aligned_malloc( pixelSize, 16 ) );
    if ( !_memory )
    {
        Release();
		return false;
    }
    _size = pixelSize;
    if ( !tSetupImageArray( _memory, pixelSize, _metadata, flags, _image, nimages ) )
    {
        Release();
		return false;
    }

    return true;
}


int tScratchImage::Initialize1D( tDXGI_FORMAT fmt, int length, int arraySize, int mipLevels, UINT32 flags )
{
    if ( !length || !arraySize )
        return false;

    if ( tIsVideo(fmt) )
        return false;

    // 1D is a special case of the 2D case
    int hr = Initialize2D( fmt, length, 1, arraySize, mipLevels, flags );
    if (!hr)
        return hr;

    _metadata.dimension = tTEX_DIMENSION_TEXTURE1D;

    return true;
}


int tScratchImage::Initialize2D( tDXGI_FORMAT fmt, int width, int height, int arraySize, int mipLevels, UINT32 flags )
{
    if ( !tIsValid(fmt) || !width || !height || !arraySize )
        return false;

    if ( tIsPalettized(fmt) )
        return false;

    if ( !tCalculateMipLevels(width,height,mipLevels) )
        return false;

    Release();

    _metadata.width = width;
    _metadata.height = height;
    _metadata.depth = 1;
    _metadata.arraySize = arraySize;
    _metadata.mipLevels = mipLevels;
    _metadata.miscFlags = 0;
    _metadata.miscFlags2 = 0;
    _metadata.format = fmt;
    _metadata.dimension = tTEX_DIMENSION_TEXTURE2D;

    int pixelSize, nimages;
    tDetermineImageArray( _metadata, flags, nimages, pixelSize );

    _image = new (std::nothrow) tImage[ nimages ];
    if ( !_image )
        return false;

    _nimages = nimages;
    memset( _image, 0, sizeof(tImage) * nimages );

    _memory = reinterpret_cast<unsigned char*>( _aligned_malloc( pixelSize, 16 ) );
    if ( !_memory )
    {
        Release();
        return false;
    }
    _size = pixelSize;
    if ( !tSetupImageArray( _memory, pixelSize, _metadata, flags, _image, nimages ) )
    {
        Release();
        return false;
    }

    return true;
}

int tScratchImage::Initialize3D( tDXGI_FORMAT fmt, int width, int height, int depth, int mipLevels, UINT32 flags )
{
    if ( !tIsValid(fmt) || !width || !height || !depth )
        return false;

    if ( tIsVideo(fmt) || tIsPlanar(fmt) || tIsDepthStencil(fmt) )
        return false;

    if ( !tCalculateMipLevels3D(width,height,depth,mipLevels) )
        return false;

    Release();

    _metadata.width = width;
    _metadata.height = height;
    _metadata.depth = depth;
    _metadata.arraySize = 1;    // Direct3D 10.x/11 does not support arrays of 3D textures
    _metadata.mipLevels = mipLevels;
    _metadata.miscFlags = 0;
    _metadata.miscFlags2 = 0;
    _metadata.format = fmt;
    _metadata.dimension = tTEX_DIMENSION_TEXTURE3D;

    int pixelSize, nimages;
    tDetermineImageArray( _metadata, flags, nimages, pixelSize );

    _image = new (std::nothrow) tImage[ nimages ];
    if ( !_image )
    {
        Release();
        return false;
    }
    _nimages = nimages;
    memset( _image, 0, sizeof(tImage) * nimages );

    _memory = reinterpret_cast<unsigned char*>( _aligned_malloc( pixelSize, 16 ) );
    if ( !_memory )
    {
        Release();
        return false;
    }
    _size = pixelSize;

    if ( !tSetupImageArray( _memory, pixelSize, _metadata, flags, _image, nimages ) )
    {
        Release();
        return false;
    }

    return true;
}

int tScratchImage::InitializeCube( tDXGI_FORMAT fmt, int width, int height, int nCubes, int mipLevels, UINT32 flags )
{
    if ( !width || !height || !nCubes )
        return false;

    if ( tIsVideo(fmt) )
        return false;
    
    // A DirectX11 cubemap is just a 2D texture array that is a multiple of 6 for each cube
    int hr = Initialize2D( fmt, width, height, nCubes * 6, mipLevels, flags );
	if (!hr)
        return hr;

    _metadata.miscFlags |= tTEX_MISC_TEXTURECUBE;

    return true;
}

void tScratchImage::Release()
{
    _nimages = 0;
    _size = 0;

    if ( _image )
    {
        delete [] _image;
        _image = 0;
    }

    if ( _memory )
    {
        _aligned_free( _memory );
        _memory = 0;
    }
    
    memset(&_metadata, 0, sizeof(_metadata));
}

bool tScratchImage::OverrideFormat( tDXGI_FORMAT f )
{
    if ( !_image )
        return false;

    if ( !tIsValid( f ) || tIsPlanar( f ) || tIsPalettized( f ) )
        return false;

    if ( ( tBitsPerPixel( f ) != tBitsPerPixel( _metadata.format ) )
         || ( tIsCompressed( f ) != tIsCompressed( _metadata.format ) )
         || ( tIsPacked( f ) != tIsPacked( _metadata.format ) )
         || ( tIsVideo( f ) != tIsVideo( _metadata.format ) ) )
    {
         // Can't change the effective pitch of the format this way
         return false;
    }

    for( int index = 0; index < _nimages; ++index )
    {
        _image[ index ].format = f;
    }

    _metadata.format = f;

    return true;
}

const tImage* tScratchImage::GetImage(int mip, int item, int slice) const
{
    if ( mip >= _metadata.mipLevels )
        return nullptr;

    int index = 0;

    switch( _metadata.dimension )
    {
    case tTEX_DIMENSION_TEXTURE1D:
    case tTEX_DIMENSION_TEXTURE2D:
        if ( slice > 0 )
            return nullptr;

        if ( item >= _metadata.arraySize )
            return nullptr;

        index = item*( _metadata.mipLevels ) + mip;
        break;

    case tTEX_DIMENSION_TEXTURE3D:
        if ( item > 0 )
        {
            // No support for arrays of volumes
            return nullptr;
        }
        else
        {
            int d = _metadata.depth;

            for( int level = 0; level < mip; ++level )
            {
                index += d;
                if ( d > 1 )
                    d >>= 1;
            }

            if ( slice >= d )
                return nullptr;

            index += slice;
        }
        break;

    default:
        return nullptr;
    }
 
    return &_image[index];
}

