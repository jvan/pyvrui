include(LibFindMacros)

find_path(VRUI_INCLUDE_DIR 
   NAMES Vrui/Application.h
   PATHS /home/jvan/Development/pyvrui/scratch/Vrui-1.0/include
)

find_library(VRUI_LIBRARY
   NAMES Vrui.g++-3
   PATHS /home/jvan/Development/pyvrui/scratch/Vrui-1.0/lib64
)

libfind_process(VRUI)

