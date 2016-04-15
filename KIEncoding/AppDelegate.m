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

// 生成公钥文件和私钥文件，私钥文件带密码
int generate_key_files(const char *pub_keyfile, const char *pri_keyfile,
                       const unsigned char *passwd, int passwd_len)
{
    RSA *rsa = NULL;
//    RAND_seed(rnd_seed, sizeof(rnd_seed));
    rsa = RSA_generate_key(1024, RSA_F4, NULL, NULL);
    if(rsa == NULL)
    {
        printf("RSA_generate_key error!\n");
        return -1;
    }
    
    // 开始生成公钥文件
    BIO *bp = BIO_new(BIO_s_file());
    if(NULL == bp)
    {
        printf("generate_key bio file new error!\n");
        return -1;
    }
    
    if(BIO_write_filename(bp, (void *)pub_keyfile) <= 0)
    {
        printf("BIO_write_filename error!\n");
        return -1;
    }
    
    if(PEM_write_bio_RSAPublicKey(bp, rsa) != 1)
    {
        printf("PEM_write_bio_RSAPublicKey error!\n");
        return -1;
    }
    
    // 公钥文件生成成功，释放资源
    printf("Create public key ok!\n");
    BIO_free_all(bp);
    
    // 生成私钥文件
    bp = BIO_new_file(pri_keyfile, "w+");
    if(NULL == bp)
    {
        printf("generate_key bio file new error2!\n");
        return -1;
    }
    
    if(PEM_write_bio_RSAPrivateKey(bp, rsa,
                                   EVP_des_ede3_ofb(), (unsigned char *)passwd,
                                   passwd_len, NULL, NULL) != 1)
    {
        printf("PEM_write_bio_RSAPublicKey error!\n");
        return -1;
    }
    
    // 释放资源
    printf("Create private key ok!\n");
    BIO_free_all(bp);
    RSA_free(rsa);  
    
    return 0;  
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *pubPath = KIPathBaseDocument(@"test_pub.key");
    NSString *priPath = KIPathBaseDocument(@"test.key");
    
//    generate_key_files([pubPath UTF8String], [priPath UTF8String], "123456", 6);
    
    
    NSData *pt = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"mp3"]];//[@"这个内容被加密了，你知道吗？" dataUsingUTF8Encoding];
    
    pt = [@"这个是加密内容" dataUsingUTF8Encoding];
    
   

//    KIRSA *rsa = [KIRSA generateKey];
//    self.priKey = rsa.privateKey;
//    self.pubKey = rsa.publicKey;
    
    self.pubKey = [[KIRSAPublicKey alloc] initWithFile:pubPath];
    self.priKey = [[KIRSAPrivateKey alloc] initWithFile:priPath];
    
    
    __weak AppDelegate *weakSelf = self;
    [self.priKey encrypt:pt finishedBlock:^(NSData *cipherData, NSError *error) {
        [weakSelf.pubKey decrypt:cipherData finishedBlock:^(NSData *plainData, NSError *error) {
            NSLog(@"解密出来啦：%@", [plainData UTF8String]);
            NSLog(@"%@", KIPathBaseDocument(@"aaa.mp3"));
            [plainData writeToFile:KIPathBaseDocument(@"aaa.mp3") atomically:YES];
            
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
