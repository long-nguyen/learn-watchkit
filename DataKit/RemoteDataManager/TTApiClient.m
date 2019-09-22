//
//  TTApiClient.m
//  
//
//

#import "TTApiClient.h"
#import "RNEncryptor.h"


@implementation TTApiClient

static TTApiClient *_client = nil;

+ (TTApiClient *)sharedClient
{
    if (_client == nil)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _client = [[TTApiClient alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
        });
    }
    return _client;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url])
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

/**
 * This method is to process uncatchable error(may be connection error or error which server can not catch)
 */
- (void)processNetworkError:(NSError *)error handle:(void(^)(NSDictionary *result, NSError *error))handler{
    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    NSInteger statusCode = response.statusCode;
    NSError *err = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:error.userInfo];
    //Error message(by server throwing Exception)
    if ([[err localizedDescription] isEqualToString:@"cancelled"]) {
        return;
    }
    
    NSString *errMsg;
    switch (statusCode) {
        case 400:
            errMsg = LSTR(@"Error_InvalidParameters");
            break;
        case 403:
            errMsg = LSTR(@"Error_Forbdden");
            break;
        case 404:
            errMsg = LSTR(@"Error_Weather_Not_Found");
            break;
        case 500:
            errMsg = LSTR(@"Error_Internal_Server");
            break;
        default:
            errMsg = kUNKNOW_ERROR;
            break;
    }
    NSDictionary *errorData = @{kMESSAGE : errMsg};
    
    if (handler) {
        handler(nil, [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:errorData]);
    }
}

/*
 * Process error response from our server, with server-defined error code
 * It will translate error message for each country, otherwise, show default message
 */
- (void)processErrorResponse:(NSDictionary *)error handle:(void(^)(NSDictionary *result, NSError *error))handler
{
    NSString *msg = error[kMESSAGE];
    int errorCode = [error[@"code"] intValue];
    switch (errorCode) {
        case 2:
            msg = LSTR(@"Error_Location_Not_Supported");
        break;
        case 3:
        case 4:
            msg = LSTR(@"Error_Forbdden");
            break;
        case 1:
        case 5:
            msg = LSTR(@"No_Connection_Description");
            break;
    }
    if (msg == nil || [msg length] == 0) {
        msg = kUNKNOW_ERROR;
    }
    NSDictionary *errorData = @{kMESSAGE : msg};
    
    if (handler) {
        handler(nil, [NSError errorWithDomain:NSURLErrorDomain code:errorCode userInfo:errorData]);
    }
}

//This process both success and error case
- (void)processResponse:(id)responseObject handle:(void(^)(NSDictionary *result, NSError *error))handler
{
    if (handler) {
        NSDictionary *rpDict = responseObject;
//        LOG(@"response %@",rpDict);
        if ([[rpDict allKeys] containsObject:@"data"]) {
            //Success message
            handler(rpDict, nil);
        } else if ([[rpDict allKeys] containsObject:@"error"]) {
            //Error message
            NSDictionary *errorResponse = rpDict[@"error"];
            [self processErrorResponse:errorResponse handle:handler];
        } else {
            //Unknown message
            NSDictionary *erorrInfo = @{kMESSAGE : kUNKNOW_ERROR};
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:TTConnectErrorTypeUnknown userInfo:erorrInfo];
            handler(nil, error);
        }
    }
}

#pragma mark - API Request



- (void)getWallsWithHandler:(void(^)(NSDictionary *resutl, NSError *error))handler
{
    PREPARE_SELF;
    TTAsync(^{
        [SELF GET:API_WALLPAPERS parameters:nil progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            //Get server response
            TTAsyncMain(^{
                [SELF processResponse:responseObject handle:handler];
            });
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            //No server response, error
            TTAsyncMain(^{
                [self processNetworkError:error handle:handler];
            });
        }];
    });
}

- (void)cancelAllHTTPOperationsWithPath:(NSString *)path
{
    [[self session] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        [self cancelTasksInArray:dataTasks withPath:path];
        [self cancelTasksInArray:uploadTasks withPath:path];
        [self cancelTasksInArray:downloadTasks withPath:path];
    }];
}

- (void)cancelTasksInArray:(NSArray *)tasksArray withPath:(NSString *)path
{
    for (NSURLSessionTask *task in tasksArray) {
        NSRange range = [[[[task currentRequest]URL] absoluteString] rangeOfString:path];
        if (range.location != NSNotFound) {
            [task cancel];
        }
    }
}
@end
