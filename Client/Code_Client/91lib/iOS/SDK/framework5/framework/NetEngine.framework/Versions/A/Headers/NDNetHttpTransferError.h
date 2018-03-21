/*
 *  NetHttpTransferErro.h
 *  NetEngine
 *
 *  Created by Ｓie Kensou on 4/29/10.
 *  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
 *
 */

/*!
 Error Number
 */

#define ND_NET_HTTP_TRANSFER_ERROR_NONE				0				/**< no error occured */
#define ND_NET_HTTP_TRANSFER_ERROR					-1				/**< an error occured */
#define ND_NET_HTTP_TRANSFER_ERROR_PARAM			-2				/**< an error occured, may be something wrong with your params */
#define ND_NET_HTTP_TRANSFER_ERROR_MEMORY			-3				/**< an error occured, memory not enough, or alloc failed */
#define ND_NET_HTTP_TRANSFER_ERROR_FILE				-4				/**< an error occured, file access right not enough or create failed */
#define ND_NET_HTTP_TRANSFER_ERROR_UNKNOWN			-5				/**< an error occured, and we don't know what happened */
