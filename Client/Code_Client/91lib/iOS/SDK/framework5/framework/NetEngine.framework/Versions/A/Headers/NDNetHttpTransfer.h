//
//  NDNetHttpTransfer.h
//  NetEngine
//
//  Created by Ｓie Kensou on 4/29/10.
//  Copyright 2010 NetDragon WebSoft Inc.. All rights reserved.
//

//	Version:1.0		2010-05

#import <UIKit/UIKit.h>
@class NDNetHttpTransferClient;
typedef long NDNetHttpTransferIDRef;	/**< an client id reference for an user's request, an valid id reference will be bigger than 0, or else it means an error occured */

@protocol NDNetHttpTransferProtocol;

/*!
 Http Transfer Manager, managing user's requests.mainly deal with http requests.
 */
@interface NDNetHttpTransfer : NSObject {
	NSMutableDictionary*	m_clientInfoDict;		/**< recording requests and some info, such as delegate */
	NSMutableDictionary*	m_clientIDDict;			/**< recording requests and id */
	unsigned long			m_currentID;			/**< currently the last client id */
	BOOL					m_useGzip;			
	NSURLRequestCachePolicy	m_cachePolicy;
	BOOL					m_halfEncode;
    
    int                     m_autoRetryCount;
    float                   m_autoRetryInterval;
}

@property(nonatomic, assign) BOOL useGzip;			/**< whether to accept gzip content by default */
@property(nonatomic, assign) NSURLRequestCachePolicy cachePolicy; /**< cachePolicy type */
@property(nonatomic, assign) BOOL halfEncode;		/**< 熊猫看书提出的不完全Encode方式,对传入的空格以及汉字进行URLEncode，其他的不处理；默认为YES */

@property(nonatomic, assign) int autoRetry;         /**< if failed, will auto retry to connect until retry autoRetry times;currently only affect getFile*/
@property(nonatomic, assign) float autoRetryInterval;       /**< will auto retry after autoRetryInterval when failed */

+ (NDNetHttpTransfer*)sharedTransfer;				/**< return a global instant of NDNetHttpTransfer class */
- (void)cancelAllTransfer;							/**< cancel all transfer you have made */

/*!
 create an request, using get method, download a file.Default gzip accept is enabled.
 @param urlString	the server url
 @param fileName	the file name for download
 @param overWrite	if NO, the fileName will be truncated to zero if the fileName has been existed;if YES, download will be started from the size of fileName
 @param myDelegate	the receiver of the message send by NDNetHttpTransfer
 @result a client ref(bigger than 0) if success, or else an error is returned
 */
- (NDNetHttpTransferIDRef)getFile:(NSString*)urlString fileName:(NSString*)fileName allowOverWrite:(BOOL)overWrite delegate:(id)myDelegate;

/*!
 create an request, using get method, download some data in memory.Default gzip accept is enabled.
 @param urlString	the server url
 @param data		the data for download
 @param myDelegate	the receiver of the message send by NDNetHttpTransfer
 @result a client ref(bigger than 0) if success, or else an error is returned 
 */
- (NDNetHttpTransferIDRef)getData:(NSString*)urlString data:(NSMutableData*)data delegate:(id)myDelegate;

/*!
 create an request, using get method, download some data in memory.Default gzip accept is enabled.
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
 @param data		the data for download
 @param myDelegate	the receiver of the message send by NDNetHttpTransfer
 @result a client ref(bigger than 0) if success, or else an error is returned 
 */
- (NDNetHttpTransferIDRef)getData:(NSString*)urlString delegate:(id)myDelegate;


/*!
 create an request, using post method, post a file to server.
 @param urlString	the server url
 @param fileToPost	the file used to post
 @param myDelegate	the receiver of the message send by NDNetHttpTransfer
 @result a client ref(bigger than 0) if success, or else an error is returned 
 */
- (NDNetHttpTransferIDRef)postFile:(NSString*)urlString fileToPost:(NSString*)fileToPost delegate:(id)myDelegate;

