cmake_minimum_required(VERSION 3.16)
project(TrustRegionNLS LANGUAGES Fortran C)

set(CMAKE_Fortran_STANDARD 2008)
set(CMAKE_Fortran_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

find_package(BLAS REQUIRED)
find_package(LAPACK REQUIRED)

add_library(nonlinearsolve
    src/nonlinearsolve.f90
)
target_link_libraries(nonlinearsolve PRIVATE LAPACK::LAPACK BLAS::BLAS)

option(TRUST_REGION_BUILD_EXAMPLES "Build example driver" ON)

if(TRUST_REGION_BUILD_EXAMPLES)
    add_executable(example_trust_region examples/example_trust_region.f90)
    target_link_libraries(example_trust_region PRIVATE nonlinearsolve)
    add_executable(compare_trust_region_fortran examples/compare_trust_region_fortran.f90)
    target_link_libraries(compare_trust_region_fortran PRIVATE nonlinearsolve)
    add_executable(compare_newton_fortran examples/compare_newton_fortran.f90)
    target_link_libraries(compare_newton_fortran PRIVATE nonlinearsolve)
    add_executable(run_test_nonlin examples/run_test_nonlin.f90 examples/test_nonlin.f90 examples/minpack.f90)
    target_link_libraries(run_test_nonlin PRIVATE nonlinearsolve)
endif()
