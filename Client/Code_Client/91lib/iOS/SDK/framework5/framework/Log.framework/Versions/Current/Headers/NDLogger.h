//
//  NDLogger.h
//  Untitled
//
//  Created by QiLiang Shen on 09-2-16.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#if defined(__cplusplus)
extern "C" {
#endif
	void NDSimulatorLog(NSString *logStr,char* fileName, int lineNum);
#if defined(__cplusplus)
}
#endif

@interface NDLogger : NSObject {
	NSFileHandle	*_fileHandle;
	NSString		*_basicLogPath;
}

+ (BOOL)setBasicLogPath:(NSString *)path;
+ (BOOL)setLogFile:(NSString *)file;							
+ (void)log:(NSString *)str file:(char *)fileName linnum:(int)lineNum;
+ (void)setLogEnabled:(BOOL)enable;
@end

#define setNDLOGPath(path)	[NDLogger setBasicLogPath:path];
#define setNDLOGFile(file)	[NDLogger setLogFile:file];
#if TARGET_IPHONE_SIMULATOR
#define NDLOG(...)  NDSimulatorLog([NSString stringWithFormat:__VA_ARGS__], __FILE__, __LINE__)
#else
#define NDLOG(...)   [NDLogger log:[NSString stringWithFormat:__VA_ARGS__] file:__FILE__ linnum:__LINE__]
#endif
#define setNDLOGEnable(enable) [NDLogger setLogEnabled:enable]