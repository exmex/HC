//
//  NDNetHttpTransferClient.h
//  NetEngine
//
//  Created by Ｓie Kensou on 4/29/10.
//  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSURLConnection.h>

@protocol NetHttpTransferClientDelegate;

/*!
 NDNetHttpTransferClient Class. A simple client object working for http requests.
 */
@interface NDNetHttpTransferClient : NSObject {
	NSURLConnection*			m_urlConnection;			/**< connection handle request */
	NSMutableData*				m_data;						/**< data used to receive data from server */
	NSFileHandle*				m_fileHandle;				/**< file handle, write data from server to local file */
	NSInputStream*				m_fileDataStream;			/**< file data stream, use for post a file */
	float						m_timeout;					
	long long					m_expectLength;				
	long long					m_receivedLength;			/**< the length of data we have get */
	NSURLRequestCachePolicy		m_cachePolicy;				
	BOOL						m_allowOverWrite;			/**< if NO, the fileName will be truncated to zero if the fileName has been existed;if YES, download will be started from the size of fileName*/

	id							m_clientDelegate;			
	unsigned long				m_clientID;					
	int							m_tag;						
	BOOL						m_acceptGZip;				/**< whether to accept gzip content,default YES */
	BOOL						m_isGZipReceived;			/**< whether the data we received is gziped */
	int							m_responseCode;				/**< the response code in http request */
	NSString					*m_suggestFileNameByServer;    
    NSString                    *m_responseContentTypeString;
	BOOL						m_halfEncode;
    
    int                         m_autoRetryCount;
    float                       m_autoRetryInterval;
    
    NSMutableDictionary         *m_autoRetryDict;
}

@property float timeout;									/**< request time out value, please set before you send the request */
@property (nonatomic, readonly) long long expectLength;		/**< length we expected to receive from server, it's returned by server */
@property (nonatomic, assign) id clientDelegate;			/**< the recevier to receive some call back */
@property (nonatomic, assign) NSURLRequestCachePolicy	cachePolicy;	/**< request cache policy, default use protocol cache policy */
@property (nonatomic, assign) unsigned long clientID;		/**< every client has an client id, allocate by NetHttpTransfer */
@property (nonatomic, assign) int tag;						/**< user defined tag */
@property (nonatomic, retain, readonly) NSMutableData		*data;
@property (nonatomic, readonly) int	responseCode;			/**< the last http response code */
@property (nonatomic, retain, readonly) NSString *suggestFileName;	/**< server returned suggestFileName */
@property (nonatomic, retain, readonly) NSString *contentTypeString;    /** http response content type */
@property (nonatomic, assign) BOOL halfEncode;				/**< 熊猫看书提出的不完全Encode方式,对传入的空格以及汉字进行URLEncode，其他的不处理；默认为NO */

@property (nonatomic, assign) int autoRetry;
@property (nonatomic, assign) float autoRetryInterval;
/*!
 @param delegate	the receiver of some call back
 @result an client object.
 */
- (id)initWithDelegate:(id)delegate;				
/*!
 @param acceptGZip	whether to accept gzip content from server
 */
- (void)enableGZipAccept:(BOOL)acceptGZip;
/*!
 using get method, download a file.Default gzip accept is enabled.
 @param urlString	the server url
 @param fileName	the file name for download
 @param overWrite	if NO, the fileName will be truncated to zero if the fileName has been existed;if YES, download will be started from the size of fileName
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR
 */
- (int)getFile:(NSString*)urlString fileName:(NSString*)fileName allowOverWrite:(BOOL)overWrite;

/*!
 download some data in memory.Default gzip accept is enabled.
 @param urlString	the server url
 @param data		the data for download, if data nil, we'll create one for you.
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR 
 */
- (int)getData:(NSString*)urlString data:(NSMutableData*)data;
/*!
 download some data in memory.Default gzip accept is enabled.
 This interface need not pass in the data to accept,an data buffer will be created automatically for you.
 use getConnectionData: to get the data accepted.
 e.g. 
 
 - (void)transferDidFinishLoading:(NDNetHttpTransferIDRef)connection
 {
 NSData *data = [[NDNetHttpTransfer sharedTransfer] getConnectionData:connection];
 if (data != nil)
 // do your work
 }
 
 @param urlString	the server url
 @param data		the data for download, if data nil, we'll create one for you.
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR 
 */
- (int)getData:(NSString *)urlString;
/*!
 post a file to server.
 @param urlString	the server url
 @param fileToPost	the file used to post
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR 
 */
