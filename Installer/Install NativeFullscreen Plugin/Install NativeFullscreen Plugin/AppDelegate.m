//
//  AppDelegate.m
//  Install NativeFullscreen Plugin
//
//  Created by Guilherme Rambo on 07/01/15.
//  Copyright (c) 2015 Guilherme Rambo. All rights reserved.
//

#import "AppDelegate.h"
#import "GRAdobePluginInstaller.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSButton *uninstallButton;
@property (weak) IBOutlet NSTextField *infoLabel;
@property (weak) IBOutlet NSButton *installButton;
@property (weak) IBOutlet NSButton *updateButton;

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if ([[GRAdobePluginInstaller installer] hasCreativeSuiteAndOrCreativeCloudInstalled]) {
        if (![GRAdobePluginInstaller installer].isAlreadyInstalled) {
            self.infoLabel.stringValue = @"Press \"install\" to install NativeFullscreen for Premiere, After Effects, Media Encoder and SpeedGrade.";
            self.uninstallButton.hidden = YES;
            self.updateButton.hidden = YES;
        } else {
            self.installButton.hidden = YES;
        }
    } else {
        self.uninstallButton.hidden = YES;
        self.updateButton.hidden = YES;
        self.installButton.hidden = NO;
        self.installButton.title = @"Quit";
        self.installButton.target = [NSApplication sharedApplication];
        self.installButton.action = @selector(terminate:);
        self.infoLabel.stringValue = @"It looks like you don't have Adobe CS6 or CC installed.";
    }
    
    [self.window center];
    [self.window makeKeyAndOrderFront:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)uninstallAction:(id)sender {
    [[GRAdobePluginInstaller installer] uninstallWithCompletionHandler:^(NSError *error) {
        if (error) {
            [[NSAlert alertWithError:error] runModal];
        } else {
            [self showUninstallSuccess];
        }
    }];
}

- (IBAction)installAction:(id)sender {
    [[GRAdobePluginInstaller installer] installWithCompletionHandler:^(NSError *error) {
        if (error) {
            [[NSAlert alertWithError:error] runModal];
        } else {
            [self showInstallSuccess];
        }
    }];
}

- (IBAction)updateAction:(id)sender {
    [[GRAdobePluginInstaller installer] uninstallWithCompletionHandler:^(NSError *error) {
        if (error) {
            [[NSAlert alertWithError:error] runModal];
        } else {
            [[GRAdobePluginInstaller installer] installWithCompletionHandler:^(NSError *error) {
                if (error) {
                    [[NSAlert alertWithError:error] runModal];
                } else {
                    [self showUpdateSuccess];
                }
            }];
        }
    }];
}

- (void)showInstallSuccess
{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Success!";
    alert.informativeText = @"NativeFullscreen installed successfully!";
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
    [NSApp terminate:nil];
}

- (void)showUninstallSuccess
{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Uninstalled";
    alert.informativeText = @"NativeFullscreen removed successfully!";
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
    [NSApp terminate:nil];
}

- (void)showUpdateSuccess
{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = @"Updated";
    alert.informativeText = @"NativeFullscreen updated successfully!";
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
    [NSApp terminate:nil];
}

@end
