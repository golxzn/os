include(FetchContent)

if(NOT GXZN_NAME)
	set(GXZN_NAME os)
endif()

if(NOT GXZN_PATH)
	message(SEND_ERROR
		"Seems like you're trying to add this module manually."
		"Please, use 'golxzn_load_modules(path)' from golxzn/cmake!"
	)
	return()
endif()

if(DEFINED GXZN_DISABLED_MODULES AND golxzn::os IN_LIST GXZN_DISABLED_MODULES)
	return()
endif()

set(GXZN_GIT_URL https://github.com/golxzn)
set(${GXZN_NAME}_submodules
	#subdirectories
)

list(FILTER GXZN_DISABLED_MODULES INCLUDE REGEX "^golxzn::os::.*")
message(STATUS "[golxzn/os] Disabled modules: ${GXZN_DISABLED_MODULES}")

add_library(golxzn_${GXZN_NAME} INTERFACE)
add_library(golxzn::${GXZN_NAME} ALIAS golxzn_${GXZN_NAME})

set(checked_submodules)
foreach(submodule IN LISTS ${GXZN_NAME}_submodules)
	if (${submodule}_DISABLED OR golxzn::os::${submodule} IN_LIST GXZN_DISABLED_MODULES)
		continue()
	endif()

	if (NOT EXISTS ${GXZN_PATH}/${GXZN_NAME}/${submodule})
		FetchContent_Declare(${GXZN_NAME}-${submodule}
			GIT_REPOSITORY ${GXZN_GIT_URL}/${GXZN_NAME}-${submodule}.git
		)
		FetchContent_Populate(${GXZN_NAME}-${submodule})
	endif()

	list(APPEND checked_submodules ${submodule})
endforeach()

foreach(submodule IN LISTS checked_submodules)
	set(submodule_root ${GXZN_PATH}/${GXZN_NAME}/${submodule})
	if(EXISTS ${${GXZN_NAME}-${submodule}_SOURCE_DIR}/CMakeLists.txt)
		set(submodule_root ${${GXZN_NAME}-${submodule}_SOURCE_DIR})
	endif()

	add_subdirectory(${submodule_root})
	target_link_libraries(golxzn_${GXZN_NAME} INTERFACE golxzn::os::${submodule})

	target_compile_definitions(golxzn_${GXZN_NAME} INTERFACE
		$<TARGET_PROPERTY:golxzn::os::${submodule},INTERFACE_COMPILE_DEFINITIONS>
	)
endforeach()

unset(${GXZN_NAME}_submodules)
unset(checked_submodules)
