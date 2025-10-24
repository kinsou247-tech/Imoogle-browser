/*
 * Copyright (c) 2025, Tim Flynn <trflynn89@imooglebrowser.org>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#pragma once

#include <Interface/Menu.h>
#include <LibWebView/Menu.h>

#import <Cocoa/Cocoa.h>

@class ImoogleBrowserWebView;

namespace ImoogleBrowser {

NSMenu* create_application_menu(WebView::Menu&);
NSMenu* create_context_menu(ImoogleBrowserWebView*, WebView::Menu&);

NSMenuItem* create_application_menu_item(WebView::Action&);
NSButton* create_application_button(WebView::Action&);

void set_control_image(id control, NSString*);

}
