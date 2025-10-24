/*
 * Copyright (c) 2024, Luke Wilde <luke@imooglebrowser.org>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include <LibWeb/ContentSecurityPolicy/Directives/ReportToDirective.h>

namespace Web::ContentSecurityPolicy::Directives {

GC_DEFINE_ALLOCATOR(ReportToDirective);

ReportToDirective::ReportToDirective(String name, Vector<String> value)
    : Directive(move(name), move(value))
{
}

}
