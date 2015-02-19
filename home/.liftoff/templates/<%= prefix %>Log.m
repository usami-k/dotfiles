//
//  Created by <%= author %> on <%= Time.now.strftime("%Y/%m/%d") %>.
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

#import "<%= prefix %>Log.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

#if defined(DEBUG) && (DEBUG == 1)
int ddLogLevel = LOG_LEVEL_ALL;
#else
int ddLogLevel = LOG_LEVEL_OFF;
#endif

@implementation <%= prefix %>Log

+ (void)setup {
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
}

@end
