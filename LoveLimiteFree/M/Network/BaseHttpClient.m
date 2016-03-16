//
//  BaseHttpClient.m
//  LoveLimiteFree
//
//  Created by Elean on 16/3/15.
//  Copyright (c) 2016年 Elean. All rights reserved.
//

#import "BaseHttpClient.h"

static BaseHttpClient *sharedClient = nil;
//一开始没有对象 因此指向nil
@implementation BaseHttpClient

#pragma mark -- 自定义构造方法
- (instancetype)initWithBaseURL:(NSString *)baseURL{
//需要传递一个baseURL 为了以后接口功能的拓展
    
    if (self = [super init]) {
        
        _baseURL = baseURL;
        
        _manager = [AFHTTPSessionManager manager];
        
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _manager.responseSerializer.acceptableContentTypes = [[NSSet alloc]initWithObjects:@"text/html",@"application/json", nil];
    }
    
    return self;
    
}

//实现单例方法
/*
 1.存在一个static修饰的指针 == nil
 2.存在一个返回值是当前类的加方法
 3.加方法内部 指针指向对象 对象的创建制只能有一次 最后将指针返回
 */
#pragma mark -- 单例方法
+ (BaseHttpClient *)sharedClient{
//  static BaseHttpClient *sharedClient = nil;
//    单例指针可以写在实现之上 也可以写在方法内部
    //使用GCD onceToken的方法 确保该方法中 对象只被创建一次
    static dispatch_once_t oneceToken;
    //onceToken 标记 一开始默认是0 执行一次变为1 下一次再执行 检查到标记已经改变 不再执行 保证某些代码片段只执行一次
    dispatch_once(&oneceToken, ^{
        //代码片段 只被执行一次
        
        sharedClient = [[self alloc]initWithBaseURL:BASE_URL];
        
        //self 在对象方法中 谁调用self就是谁 表示的是当前调用方法的对象
        //在类方法中  self表示当前类的类型
        
//        [[BaseHttpClient alloc]init];
        
        //Client对象被创建时 属性manager应该被创建并初始化 否则manager为空 无法进行网络请求
        
        
    });
    
    
    return sharedClient;
    
}

#pragma mark -- 公共的请求方法
+ (NSURL *)httpType:(BASE_HTTP_TYPE)type andURL:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucBlock andFailBlock:(httpFailBlock)failBlock{
    //1.检查当前的网络状态 如果没有网络 直接返回错误信息 如果有网络 判断type的值 分别调用相应的方法
    
    //2.if else 分别调用封装好的方法
    
    
    return nil;
}


#pragma mark -- GET 方法的封装

+ (NSURL *)requestGETWithURL:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucBlock andFailBlock:(httpFailBlock)failBlock{
    
    //先判断url是否为空 放到共有的方法中去判断
    
    //如果不为空 请求数据
    //数据解析回调
    
    //1.创建单例
    BaseHttpClient *client = [BaseHttpClient sharedClient];
    
    //2.拼接请求地址 服务器的地址+资源的文件路径
    
    NSString *signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL, url];
    
    //3.请求的合法化
    signUrl = [signUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *returnURL = [NSURL URLWithString:signUrl];
    
    
    //4.进行网络请求
    
    [client.manager GET:signUrl parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (responseObject == nil) {
            
            //数据请求失败
            NSError *error = [[NSError alloc]initWithDomain:@"网络请求数据为空!" code:9999 userInfo:nil];
            
            failBlock(returnURL, error);
            
        
        }else{
        
            
            //数据解析 可能是数组 也可能是字典
            
            
            //(1)JSON解析
            
            id obejct = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            
            //(2)由于成功的block回调参数本身就是id 因此具体是数组还是字典 可以由UI自己去判断
            
            sucBlock(returnURL, obejct);
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        failBlock(returnURL, error);
        
    }];
    
    
    
    return returnURL;
    
}






@end
