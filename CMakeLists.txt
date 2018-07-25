cmake_minimum_required(VERSION 3.8.2)

########################################################
# Set project details here

set(PROJECT_NAME MyProjectName)
set(UNIT_TESTS_PROJECT_NAME ${PROJECT_NAME}_UnitTests)
set(USE_PRECOMPILED_HEADERS Yes)


########################################################
# Set third-party libraries here

set(THIRD_PARTY_DIR "${CMAKE_BINARY_DIR}/../3rdparty")
set(GTEST_ROOT "${THIRD_PARTY_DIR}/googletest/googletest")
set(GTEST_LIBRARY "${THIRD_PARTY_DIR}/googletest/googletest")
set(GTEST_MAIN_LIBRARY "${THIRD_PARTY_DIR}/googletest/googletest")


########################################################
# Global parameters

set_property(GLOBAL PROPERTY USE_FOLDERS ON) #Use solution folders
set(CMAKE_SUPPRESS_REGENERATION true) #suppress ZERO_CHECK
enable_testing()



########################################################
# For precompiled headers

if (MSVC)
    # For precompiled header.
    # Set 
    # "Precompiled Header" to "Use (/Yu)"
    # "Precompiled Header File" to "stdafx.h"
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Yustdafx.h /FIstdafx.h")
endif()


########################################################
# Initial setup

set(PROJECT_FOLDER ${PROJECT_NAME})
set(UNIT_TESTS_FOLDER ${PROJECT_NAME}_UnitTests)


########################################################
# File manipulations

if (${USE_PRECOMPILED_HEADERS})
    file(COPY "Templates/UnitTests/UsingPrecompiledHeaders" DESTINATION ../)
    file(RENAME "UsingPrecompiledHeaders" ${UNIT_TESTS_FOLDER})
    file(COPY "Templates/Project/UsingPrecompiledHeaders" DESTINATION ../)
    file(RENAME "UsingPrecompiledHeaders" ${PROJECT_FOLDER})
else()
    file(COPY "Templates/UnitTests/NotUsingPrecompiledHeaders" DESTINATION ../)
    file(RENAME "NotUsingPrecompiledHeaders" ${UNIT_TESTS_FOLDER})
    file(COPY "Templates/Project/NotUsingPrecompiledHeaders" DESTINATION ../)
    file(RENAME "NotUsingPrecompiledHeaders" ${PROJECT_FOLDER})
endif()


########################################################
# Add solution

project(${PROJECT_NAME})

if (NOT MSVC)
    message(SEND_ERROR "This CMake file intended to work properly only with MSVC")
    return()
endif()


########################################################
# Include googletest project
if(MSVC)
    include_external_msproject(googletest "${GTEST_ROOT}/msvc/2010/gtest.vcxproj")
else()
    message(SEND_ERROR "Something needs to be done with googletest and non-MSVC environment")
    return()
endif()

# Put googletest in separate folder
set_target_properties(googletest PROPERTIES FOLDER 3rdParty/googletest)


########################################################
# Add main project

set(PROJECT_SOURCE "${PROJECT_FOLDER}/main.cpp")

if (${USE_PRECOMPILED_HEADERS})
    list(APPEND PROJECT_SOURCE "${PROJECT_FOLDER}/stdafx.cpp" "${PROJECT_FOLDER}/stdafx.h")
endif()

add_executable(${PROJECT_NAME} ${PROJECT_SOURCE})

if (${USE_PRECOMPILED_HEADERS})
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Yustdafx.h /FIstdafx.h")
endif()


########################################################
# Add unit-tests project
set(UNIT_TESTS_SOURCE "${UNIT_TESTS_FOLDER}/main_UnitTests.cpp" "${UNIT_TESTS_FOLDER}/main.cpp")

if (${USE_PRECOMPILED_HEADERS})
    list(APPEND UNIT_TESTS_SOURCE "${UNIT_TESTS_FOLDER}/stdafx.cpp" "${UNIT_TESTS_FOLDER}/stdafx.h")
endif()

# Link directory for googletest lib
link_directories("${CMAKE_BINARY_DIR}/$(SolutionName)/$(Platform)-$(Configuration)")

add_executable(${UNIT_TESTS_PROJECT_NAME} ${UNIT_TESTS_SOURCE})

if (${USE_PRECOMPILED_HEADERS})
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Yustdafx.h /FIstdafx.h")
endif()

# Add include dirs
find_package(GTest REQUIRED)
if(NOT GTEST_FOUND)
    message(SEND_ERROR "Failed to find googletest")
    return()
else()
    target_include_directories(${UNIT_TESTS_PROJECT_NAME} PUBLIC ${GTEST_INCLUDE_DIRS})
endif()

# add libs
target_link_libraries(${UNIT_TESTS_PROJECT_NAME} debug gtestd.lib)
target_link_libraries(${UNIT_TESTS_PROJECT_NAME} optimized gtest.lib)

# change code generation to be compatible with default googletest project
set(CMAKE_CXX_FLAGS_RELEASE "/MT")
set(CMAKE_CXX_FLAGS_DEBUG "/MTd")

# add dependency on googletest
add_dependencies(${UNIT_TESTS_PROJECT_NAME} googletest)


########################################################
# Set output dirs
set_target_properties(${PROJECT_NAME} ${UNIT_TESTS_PROJECT_NAME}
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
    RUNTIME_OUTPUT_DIRECTORY "../bin/$(Platform)/$(Configuration)"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG "../bin/$(Platform)/$(Configuration)"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "../bin/$(Platform)/$(Configuration)"
)
