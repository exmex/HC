package org.cocos2dx.lib;

import android.R.integer;
import android.graphics.PixelFormat;
import android.opengl.GLSurfaceView.EGLConfigChooser;
import android.view.SurfaceHolder;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLDisplay;

final class ConfigChooser
  implements EGLConfigChooser
{
  private static int g = 4;
  private static int[] h;
  protected int _redSize;
  protected int _greenSize;
  protected int _blueSize;
  protected int _alphaSize;
  protected int _depthSize;
  protected int _stencilSize;
  private final int[] i = new int[1];
  private SurfaceHolder _holder;
  static
  {
    int[] arrayOfInt = new int[9];
    arrayOfInt[0] = EGL10.EGL_RED_SIZE;
    arrayOfInt[1] = 4;
    arrayOfInt[2] = EGL10.EGL_GREEN_SIZE;
    arrayOfInt[3] = 4;
    arrayOfInt[4] = EGL10.EGL_BLUE_SIZE;
    arrayOfInt[5] = 4;
    arrayOfInt[6] = EGL10.EGL_RENDERABLE_TYPE;
    arrayOfInt[7] = g;
    arrayOfInt[8] = EGL10.EGL_NONE;
    h = arrayOfInt;
  }
  
  
	class GLConfigSubet
	{
		public int redSize;
		public int greenSize;
		public int blueSize;
		public int alphaSize;
		public int depthSize;
		public int stencilSize;
		
		public String dump()
		{
			return "red: " + redSize + " green: " + greenSize + " blue: " + blueSize + " alpha: " + alphaSize + " depth: "+ depthSize + " stencel: " + stencilSize + " sum: "+sum();
		}
		
		public int sum()
		{
			int sum =  redSize+ greenSize + blueSize + alphaSize+ depthSize + stencilSize;
			if(stencilSize ==8 )
			{
				sum += 100000;
			}
			return sum;
		}
	}
	
  public ConfigChooser(SurfaceHolder holder, int paramInt1, int paramInt2, int paramInt3, int paramInt4, int paramInt5, int paramInt6)
  {
    this._redSize = paramInt1;
    this._greenSize = paramInt2;
    this._blueSize = paramInt3;
    this._alphaSize = paramInt4;
    this._depthSize = paramInt5;
    this._stencilSize = paramInt6;
    this._holder = holder;
  }
  
  private int getGlConfigAttrib(EGL10 paramEGL10, EGLDisplay paramEGLDisplay, EGLConfig paramEGLConfig, int paramInt)
  {
    int j = 0;
    if (paramEGL10.eglGetConfigAttrib(paramEGLDisplay, paramEGLConfig, paramInt, this.i)) {
      j = this.i[j];
    }
    return j;
  }
  
  private EGLConfig pickConfig(EGL10 egl, EGLDisplay display, EGLConfig[] paramArrayOfEGLConfig)
  {
	  //from coc
//	  Object localObject1 = null;
//	    int j = 268435455;
//	    int k = paramArrayOfEGLConfig.length;
//	    int m = 0;
//	    EGLConfig localEGLConfig2;
//	    int i13;
//	    if (m < k)
//	    {
//	      localEGLConfig2 = paramArrayOfEGLConfig[m];
//	      int i11 = a(paramEGL10, paramEGLDisplay, localEGLConfig2, EGL10.EGL_DEPTH_SIZE);
//	      int i12 = a(paramEGL10, paramEGLDisplay, localEGLConfig2, EGL10.EGL_STENCIL_SIZE);
//	      if ((i11 < this.e) || (i12 < this.f)) {
//	        break label440;
//	      }
//	      int i14 = a(paramEGL10, paramEGLDisplay, localEGLConfig2, EGL10.EGL_RED_SIZE);
//	      int i15 = a(paramEGL10, paramEGLDisplay, localEGLConfig2, EGL10.EGL_GREEN_SIZE);
//	      int i16 = a(paramEGL10, paramEGLDisplay, localEGLConfig2, EGL10.EGL_BLUE_SIZE);
//	      int i17 = a(paramEGL10, paramEGLDisplay, localEGLConfig2, EGL10.EGL_ALPHA_SIZE);
//	      if ((i14 != this.a) || (i15 != this.b) || (i16 != this.c) || (i17 != this.d)) {
//	        break label440;
//	      }
//	      i13 = a(paramEGL10, paramEGLDisplay, localEGLConfig2, EGL10.EGL_SAMPLE_BUFFERS);
//	      if (i13 == 0)
//	      {
//	        localObject1 = localEGLConfig2;
//	        label181:
//	        return localObject1;
//	      }
//	      if (i13 >= j) {
//	        break label440;
//	      }
//	    }
//	    for (Object localObject3 = localEGLConfig2;; localObject3 = localObject1)
//	    {
//	      m++;
//	      localObject1 = localObject3;
//	      j = i13;
//	      break;
//	      if (localObject1 != null) {
//	        break label181;
//	      }
//	      int n = 2147483647;
//	      int i1 = paramArrayOfEGLConfig.length;
//	      int i2 = 0;
//	      label225:
//	      EGLConfig localEGLConfig1;
//	      int i10;
//	      if (i2 < i1)
//	      {
//	        localEGLConfig1 = paramArrayOfEGLConfig[i2];
//	        int i3 = a(paramEGL10, paramEGLDisplay, localEGLConfig1, EGL10.EGL_DEPTH_SIZE) - this.e;
//	        int i4 = a(paramEGL10, paramEGLDisplay, localEGLConfig1, EGL10.EGL_STENCIL_SIZE) - this.f;
//	        int i5 = a(paramEGL10, paramEGLDisplay, localEGLConfig1, EGL10.EGL_RED_SIZE) - this.a;
//	        int i6 = a(paramEGL10, paramEGLDisplay, localEGLConfig1, EGL10.EGL_GREEN_SIZE) - this.b;
//	        int i7 = a(paramEGL10, paramEGLDisplay, localEGLConfig1, EGL10.EGL_BLUE_SIZE) - this.c;
//	        int i8 = a(paramEGL10, paramEGLDisplay, localEGLConfig1, EGL10.EGL_ALPHA_SIZE) - this.d;
//	        int i9 = 0 + a(paramEGL10, paramEGLDisplay, localEGLConfig1, EGL10.EGL_SAMPLE_BUFFERS);
//	        i10 = i3 * i3 + i4 * i4 + i5 * i5 + i6 * i6 + i7 * i7 + i8 * i8 + i9 * i9;
//	        if (i10 >= n) {
//	          break label429;
//	        }
//	      }
//	      for (Object localObject2 = localEGLConfig1;; localObject2 = localObject1)
//	      {
//	        i2++;
//	        localObject1 = localObject2;
//	        n = i10;
//	        break label225;
//	        break;
//	        label429:
//	        i10 = n;
//	      }
//	      label440:
//	      i13 = j;
//	    }


	  
		EGLConfig preferCfg = null;
		int n = Integer.MAX_VALUE;
		 GLConfigSubet preferCs=new GLConfigSubet();
		for(int i=0;i<paramArrayOfEGLConfig.length;i++)
		{
		  EGLConfig cfg = paramArrayOfEGLConfig[i];
		  
          int i3 = getGlConfigAttrib(egl, display, cfg, EGL10.EGL_DEPTH_SIZE) - this._depthSize;
          int i4 = getGlConfigAttrib(egl, display, cfg,  EGL10.EGL_STENCIL_SIZE) - this._stencilSize;
          
          int i5 = getGlConfigAttrib(egl, display, cfg,  EGL10.EGL_RED_SIZE) - this._redSize;
          int i6 = getGlConfigAttrib(egl, display, cfg,  EGL10.EGL_GREEN_SIZE) - this._greenSize;
          int i7 = getGlConfigAttrib(egl, display, cfg,  EGL10.EGL_BLUE_SIZE) - this._blueSize;
          int i8 = getGlConfigAttrib(egl, display, cfg,  EGL10.EGL_ALPHA_SIZE) - this._alphaSize;
          int i9 = 0 +  getGlConfigAttrib(egl, display, cfg,  EGL10.EGL_SAMPLE_BUFFERS);
          
          if(i3>=0 && i4>=0 && i5==0 && i6==0 && i7==0 && i8==0 && i9==0)
          {
        	  return cfg;
          }
          
          int i10 = i3 * i3 + i4 * i4 + i5 * i5 + i6 * i6 + i7 * i7 + i8 * i8 + i9 * i9;
          if (i10 < n) {
        	  n = i10;
        	  preferCfg = cfg;
        	  preferCs.redSize = i5;
        	  preferCs.greenSize = i6;
        	  preferCs.blueSize = i7;
        	  preferCs.alphaSize = i8;
        	  preferCs.depthSize = i3;
        	  preferCs.stencilSize = i4;
          }

			
		}
		
		
		if(preferCfg!=null)
		{
			if(preferCs.redSize==8 && preferCs.greenSize==8 && preferCs.blueSize==8 && preferCs.alphaSize==8)
			{
				this._holder.setFormat(PixelFormat.RGBA_8888);
			}
			else if(preferCs.redSize==8 && preferCs.greenSize==8 && preferCs.blueSize==8)
			{
				this._holder.setFormat(PixelFormat.RGB_888);
			}
			else if(preferCs.redSize==5 && preferCs.greenSize==6 && preferCs.blueSize==5)
			{
				this._holder.setFormat(PixelFormat.RGB_565);
			}
			else  if(preferCs.redSize==4 && preferCs.greenSize==4 && preferCs.blueSize==4 && preferCs.alphaSize==4)
			{
				this._holder.setFormat(PixelFormat.RGBA_4444);
			}
			else  if(preferCs.redSize==5 && preferCs.greenSize==5 && preferCs.blueSize==5 && preferCs.alphaSize==1)
			{
				this._holder.setFormat(PixelFormat.RGBA_5551);
			}
			
		}
		
		
		return preferCfg;
  }
  
  public final EGLConfig chooseConfig(EGL10 paramEGL10, EGLDisplay paramEGLDisplay)
  {
    int[] arrayOfInt = new int[1];
    paramEGL10.eglChooseConfig(paramEGLDisplay, h, null, 0, arrayOfInt);
    int j = arrayOfInt[0];
    if (j <= 0) {
      throw new IllegalArgumentException("No configs match configSpec");
    }
    EGLConfig[] arrayOfEGLConfig = new EGLConfig[j];
    paramEGL10.eglChooseConfig(paramEGLDisplay, h, arrayOfEGLConfig, j, arrayOfInt);
    EGLConfig preferCfg= pickConfig(paramEGL10, paramEGLDisplay, arrayOfEGLConfig);
   
    
    return preferCfg;
  }
}

