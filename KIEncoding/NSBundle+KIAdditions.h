//
//  NSBundle+KIAdditions.h
//  Kitalker
//
//  Created by 杨 烽 on 12-10-25.
//
//

#import <Foundation/Foundation.h>

/*从nib文件创建View*/
#define KILoadViewFromNibWithIndex(nibNamed, index) [[[NSBundle mainBundle] loadNibNamed:nibNamed\
                                                        owner:self\
                                                        options:nil] objectAtIndex:index]

#define KILoadViewFromNib(nibNamed) KILoadViewFromNibWithIndex(nibNamed, 0)


#define KI_APP_HOME_DIRECTORY   [NSBundle appHomeDirectory]

/*苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录*/
#define KI_DOCUMENT_DIRECTORY   [NSBundle documentDirectory]

/*存储程序的默认设置或其它状态信息*/
#define KI_LIBRARY_DIRECTORY    [NSBundle libraryDirectory]

/*存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除*/
#define KI_CACHES_DIRECTORY     [NSBundle cachesDirectory]

/*提供一个即时创建临时文件的地方*/
#define KI_TEMP_DIRECTORY       [NSBundle tempDirectory]


/*只返回文件夹的路径*/
#define KIDirectoryBaseDocument(fileName)    [KI_DOCUMENT_DIRECTORY stringByAppendingPathComponent:fileName]
#define KIDirectoryBaseLibrary(fileName)     [KI_LIBRARY_DIRECTORY stringByAppendingPathComponent:fileName]
#define KIDirectoryBaseCaches(fileName)      [KI_CACHES_DIRECTORY stringByAppendingPathComponent:fileName]
#define KIDirectoryBaseTmp(fileName)         [KI_TEMP_DIRECTORY stringByAppendingPathComponent:fileName]

/*根据提供的 file name 返回其路径*/
#define KIPathBaseDocument(fileName)    [KI_DOCUMENT_DIRECTORY stringByAppendingPathComponent:fileName]
#define KIPathBaseLibrary(fileName)     [KI_LIBRARY_DIRECTORY stringByAppendingPathComponent:fileName]
#define KIPathBaseCaches(fileName)      [KI_CACHES_DIRECTORY stringByAppendingPathComponent:fileName]
#define KIPathBaseTmp(fileName)         [KI_TEMP_DIRECTORY stringByAppendingPathComponent:fileName]


/*文件缓存目录*/
#define KICachePath(path) [KIDirectoryBaseCaches(@"KICache") stringByAppendingPathComponent:path]


@interface NSBundle (KIAdditions)

+ (NSString *)bundlePath;

+ (NSString *)appHomeDirectory;

+ (NSString *)documentDirectory;

+ (NSString *)libraryDirectory;

+ (NSString *)cachesDirectory;

+ (NSString *)tempDirectory;

+ (NSString *)bundleIdentifier;

+ (NSString *)bundleDisplayName;

+ (NSString *)bundleName;

+ (NSString *)bundleBuildVersion;

+ (NSString *)bundleVersion;

+ (float)bundleMiniumOSVersion;

/*编译使用的Xcode版本信息*/
+ (int)buildXcodeVersion;

/*当前系统语言*/
+ (NSString *)appLanguages;

/*打开一个URL*/
+ (void)openURL:(NSURL *)url;

/*发送邮件*/
+ (void)sendMail:(NSString *)mail;

/*发送短信*/
+ (void)sendSMS:(NSString *)number;

/*打电话*/
+ (void)callNumber:(NSString *)number;

@end
