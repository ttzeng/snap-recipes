cmake_minimum_required(VERSION 3.2)

set(IOTIVITY            $ENV{SNAPCRAFT_STAGE}/usr/local/iotivity)
set(IOTIVITY_INC        ${IOTIVITY}/include)
set(IOTIVITY_LIB        ${IOTIVITY}/lib)
set(IOTIVITY_EXAMPLES   ${IOTIVITY}/examples)

set(CMAKE_CXX_FLAGS     "${CMAKE_CXX_FLAGS} -std=c++0x -Wall")

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)

include_directories(
    ${IOTIVITY_INC}/c_common
    ${IOTIVITY_INC}/resource
)

add_library(oc SHARED IMPORTED)
set_target_properties(oc PROPERTIES IMPORTED_LOCATION ${IOTIVITY_LIB}/liboc.so)

add_library(octbstack SHARED IMPORTED)
set_target_properties(octbstack PROPERTIES IMPORTED_LOCATION ${IOTIVITY_LIB}/liboctbstack.so)

add_library(oc_logger SHARED IMPORTED)
set_target_properties(oc_logger PROPERTIES IMPORTED_LOCATION ${IOTIVITY_LIB}/liboc_logger.so)

add_library(connectivity_abstraction SHARED IMPORTED)
set_target_properties(connectivity_abstraction PROPERTIES IMPORTED_LOCATION ${IOTIVITY_LIB}/libconnectivity_abstraction.so)

set(CMAKE_BUILD_ARTIFACTS
    ${CMAKE_BINARY_DIR}/CMakeCache.txt
    ${CMAKE_BINARY_DIR}/cmake_install.cmake
    ${CMAKE_BINARY_DIR}/Makefile
    ${CMAKE_BINARY_DIR}/CMakeFiles
    ${CMAKE_BINARY_DIR}/install_manifest.txt
)
add_custom_target(distclean rm -rf ${CMAKE_BUILD_ARTIFACTS})

#
# simpleserver
#
add_executable (simpleserver ${IOTIVITY_EXAMPLES}/simpleserver.cpp)
target_link_libraries(simpleserver Threads::Threads connectivity_abstraction oc_logger octbstack oc)
install(TARGETS simpleserver RUNTIME DESTINATION bin)

#
# simpleclient
#
add_executable (simpleclient ${IOTIVITY_EXAMPLES}/simpleclient.cpp)
target_link_libraries(simpleclient Threads::Threads connectivity_abstraction oc_logger octbstack oc)
install(TARGETS simpleclient RUNTIME DESTINATION bin)

