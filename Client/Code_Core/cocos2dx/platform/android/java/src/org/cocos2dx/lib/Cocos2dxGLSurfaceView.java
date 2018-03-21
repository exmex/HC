/****************************************************************************
Copyright (c) 2010-2011 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 ****************************************************************************/
package org.cocos2dx.lib;

import javax.microedition.khronos.egl.EGL10;
import javax.microedition.khronos.egl.EGLConfig;
import javax.microedition.khronos.egl.EGLDisplay;

import android.content.Context;
import android.graphics.PixelFormat;
import android.opengl.GLSurfaceView;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.inputmethod.InputMethodManager;

public class Cocos2dxGLSurfaceView extends GLSurfaceView {
	// ===========================================================
	// Constants
	// ===========================================================

	private static final String TAG = Cocos2dxGLSurfaceView.class.getSimpleName();

	private final static int HANDLER_OPEN_IME_KEYBOARD = 2;
	private final static int HANDLER_CLOSE_IME_KEYBOARD = 3;

	// ===========================================================
	// Fields
	// ===========================================================

	// TODO Static handler -> Potential leak!
	private static Handler sHandler;

	private static Cocos2dxGLSurfaceView mCocos2dxGLSurfaceView;
	private static Cocos2dxTextInputWraper sCocos2dxTextInputWraper;

	private Cocos2dxRenderer mCocos2dxRenderer;
	private Cocos2dxEditText mCocos2dxEditText;

	private int m_desiredRBits = 8;
	private int  m_desiredGBits = 8;
	private int m_desiredBBits = 8;
	private int m_desiredABits = 8;
	private int m_desireBitdepth=24;
	private int m_pixelFormatVal=0;
	
	public static long m_touchTime=0;
	
	// ===========================================================
	// Constructors
	// ===========================================================

	

	public Cocos2dxGLSurfaceView(final Context context, int pixelFormatVal) {
		super(context);
		m_pixelFormatVal = pixelFormatVal;
		
		
	// 	super.setEGLConfigChooser(5, 6, 5, 0, 16, 8); // add this fix android  Stencil buffer is not enabled
	//	super.setEGLConfigChooser(0 , 0, 0, 0, 16, 8);

		
		//public void setEGLConfigChooser (int redSize, int greenSize, int blueSize, int alphaSize, int depthSize, int stencilSize)
		
//		super.setEGLConfigChooser(new EGLConfigChooser() {
//			
//			@Override
//			public EGLConfig chooseConfig(EGL10 egl, EGLDisplay display) {
//				 EGLConfig[]  cfgs = new  EGLConfig[255];
//				 int [] num_config = new int[1];
//				 
//				 
//				if(egl.eglGetConfigs(display, cfgs, 255, num_config))
//				{
//					if(num_config[0] > 0)
//					{
//						EGLConfig preferCfg = null;
//						int max = 0;
//						int []value = new int[1];
//						GLConfigSubet s = new GLConfigSubet();
//						for(int i=0;i<num_config[0];i++)
//						{
//							EGLConfig cfg = cfgs[i];
//					
//							
//							egl.eglGetConfigAttrib(display, cfg, EGL10.EGL_RED_SIZE, value);
//							s.redSize = value[0];
//							egl.eglGetConfigAttrib(display, cfg, EGL10.EGL_GREEN_SIZE, value);
//							s.greenSize = value[0];
//							egl.eglGetConfigAttrib(display, cfg, EGL10.EGL_BLUE_SIZE, value);
//							s.blueSize = value[0];
//							egl.eglGetConfigAttrib(display, cfg, EGL10.EGL_DEPTH_SIZE, value);
//							s.depthSize = value[0];
//							egl.eglGetConfigAttrib(display, cfg, EGL10.EGL_ALPHA_SIZE, value);
//							s.alphaSize = value[0];
//							egl.eglGetConfigAttrib(display, cfg, EGL10.EGL_STENCIL_SIZE, value);
//							s.stencilSize = value[0];
//							
//							Log.i("EGLConfigChooser", s.dump());
//							
//							if(max < s.sum() || preferCfg==null )
//							{
//								Log.i("UPDATE EGLConfig TO",  s.dump());
//								
//								max = s.sum();
//								preferCfg = cfg;
//							}
//							
//							
//						}
//						return preferCfg;
//					}
//				}
//				return null;
//				
//			}
//		});
		
		this.initView();
	}

