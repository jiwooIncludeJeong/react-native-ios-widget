#import <Foundation/Foundation.h>
#import "NativeUserDefault.h"

@implementation NativeUserDefault

-(dispatch_queue_t)methodQueue {
  return dispatch_get_main_queue();
}
 
RCT_EXPORT_MODULE(NativeUserDefault);

RCT_EXPORT_METHOD(set:(NSString *)data
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  @try{
    NSUserDefaults *shared = [[NSUserDefaults alloc]initWithSuiteName:@"group.react.native.widget.example"];
    [shared setObject:data forKey:@"data"];
    [shared synchronize];
    if (@available(iOS 14, *)) {
//       [WidgetKitHelper reloadAllTimelines];
     } else {
         // Fallback on earlier versions
     }
    resolve(@"true");
  }@catch(NSException *exception){
    reject(@"get_error",exception.reason, nil);
  }

}

@end
