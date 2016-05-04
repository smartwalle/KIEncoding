//
//  AppDelegate.m
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "AppDelegate.h"
#import "NSData+KIAES.h"
#import "NSString+KIEncoding.h"
#import "KIRSA.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"mp3"]];
//    
//    data = [data AESEncryptWithMode:KIAESMode_CBC bits:KIAESBits_256 password:[@"aaa" dataUsingUTF8Encoding]];
//    
//    data = [data AESDecryptWithMode:KIAESMode_CBC bits:KIAESBits_256 password:[@"aaa" dataUsingUTF8Encoding]];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [paths objectAtIndex:0];
//    
//    [data writeToFile:[path stringByAppendingPathComponent:@"bb.mp3"] atomically:YES];
//    
//    NSLog(@"%@", path);
    
    NSLog(@"%@", [[[@"aaaa" dataUsingUTF8Encoding] AESEncryptWithMode:KIAESMode_CBC bits:KIAESBits_256 password:[@"cccc" dataUsingUTF8Encoding]] base64Encoded]);
    
    NSLog(@"%@", [[[@"U2FsdGVkX1/TeVQDOzI4bDCQREb+TBN9Pew7yMni9tM=" base64Decoded] AESDecryptWithMode:KIAESMode_CBC bits:KIAESBits_256 password:[@"cccc" dataUsingUTF8Encoding]] UTF8String]);
    
    
//    NSData *cipher = [@"U2FsdGVkX1+MV65Eu1KOTvsdpFqSefapGx3pE1r4InGnNKzEFjSF58H9ISoQHqgy +jHDba0VnEKnXJws2sJlUE4WGJpxWjP2AmhZb2p2BgUvrlZ6SK/G5aFaeP+5aaSWpYaX23P2peTFUreTia +7585b5QAmbJ3cdIKvBtDNC2+9Sz+EqkS7Go +r1CGLdiD9kQwpFK7mkeZAcFy5aRZw74Odeal6GC2KM/gb/ULRCu6VA6E0abtQKOcq0z9CzxGQ" base64Decoded];
//    
//    NSLog(@"%@", [[cipher AESDecryptWithMode:KIAESMode_CBC bits:KIAESBits_256 password:[@"11111111111111111111111111111112" dataUsingUTF8Encoding] saltType:KIAESSaltType_PBKDF2 saltDigest:EVP_sha1() iterCount:0 magic:@"Salted__"] UTF8String]);
//    
//    NSLog(@"%@", [KIRSAKey RSAError]);
    
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
