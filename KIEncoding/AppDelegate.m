//
//  AppDelegate.m
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "AppDelegate.h"
#import "NSString+KIAES.h"
#import "NSString+KIDigest.h"
#import "NSString+KIEncoding.h"
#import "NSBundle+KIAdditions.h"

#include <openssl/evp.h>
#include <openssl/rand.h>
#include <openssl/rsa.h>
#include <openssl/pem.h>

#import "KIRSA.h"


@interface AppDelegate ()
@property(nonatomic, strong) KIRSAPublicKey *pubKey;
@property(nonatomic, strong) KIRSAPrivateKey *priKey;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *pubPath = KIDirectoryBaseDocument(@"test_pub_1.key");
    NSString *priPath = KIDirectoryBaseDocument(@"test_pri_1.key");
    NSLog(@"%@", pubPath);
    
    NSData *pt = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"mp3"]];//[@"这个内容被加密了，你知道吗？" dataUsingUTF8Encoding];
    
    pt = [@"这个是加密内容" dataUsingUTF8Encoding];
    
   

//    KIRSA *rsa = [KIRSA generateKey];
//    self.priKey = rsa.privateKey;
//    self.pubKey = rsa.publicKey;
//    [self.priKey writeKeyToFile:priPath];
//    [self.pubKey writeKeyToFile:pubPath];
    
    self.pubKey = [[KIRSAPublicKey alloc] initWithFile:pubPath];
    self.priKey = [[KIRSAPrivateKey alloc] initWithFile:priPath];
    

    __weak AppDelegate *weakSelf = self;
    [self.pubKey encrypt:pt finishedBlock:^(NSData *cipherData, NSError *error) {
        [weakSelf.priKey decrypt:cipherData finishedBlock:^(NSData *plainData, NSError *error) {
            NSLog(@"解密出来啦：%@", [plainData UTF8String]);
        }];
    }];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
