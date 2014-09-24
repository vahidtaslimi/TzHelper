#import <sqlite3.h>
#import "SHACity.h"
#import "SHADatabaseStorageHelper.h"
static sqlite3 *database = nil;

@implementation SHADatabaseStorageHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self openDB];
    }
    return self;
}
#pragma mark - Init and preparation methods

-(NSString *) filePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory=[paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"Cities.sqlite"];
}

-(void)openDB
{
    [self checkAndCreateDatabase];
    if(sqlite3_open([[self filePath]UTF8String], &database) !=SQLITE_OK)
    {
        sqlite3_close(database);
        NSAssert(0, @"Database failed to Open");
    }
}

-(void) checkAndCreateDatabase
{
    // Check if the SQL database has already been saved to the users phone, if not then copy it over
    BOOL success;
    NSString* _databasePath = [self filePath];
    NSString* _databaseName = @"Cities.sqlite";
    // Create a FileManager object, we will use this to check the status
    // of the database and to copy it over if required
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Check if the database has already been created in the users filesystem
    success = [fileManager fileExistsAtPath:_databasePath];
    
    // If the database already exists then return without doing anything
    if(success) return;
    
    // If not then proceed to copy the database from the application to the users filesystem
    
    // Get the path to the database in the application package
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_databaseName];
    
    // Copy the database from the package to the users filesystem
    [fileManager copyItemAtPath:databasePathFromApp toPath:_databasePath error:nil];
    
}

- (void)dealloc
{
    if(database)
    {
        sqlite3_close(database);
    }
}

#pragma mark - Public Methods
-(NSMutableArray*)getCities
{
    NSMutableArray* cities = [[NSMutableArray alloc] init];
      //char *errMsg;
        const char *getSql = "SELECT name,timezonename,identifier FROM cities order by name";
    sqlite3_stmt *getStmt;
    
    if(sqlite3_prepare_v2(database, getSql, -1, &getStmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(getStmt) == SQLITE_ROW) {
                SHACity *city = [[SHACity alloc] init];
                city.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(getStmt, 0)];
                city.timeZoneName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(getStmt, 1)];
                city.cityId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(getStmt, 2)];
                city.timeZone=[NSTimeZone timeZoneWithName:city.timeZoneName];
                [cities addObject:city];
            }
        sqlite3_finalize(getStmt);
    }
    
    return cities;
}

@end
