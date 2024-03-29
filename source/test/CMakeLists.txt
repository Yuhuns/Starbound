# Supprimer l'option /DEFAULTLIB:LIBCMT de CMAKE_CXX_FLAGS
string(REPLACE "/DEFAULTLIB:LIBCMT" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")

# Supprimer l'option /DEFAULTLIB:LIBCMT de CMAKE_CXX_FLAGS_DEBUG
string(REPLACE "/DEFAULTLIB:LIBCMT" "" CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}")

# Supprimer l'option /DEFAULTLIB:LIBCMT de CMAKE_CXX_FLAGS_RELEASE
string(REPLACE "/DEFAULTLIB:LIBCMT" "" CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")

# Supprimer l'option /DEFAULTLIB:LIBCMT de CMAKE_CXX_FLAGS_RELWITHDEBINFO
string(REPLACE "/DEFAULTLIB:LIBCMT" "" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")

include_directories(
    ${STAR_EXTERN_INCLUDES}
    ${STAR_CORE_INCLUDES}
    ${STAR_BASE_INCLUDES}
    ${STAR_PLATFORM_INCLUDES}
    ${STAR_GAME_INCLUDES}
    ${STAR_APPLICATION_INCLUDES}
    ${STAR_RENDERING_INCLUDES}
  )

# Add top-level test directory so  gtest-all.cc can find its own include file
include_directories(.)

set(star_core_tests_SOURCES
      gtest/gtest-all.cc

      core_tests_main.cpp

      algorithm_test.cpp
      block_allocator_test.cpp
      blocks_along_line_test.cpp
      btree_database_test.cpp
      btree_test.cpp
      byte_array_test.cpp
      clock_test.cpp
      color_test.cpp
      container_test.cpp
      encode_test.cpp
      file_test.cpp
      hash_test.cpp
      host_address_test.cpp
      ref_ptr_test.cpp
      json_test.cpp
      flat_hash_test.cpp
      formatted_json_test.cpp
      line_test.cpp
      lua_test.cpp
      lua_json_test.cpp
      math_test.cpp
      multi_table_test.cpp
      net_states_test.cpp
      ordered_map_test.cpp
      ordered_set_test.cpp
      periodic_test.cpp
      poly_test.cpp
      random_test.cpp
      rect_test.cpp
      serialization_test.cpp
      static_vector_test.cpp
      small_vector_test.cpp
      sha_test.cpp
      shell_parse.cpp
      string_test.cpp
      strong_typedef_test.cpp
      thread_test.cpp
      worker_pool_test.cpp
      variant_test.cpp
      vlq_test.cpp
    )
add_executable(core_tests
  $<TARGET_OBJECTS:star_extern> $<TARGET_OBJECTS:star_core>
  ${star_core_tests_SOURCES})
target_link_libraries(core_tests ${STAR_EXT_LIBS})
add_test(NAME core_tests WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} COMMAND ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/core_tests)

set(star_game_tests_SOURCES
      gtest/gtest-all.cc

      game_tests_main.cpp

      StarTestUniverse.cpp
      assets_test.cpp
      function_test.cpp
      item_test.cpp
      root_test.cpp
      server_test.cpp
      spawn_test.cpp
      stat_test.cpp
      tile_array_test.cpp
      world_geometry_test.cpp
      universe_connection_test.cpp
    )
add_executable(game_tests
  $<TARGET_OBJECTS:star_extern> $<TARGET_OBJECTS:star_core> $<TARGET_OBJECTS:star_base> $<TARGET_OBJECTS:star_game>
  ${star_game_tests_SOURCES})
target_link_libraries(game_tests ${STAR_EXT_LIBS})
add_test(NAME game_tests WORKING_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} COMMAND ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/game_tests)