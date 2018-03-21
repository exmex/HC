#pragma once
#include <Windows.h>
/*  注意，InputBox函数是C++语法，只能用于C++，不能用于C */

/********************************************/
/*       InputBox.h                         */
/********************************************/
BOOL _InitInputBox(HWND hParent);          // 可选，不过在调用InputBox函数之前最好调用一下该函数，
// 该函数是初始化InputBox,主要就是传入一个父窗口句柄。
void _SetNumber(BOOL fIsNumber);           // 可选，该函数是设置Edit只能输入数字
void _SetLowerCase(BOOL fIsLowerCase);     // 可选，该函数是设置Edit只能输入小写字母
void _SetUpperCase(BOOL fIsUpperCase);     // 可选，该函数是设置Edit只能输入大写字母
void _SetMaxLine(unsigned int nLineSize);  // 可选，该函数是设置Edit可以输入最大字符数，默认最大是256个字符，不能超过这个数。

/*********************************************************/
/*                InputBox函数                           */
/*  lpWndMsg     ; 必选参数，用于提示用户                 */
/*  lpWndTitle   ; 可选参数, 设置对话框默认标题           */
/*  lpDefValue   ; 可选参数，设置Edit默认值               */
/*  xPos         ; 可选参数，如果为零则居中窗口            */
/*  yPos         ; 可选参数，如果为零则居中窗口            */
/*  lpHelpFile   ; 可选参数，打开*.hlp帮助文件             */
/*  nHelpIndex   ; 可选参数，但如果设置了lpHelpFile参数，  */
/*               ; 这个参数就是Help文件的索引              */
/*  如果函数成功，返回一个char *指针，包含用户输入的内容     */
/*********************************************************/
wchar_t *_InputBox(wchar_t *lpWndMsg,
	wchar_t *lpWndTitle = L"工程!",
	wchar_t *lpDefValue = L"",
	int xPos = 0,
	int yPos = 0,
	wchar_t *lpHelpFile = L"",
	int nHelpIndex = 0);

#define InputBox     _InputBox
#define SetNumber    _SetNumber
#define InitInputBox _InitInputBox
#define SetLowerCase _SetLowerCase
#define SetUpperCase _SetUpperCase
#define SetMaxLine   _SetMaxLine
