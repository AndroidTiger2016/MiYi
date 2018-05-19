//
//  MiYiRequestManager.m
//  MiYi
//
//  Created by 叶星龙 on 15/8/3.
//  Copyright (c) 2015年 北京美耶时尚信息科技有限公司. All rights reserved.
//


#import "MiYiRequestManager.h"

#define MiYi_API_Test   NO
#define MiYi_API    (MiYi_API_Test ? @"http://192.168.1.113:8000/":@"http://api.miyifashion.com/")

@interface MiYiRequestManager ()

@end

static NSString * AFURLEncodedStringFromString(NSString *string) {
    static NSString * const kAFLegalCharactersToBeEscaped = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\|~ ";
    
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, (CFStringRef)kAFLegalCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))) ;
}

 NSString * AFQueryStringFromParameters(NSDictionary *parameters) {
    NSMutableArray *mutableParameterComponents = [NSMutableArray array];
    for (id key in [parameters allKeys]) {
        NSString *component = [NSString stringWithFormat:@"%@=%@", AFURLEncodedStringFromString([key description]), AFURLEncodedStringFromString([[parameters valueForKey:key] description])];
        [mutableParameterComponents addObject:component];
    }
    return [mutableParameterComponents componentsJoinedByString:@"&"];
}

@implementation MiYiRequestManager

+ (void)postMiYi_APIWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    __block  unsigned int ret_length = 0;
    __block NSData *dataKey =[@"qU$YK!7w@j1u3x@P" JSONData];

    
    NSString *httpURL =[NSString stringWithFormat:@"%@%@",MiYi_API,url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
        
        NSString * request_string = AFQueryStringFromParameters(parameters);
        NSData *data =[request_string JSONData];
        unsigned char *charEncrypt = xxtea_encrypt((unsigned char *)data.bytes ,(unsigned int)data.length,(unsigned char *)dataKey.bytes,(unsigned int)dataKey.length, &ret_length);
        NSData *baseData = [NSData dataWithBytes:charEncrypt length:ret_length];
        NSString *parametersBase64 =[baseData base64EncodedString];
        return parametersBase64;
    }];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:httpURL parameters:params
          success:^(NSURLSessionDataTask *task, id responseObject) {
              if (success) {
                  NSString* stringBase64Decoded= [[NSString alloc] initWithData:responseObject  encoding:NSASCIIStringEncoding];
                  NSData *dataBase64Decoded = [stringBase64Decoded base64DecodedData];
                  unsigned char *charDecrypt =xxtea_decrypt((unsigned char *)[dataBase64Decoded bytes], (unsigned int)dataBase64Decoded.length,(unsigned char *)dataKey.bytes,(unsigned int)dataKey.length, &ret_length);
                  NSData *dataObject = [NSData dataWithBytes:charDecrypt length:ret_length];
                  success([dataObject JSONObject]);
              }
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure) {
                  failure(error);
              }
          }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:params
          success:^(NSURLSessionDataTask *task, id responseObject) {
              if (success) {
                  success(responseObject);
              }
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              if (failure) {
                  failure(error);
              }
          }];
}

+ (void)postMiYi_APIWithURL:(NSString *)url params:(NSDictionary *)params formData:(formData *)formData success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    NSString *httpURL =[NSString stringWithFormat:@"http://www.miyifashion.com/%@",url];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr POST:httpURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
        
        [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        

    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
  
//    [mgr setuploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//        NSLog(@"%lld  ~~~~~~~~~~~ %lld",totalBytesWritten ,totalBytesExpectedToWrite);
//    }];
    
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)paramets success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
   
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:url parameters:paramets
     success:^(NSURLSessionDataTask *task, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}
+ (void)getMiYi_APIWithURL:(NSString *)url params:(NSDictionary *)paramets success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *httpURL =[NSString stringWithFormat:@"%@%@",MiYi_API,url];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr GET:httpURL parameters:paramets
     success:^(NSURLSessionDataTask *task, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

@end

@implementation formData



@end
