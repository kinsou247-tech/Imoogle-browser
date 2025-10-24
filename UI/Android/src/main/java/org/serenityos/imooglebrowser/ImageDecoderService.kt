/**
 * Copyright (c) 2023, Andrew Kaster <akaster@serenityos.org>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

package org.serenityos.imooglebrowser

import android.os.Message

class ImageDecoderService : ImoogleBrowserServiceBase("ImageDecoderService") {
    override fun handleServiceSpecificMessage(msg: Message): Boolean {
        return false
    }

    companion object {
        init {
            System.loadLibrary("imagedecoderservice")
        }
    }
}
