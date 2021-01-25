#import <Foundation/Foundation.h>

@interface ObjCExceptionCacher : NSObject

+ (BOOL)catchException:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end
