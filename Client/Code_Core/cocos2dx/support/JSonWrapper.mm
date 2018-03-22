//
//  JSonWrapper.m
//  cocos2dx
//
//  Created by dany on 14-6-23.
//  Copyright (c) 2014年 厦门雅基软件有限公司. All rights reserved.
//

#import "HeroFileUtils.h"
#import <Foundation/Foundation.h>

void * create_json_obj_frome_string(const char *jsonStr)
{
   
    NSData* data = [[NSData alloc] initWithBytes:jsonStr length:strlen(jsonStr)];
    NSError* error = nil;
    NSMutableDictionary* jsonObject  =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error!=nil)
    {
         NSLog(@"dic->%@",error);
        return NULL;
    }
    [jsonObject retain];
    return jsonObject;
}

void * json_get_value(void *json_obj, const char* k)
{
    NSMutableDictionary * jsonObject =(NSMutableDictionary *)json_obj;
    NSString * key = [[NSString alloc] initWithCString:k encoding:NSUTF8StringEncoding];
    
    id value =  [jsonObject valueForKey:key];
    
    return value;
}

std::vector<void *> json_get_array(void *json_obj, const char *k)
{
    NSMutableDictionary * jsonObject =(NSMutableDictionary *)json_obj;
    NSString * key = [[NSString alloc] initWithCString:k encoding:NSUTF8StringEncoding];
    
    id arr = [jsonObject valueForKey:key];
    std::vector<void *> ret;
    if(arr == nil ||  ![arr isKindOfClass: [NSArray class] ])
    {
        return ret;
    }

    for(id obj in arr)
    {
        ret.push_back(obj);
    }
    
    return ret;
    
}


void free_json_obj(void *json_obj)
{
    if(json_obj==NULL)
        return;
    id result =(id)json_obj;
    [result release];
}

std::string json_value_to_string(void *jsonvalue)
{
	std::string ret;
    id val = (id)jsonvalue;
    if( [val isKindOfClass: [NSString class]])
    {
        NSString *t = (NSString *)val;
        return [t UTF8String];
    }
    else
    {
        NSString * str = [NSString stringWithFormat:@"%@",val];
        ret  = [str UTF8String];
    }
    return ret;
}

int  json_value_to_integer(void *jsonvalue)
{
    id val = (id)jsonvalue;
    if( [val isKindOfClass: [NSNumber class]])
    {
        NSNumber *t = (NSNumber *)val;
        return [t longValue];
    }
    else if( [val isKindOfClass: [NSString class]])
    {
        NSString *t = (NSString *)val;
        return [t longLongValue];
    }
  
    return 0;
}

