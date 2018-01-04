//
//  WebConnector.m
//  SQLExample
//
//  Created by Prerna on 5/15/15.
//  Copyright (c) 2015 Narola. All rights reserved.
//

#import "WebServiceConnector.h"
#import "WebServiceResponse.h"
#import "WebServiceDataAdaptor.h"
#import "NetworkAvailability.h"
#import "SVProgressHUD.h"
#define DEFAULT_TIMEOUT 3000.0f

@implementation WebServiceConnector
@synthesize responseArray,responseError,responseDict,responseCode,URLRequest;


- (BOOL)checkNetConnection
{
    return [[NetworkAvailability instance] isReachable];
}

-(void)init:(NSString *) WebService
                    withParameters:(NSDictionary *) ParamsDictionary
                        withObject:(id)object
                      withSelector:(SEL)selector
                    forServiceType:(NSString *)serviceType/* serviceType: {GET, POST, JSON} */
                    showDisplayMsg:(NSString *)message
{
    
    WebServiceResponse *server = [WebServiceResponse sharedMediaServer];
    ShowNetworkIndicator(YES);
    responseCode = 100;
    responseError = [[NSString alloc]init];
    responseArray = [[NSArray alloc]init];
    if([serviceType isEqualToString:@"GET"])
    {
        URLRequest = [self getMutableRequestFromGetWS:WebService withParams:ParamsDictionary];
    }
    else if([serviceType isEqualToString:@"POST"])
    {
        URLRequest = [self getMutableRequestForPostWS:WebService withObjects:ParamsDictionary isJsonBody:NO];
    }
    else if([serviceType isEqualToString:@"JSON"])
    {
        URLRequest = [self getMutableRequestForPostWS:WebService withObjects:ParamsDictionary isJsonBody:YES];
    }

    if (![self checkNetConnection])
    {
        responseCode = 104;
        self.responseError = @"The network connection was lost.";
        [object performSelectorOnMainThread:selector withObject:self waitUntilDone:false];
        return;
    }
    //[SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeBlack];

    [server initWithWebRequests:URLRequest inBlock:^(NSError *error, id objects, NSString *responseString)
     {
         if (error)
         {
             responseCode = 101;
             self.responseError = error.localizedDescription;
         }
         else
         {
             if ([responseString isEqualToString:@"Fail"])
             {
                 responseCode = 102;
                 self.responseError = @"Response Issue From Server";
             }
             else if ([responseString isEqualToString:@"Not Available"])
             {
                 responseCode = 103;
                 self.responseError = @"No Data Available";
                 ShowNetworkIndicator(NO);
             }
             else
             {
                 responseCode = 100;
                 responseDict = (NSDictionary *) objects;
                 responseArray = [[WebServiceDataAdaptor alloc]autoParse:responseDict forServiceName:WebService];

                 ShowNetworkIndicator(NO);
             }
         }
         [SVProgressHUD dismiss];
         [object performSelectorOnMainThread:selector withObject:self waitUntilDone:false];
     }
     ];
}

#pragma mark - generate URL Methods
///*** this method can be used when there is cake php webservice ***/
//-(NSString *) getNetURLFromService:(NSString *) WebService withParams: (NSArray *) ParamsArray
//{
//    NSString *Query = WebService;
//    if(ParamsArray == nil)
//        return nil;
//    
//    for(int i = 0;i<[ParamsArray count];i++)
//    {
//        NSString *appendString = [NSString stringWithFormat:@"/%@",[ParamsArray objectAtIndex:i]];
//        Query = [Query stringByAppendingString:appendString];
//    }
//    return Query;
//}

/*** this method can be used when parameters are to be sent as query string ***/
-(NSMutableURLRequest *) getMutableRequestFromGetWS:(NSString *)WebService withParams: (NSDictionary *) ParamsDictionary
{
//   TraceWS(WebService,ParamsDictionary,@"GET")
    NSString *Query;
    
    if(ParamsDictionary == nil)
    {
        Query = WebService;
    }
    else
    {
        int i = 0;
        Query = WebService;
        for(id key in ParamsDictionary)
        {
            NSString *appendString = @"";
            if(i != ParamsDictionary.count - 1)
                appendString = [appendString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[ParamsDictionary objectForKey:key]] ];
            else
                appendString = [appendString stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,[ParamsDictionary objectForKey:key]] ];
            Query = [Query stringByAppendingString:appendString];
            i++;
        }
    }
    Query = [Query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:Query]
                                    cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                    timeoutInterval:DEFAULT_TIMEOUT];

    return request;
}

