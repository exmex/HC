//
//  com4lovesEncrypt.m
//  com4lovesSDK
//
//  Created by fish on 13-8-26.
//  Copyright (c) 2013年 com4loves. All rights reserved.
//

#import "SDKEncrypt.h"
#include "stdio.h"
#include <openssl/rsa.h>
#include <openssl/pem.h>

#import "GTMBase64.h"
#import "GTMDefines.h"

int test1()
{
    // 原始明文
    char plain[2256]="{\"error\":\"200\",\"errorMessage\":\"成功\",\"timestamp\":1381598243444,\"data\":{\"players\":[{\"name\":\"aaa\",\"serverId\":1,\"youaiId\":\"91_427628900\"},{\"name\":\"aaa\",\"serverId\":98,\"youaiId\":\"91_427628900\"},{\"name\":\"娜美来了\",\"serverId\":1407,\"youaiId\":\"91_427628900\"},{\"name\":\"aaa\",\"serverId\":84,\"youaiId\":\"91_427628900\"},{\"name\":\"aaa\",\"serverId\":84,\"youaiId\":\"91_427628900\"},{\"name\":\"aaa\",\"serverId\":85,\"youaiId\":\"91_427628900\"},{\"name\":\"琳古艾帝纳\",\"serverId\":14010,\"youaiId\":\"91_427628900\"},{\"name\":\"aaa\",\"serverId\":1,\"youaiId\":\"91_427628900\"},{\"name\":\"aaa\",\"serverId\":98,\"youaiId\":\"91_427628900\"},{\"name\":\"aaa\",\"serverId\":85,\"youaiId\":\"91_427628900\"},{\"name\":\"特欧萨奥\",\"serverId\":1401,\"youaiId\":\"91_427628900\"},{\"name\":\"50024\",\"serverId\":2014,\"youaiId\":\"91_427628900\"},{\"name\":\"aaa\",\"serverId\":1,\"youaiId\":\"91_427628900\"},{\"name\":\"特欧萨奥\",\"serverId\":178,\"youaiId\":\"91_427628900\"}]}}";
    
    // 用来存放密文
    char encrypted[1024]="";
    
    // 用来存放解密后的明文
    char decrypted[1024]="";
    
    // 公钥和私钥文件
    
    
    NSString* fullpath1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:"public.pem"]
                                                          ofType:nil
                                                     inDirectory:[NSString stringWithUTF8String:""]];
    NSString* fullpath2 = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:"private.key"]
                                                          ofType:nil
                                                     inDirectory:[NSString stringWithUTF8String:""]];
    
    const char* pub_key= [fullpath1 UTF8String];
    const char* priv_key= [fullpath2 UTF8String];
    
    // -------------------------------------------------------
    // 利用公钥加密明文的过程
    // -------------------------------------------------------
    
    // 打开公钥文件
    FILE* pub_fp=fopen(pub_key,"r");
    if(pub_fp==NULL){
        printf("failed to open pub_key file %s!\n", pub_key);
        return -1;
    }
    
    // 从文件中读取公钥
    RSA* rsa1=PEM_read_RSA_PUBKEY(pub_fp, NULL, NULL, NULL);
    if(rsa1==NULL){
        printf("unable to read public key!\n");
        return -1;
    }
    
    if(strlen(plain)>=RSA_size(rsa1)-41){
        printf("failed to encrypt\n");
        return -1;
    }
    fclose(pub_fp);
    
    // 用公钥加密
    
    int len=RSA_public_encrypt(strlen(plain), (unsigned char*)plain, (unsigned char*)encrypted, rsa1, RSA_PKCS1_PADDING);
    if(len==-1 ){
        printf("failed to encrypt\n");
        return -1;
    }
    
    // 输出加密后的密文
    FILE* fp=fopen("out.txt","w");
    if(fp){
        fwrite(encrypted,len,1,fp);
        fclose(fp);
    }
    // -------------------------------------------------------
    // 利用私钥解密密文的过程
    // -------------------------------------------------------
    // 打开私钥文件
    FILE* priv_fp=fopen(priv_key,"r");
    if(priv_fp==NULL){
        printf("failed to open priv_key file %s!\n", priv_key);
        return -1;
    }
    
    
    // 从文件中读取私钥
    RSA *rsa2 = PEM_read_RSAPrivateKey(priv_fp, NULL, NULL, NULL);
    if(rsa2==NULL){
        printf("unable to read private key!\n");
        return -1;
    }
    
    // 用私钥解密
    len=RSA_private_decrypt(len, (unsigned char*)encrypted, (unsigned char*)decrypted, rsa2, RSA_PKCS1_PADDING);
    if(len==-1){
        printf("failed to decrypt!\n");
        return -1;
    }
    fclose(priv_fp);
    
    
    // 输出解密后的明文
    decrypted[len]=0;
    printf("%s\n",decrypted);
    
    return 0;
}

