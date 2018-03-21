/*
 * gzio - Lua gzip file I/O module
 *
 * Author: Judge Maygarden
 * Copyright (c) 2007 Judge Maygarden
 *
 */

#ifndef LGZIOLIB_H
#define LGZIOLIB_H

#include "lua.h"

#ifndef GZIO_API
#define GZIO_API	LUA_API
#endif /* GZIO_API */

#define LUA_GZIOLIBNAME   "gzio"
GZIO_API int luaopen_gzio (lua_State *L);

#endif /* LGZIOLIB_H */

