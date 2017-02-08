//
//  LogFile.h
//  LogFile
//
//  Created by zivInfo on 17/1/17.
//  Copyright © 2017年 xiwangtech.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogFile : NSObject

@property (nonatomic, strong) NSString *filePath;//当前操作的文件的路径
@property (nonatomic, strong) dispatch_queue_t concurrentWriteFileQueue;//自己创建的一个线程

- (void) userInfoWithUID:(NSString*)UID;

// 创建文件
-(void) createFileWithUID:(NSString*)UID;

// 文件写入
- (void) writeMessageToFileWithJsonStr:(NSDictionary*)dic;

// 文件删除
- (void) deleteUserInfoFile;

//文件大小
- (float) fileSize;

@end