int test()
{
    // 原始明文
    char plain[256]="123456";
    
    // 用来存放密文
    char encrypted[1024]="";
    
    // 用来存放解密后的明文
    char decrypted[1024]="";
    
    // 公钥和私钥文件

    
    NSString* fullpath1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:"public.pem"]
                                                         ofType:nil
                                                    inDirectory:[NSString stringWithUTF8String:""]];
    NSString* fullpath2 = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:"private.key"]
                                               ofType:nil
                                          inDirectory:[NSString stringWithUTF8String:""]];
    
    const char* pub_key= [fullpath1 UTF8String];
    const char* priv_key= [fullpath2 UTF8String];
    
    // -------------------------------------------------------
    // 利用公钥加密明文的过程
    // -------------------------------------------------------
    
    // 打开公钥文件
    FILE* pub_fp=fopen(pub_key,"r");
    if(pub_fp==NULL){
        printf("failed to open pub_key file %s!\n", pub_key);
        return -1;
    }
    
    // 从文件中读取公钥
    RSA* rsa1=PEM_read_RSA_PUBKEY(pub_fp, NULL, NULL, NULL);
    if(rsa1==NULL){
        printf("unable to read public key!\n");
        return -1;
    }
    
//    if(strlen(plain)>=RSA_size(rsa1)-41){
//        printf("failed to encrypt\n");
//        return -1;
//    }
    fclose(pub_fp);
    
        // -------------------------------------------------------
    // 利用私钥解密密文的过程
    // -------------------------------------------------------
    // 打开私钥文件
    FILE* priv_fp=fopen(priv_key,"r");
    if(priv_fp==NULL){
        printf("failed to open priv_key file %s!\n", priv_key);
        return -1;
    }
    
    
    // 从文件中读取私钥
    RSA *rsa2 = PEM_read_RSAPrivateKey(priv_fp, NULL, NULL, NULL);
    if(rsa2==NULL){
        printf("unable to read private key!\n");
        return -1;
    }
    // 用公钥加密
    
    
    
    int len=RSA_private_encrypt(strlen(plain), (unsigned char*)plain, (unsigned char*)encrypted, rsa2, RSA_PKCS1_PADDING);
    if(len==-1 ){
        printf("failed to encrypt\n");
        return -1;
    }
    NSData* base64data = [NSData dataWithBytes:encrypted length:len];
    NSString *receiptBase64= [GTMBase64 stringByEncodingData:base64data] ;//[postStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //printf("%s",encrypt);
    YALog(@"%@",receiptBase64);
    

    // 用私钥解密
    len=RSA_public_decrypt(len, (unsigned char*)encrypted, (unsigned char*)decrypted, rsa1, RSA_PKCS1_PADDING);
    if(len==-1){
        printf("failed to decrypt!\n");
        return -1;
    }
    fclose(priv_fp);
    
    
    // 输出解密后的明文
    decrypted[len]=0;
    printf("%s\n",decrypted);
    
    return 0;
}


@implementation SDKEncrypt

+(SDKEncrypt*) sharedInstance {
    static SDKEncrypt *_instance = nil;
    if (_instance == nil) {
        _instance = [[SDKEncrypt alloc] init];
    }
    return _instance;
}

-(NSString*) rsaEncrypt:(NSString*) _plain
{

    // 公钥和私钥文件
    
    NSString* fullpath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:"GamesBundle.bundle"]
                                                          ofType:nil
                                                     inDirectory:[NSString stringWithUTF8String:""]];
    NSBundle *buddle = [NSBundle bundleWithPath:fullpath];
    //NSBundle *buddle = [NSBundle bundleWithIdentifier:@"com.loves.com4lovesBundle"];
    [buddle load];
    
    NSString* fullpath1 = [buddle pathForResource:[NSString stringWithUTF8String:"public.pem"]
                                                          ofType:nil
                                                     inDirectory:[NSString stringWithUTF8String:""]];
    
    const char* pub_key= [fullpath1 UTF8String];
    
    // -------------------------------------------------------
    // 利用公钥加密明文的过程
    // -------------------------------------------------------
    
    // 打开公钥文件
    FILE* pub_fp=fopen(pub_key,"r");
    if(pub_fp==NULL){
        printf("failed to open pub_key file %s!\n", pub_key);
        return nil;
    }
    
    // 从文件中读取公钥
    RSA* rsa1=PEM_read_RSA_PUBKEY(pub_fp, NULL, NULL, NULL);
    if(rsa1==NULL){
        printf("unable to read public key!\n");
        return nil;
    }
    
    fclose(pub_fp);
    
    // 原始明文
    int length = [_plain length];
    char plain[1024*10] = {0};// = new char[length];
    if (length>1024*10) {
        printf("message too large!");
        return nil;
    }
    const char* str = [_plain UTF8String];
    length = strlen(str);
    memcpy(plain,str,length);
    plain[length]=0;
    
    NSMutableData* finalData = [NSMutableData alloc];
    
    // 用来存放解密后的明文
    char subPlain[128]={0};
    char subEnc[1024]={0};
    
    int offset = 0;
    while (length>0) {
        int sublength = 0;
        if(length>100)
        {
            memcpy(subPlain,plain+offset,100);
            sublength = 100;
        }
        else
        {
            memcpy(subPlain,plain+offset,length);
            sublength = length;
        }
        
        int len=RSA_public_encrypt(sublength, (unsigned char*)subPlain, (unsigned char*)subEnc, rsa1, RSA_PKCS1_PADDING);
        if(len==-1 ){
            printf("failed to encrypt\n");
            [finalData release];
            return nil;
        }
        [finalData appendBytes:subEnc length:len];
        
        offset+=100;
        length-=100;
    }
    [finalData autorelease];
    return [GTMBase64 stringByEncodingData:finalData];
    }

