//
//  Created by <%= author %> on <%= Time.now.strftime("%Y/%m/%d") %>.
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

#import "DDLog.h"

extern int ddLogLevel;

@interface <%= prefix %>Log : NSObject
+ (void)setup;
@end
