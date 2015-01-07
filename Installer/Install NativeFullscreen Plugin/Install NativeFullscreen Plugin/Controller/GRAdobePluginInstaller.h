//
//  GRAdobePluginInstaller.h
//  Install NativeFullscreen Plugin
//
//  Created by Guilherme Rambo on 07/01/15.
//  Copyright (c) 2015 Guilherme Rambo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRAdobePluginInstaller : NSObject

+ (instancetype)installer;

@property (readonly) BOOL isAlreadyInstalled;

- (BOOL)hasCreativeSuiteAndOrCreativeCloudInstalled;

- (void)installWithCompletionHandler:(void(^)(NSError *error))callback;
- (void)uninstallWithCompletionHandler:(void(^)(NSError *error))callback;

@end
