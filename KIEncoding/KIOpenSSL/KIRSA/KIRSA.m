//
//  KIRSA.m
//  KIEncoding
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "KIRSA.h"
#import "NSData+KIEncoding.h"

@interface KIRSA ()
@property (nonatomic, strong) KIRSAPrivateKey *privateKey;
@property (nonatomic, strong) KIRSAPublicKey  *publicKey;
@end

@implementation KIRSA

- (void)dealloc {
}

+ (KIRSA *)generateKey {
    return [KIRSA generateKeyWithBits:1024];
}

+ (KIRSA *)generateKeyWithBits:(int)bits {
    return [KIRSA generateKeyWithBits:bits e:RSA_F4];
}

+ (KIRSA *)generateKeyWithBits:(int)bits e:(unsigned long)e {
    KIRSA *r = [[KIRSA alloc] init];
    
    BIGNUM *bn = BN_new();
    BN_set_word(bn, e);
    
    RSA *rsa = RSA_new();
    int status = RSA_generate_key_ex(rsa, bits, bn, NULL);
    
    if (status != 0) {
        KIRSAPrivateKey *privateKey = [[KIRSAPrivateKey alloc] initWithRSA:rsa];
        KIRSAPublicKey  *publicKey  = [[KIRSAPublicKey alloc] initWithRSA:rsa];
        
        r.privateKey = privateKey;
        r.publicKey  = publicKey;
        
        RSA_free(rsa);
    } else {
        r = nil;
    }
    BN_free(bn);
    
    return r;
}

@end
