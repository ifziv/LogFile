//
//  LogFile.m
//  LogFile
//
//  Created by zivInfo on 17/1/17.
//  Copyright © 2017年 xiwangtech.com. All rights reserved.
//

#import "LogFile.h"

@implementation LogFile

- (instancetype) shareInstance{
    
    static dispatch_once_t onceToken;
    static LogFile *logFile = nil;
    //确保创建单例只被执行一次。
    dispatch_once(&onceToken, ^{
        logFile = [LogFile new];
        //自己建立一个线程
        logFile.concurrentWriteFileQueue = dispatch_queue_create("写文件的线程自定义队列", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return logFile;
}

//xieru
- (void)userInfoWithUID:(NSString*)UID{
    

        [self createFileWithUID:@"LogFile"];
        
        NSDictionary *dic = @{
                              @"u":@{
                                      @"uid":@"Log",//
                                      @"device":@"设备号",
                                      @"brand":@"设备信息",
                                      @"os":@"设备操作系统信息",
                                      @"tag":@"客户端发布渠道",
                                      @"clienttype":@"iPhone",
                                      @"version":@"x.x.xxxx"
                                      }
                              };
        
        [self writeMessageToFileWithJsonStr:dic];
    
    
    
}

// 创建文件
-(void) createFileWithUID:(NSString*)UID
{
    // 文件存储的路径，
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [paths objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 路径下的所有文件名
    NSArray *filePathArr = [manager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/",documentDirectory] error:nil];
    NSLog(@"arr = %@",filePathArr);
    
    //    用UID 匹配文件 如果已经有了某个用户的日志，那么就返回这个用户的文件路径，不创建新的。
    for (NSString * file in filePathArr) {
        if ([file rangeOfString:[NSString stringWithFormat:@"%@",UID]].location != NSNotFound) {
            //            已经有了文件，
            //self.filePath 当前操作的文件的路径
            self.filePath = [NSString stringWithFormat:@"%@/%@",documentDirectory,file];
            return;
        }
    }
    
    //首次创建文件名
    NSString *testPath = [NSString stringWithFormat:@"%@/%@.txt",documentDirectory,UID];
    
    BOOL ifFileExist = [manager fileExistsAtPath:testPath];
    BOOL success = NO;
    if (ifFileExist) {
        NSLog(@"文件已经存在");
        self.filePath = testPath;
    }else{
        NSLog(@"文件不存在");
        success = [manager createFileAtPath:testPath contents:nil attributes:nil];
    }
    
    if (!success) {
        NSLog(@"创建文件不成功");
        self.filePath = nil;
        //        错误判断+++
    }else{
        NSLog(@"创建文件成功");
        self.filePath = testPath;
    }
}

// 文件写入
- (void) writeMessageToFileWithJsonStr:(NSDictionary*)dic
{
    if (!self.filePath) {
        NSLog(@"文件路径错误，写不进去");
        return;
    }
    
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:self.filePath];
    // 字典转JSON
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonStr = [json stringByAppendingString:@",\n"];
    
    // 在文件的末尾添加内容。如果想在开始写 [file seekToFileOffset:0];
    [file seekToEndOfFile];
    NSData *strData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [file writeData:strData ];
    
}

// 文件删除
- (void) deleteUserInfoFile
{
    dispatch_barrier_async(self.concurrentWriteFileQueue, ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        BOOL deleSuccess = [manager removeItemAtPath:self.filePath error:nil];
        if (deleSuccess) {
            NSLog(@"删除文件成功");
        }else{
            NSLog(@"删除文件不成功");
        }
    });
    
}

// 文件大小
- (float) fileSize
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return  [[manager attributesOfItemAtPath:self.filePath error:nil] fileSize]/(1024.0); //这里返回的单位是KB
}

@end
