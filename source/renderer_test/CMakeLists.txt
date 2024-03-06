project(rendererTest)
# Add include directories
include_directories(
    ${STAR_EXTERN_INCLUDES}
    ${STAR_CORE_INCLUDES}
    ${STAR_BASE_INCLUDES}
    ${STAR_PLATFORM_INCLUDES}
	${STAR_APPLICATION_INCLUDES}
    ${STAR_GAME_INCLUDES}
	${STAR_RENDERING_INCLUDES}
)

# Set headers and sources
set(render_test_HEADERS
	StarMainApplication.hpp
    StarLogging.hpp
)

set(render_test_SOURCES
    rendererTest.cpp
)

# Ajouter les répertoires d'inclusion
include_directories(
    ${STAR_EXTERN_INCLUDES}
    ${STAR_CORE_INCLUDES}
    ${STAR_BASE_INCLUDES}
    ${STAR_PLATFORM_INCLUDES}
    ${STAR_APPLICATION_INCLUDES}
    ${STAR_GAME_INCLUDES}
    ${STAR_RENDERING_INCLUDES}
)

# Définir les fichiers d'en-tête et les sources
set(render_test_HEADERS
    StarCellularLiquid.hpp
    StarRandom.hpp
    StarRenderer.hpp
    StarRootLoader.hpp
    StarLiquidsDatabase.hpp
    StarAssets.hpp
    StarTextPainter.hpp
    StarMainApplication.hpp
)

# Ajouter l'exécutable et les fichiers objets des bibliothèques cibles
add_executable(render_test WIN32
    $<TARGET_OBJECTS:star_extern>
    $<TARGET_OBJECTS:star_core>
    $<TARGET_OBJECTS:star_base>
    $<TARGET_OBJECTS:star_game>
	$<TARGET_OBJECTS:star_rendering>
	$<TARGET_OBJECTS:star_application>
    ${render_test_SOURCES}
)

# Lier les bibliothèques
target_link_libraries(render_test
    ${STAR_EXT_LIBS}
	${STAR_EXT_GUI_LIBS}
)