	public Cocos2dxGLSurfaceView(final Context context, final AttributeSet attrs) {
		super(context, attrs);
		
		this.initView();
	}

	protected void initView() {
		this.setEGLContextClientVersion(2);
		this.setFocusableInTouchMode(true);
		this.setKeepScreenOn(true);

		Cocos2dxGLSurfaceView.mCocos2dxGLSurfaceView = this;
		Cocos2dxGLSurfaceView.sCocos2dxTextInputWraper = new Cocos2dxTextInputWraper(this);

		Cocos2dxGLSurfaceView.sHandler = new Handler() {
			@Override
			public void handleMessage(final Message msg) {
				switch (msg.what) {
					case HANDLER_OPEN_IME_KEYBOARD:
						if (null != Cocos2dxGLSurfaceView.this.mCocos2dxEditText && Cocos2dxGLSurfaceView.this.mCocos2dxEditText.requestFocus()) {
							Cocos2dxGLSurfaceView.this.mCocos2dxEditText.removeTextChangedListener(Cocos2dxGLSurfaceView.sCocos2dxTextInputWraper);
							Cocos2dxGLSurfaceView.this.mCocos2dxEditText.setText("");
							final String text = (String) msg.obj;
							Cocos2dxGLSurfaceView.this.mCocos2dxEditText.append(text);
							Cocos2dxGLSurfaceView.sCocos2dxTextInputWraper.setOriginText(text);
							Cocos2dxGLSurfaceView.this.mCocos2dxEditText.addTextChangedListener(Cocos2dxGLSurfaceView.sCocos2dxTextInputWraper);
							final InputMethodManager imm = (InputMethodManager) Cocos2dxGLSurfaceView.mCocos2dxGLSurfaceView.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
							imm.showSoftInput(Cocos2dxGLSurfaceView.this.mCocos2dxEditText, 0);
							Log.d("GLSurfaceView", "showSoftInput");
						}
						break;

					case HANDLER_CLOSE_IME_KEYBOARD:
						if (null != Cocos2dxGLSurfaceView.this.mCocos2dxEditText) {
							Cocos2dxGLSurfaceView.this.mCocos2dxEditText.removeTextChangedListener(Cocos2dxGLSurfaceView.sCocos2dxTextInputWraper);
							final InputMethodManager imm = (InputMethodManager) Cocos2dxGLSurfaceView.mCocos2dxGLSurfaceView.getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
							imm.hideSoftInputFromWindow(Cocos2dxGLSurfaceView.this.mCocos2dxEditText.getWindowToken(), 0);
							Cocos2dxGLSurfaceView.this.requestFocus();
							Log.d("GLSurfaceView", "HideSoftInput");
						}
						break;
				}
			}
		};
	}

	// ===========================================================
	// Getter & Setter
	// ===========================================================


       public static Cocos2dxGLSurfaceView getInstance() {
	   return mCocos2dxGLSurfaceView;
       }

       public static void queueAccelerometer(final float x, final float y, final float z, final long timestamp) {	
	   mCocos2dxGLSurfaceView.queueEvent(new Runnable() {
		@Override
		    public void run() {
			    Cocos2dxAccelerometer.onSensorChanged(x, y, z, timestamp);
		}
	    });
	}

