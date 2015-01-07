//
//  GRAdobeThemeFrameOverrides.h
//  NativeFullscreen
//
//  Created by Guilherme Rambo on 07/01/15.
//  Copyright (c) 2015 Guilherme Rambo. All rights reserved.
//

// Code based on my GRProKit project: https://github.com/insidegui/GRProKit/tree/GRProKit2

#import "GRProTitlebarView.h"

@interface GRAdobeThemeFrame : NSThemeFrame

- (id)_makeTitlebarViewWithFrame:(NSRect)frameRect;
- (NSColor *)_currentTitleColor;
- (NSTextField *)_titleTextField;

@end
