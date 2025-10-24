/*
 * Copyright (c) 2024, Tim Flynn <trflynn89@imooglebrowser.org>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#pragma once

#import <Cocoa/Cocoa.h>

@class ImoogleBrowserWebView;

@interface ImoogleBrowserWebViewWindow : NSWindow

- (instancetype)initWithWebView:(ImoogleBrowserWebView*)web_view
                     windowRect:(NSRect)window_rect;

@property (nonatomic, strong) ImoogleBrowserWebView* web_view;

@end
