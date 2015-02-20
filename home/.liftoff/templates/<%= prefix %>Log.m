//
//  Created by <%= author %> on <%= Time.now.strftime("%Y/%m/%d") %>.
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

#import "<%= prefix %>Log.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

int ddLogLevel;

@implementation <%= prefix %>Log

+ (void)setup {
#if defined(DEBUG) && (DEBUG == 1)
    ddLogLevel = LOG_LEVEL_VERBOSE;
#else
    ddLogLevel = LOG_LEVEL_OFF;
#endif
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
}

@end
