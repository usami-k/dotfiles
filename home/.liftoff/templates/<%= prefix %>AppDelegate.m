//
//  Created by <%= author %> on <%= Time.now.strftime("%Y/%m/%d") %>.
//  Copyright (c) <%= Time.now.strftime('%Y') %> <%= company %>. All rights reserved.
//

#import "<%= prefix %>AppDelegate.h"
#import "<%= prefix %>Log.h"

@implementation <%= prefix %>AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [<%= prefix %>Log setup];
    return YES;
}

@end
