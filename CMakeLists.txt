
cmake_minimum_required(VERSION 3.27)

project(QuickMCL VERSION 0.1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTORCC ON)

find_package(Qt6 6.7 REQUIRED COMPONENTS Core Quick Concurrent)

if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    configure_file(src/natives/Windows/info.rc.in outfiles/info.rc)
    set(WINDOWS_SOURCES
        ${CMAKE_BINARY_DIR}/outfiles/info.rc
        src/natives/Windows/memory_info.cpp
    )
elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    set(LINUX_SOURCES
        src/natives/Linux/memory_info.cpp
    )
endif()

configure_file(src/version.cpp.in outfiles/version.cpp)

set(MAIN_SOURCES
    src/main.cpp
    src/config.h
    src/config.cpp
    src/version.h
    ${CMAKE_BINARY_DIR}/outfiles/version.cpp
    ${WINDOWS_SOURCES}
    ${LINUX_SOURCES}
    ${FREEBSD_SOURCES}
    ${MACOS_SOURCES}
)

set(GAME_SOURCES
    # download
    src/game/download.h
    src/game/download.cpp
    # game
    src/game/game.h
    src/game/game.cpp
    # launch
    src/game/launcher.h
    src/game/launcher.cpp
)

set(UTILS_SOURCES
    # json_parser
    src/utils/json_parser.h
    src/utils/json_parser.cpp
    # urls
    src/utils/urls.h
    src/utils/urls.cpp
    # java
    src/utils/java.h
    src/utils/java.cpp
    # utils
    src/utils/utils.h
    src/utils/utils.cpp
    # qml_interface
    src/utils/qml_interface.h
    src/utils/qml_interface.cpp
)

set(QML_SOURCES
    src/ui/QuickMCLComponents/QuickMCLButton.qml
    src/ui/QuickMCLComponents/QuickMCLComboBox.qml
    src/ui/Main.qml
    src/ui/NavBar.qml
    src/ui/FuncBar.qml
    src/ui/ContentArea.qml
    src/ui/NavBarButtonGroups/ButtonGroupLaunch.qml
    src/ui/NavBarButtonGroups/ButtonGroupDownload.qml
    src/ui/NavBarButtonGroups/ButtonGroupSettings.qml
    src/ui/NavBarButtonGroups/ButtonGroupAbout.qml
    src/ui/ContentAreaPages/LaunchPages/PageLaunch.qml
    src/ui/ContentAreaPages/LaunchPages/PageGameSettings.qml
    src/ui/ContentAreaPages/SettingsPages/PageGameSettings.qml
)

set(RESOURCES
    assests.qrc
)

qt_standard_project_setup(REQUIRES 6.7)

qt_add_executable(app${PROJECT_NAME}
    ${RESOURCES}
    ${MAIN_SOURCES}
    ${GAME_SOURCES}
    ${UTILS_SOURCES}
)

qt_add_qml_module(app${PROJECT_NAME}
    URI QuickMCL
    VERSION 1.0
    QML_FILES ${QML_SOURCES}
)

if(${CMAKE_BUILD_TYPE} STREQUAL "MinSizeRel")
    set(CMAKE_EXE_LINKER_FLAGS "-s")
    add_definitions("-DQT_NO_DEBUG_OUTPUT")
endif()

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(app${PROJECT_NAME} PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.${PROJECT_NAME}
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_include_directories(app${PROJECT_NAME} PUBLIC
    ${CMAKE_BINARY_DIR}/outfiles
)

target_link_libraries(app${PROJECT_NAME}
    PRIVATE Qt6::Core
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Concurrent
)

include(GNUInstallDirs)
install(TARGETS app${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
