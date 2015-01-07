//
//  GRAdobePluginInstaller.m
//  Install NativeFullscreen Plugin
//
//  Created by Guilherme Rambo on 07/01/15.
//  Copyright (c) 2015 Guilherme Rambo. All rights reserved.
//

#import "GRAdobePluginInstaller.h"

@implementation GRAdobePluginInstaller

+ (instancetype)installer
{
    static GRAdobePluginInstaller *_instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[GRAdobePluginInstaller alloc] init];
    });
    
    return _instance;
}

- (NSString *)payloadName
{
    return @"NativeFullscreen.plugin";
}

- (NSString *)payloadPath
{
    return [[[NSBundle mainBundle] builtInPlugInsPath] stringByAppendingPathComponent:[self payloadName]];
}

- (NSArray *)targetPaths
{
    return @[@"/Library/Application Support/Adobe/Common/Plug-ins/7.0/MediaCore",
             @"/Library/Application Support/Adobe/Common/Plug-ins/CS6/MediaCore"];
}

- (BOOL)hasCreativeSuiteAndOrCreativeCloudInstalled
{
    for (NSString *path in [self targetPaths]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    return NO;
}

- (BOOL)isAlreadyInstalled
{
    for (NSString *path in [self targetPaths]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:[self payloadName]]]) return YES;
    }
    
    return NO;
}

- (void)installWithCompletionHandler:(void (^)(NSError *))callback
{
    NSString *source = [self payloadPath];
    
    NSError *outError = nil;
    
    for (NSString *targetPath in [self targetPaths]) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) continue;
        
        NSString *destination = [targetPath stringByAppendingPathComponent:[self payloadName]];
        NSError *error;
        if (![[NSFileManager defaultManager] copyItemAtPath:source toPath:destination error:&error]) {
            outError = error;
            break;
        }
    }
    
    callback(outError);
}

- (void)uninstallWithCompletionHandler:(void (^)(NSError *))callback
{
    NSError *outError = nil;
    
    for (NSString *targetPath in [self targetPaths]) {
        NSString *installedItemPath = [targetPath stringByAppendingPathComponent:[self payloadName]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:installedItemPath]) continue;
        
        NSError *error;
        if (![[NSFileManager defaultManager] removeItemAtPath:installedItemPath error:&error]) {
            outError = error;
            break;
        }
    }
    
    callback(outError);
}

@end
