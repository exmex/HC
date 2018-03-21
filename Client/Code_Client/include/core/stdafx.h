

//////////////////////////////////////////////////////////////////////////

#if defined(WIN32) && defined(_DEBUG) && defined(_CHECK_MEMORY)
	#define _CRTDBG_MAP_ALLOC
	//#define _CRTDBG_MAP_ALLOC_NEW
	//#include <stdlib.h>
	#include <crtdbg.h>

	#ifndef DBG_NEW
		#define DBG_NEW new ( _NORMAL_BLOCK , __FILE__ , __LINE__ )
		#define new DBG_NEW
	#endif

	#define WM_DEBUG _CrtSetDbgFlag ( _CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF );
	#define WM_DEBUG_TEST {void* p = malloc(10u);}
	#define WM_NEW_TEST {int* pi = new int();}
#else
	#define WM_DEBUG 
	#define WM_DEBUG_TEST
	#define WM_NEW_TEST
#endif

//////////////////////////////////////////////////////////////////////////