- (NSMutableURLRequest *)getMutableRequestForPostWS:(NSString *)url withObjects:(NSDictionary *)dict isJsonBody:(bool)JSONBody
{
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[NSURL URLWithString:urlString]
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:DEFAULT_TIMEOUT];
    NSData *objData;
    if (JSONBody)
    {
        //TraceWS(url,dict,@"JSON")
        objData = [self dictionaryToJSONData:dict];
        NSDictionary *headers = @{ @"content-type": @"application/json",
                                   @"accept": @"application/json" };
        [request setAllHTTPHeaderFields:headers];
    }
    else
    {
        //TraceWS(url,dict,@"POST")
        objData = [self dictionaryToPostData:dict];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    [request addValue:[NSString stringWithFormat:@"%lu", (unsigned long)[objData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:objData];
    return request;
}

- (void)uploadMultipleImageInSingleRequestForURL:(NSString *)URL
                                  WithParameters:(NSDictionary *)dicParameters
                                     withImageDictionary:(NSDictionary *)dicImages
                                            withSelector:(SEL)selector
                                              withObject:(id)object
                                  showDisplayMsg:(NSString *)message
{
    // dicParameters contains other parameters
    // dicImages contains multiple image data as value and a image name as key
    WebServiceResponse *server = [WebServiceResponse sharedMediaServer];
    ShowNetworkIndicator(YES);
    responseCode = 100;
    responseError = [[NSString alloc]init];
    responseArray = [[NSArray alloc]init];
    NSString *urlString = URL; // an url where the request to be posted
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] initWithURL:url] ;
    
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postbody = [NSMutableData data];
    NSString *postData = [self getHTTPBodyParamsFromDictionary:dicParameters boundary:boundary];
    [postbody appendData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    [dicImages enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         if(obj != nil)
         {
             [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
             [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"PostedImage_%@\"; filetype=\"image/png\"; filename=\"%@\"\r\n", key,key] dataUsingEncoding:NSUTF8StringEncoding]];
             [postbody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
             [postbody appendData:[NSData dataWithData:obj]];
         }
     }];
    
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    URLRequest = request;
    
    if (![self checkNetConnection])
    {
        responseCode = 104;
        self.responseError = @"The network connection was lost.";
        [object performSelectorOnMainThread:selector withObject:self waitUntilDone:false];
        return;
    }
    [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
    
    
    [server initWithWebRequests:URLRequest inBlock:^(NSError *error, id objects, NSString *responseString)
        {
         if (error)
         {
             responseCode = 101;
             self.responseError = error.localizedDescription;
         }
         else
         {
             if ([responseString isEqualToString:@"Fail"])
             {
                 responseCode = 102;
                 self.responseError = @"Response Issue From Server";
             }
             else if ([responseString isEqualToString:@"Not Available"])
             {
                 responseCode = 103;
                 self.responseError = @"No Data Available";
                 ShowNetworkIndicator(NO);
             }
             else
             {
                 responseCode = 100;
                 responseDict = (NSDictionary *) objects;
                 responseArray = [[WebServiceDataAdaptor alloc]autoParse:responseDict forServiceName:URL_AddStore];
                 
                 ShowNetworkIndicator(NO);
             }
         }
         [SVProgressHUD dismiss];
         [object performSelectorOnMainThread:selector withObject:self waitUntilDone:false];
        }
     ];
}


-(NSString *) getHTTPBodyParamsFromDictionary: (NSDictionary *)params boundary:(NSString *)boundary
{
    NSMutableString *tempVal = [[NSMutableString alloc] init];
    for(NSString * key in params)
    {
        [tempVal appendFormat:@"\r\n--%@\r\n", boundary];
        [tempVal appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key,[params objectForKey:key]];
    }
    return [tempVal description];
}


#pragma mark - helper methods

-(NSData *)dictionaryToJSONData:(NSDictionary *)dict
{
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithDictionary:dict] options:0 error:&jsonError];
    if (jsonError!=nil)
    {
        return nil;
    }
    return jsonData;
}

-(NSData *) dictionaryToPostData:(NSDictionary *) ParamsDictionary
{
    int i = 0;
    NSString *postDataString = @"";
    for(id key in ParamsDictionary)
    {
        if(i != ParamsDictionary.count - 1)
            postDataString = [postDataString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,[ParamsDictionary objectForKey:key]]];
        else
            postDataString = [postDataString stringByAppendingString:[NSString stringWithFormat:@"%@=%@",key,[ParamsDictionary objectForKey:key]]];
        i++;
    }
    return [postDataString dataUsingEncoding:NSUTF8StringEncoding];
}

@end
