//
//  TTApiClient.h
//
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


static NSString *const TTConnectErrorDomain = @"TTConnectErrorDomain";
static NSString *const TTNetworkError = @"TTNetworkError";

typedef NS_ENUM(NSInteger, TTConnectErrorType) {
    TTConnectErrorTypeUnknown = 0,
    TTConnectErrorTypeInvalidParameters = 400,
    TTConnectErrorTypeUnauthorize = 401,
    TTConnectErrorTypeForbidden = 403,
    TTConnectErrorTypeNotFound = 404,
    TTConnectErrorTypeServerErro = 500
};

#define kMESSAGE @"message"
#define kUNKNOW_ERROR LSTR(@"Unknow_Error")

//#if DEBUG
    #define API_BASE_URL  @"https://
//#endif

/// -----------API base url
#define API_WALLPAPERS     @"wallpapers"

//// ----- API  url
#define GET_NEWS_LIST_URL @"https://weatherliving.com/api/posts"

@interface TTApiClient : AFHTTPSessionManager

+ (TTApiClient *)sharedClient;

//Wallpapers
- (void)getWallsWithHandler:(void(^)(NSDictionary *resutl, NSError *error))handler;


//Cancel operation(old)
- (void)cancelAllHTTPOperationsWithPath:(NSString *)path;


@end