	public void setCocos2dxRenderer(final Cocos2dxRenderer renderer) {
		this.mCocos2dxRenderer = renderer;

		if (m_pixelFormatVal > 0) {

		    PixelFormat info = new PixelFormat();
		    PixelFormat.getPixelFormatInfo(m_pixelFormatVal, info);

		    if (PixelFormat.formatHasAlpha(m_pixelFormatVal)) {

		        if (info.bitsPerPixel >= 24) {
		            m_desiredABits = 8;
		        } else {
		            m_desiredABits = 6;  // total guess
		        }

		    } else {
		        m_desiredABits = 0;
		    }

		    if (info.bitsPerPixel >= 24) {
		        m_desiredRBits = 8;
		        m_desiredGBits = 8;
		        m_desiredBBits = 8;
		        m_desireBitdepth = 16;
		        getHolder().setFormat(PixelFormat.RGB_888);
		    } else if (info.bitsPerPixel >= 16) {
		        m_desiredRBits = 5;
		        m_desiredGBits = 6;
		        m_desiredRBits = 5;
		        m_desireBitdepth = 16;
		        getHolder().setFormat(PixelFormat.RGB_565);
		    } else {
		        m_desiredRBits = 3;
		        m_desiredGBits = 3;
		        m_desiredBBits = 2;
		        m_desireBitdepth = 8;
		        getHolder().setFormat(PixelFormat.RGB_332);
		    }
		//    m_desireBitdepth = info.bitsPerPixel;
		    Log.i(TAG, "use format r "+m_desiredRBits + " g "+m_desiredGBits + " b "+ m_desiredABits + " a " + m_desiredABits);
		} else {
		    m_desiredRBits = 8;
		    m_desiredGBits = 8;
		    m_desiredBBits = 8;
		    m_desiredABits = 0;
		    m_desireBitdepth = 16;
		    Log.i(TAG, "use default format 8888, and change holder format to RGB_888" );
			getHolder().setFormat(PixelFormat.RGB_888);
		}
		
		
	
		this.setEGLConfigChooser(new ConfigChooser(this.getHolder(), m_desiredRBits,m_desiredGBits,m_desiredBBits,m_desiredABits,m_desireBitdepth,8));
		
		this.setRenderer(this.mCocos2dxRenderer);
	}

	private String getContentText() {
		return this.mCocos2dxRenderer.getContentText();
	}

	public Cocos2dxEditText getCocos2dxEditText() {
		return this.mCocos2dxEditText;
	}

	public void setCocos2dxEditText(final Cocos2dxEditText pCocos2dxEditText) {
		this.mCocos2dxEditText = pCocos2dxEditText;
		if (null != this.mCocos2dxEditText && null != Cocos2dxGLSurfaceView.sCocos2dxTextInputWraper) {
			this.mCocos2dxEditText.setOnEditorActionListener(Cocos2dxGLSurfaceView.sCocos2dxTextInputWraper);
			this.mCocos2dxEditText.setCocos2dxGLSurfaceView(this);
			this.requestFocus();
		}
	}

	// ===========================================================
	// Methods for/from SuperClass/Interfaces
	// ===========================================================

	@Override
	public void onResume() {
		super.onResume();

		this.queueEvent(new Runnable() {
			@Override
			public void run() {
				Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleOnResume();
			}
		});
	}

	@Override
	public void onPause() {
		this.queueEvent(new Runnable() {
			@Override
			public void run() {
				Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleOnPause();
			}
		});

		super.onPause();
	}

