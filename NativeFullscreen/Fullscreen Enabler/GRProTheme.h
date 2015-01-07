//
//  GRProTheme.h
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

// Code based on my GRProKit project: https://github.com/insidegui/GRProKit/tree/GRProKit2

@import Cocoa;

@interface GRProTheme : NSObject <NSCoding>

+ (instancetype)defaultTheme;

@property (nonatomic, copy) NSColor *windowBackgroundColor;
@property (nonatomic, copy) NSColor *titlebarGradientColor1;
@property (nonatomic, copy) NSColor *titlebarGradientColor2;
@property (nonatomic, copy) NSColor *titlebarSeparatorColor;
@property (nonatomic, copy) NSColor *titlebarTextColor;

- (void)drawTitleBarBackgroundInRect:(NSRect)rect forView:(NSView *)view;

@end
