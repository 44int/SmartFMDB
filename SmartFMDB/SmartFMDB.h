//
//  SmartFMDB.h
//  SmartFMDB
//
//  Created by 進藤こだま on 2013/05/21.
//  Copyright (c) 2013年 kodam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define DEFAULT_DB_FILE @"Books.sqlite"

@interface SmartFMDB : NSObject

+(void)createEditableCopyOfDatabaseIfNeeded;
+(NSString*)defalutdbpath;

+(NSArray*)query:(NSString*)query;
+(NSArray*)query:(NSString*)query dbPath:(NSString*)dbPath;
+(BOOL)quickQuery:(NSArray*)querys;
+(BOOL)quickQuery:(NSArray*)querys dbPath:(NSString*)dbPath;

//+(id)g:(NSString*)query;
//+(id)g:(NSString*)query dbPath:(NSString*)dbPath;
//+(NSArray*)gAll:(NSString*)query;
//+(NSArray*)gAll:(NSString*)query dbPath:(NSString*)dbPath;
//+(NSDictionary*)get:(NSString*)query;
//+(NSDictionary*)get:(NSString*)query dbPath:(NSString*)dbPath;
//+(NSArray*)getAll:(NSString*)query;
//+(NSArray*)getAll:(NSString*)query dbPath:(NSString*)dbPath;
//
//+(void)put:(NSString*)table data:(NSDictionary*)data;
//+(void)put:(NSString*)table key:(NSString*)key data:(NSDictionary*)data;
//+(void)put:(NSString*)table keys:(NSArray*)keys data:(NSDictionary*)data;
//+(void)quickPut:(NSString*)table datas:(NSArray*)datas dbPath:(NSString*)dbPath;
//+(void)quickPut:(NSString*)table datas:(NSArray*)datas;
//+(void)quickPut:(NSString*)table key:(NSString*)key datas:(NSArray*)datas;
//+(void)quickPut:(NSString*)table keys:(NSArray*)keys datas:(NSArray*)datas;
//
//+(void)insert:(NSString*)table data:(NSDictionary*)data;
//+(BOOL)quickInsert:(NSString*)table datas:(NSArray*)datas;
//+(BOOL)quickInsert:(NSString*)table datas:(NSArray*)datas dbPath:(NSString*)dbPath;
//
//+(void)update:(NSString*)table key:(NSString*)key data:(NSDictionary*)data;
//+(void)update:(NSString*)table keys:(NSArray*)keys data:(NSDictionary*)data;
//+(BOOL)quickUpdate:(NSString*)table key:(NSString*)key datas:(NSArray*)datas;
//+(BOOL)quickUpdate:(NSString*)table keys:(NSArray*)keys datas:(NSArray*)datas;

+(void)truncateTable:(NSString*)table;
+(void)truncateTable:(NSString*)table dbPath:(NSString*)dbPath;

+(NSDictionary*)ResultToDict:(FMResultSet*)resultSet;
+(id)dq:(id)val;
@end
