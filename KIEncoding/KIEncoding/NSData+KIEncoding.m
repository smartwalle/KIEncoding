//
//  NSData+KIEncoding.m
//  KIEncoding
//
//  Created by apple on 16/4/14.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "NSData+KIEncoding.h"

static char encodingTable[64] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };

@implementation NSData (KIEncoding)

+ (NSData *)dataWithHex:(NSString *)hex {
    NSString *str = [hex stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    NSUInteger strLen = [str length] * 0.5;
    for (NSUInteger i = 0; i < strLen; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

- (NSString *)hexString {
    const unsigned char *bytes = [self bytes];
    NSUInteger len = [self length];
    NSMutableString *hex = [[NSMutableString alloc] initWithCapacity:len * 2];
    for(NSUInteger i=0; i<len; ) {
        [hex appendFormat:@"%02x", bytes[i]];
        ++i;
    }
    return [hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)base64Encoded {
    const unsigned char	*bytes = [self bytes];
    NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
    unsigned long ixtext = 0;
    unsigned long lentext = [self length];
    long ctremaining = 0;
    unsigned char inbuf[3], outbuf[4];
    unsigned short i = 0;
    unsigned short charsonline = 0, ctcopy = 0;
    unsigned long ix = 0;
    
    while(YES) {
        ctremaining = lentext - ixtext;
        if( ctremaining <= 0 ) break;
        
        for( i = 0; i < 3; i++ ) {
            ix = ixtext + i;
            if( ix < lentext ) inbuf[i] = bytes[ix];
            else inbuf [i] = 0;
        }
        
        outbuf [0] = (inbuf [0] & 0xFC) >> 2;
        outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
        outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
        outbuf [3] = inbuf [2] & 0x3F;
        ctcopy = 4;
        
        switch( ctremaining ) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for( i = 0; i < ctcopy; i++ ) {
            [result appendFormat:@"%c", encodingTable[outbuf[i]]];
        }
        
        for( i = ctcopy; i < 4; i++ ) {
            [result appendString:@"="];
        }
        
        ixtext += 3;
        charsonline += 4;
    }
    
    return [NSString stringWithString:result];
}

- (NSData *)base64Decoded {
    const unsigned char	*bytes = [self bytes];
    NSMutableData *result = [NSMutableData dataWithCapacity:[self length]];
    
    unsigned long ixtext = 0;
    unsigned long lentext = [self length];
    unsigned char ch = 0;
    unsigned char inbuf[4] = {0, 0, 0, 0};
    unsigned char outbuf[3] = {0, 0, 0};
    short i = 0, ixinbuf = 0;
    BOOL flignore = NO;
    BOOL flendtext = NO;
    
    while( YES ) {
        if( ixtext >= lentext ) break;
        ch = bytes[ixtext++];
        flignore = NO;
        
        if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
        else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
        else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
        else if( ch == '+' ) ch = 62;
        else if( ch == '=' ) flendtext = YES;
        else if( ch == '/' ) ch = 63;
        else flignore = YES;
        
        if( ! flignore ) {
            short ctcharsinbuf = 3;
            BOOL flbreak = NO;
            
            if( flendtext ) {
                if( ! ixinbuf ) break;
                if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
                else ctcharsinbuf = 2;
                ixinbuf = 3;
                flbreak = YES;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if( ixinbuf == 4 ) {
                ixinbuf = 0;
                outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
                outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
                outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
                
                for( i = 0; i < ctcharsinbuf; i++ )
                    [result appendBytes:&outbuf[i] length:1];
            }
            
            if( flbreak )  break;
        }
    }
    return [NSData dataWithData:result];
}

@end
