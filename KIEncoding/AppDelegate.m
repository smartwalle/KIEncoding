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
    
    NSData *pt = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"txt"]];
    
//    KIRSA *rsa = [KIRSA generateKeyWithBits:1024];
//    self.priKey = rsa.privateKey;
//    self.pubKey = rsa.publicKey;
    
    self.pubKey = [KIRSAPublicKey keyWithData:[NSData dataWithContentsOfFile:pubPath]];
    self.priKey = [KIRSAPrivateKey keyWithData:[NSData dataWithContentsOfFile:priPath]];
    
    NSError *e;
    NSData *ct = [self.pubKey encrypt:[@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" dataUsingUTF8Encoding] error:&e];
    NSLog(@"%@  %@", [ct hexString], e);
    
    ct = [@"5d2a3a7b6e57141746dbabe8a37554a7e27226b01c392544d32dbb4d84dc6bd643f652d65cb5d64fd0e8483f4639c11434afdd60a911c0d268e76a9633909edc41cf6073359f16c59cad81429b30223cd50a74c277f2daa21c889eb43e17d100e9633d48dbab8dcef8a0516065f2dcd771effdbab5b604c4c5d6a9c8e42b75a3" dataUsingHex];
    
    pt = [self.priKey decrypt:ct error:nil];
    NSLog(@"%@", [pt UTF8String]);

    
//    NSLog(@"=========");
//    e = nil;
//    ct = [self.priKey encrypt:[@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" dataUsingUTF8Encoding] error:&e];
//    NSLog(@"%@   %@", [ct hexString], e);
//    
//    pt = [self.pubKey decrypt:ct error:nil];
//    NSLog(@"%@", [pt UTF8String]);
    
//    [self.priKey writeKeyToFile:priPath password:@"123456"];
//    [self.pubKey writeKeyToFile:pubPath];
    
    
    
//    NSData *d128 = [self.priKey signWithSHA128:pt error:nil];
//    NSData *d256 = [self.priKey signWithSHA256:pt error:nil];
//    NSData *md = [self.priKey signWithMD5:pt error:nil];
//    
//    
//    pt = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"b" ofType:@"txt"]];
//    
//    NSError *err;
//    NSLog(@"%d   %@", [self.pubKey verifySignatureWithSHA128:d128 plainData:pt error:&err], err);
//    NSLog(@"%d   %@", [self.pubKey verifySignatureWithSHA256:d256 plainData:pt error:&err], err);
//    NSLog(@"%d   %@", [self.pubKey verifySignatureWithMD5:md plainData:pt error:&err], err);
//    
    NSLog(@"%@", self.pubKey);
    NSLog(@"%@", self.priKey);
    
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
