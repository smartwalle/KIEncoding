//
//  KIRSA.h
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIRSAPublicKey.h"
#import "KIRSAPrivateKey.h"

@interface KIRSA : NSObject

@property (readonly) KIRSAPublicKey  *publicKey;
@property (readonly) KIRSAPrivateKey *privateKey;

+ (KIRSA *)generateKey;
+ (KIRSA *)generateKeyWithBits:(int)bits;
+ (KIRSA *)generateKeyWithBits:(int)bits e:(unsigned long)e;

@end
