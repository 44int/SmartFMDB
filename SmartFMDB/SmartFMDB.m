//
//  SmartFMDB.m
//  SmartFMDB
//
//  Created by 進藤こだま on 2013/05/21.
//  Copyright (c) 2013年 kodam. All rights reserved.
//

#import "SmartFMDB.h"

@implementation SmartFMDB

// Creates a writable copy of the bundled default database in the application Documents directory.
+ (void)createEditableCopyOfDatabaseIfNeeded
{
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *writableDBPath = [NSHomeDirectory() stringByAppendingPathComponent:
								[NSString stringWithFormat:@"Documents/%@",DEFAULT_DB_FILE]
								];
    success = [fileManager fileExistsAtPath:writableDBPath];

    if (success) return;
	
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DEFAULT_DB_FILE];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

+(NSString*)defalutdbpath
{
    NSString *writableDBPath = [NSHomeDirectory() stringByAppendingPathComponent:
								[NSString stringWithFormat:@"Documents/%@",DEFAULT_DB_FILE]];
	return writableDBPath;
}

#pragma mark - デフォルトのDBに対してクエリを発行する
+(NSArray*)query:(NSString*)query
{
	return [SmartFMDB query:query dbPath:[SmartFMDB defalutdbpath]];
}

#pragma mark - DBのパスを指定してクエリを発行する
+(NSArray*)query:(NSString*)query dbPath:(NSString*)dbPath
{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	FMDatabase *db  = [FMDatabase databaseWithPath:dbPath];
	
	if (![db open]) {
		[NSException raise:@"FileOpenException" format:@"DBerror:Couldn't open specified db file:%@",dbPath];
	}
	
	FMResultSet *results = [db executeQuery:query];
	
	while ([results next]) {
		[result addObject:[SmartFMDB ResultToDict:results]];
    }
	
	[results close];
	
	if([db hadError]){
		NSString *error = [NSString stringWithString:[[db lastError] description]];
		[db close];
		
		[NSException raise:@"ExecuteException"
					format:@"Error:%@\nQuery:%@",error,query];
	}
	
	[db close];
	
	return (NSArray*)result;
}

#pragma mark - 高速化されますが、updateもしくはinsertなど、結果を求めないクエリーに限ります
+(BOOL)quickQuery:(NSArray*)querys
{
	return [SmartFMDB quickQuery:querys dbPath:[SmartFMDB description]];
}

#pragma mark - 高速化されますが、updateもしくはinsertなど、結果を求めないクエリーに限ります
+(BOOL)quickQuery:(NSArray*)querys dbPath:(NSString*)dbPath{
	FMDatabase *db  = [FMDatabase databaseWithPath:dbPath];
	
	[db open];
	[db beginTransaction];
	
	BOOL isSucceeded = YES;
	for( NSString* query in querys ){
		if( ![db executeUpdate:query] ){
			NSLog(@"DBerror:%@\nQuery:%@",[[db lastError] description],query);
			isSucceeded = NO;
			break;
		}
	}
	
	if(isSucceeded){
		[db commit];
	}else{
		[db rollback];
	}
	
	[db close];
	return isSucceeded;
}

#pragma mark - テーブルを空にする
+(void)truncateTable:(NSString*)table{
	[SmartFMDB truncateTable:table dbPath:[SmartFMDB defalutdbpath]];
}

+(void)truncateTable:(NSString*)table dbPath:(NSString*)dbPath{
	//テーブルを空にする
	[SmartFMDB query:[NSString stringWithFormat:@"DELETE FROM %@",table] dbPath:dbPath];
	
	//autoincrementの値を初期化する
	[SmartFMDB query:[NSString stringWithFormat:@"UPDATE sqlite_sequence SET seq=1 WHERE name='%@'",table] dbPath:dbPath];
}

#pragma mark - FMResultSetからDictionary形式に変換する
+(NSDictionary*)ResultToDict:(FMResultSet*)resultSet
{
	NSDictionary *result = [NSMutableDictionary dictionary];
	for (int i=0; i<[resultSet columnCount]; i++) {
		[result setValue:[resultSet objectForColumnIndex:i] forKey:[resultSet columnNameForIndex:i]];;
	}
	return result;
}

#pragma mark - SQLiteのエスケープ処理
+(id)dq:(id)val
{
	if(![val isKindOfClass:[NSString class]]) return val;
	
	NSArray *targets = [NSArray arrayWithObjects:
						@"\x00",@"\x01",@"\x27",nil];
	NSArray *replaceds = [NSArray arrayWithObjects:
						  @"\x01\x01",@"\x01\x02",@"\x27\x27",nil];
	NSString *query = [NSString stringWithString:val];
	for (int i=0; i<[targets count]; i++) {
		query = [query stringByReplacingOccurrencesOfString:[targets objectAtIndex:i]
												 withString:[replaceds objectAtIndex:i]];
	}
	return query;
}
@end
