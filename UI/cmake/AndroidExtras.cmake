# Copyright (c) 2022, Andrew Kaster <akaster@serenityos.org>
#
# SPDX-License-Identifier: BSD-2-Clause
#

#
# Copy resources into tarball for inclusion in /assets of APK
#
set(IMOOGLE_BROWSER_RESOURCE_ROOT "${IMOOGLE_BROWSER_SOURCE_DIR}/Base/res")
macro(copy_res_folder folder)
    add_custom_target(copy-${folder}
        COMMAND ${CMAKE_COMMAND} -E copy_directory
            "${IMOOGLE_BROWSER_RESOURCE_ROOT}/${folder}"
            "asset-bundle/res/${folder}"
    )
    add_dependencies(archive-assets copy-${folder})
endmacro()
add_custom_target(archive-assets COMMAND ${CMAKE_COMMAND} -E chdir asset-bundle zip -r ../imooglebrowser-assets.zip ./ )
copy_res_folder(imooglebrowser)
copy_res_folder(fonts)
copy_res_folder(icons)
copy_res_folder(themes)
add_custom_target(copy-assets COMMAND ${CMAKE_COMMAND} -E copy_if_different imooglebrowser-assets.zip "${CMAKE_SOURCE_DIR}/UI/Android/src/main/assets/")
add_dependencies(copy-assets archive-assets)
add_dependencies(imooglebrowser copy-assets)
