cmake_minimum_required(VERSION 3.4)
set(CMAKE_CXX_STANDARD 17)
find_package(Qt5 COMPONENTS Core Widgets REQUIRED)
include_directories(${CMAKE_CURRENT_LIST_DIR} ${Qt5Widgets_INCLUDE_DIRS} ${Qt5Core_INCLUDE_DIRS})
add_executable(vast
               Model.cpp
               Model.cpp
               Node.cpp
               TranslationUnit.cpp
               Window.cpp
               main.cpp)
set_target_properties(vast PROPERTIES AUTOMOC TRUE)
target_link_libraries(vast ${LIBCLANG_LIBRARIES} ${Qt5Widgets_LIBRARIES} ${Qt5Core_LIBRARIES})
