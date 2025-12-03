cmake_minimum_required(VERSION 3.16)
project(TrustRegionNLS LANGUAGES Fortran C)

set(CMAKE_Fortran_STANDARD 2008)
set(CMAKE_Fortran_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

find_package(BLAS REQUIRED)
find_package(LAPACK REQUIRED)

add_library(trust_region
    src/trust_region.f90
)
target_link_libraries(trust_region PRIVATE LAPACK::LAPACK BLAS::BLAS)

option(TRUST_REGION_BUILD_EXAMPLES "Build example driver" ON)

if(TRUST_REGION_BUILD_EXAMPLES)
    add_executable(example_trust_region examples/example_trust_region.f90)
    target_link_libraries(example_trust_region PRIVATE trust_region)
    add_executable(compare_trust_region_fortran examples/compare_trust_region_fortran.f90)
    target_link_libraries(compare_trust_region_fortran PRIVATE trust_region)
endif()