-(NSString*) rsaDecrypt:(NSString*) _secret
{
    NSString* fullpath = [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:"GamesBundle.bundle"]
                                                         ofType:nil
                                                    inDirectory:[NSString stringWithUTF8String:""]];
    NSBundle *buddle = [NSBundle bundleWithPath:fullpath];
    //NSBundle *buddle = [NSBundle bundleWithIdentifier:@"com.loves.com4lovesBundle"];
    [buddle load];
    
    NSString* fullpath1 = [buddle pathForResource:[NSString stringWithUTF8String:"public.pem"]
                                           ofType:nil
                                      inDirectory:[NSString stringWithUTF8String:""]];
    
    const char* pub_key= [fullpath1 UTF8String];
    
    // -------------------------------------------------------
    // 利用公钥加密明文的过程
    // -------------------------------------------------------
    
    // 打开公钥文件
    FILE* pub_fp=fopen(pub_key,"r");
    if(pub_fp==NULL){
        printf("failed to open pub_key file %s!\n", pub_key);
        return nil;
    }
    
    // 从文件中读取公钥
    RSA* rsa1=PEM_read_RSA_PUBKEY(pub_fp, NULL, NULL, NULL);
    if(rsa1==NULL){
        printf("unable to read public key!\n");
        return nil;
    }
    
    fclose(pub_fp);
    
    // 原始明文
    NSData* data = [GTMBase64 decodeString:_secret];
    int length = [data length];
    char plain[1024*30] = {0};// = new char[length];
    if (length>1024*30) {
        printf("message too large!");
        return nil;
    }
    [data getBytes:plain length:length];
    //memcpy(plain,[data ],length);
    
    
    // 用来存放解密后的明文
    char subPlain[129]={0};
    char subEnc[1024]={0};
    char encBytes[1024*30] = {0};

    @try
    {
        int encOffset = 0;
        int offset = 0;
        while (length>0)
        {
            int sublength = 0;
            if(length>128)
            {
                memcpy(subPlain,plain+offset,128);
                sublength = 128;
            }
            else
            {
                memcpy(subPlain,plain+offset,length);
                sublength = length;
            }
            subPlain[sublength]=0;
        
            int len=RSA_public_decrypt(sublength, (unsigned char*)subPlain, (unsigned char*)subEnc, rsa1, RSA_PKCS1_PADDING);
            if(len==-1 )
            {
                printf("failed to encrypt\n");
                return nil;
            }
            
            memcpy(encBytes+encOffset,subEnc,len);
            encOffset+=len;
            encBytes[encOffset] = 0;
            subEnc[len]=0;

        
            offset+=128;
            length-=128;
        }
//        NSString * subEncString = [[NSString alloc] initWithUTF8String:encBytes];
//        YALog(@"decode %@",subEncString);
        return [[[NSString alloc] initWithUTF8String:encBytes] autorelease];
    }
    @catch (NSException *exception)
    {
        return nil;
    }
    @finally
    {
    }
        

}

-(NSString*) base64Encrypt:(NSString*) plain
{

    return [GTMBase64 stringByEncodingData: [plain dataUsingEncoding:NSUTF8StringEncoding]];
}
-(NSString*) base64Decrypt:(NSString*) secret
{
    NSData* data = [GTMBase64 decodeString:secret];

    NSString* ret = [[[NSString alloc] initWithBytes: [data bytes] length: [data length]encoding:NSUTF8StringEncoding] autorelease];
    
    return ret;
}
@end
