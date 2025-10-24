/*
 * Copyright (c) 2024, Andreas Kling <andreas@imooglebrowser.org>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#pragma once

#include <LibJS/Forward.h>
#include <LibWeb/Export.h>

namespace Web::WebIDL {

void log_trace(JS::VM& vm, char const* function);

WEB_API void set_enable_idl_tracing(bool enabled);

}
