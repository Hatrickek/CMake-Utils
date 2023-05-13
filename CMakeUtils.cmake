# Get all the child targets in 'dir'
function(get_all_targets var dir)
    set(targets)
    get_all_targets_recursive(targets ${dir})
    set(${var} ${targets} PARENT_SCOPE)
endfunction()

macro(get_all_targets_recursive targets dir)
    get_property(subdirectories DIRECTORY ${dir} PROPERTY SUBDIRECTORIES)
    foreach(subdir ${subdirectories})
        get_all_targets_recursive(${targets} ${subdir})
    endforeach()

    get_property(current_targets DIRECTORY ${dir} PROPERTY BUILDSYSTEM_TARGETS)
    list(APPEND ${targets} ${current_targets})
endmacro()

# Folder '_target'.
function(folder_dir_targets _target)
    get_target_property(TARGET_SOURCE_DIR ${_target} SOURCE_DIR)
    get_all_targets(targets ${TARGET_SOURCE_DIR})
    set_target_properties(${targets} PROPERTIES FOLDER "Vendor/${_target}")
endfunction()

# Get all the child targets and set them all as static. (MSVC)
function(set_targets_static _target)
    get_target_property(TARGET_SOURCE_DIR ${_target} SOURCE_DIR)
    get_all_targets(targets ${TARGET_SOURCE_DIR})
    set_target_properties(${targets} PROPERTIES MSVC_RUNTIME_LIBRARY ${MSVC_RUNTIME_LIBRARY_STR})
endfunction()

# Get all the child targets and set them all as static. Also folder them. (MSVC)
function(set_targets_static_and_folder _target)
    get_target_property(TARGET_SOURCE_DIR ${_target} SOURCE_DIR)
    get_all_targets(targets ${TARGET_SOURCE_DIR})
    set_target_properties(${targets} PROPERTIES MSVC_RUNTIME_LIBRARY ${MSVC_RUNTIME_LIBRARY_STR} FOLDER "Vendor/${_target}")
endfunction()

# Disable INTERPROCEDURAL_OPTIMIZATION for '_target'
function(disable_ipo_target _target)
    set_property(TARGET ${_target} PROPERTY INTERPROCEDURAL_OPTIMIZATION OFF)
endfunction()