/*!
 create an request, using post method, post a file to server.
 @param urlString	the server url
 @param dataToPost	the data used to post
 @param myDelegate	the receiver of the message send by NDNetHttpTransfer
 @result a client ref(bigger than 0) if success, or else an error is returned 
 */
- (NDNetHttpTransferIDRef)postData:(NSString*)urlString dataToPost:(NSData*)dataToPost delegate:(id)myDelegate;

/*!
 create an request, post data to server,than download a file using get method
 @param urlString	the server url
 @param dataToPost	the data used to post
 @param fileName	the file name for download
 @param overWrite	if YES, the fileName will be truncated to zero if the fileName has been existed;if NO, download will be started from the size of fileName
 @param myDelegate	the receiver of the message send by NDNetHttpTransfer
 @result a client ref(bigger than 0) if success, or else an error is returned 
 */
- (NDNetHttpTransferIDRef)post_GetFile:(NSString*)urlString dataToPost:(NSData*)dataToPost fileName:(NSString*)fileName allowOverWrite:(BOOL)overWrite delegate:(id)myDelegate;

/*!
 create an request, post data to server,than download some data using get method
 @param urlString		the server url
 @param dataToPost		the data used to post
 @param dataToAccept	the data for download
 @param myDelegate		the receiver of the message send by NDNetHttpTransfer
 @result a client ref(bigger than 0) if success, or else an error is returned 
 */
- (NDNetHttpTransferIDRef)post_GetData:(NSString*)urlString dataToPost:(NSData*)dataToPost dataToAccept:(NSMutableData*)dataToAccept delegate:(id)myDelegate;

/*!
 create an request, post data to server and set the request‘s HTTPHeaderFields if necessary, than download some data using get method
 @param urlString		the server url
 @param dataToPost		the data used to post
 @param dataToAccept	the data for download
 @param httpHeader		the HTTPHeaderFields used to append
 @param customizationBlock	the block used to customize NDNetHttpTransfer
 @param myDelegate		the receiver of the message send by NDNetHttpTransfer
 @result a client ref(bigger than 0) if success, or else an error is returned
 */
- (NDNetHttpTransferIDRef)post_GetData:(NSString*)urlString dataToPost:(NSData*)dataToPost dataToAccept:(NSMutableData*)dataToAccept httpHeader:(NSDictionary *)httpHeader customizationBlock:(void(^)(NDNetHttpTransferClient *httpTransferClient))customizationBlock delegate:(id)myDelegate;

/*!
 create an request, post data to server,than download some data using get method.
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
 @param myDelegate		the receiver of the message send by NDNetHttpTransfer
 @result a client ref(bigger than 0) if success, or else an error is returned 
 */
- (NDNetHttpTransferIDRef)post_GetData:(NSString*)urlString dataToPost:(NSData*)dataToPost delegate:(id)myDelegate;

/*!
 create an request, post data to server and set the request‘s HTTPHeaderFields if necessary,than download some data using get method.
@param urlString            the server url
@param dataToPost           the data used to post
@param httpHeader           the HTTPHeaderFields used to append
@param customizationBlock	the block used to customize NDNetHttpTransfer
@param myDelegate           the receiver of the message send by NDNetHttpTransfer
@result a client ref(bigger than 0) if success, or else an error is returned
*/
- (NDNetHttpTransferIDRef)post_GetData:(NSString*)urlString dataToPost:(NSData*)dataToPost httpHeader:(NSDictionary *)httpHeader customizationBlock:(void(^)(NDNetHttpTransferClient *httpTransferClient))customizationBlock delegate:(id)myDelegate;

/*!
 send a put request to server
 @param urlString the server url
 @param dataToPut the data used to put
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR  
 */
- (NDNetHttpTransferIDRef)putData:(NSString *)urlString dataToPut:(NSData *)dataToPut delegate:(id)myDelegate;