	@Override
	public boolean onTouchEvent(final MotionEvent pMotionEvent) {
		// these data are used in ACTION_MOVE and ACTION_CANCEL
		final int pointerNumber = pMotionEvent.getPointerCount();
		final int[] ids = new int[pointerNumber];
		final float[] xs = new float[pointerNumber];
		final float[] ys = new float[pointerNumber];

		for (int i = 0; i < pointerNumber; i++) {
			ids[i] = pMotionEvent.getPointerId(i);
			xs[i] = pMotionEvent.getX(i);
			ys[i] = pMotionEvent.getY(i);
		}
		
		m_touchTime=System.currentTimeMillis();

		switch (pMotionEvent.getAction() & MotionEvent.ACTION_MASK) {
			case MotionEvent.ACTION_POINTER_DOWN:
				final int indexPointerDown = pMotionEvent.getAction() >> MotionEvent.ACTION_POINTER_ID_SHIFT;
				final int idPointerDown = pMotionEvent.getPointerId(indexPointerDown);
				final float xPointerDown = pMotionEvent.getX(indexPointerDown);
				final float yPointerDown = pMotionEvent.getY(indexPointerDown);

				this.queueEvent(new Runnable() {
					@Override
					public void run() {
						Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionDown(idPointerDown, xPointerDown, yPointerDown);
					}
				});
				break;

			case MotionEvent.ACTION_DOWN:
				// there are only one finger on the screen
				final int idDown = pMotionEvent.getPointerId(0);
				final float xDown = xs[0];
				final float yDown = ys[0];

				this.queueEvent(new Runnable() {
					@Override
					public void run() {
						Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionDown(idDown, xDown, yDown);
					}
				});
				break;

			case MotionEvent.ACTION_MOVE:
				this.queueEvent(new Runnable() {
					@Override
					public void run() {
						Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionMove(ids, xs, ys);
					}
				});
				break;

			case MotionEvent.ACTION_POINTER_UP:
				final int indexPointUp = pMotionEvent.getAction() >> MotionEvent.ACTION_POINTER_ID_SHIFT;
				final int idPointerUp = pMotionEvent.getPointerId(indexPointUp);
				final float xPointerUp = pMotionEvent.getX(indexPointUp);
				final float yPointerUp = pMotionEvent.getY(indexPointUp);

				this.queueEvent(new Runnable() {
					@Override
					public void run() {
						Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionUp(idPointerUp, xPointerUp, yPointerUp);
					}
				});
				break;

			case MotionEvent.ACTION_UP:
				// there are only one finger on the screen
				final int idUp = pMotionEvent.getPointerId(0);
				final float xUp = xs[0];
				final float yUp = ys[0];

				this.queueEvent(new Runnable() {
					@Override
					public void run() {
						Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionUp(idUp, xUp, yUp);
					}
				});
				break;

			case MotionEvent.ACTION_CANCEL:
				this.queueEvent(new Runnable() {
					@Override
					public void run() {
						Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionCancel(ids, xs, ys);
					}
				});
				break;
		}

        /*
		if (BuildConfig.DEBUG) {
			Cocos2dxGLSurfaceView.dumpMotionEvent(pMotionEvent);
		}
		*/
		return true;
	}

	/*
	 * This function is called before Cocos2dxRenderer.nativeInit(), so the
	 * width and height is correct.
	 */
	@Override
	protected void onSizeChanged(final int pNewSurfaceWidth, final int pNewSurfaceHeight, final int pOldSurfaceWidth, final int pOldSurfaceHeight) {
		if(!this.isInEditMode()) {
			this.mCocos2dxRenderer.setScreenWidthAndHeight(pNewSurfaceWidth, pNewSurfaceHeight);
		}
	}

	@Override
	public boolean onKeyDown(final int pKeyCode, final KeyEvent pKeyEvent) {
		switch (pKeyCode) {
			case KeyEvent.KEYCODE_BACK:
				//return false;
			case KeyEvent.KEYCODE_MENU:
				this.queueEvent(new Runnable() {
					@Override
					public void run() {
						Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleKeyDown(pKeyCode);
					}
				});
				return true;
			default:
				return super.onKeyDown(pKeyCode, pKeyEvent);
		}
	}

	// ===========================================================
	// Methods
	// ===========================================================

	// ===========================================================
	// Inner and Anonymous Classes
	// ===========================================================

	public static void openIMEKeyboard() {
		final Message msg = new Message();
		msg.what = Cocos2dxGLSurfaceView.HANDLER_OPEN_IME_KEYBOARD;
		msg.obj = Cocos2dxGLSurfaceView.mCocos2dxGLSurfaceView.getContentText();
		Cocos2dxGLSurfaceView.sHandler.sendMessage(msg);
	}

	public static void closeIMEKeyboard() {
		final Message msg = new Message();
		msg.what = Cocos2dxGLSurfaceView.HANDLER_CLOSE_IME_KEYBOARD;
		Cocos2dxGLSurfaceView.sHandler.sendMessage(msg);
	}

	public void insertText(final String pText) {
		this.queueEvent(new Runnable() {
			@Override
			public void run() {
				Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleInsertText(pText);
			}
		});
	}

	public void deleteBackward() {
		this.queueEvent(new Runnable() {
			@Override
			public void run() {
				Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleDeleteBackward();
			}
		});
	}

