cmake_minimum_required(VERSION 3.24)
project(WellDwellerUltrawide VERSION 1.1.0 LANGUAGES NONE)

find_program(ASSEMBLER as REQUIRED)
find_program(LINKER ld REQUIRED)
find_program(OBJCOPY objcopy REQUIRED)

include(FetchContent)
FetchContent_Declare(suwsf
    URL https://github.com/ollieatkinson/SUWSF/releases/download/v2.3.0-guard.3/SUWSF-x64.zip
    URL_HASH SHA256=28f3f4ef56c4cbddd0ad1ea81d24de9754389c5debbbfb255f0114d8afe23283
    TLS_VERIFY TRUE
)
FetchContent_Declare(asi_loader
    URL https://github.com/ThirteenAG/Ultimate-ASI-Loader/releases/download/v9.7.4/Ultimate-ASI-Loader-NoPDB_x64.zip
    URL_HASH SHA256=e5860e7d9a1805267535b65749575b5e406cc6ea3325c7392189c578815045d1
    TLS_VERIFY TRUE
)
FetchContent_MakeAvailable(suwsf asi_loader)

add_custom_command(OUTPUT "${CMAKE_BINARY_DIR}/SUWSF.ini"
    COMMAND "${ASSEMBLER}" --64 -o hooks.o "${CMAKE_SOURCE_DIR}/src/hooks.s"
    COMMAND "${ASSEMBLER}" --64 -o patches.o "${CMAKE_SOURCE_DIR}/src/patches.s"
    COMMAND "${LINKER}" -T "${CMAKE_SOURCE_DIR}/src/layout.ld" -e camera -o hooks.elf hooks.o patches.o
    COMMAND "${CMAKE_COMMAND}" "-DSOURCE_DIR=${CMAKE_SOURCE_DIR}" "-DBINARY_DIR=${CMAKE_BINARY_DIR}"
        "-DOBJCOPY=${OBJCOPY}" -P "${CMAKE_SOURCE_DIR}/src/GenerateINI.cmake"
    DEPENDS src/hooks.s src/patches.s src/layout.ld src/SUWSF.ini.in src/GenerateINI.cmake
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}"
    VERBATIM
)
add_custom_target(configuration ALL DEPENDS "${CMAKE_BINARY_DIR}/SUWSF.ini")

install(FILES "${suwsf_SOURCE_DIR}/SUWSF.asi" "${CMAKE_BINARY_DIR}/SUWSF.ini" DESTINATION .)
install(FILES "${asi_loader_SOURCE_DIR}/dinput8.dll" DESTINATION . RENAME version.dll)
install(FILES README.md LICENSE THIRD_PARTY_NOTICES.md DESTINATION WellDwellerUltrawide)
install(DIRECTORY licenses DESTINATION WellDwellerUltrawide)

set(CPACK_GENERATOR ZIP)
set(CPACK_PACKAGE_FILE_NAME "${PROJECT_NAME}-v${PROJECT_VERSION}")
set(CPACK_PACKAGE_DIRECTORY "${CMAKE_SOURCE_DIR}/dist")
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY OFF)
set(CPACK_PACKAGE_CHECKSUM SHA256)
include(CPack)