/*!
 send a put request to server
 @param urlString the server url
 @param fileToPut the file name used to put
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR   
 */
- (NDNetHttpTransferIDRef)putFile:(NSString *)urlString fileToPut:(NSString *)fileToPut delegate:(id)myDelegate;
/*!
 send a delete request to server;
 @param urlString the server url
 @param dataToPut the data used to delete
 @result error if error occured, else return ND_NET_HTTP_TRANSFER_NO_ERROR   
 */
- (NDNetHttpTransferIDRef)deleteData:(NSString *)urlString delegate:(id)myDelegate;


/*!
 cancel an request by client id reference.
 @param connection	the client id refercence returned by methods above.
 */
- (void)cancelConnection:(NDNetHttpTransferIDRef)connection;

@end

/*!
 NDNetHttpTransfer Category
 */
@interface NDNetHttpTransfer(UserInfo)

/*!
 set an tag for an client request.
 @param connection	the client id reference returned by request methods.
 @param tag			your tag for the client.
 */
- (void)connection:(NDNetHttpTransferIDRef)connection setTag:(int)tag;

/*!
 get an tag for an client reqeust.
 @param connection	the client id reference returned by request methods.
 @result the connection's setted tag, if tag not setted for connection, the return value will be random.
 */
- (int)getConnectionTag:(NDNetHttpTransferIDRef)connection;

/*!
 get the data for an client request.
 @param connection the client id reference returned by request methods.
 @result the connection's data, if tag not setted for connection, the return value will be nil;
 */
- (const NSData *)getConnectionData:(NDNetHttpTransferIDRef)connection;

/*!
 get the http response code for an client request
 @param connection the client id reference returned by request methods.
 @result the connection's response code, 0 will be return if client not valid;
 */
- (int)getConnectionResponseCode:(NDNetHttpTransferIDRef)connection;

/*!
 get the client object according to connection id
 @param connection the client id reference returned by request methods.
 @result the responding client object,return nil if not available 
 */
- (NDNetHttpTransferClient *)getConnectionClient:(NDNetHttpTransferIDRef)connection;

/*!
 whether content type of the response from server an "text/html"
 @result YES if type if "text/html"
 */
- (BOOL)isConnectionContentHTML:(NDNetHttpTransferIDRef)connection;
@end

/*!
 NDNetHttpTransferProtocol
 these method will be called when the server returns some message if you implementted the delegate
 */
@protocol NDNetHttpTransferProtocol
/*!
 @param connection:	the client id reference returned by request methods.
 */
- (void)transferDidCancel:(NDNetHttpTransferIDRef)connection;

/*!
 @param connection:	the client id reference returned by request methods.
 @param response: server returned response
 */
- (void)transfer:(NDNetHttpTransferIDRef)connection didReceiveResponse:(NSURLResponse *)response;
/*!
 if the server return response lenght -1, or gzip data is accepted, this method will not be called!
 @param connection:	the client id reference returned by request methods.
 @param receivedLen:	the data length we have received.
 @param expectedTotalLen: total length we expected to recevied.
 */
- (void)transfer:(NDNetHttpTransferIDRef)connection didReceiveData:(unsigned long)receivedLen expectedTotalLen:(unsigned long)expectedTotalLen;

/*!
 server return the send byte
 @param connection the client id reference returned by request methods.
 @param bytesWritten the byte send this time
 @param totalBytesWritten the total byte have sent
 @param totalBytesExpectedToWrite the total bytes expected to write. may be -1
 */
- (void)transfer:(NDNetHttpTransferIDRef)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

/*!
 @param connection:	the client id reference returned by request methods.
 */
- (void)transferDidFinishLoading:(NDNetHttpTransferIDRef)connection;
/*!
 @param connection:	the client id reference returned by request methods.
 @param error:	error occured.
 */
- (void)transfer:(NDNetHttpTransferIDRef)connection didFailWithError:(NSError*)error;
@end