cmake_minimum_required(VERSION 3.13.4)
project(Simplest)

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

if (NOT DEFINED GRAMMAR)
    set(GRAMMAR "simplest-lr.yy" CACHE STRING "file with grammar" FORCE)
endif()

flex_target(scanner
    simplest.l
    ${CMAKE_CURRENT_BINARY_DIR}/lexer.cc
)

bison_target(parser
    ${GRAMMAR}
    ${CMAKE_CURRENT_BINARY_DIR}/parser.cc
    COMPILE_FLAGS "--defines=${CMAKE_CURRENT_BINARY_DIR}/simplest.tab.hh")

add_flex_bison_dependency(scanner parser)

add_executable(${PROJECT_NAME}
    simplest.cc
    ${BISON_parser_OUTPUTS}
    ${FLEX_scanner_OUTPUTS}
)

set(TARGETS
    ${PROJECT_NAME}
)

foreach(TNAME ${TARGETS})
    target_compile_features(${TNAME} PRIVATE cxx_std_20)
    target_include_directories(${TNAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
    target_include_directories(${TNAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
endforeach()
