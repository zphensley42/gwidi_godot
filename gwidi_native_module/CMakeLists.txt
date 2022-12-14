cmake_minimum_required(VERSION 3.20)
project(gwidi_godot_native_module)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_library(gwidi SHARED
        src/gwidi_library.cpp
        src/gwidi_midi.cc
        include/gwidi_midi.h
)

add_dependencies(gwidi godot-cpp)

if(NOT TARGET gwidi_options_2)
    set(gwidi_options_2_DIR ${CMAKE_CURRENT_LIST_DIR}/../gwidi_midi_parser/gwidi_options_2)
    find_package(gwidi_options_2 REQUIRED)
endif()

if(NOT TARGET gwidi_data)
    set(gwidi_data_DIR ${CMAKE_CURRENT_LIST_DIR}/../gwidi_midi_parser/gwidi_data)
    find_package(gwidi_data REQUIRED)
endif()

if(NOT TARGET gwidi_midi)
    set(gwidi_midi_DIR ${CMAKE_CURRENT_LIST_DIR}/../gwidi_midi_parser/gwidi_midi)
    find_package(gwidi_midi REQUIRED)
endif()

if(NOT TARGET gwidi_tick)
    set(gwidi_tick_DIR ${CMAKE_CURRENT_LIST_DIR}/../gwidi_midi_parser/gwidi_playback)
    find_package(gwidi_tick REQUIRED)
endif()

target_link_libraries(gwidi PUBLIC
        godot-cpp
        ${gwidi_options_2_LIBRARIES}
        ${gwidi_data_LIBRARIES}
        ${gwidi_midi_LIBRARIES}
        ${gwidi_tick_LIBRARIES}
)

target_include_directories(gwidi PUBLIC
        ${CMAKE_CURRENT_LIST_DIR}/include
        ${gwidi_options_2_INCLUDE_DIRS}
        ${gwidi_data_INCLUDE_DIRS}
        ${gwidi_midi_INCLUDE_DIRS}
        ${gwidi_tick_INCLUDE_DIRS}
        PRIVATE
        ${CMAKE_CURRENT_LIST_DIR}/src
)
