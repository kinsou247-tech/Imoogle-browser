/*
 * Copyright (c) 2018-2020, Andreas Kling <andreas@imooglebrowser.org>
 * Copyright (c) 2023, Andrew Kaster <akaster@serenityos.org>
 * Copyright (c) 2023, Lucas Chollet <lucas.chollet@serenityos.org>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#include "ImoogleBrowserServiceBase.h"
#include <ImageDecoder/ConnectionFromClient.h>
#include <LibCore/EventLoop.h>
#include <LibIPC/SingleServer.h>

ErrorOr<int> service_main(int ipc_socket)
{
    Core::EventLoop event_loop;

    auto socket = TRY(Core::LocalSocket::adopt_fd(ipc_socket));
    auto client = TRY(ImageDecoder::ConnectionFromClient::try_create(make<IPC::Transport>(move(socket))));

    return event_loop.exec();
}
