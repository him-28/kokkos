
FUNCTION(KOKKOS_DEVICE_OPTION SUFFIX DEFAULT DEV_TYPE DOCSTRING)
  KOKKOS_OPTION(ENABLE_${SUFFIX} ${DEFAULT} BOOL ${DOCSTRING})
  STRING(TOUPPER ${SUFFIX} UC_NAME)
  IF (KOKKOS_ENABLE_${UC_NAME})
    LIST(APPEND KOKKOS_ENABLED_DEVICES    ${SUFFIX})
    #I hate that CMake makes me do this
    SET(KOKKOS_ENABLED_DEVICES    ${KOKKOS_ENABLED_DEVICES}    PARENT_SCOPE)
  ENDIF()
  SET(KOKKOS_ENABLE_${UC_NAME} ${KOKKOS_ENABLE_${UC_NAME}} PARENT_SCOPE)
  IF (KOKKOS_ENABLE_${UC_NAME} AND DEV_TYPE STREQUAL "HOST")
    SET(KOKKOS_HAS_HOST ON PARENT_SCOPE)
  ENDIF()
ENDFUNCTION()

KOKKOS_CFG_DEPENDS(DEVICES NONE)

# Put a check in just in case people are using this option
KOKKOS_DEPRECATED_LIST(DEVICES ENABLE)


KOKKOS_DEVICE_OPTION(PTHREAD       OFF HOST "Whether to build Pthread backend")
IF (KOKKOS_ENABLE_PTHREAD)
  #patch the naming here
  SET(KOKKOS_ENABLE_THREADS ON)
ENDIF()
KOKKOS_DEVICE_OPTION(ROCM          OFF DEVICE "Whether to build AMD ROCm backend")

IF(Trilinos_ENABLE_Kokkos AND Trilinos_ENABLE_OpenMP)
  SET(OMP_DEFAULT ON)
ELSE()
  SET(OMP_DEFAULT OFF)
ENDIF()
KOKKOS_DEVICE_OPTION(OPENMP ${OMP_DEFAULT} HOST "Whether to build OpenMP backend")

IF(Trilinos_ENABLE_Kokkos AND TPL_ENABLE_CUDA)
  SET(CUDA_DEFAULT ON)
ELSE()
  SET(CUDA_DEFAULT OFF)
ENDIF()
KOKKOS_DEVICE_OPTION(CUDA ${CUDA_DEFAULT} DEVICE "Whether to build CUDA backend")

IF (KOKKOS_ENABLE_CUDA)
  GLOBAL_SET(KOKKOS_DONT_ALLOW_EXTENSIONS "CUDA enabled")
ENDIF()

# We want this to default to OFF for cache reasons
# Someone may later activative OpenMP, at which point SERIAL should be OFF
# If have default to ON, both serial and OpenMP would both be on which
# would be behavior inconsistent with -DOpenMP=X...
KOKKOS_DEVICE_OPTION(SERIAL OFF HOST "Whether to build serial backend")
# If we have no other hosts, turn serial on
IF (NOT KOKKOS_HAS_HOST)
  SET(KOKKOS_ENABLE_SERIAL ON)
ENDIF()

KOKKOS_DEVICE_OPTION(HPX OFF HOST "Whether to build HPX backend")
