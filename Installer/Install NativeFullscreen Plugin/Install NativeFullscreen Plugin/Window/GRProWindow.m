//
//  GRProWindow.m
//  Install NativeFullscreen Plugin
//
//  Created by Guilherme Rambo on 07/01/15.
//  Copyright (c) 2015 Guilherme Rambo. All rights reserved.
//

#import "GRProWindow.h"
#import "GRProTheme.h"
#import "GRAdobeThemeFrame.h"

@implementation GRProWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    if (!(self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag])) return nil;
    
    self.backgroundColor = [GRProTheme defaultTheme].windowBackgroundColor;
    
    return self;
}

+ (Class)frameViewClassForStyleMask:(NSUInteger)aStyle
{
    return [GRAdobeThemeFrame class];
}

- (BOOL)_usesCustomDrawing
{
    return NO;
}

@end
