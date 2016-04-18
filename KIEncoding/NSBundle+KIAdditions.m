//
//  NSBundle+KIAdditions.m
//  Kitalker
//
//  Created by 杨 烽 on 12-10-25.
//
//

#import "NSBundle+KIAdditions.h"
#import <UIKit/UIKit.h>

@implementation NSBundle (KIAdditions)

+ (NSString *)bundlePath {
    return [[NSBundle mainBundle] bundlePath];
}

+ (NSString *)appHomeDirectory {
    return NSHomeDirectory();
}

+ (NSString *)documentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libraryDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)cachesDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)tempDirectory {
    return NSTemporaryDirectory();
}

/*Bundle相关*/
+ (NSString *)bundleIdentifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)bundleDisplayName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)bundleName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)bundleBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)bundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (float)bundleMiniumOSVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"MinimumOSVersion"] floatValue];
}

/*编译信息相关*/
+ (int)buildXcodeVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"DTXcode"] intValue];
}

+ (NSString *)appLanguages {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
}

+ (void)openURL:(NSURL *)url {
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)sendMail:(NSString *)mail {
    NSString *url = [NSString stringWithFormat:@"mailto://%@", mail];
    [self openURL:[NSURL URLWithString:url]];
}

+ (void)sendSMS:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"sms://%@", number];
    [self openURL:[NSURL URLWithString:url]];
}

+ (void)callNumber:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"tel://%@", number];
    [self openURL:[NSURL URLWithString:url]];
}

@end