	private static void dumpMotionEvent(final MotionEvent event) {
		final String names[] = { "DOWN", "UP", "MOVE", "CANCEL", "OUTSIDE", "POINTER_DOWN", "POINTER_UP", "7?", "8?", "9?" };
		final StringBuilder sb = new StringBuilder();
		final int action = event.getAction();
		final int actionCode = action & MotionEvent.ACTION_MASK;
		sb.append("event ACTION_").append(names[actionCode]);
		if (actionCode == MotionEvent.ACTION_POINTER_DOWN || actionCode == MotionEvent.ACTION_POINTER_UP) {
			sb.append("(pid ").append(action >> MotionEvent.ACTION_POINTER_ID_SHIFT);
			sb.append(")");
		}
		sb.append("[");
		for (int i = 0; i < event.getPointerCount(); i++) {
			sb.append("#").append(i);
			sb.append("(pid ").append(event.getPointerId(i));
			sb.append(")=").append((int) event.getX(i));
			sb.append(",").append((int) event.getY(i));
			if (i + 1 < event.getPointerCount()) {
				sb.append(";");
			}
		}
		sb.append("]");
		Log.d(Cocos2dxGLSurfaceView.TAG, sb.toString());
	}
	
	
	  public boolean onTouchEvent2(MotionEvent paramMotionEvent)
	  {
	    int i = paramMotionEvent.getPointerCount();
	    final int[] arrayOfInt = new int[i];
	    final float[] arrayOfFloat1 = new float[i];
	    final float[] arrayOfFloat2 = new float[i];
	    for (int j = 0; j < i; j++)
	    {
	      arrayOfInt[j] = paramMotionEvent.getPointerId(j);
	      arrayOfFloat1[j] = paramMotionEvent.getX(j);
	      arrayOfFloat2[j] = paramMotionEvent.getY(j);
	    }
	    switch (0xFF & paramMotionEvent.getAction())
	    {
		   
	    case MotionEvent.ACTION_POINTER_DOWN:
		      //return true;
		      int i2 = paramMotionEvent.getAction() >> 8;
		      final int i3 = paramMotionEvent.getPointerId(i2);
		      final float f7 = paramMotionEvent.getX(i2);
		      final float f8 = paramMotionEvent.getY(i2);
		      Runnable local5 = new Runnable()
		      {
		        public void run()
		        {
		          Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionDown(i3, f7, f8);
		        }
		      };
		      queueEvent(local5);

	    case MotionEvent.ACTION_DOWN:
	    	
		      final int i1 = paramMotionEvent.getPointerId(0);
		      final float f5 = arrayOfFloat1[0];
		      final float f6 = arrayOfFloat2[0];
		      Runnable local6 = new Runnable()
		      {
		        public void run()
		        {
		          Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionDown(i1, f5, f6);
		        }
		      };
		      queueEvent(local6);

	    case MotionEvent.ACTION_MOVE:
		      Runnable local7 = new Runnable()
		      {
		        public void run()
		        {
		          Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionMove(arrayOfInt, arrayOfFloat1, arrayOfFloat2);
		        }
		      };
		      queueEvent(local7);

	    case MotionEvent.ACTION_POINTER_UP:
		      int m = paramMotionEvent.getAction() >> 8;
		      final int n = paramMotionEvent.getPointerId(m);
		      final float f3 = paramMotionEvent.getX(m);
		      final float f4 = paramMotionEvent.getY(m);
		      Runnable local8 = new Runnable()
		      {
		        public void run()
		        {
		          Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionUp(n, f3, f4);
		        }
		      };
		      queueEvent(local8);

		case MotionEvent.ACTION_UP:
			
		      final int k = paramMotionEvent.getPointerId(0);
		      final float f1 = arrayOfFloat1[0];
		      final float f2 = arrayOfFloat2[0];
		      Runnable local9 = new Runnable()
		      {
		        public void run()
		        {
		          Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionUp(k, f1, f2);
		        }
		      };
		      queueEvent(local9);

		case MotionEvent.ACTION_CANCEL:
		      Runnable local10 = new Runnable()
		      {
		        public void run()
		        {
		          Cocos2dxGLSurfaceView.this.mCocos2dxRenderer.handleActionCancel(arrayOfInt, arrayOfFloat1, arrayOfFloat2);
		        }
		      };
		      queueEvent(local10);
	    }
	  
	    return true;
	  }	
}
