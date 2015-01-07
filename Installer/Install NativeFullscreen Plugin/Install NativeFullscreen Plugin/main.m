//
//  main.m
//  Install NativeFullscreen Plugin
//
//  Created by Guilherme Rambo on 07/01/15.
//  Copyright (c) 2015 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, const char * argv[]) {
    [[NSUserDefaults standardUserDefaults] setVolatileDomain:@{@"AppleAquaColorVariant": @6} forName:NSArgumentDomain];
    
    return NSApplicationMain(argc, argv);
}