- (int)postFile:(NSString*)urlString fileToPost:(NSString*)fileToPost;
/*!
 create an request, using post method, post a file to server.
 @param urlString	the server url
 @param dataToPost	the data used to post
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR 
 */
- (int)postData:(NSString*)urlString dataToPost:(NSData*)dataToPost;

/*!
 post data to server,than download a file using get method
 @param urlString	the server url
 @param dataToPost	the data used to post
 @param fileName	the file name for download
 @param overWrite	if YES, the fileName will be truncated to zero if the fileName has been existed;if NO, download will be started from the size of fileName
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR 
 */
- (int)post_GetFile:(NSString*)urlString dataToPost:(NSData*)dataToPost fileName:(NSString*)fileName allowOverWrite:(BOOL)overWrite;
/*!
 post data to server,than download some data using get method
 @param urlString		the server url
 @param dataToPost		the data used to post
 @param dataToAccept	the data for download, if nil, one mutable data will be created automatically for you.
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR  
 */
- (int)post_GetData:(NSString*)urlString dataToPost:(NSData*)dataToPost dataToAccept:(NSMutableData*)dataToAccept;
/*!
 post data to server,than download some data using get method
 @param urlString		the server url
 @param dataToPost		the data used to post
 @param dataToAccept	the data for download, if nil, one mutable data will be created automatically for you.
 @param httpHeader		the HTTPHeaderFields used to append
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR
 */
- (int)post_GetData:(NSString*)urlString dataToPost:(NSData*)dataToPost dataToAccept:(NSMutableData*)dataToAccept httpHeader:(NSDictionary *)httpHeader;
/*!
 post data to server,than download some data using get method
 This interface need not pass in the data to accept,an data buffer will be created automatically for you.
 use getConnectionData: to get the data accepted.
 e.g. 
 
 - (void)transferDidFinishLoading:(NDNetHttpTransferIDRef)connection
 {
 NSData *data = [[NDNetHttpTransfer sharedTransfer] getConnectionData:connection];
 if (data != nil)
 // do your work
 }
 
 @param urlString		the server url
 @param dataToPost		the data used to post
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR  
 */
- (int)post_GetData:(NSString*)urlString dataToPost:(NSData*)dataToPost;

/*!
 send a put request to server
 @param urlString the server url
 @param dataToPut the data used to put
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR  
 */
- (int)putData:(NSString *)urlString dataToPut:(NSData *)dataToPut;

/*!
 send a put request to server
 @param urlString the server url
 @param fileToPut the file name used to put
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR   
 */
- (int)putFile:(NSString *)urlString fileToPut:(NSString *)fileToPut;
/*!
 send a delete request to server;
 @param urlString the server url
 @param dataToPut the data used to delete
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR   
 */
- (int)deleteData:(NSString *)urlString;

/*!
 cancel the connection
 */
- (void)cancelConnection;

@end

@interface NDNetHttpTransferClient(Synchronous)
- (NSData *)getSynchronousData:(NSString *)urlString;
@end

/*!
 NetHttpTransferClientDelegate Protocol
 if your delegate implement these methods, it will be called back.
 */
@protocol NetHttpTransferClientDelegate
/*!
 @param connection	the client object
 */
- (void)clientDidCancel:(NDNetHttpTransferClient*)connection;

/*!
 server return the response, check you requirement here
 @param connection the client object
 @param response server returned response
 */
- (void)client:(NDNetHttpTransferClient *)connection didReceiveResponse:(NSURLResponse *)response;

/*!
 server return the send byte
 @param connection the client object
 @param bytesWritten the byte send this time
 @param totalBytesWritten the total byte have sent
 @param totalBytesExpectedToWrite the total bytes expected to write. may be -1
 */
- (void)client:(NDNetHttpTransferClient *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

/*!
 if the server return response lenght -1, or gzip data is accepted, this method will not be called! 
 @param connection	the client object
 @param recevedLen the length we have got
 @param expectedLen the total length we expected to get from server.
 */
- (void)client:(NDNetHttpTransferClient*)connection didReceiveData:(unsigned long)receivedLen expectedTotalLen:(unsigned long)expectedTotalLen;
/*!
 @param connection	the client object
 */
- (void)clientDidFinishLoading:(NDNetHttpTransferClient*)connection;
/*!
 @param connection	the client object
 @param error	the error occured
 */
- (void)client:(NDNetHttpTransferClient*)connection didFailWithError:(NSError*)error;

@end
