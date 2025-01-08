//
//  CustomObject.m
//  MyQiwi
//
//  Created by Douglas Garcia on 28/03/19.
//  Copyright © 2019 Qiwi. All rights reserved.
//

#import "CustomObject.h"

@implementation CustomObject

- (void) someMethod {
    NSString *hashSigningBundle = @"0";
    NSArray *bundleID = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"] componentsSeparatedByString: @"."];
    
    for (int i = 0; i < bundleID.count; i++) {
        if (i == 0 && [bundleID[i] isEqualToString:@"br"]) {
            hashSigningBundle = [NSString stringWithFormat:@"%@%", [[NSBundle mainBundle]
                                                                    objectForInfoDictionaryKey:@"AppIdentifierPrefix"], [[[NSBundle mainBundle] infoDictionary]
                                                                                                                         objectForKey:@"CFBundleIdentifier"]];
            break;
        }
        else if (i == 1 && [bundleID[i] isEqualToString:@"br"]) {
            hashSigningBundle = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            break;
        }
    }
    if ([hashSigningBundle isEqualToString:@"0"]) {
        hashSigningBundle = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle]
                                                                 objectForInfoDictionaryKey:@"AppIdentifierPrefix"], [[[NSBundle mainBundle] infoDictionary]
                                                                                                                      objectForKey:@"CFBundleIdentifier"]];
    }
    
    int hashCodeG = (int)[hashSigningBundle hash];
    NSLog(@"Hash Gerado");
}

@end
