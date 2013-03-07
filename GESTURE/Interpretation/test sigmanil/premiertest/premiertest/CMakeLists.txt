#****************************************************************************#
#                                                                            #
#  SigmaNIL Samples 1.x Beta                                                 #
#                                                                            #
#  Copyright (c) 2012 Sigma ArGe Bilisim Teknolojileri Tic. Ltd. Sti.        #
#  All rights reserved.                                                      #
#                                                                            #
#  This file is part of SigmaNIL Samples.                                    #
#                                                                            #
#****************************************************************************#

cmake_minimum_required (VERSION 2.6)
project (premier_test)

SET(CMAKE_USE_RELATIVE_PATHS ON)

set(premier_test
	main.cpp
)

include_directories("$ENV{SigmaNIL_inc}")
include_directories( ${PROJECT_BINARY_DIR} )

if(CMAKE_CL_64)
	link_directories("$ENV{SigmaNIL_lib64}")
else(CMAKE_CL_64)
	link_directories("$ENV{SigmaNIL_lib}")
endif(CMAKE_CL_64)

# BOOST
set(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} "$ENV{BOOST}")
set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} "$ENV{BOOST}")
find_package(Boost REQUIRED)
if(Boost_FOUND)
	set(Boost_INCLUDE ${Boost_INCLUDE_DIR} CACHE FILEPATH "Boost Include Path")
	set(Boost_LIB ${Boost_LIBRARY_DIRS} CACHE FILEPATH "Boost Lib Path")
    include_directories(${Boost_INCLUDE_DIR})
    add_definitions( "-DHAS_BOOST" )
	if(CMAKE_CL_64)
		link_directories("C:\boost\boost_1_53_0\bin.v2\libs")
		link_directories("C:\boost\boost_1_53_0\bin.v2\libs\system\build\msvc-10.0\debug\link-static\threading-multi")
		link_directories("C:\boost\boost_1_53_0\bin.v2\libs\thread\build\msvc-10.0\debug\link-static\threading-multi")
		link_directories("C:\boost\boost_1_53_0\bin.v2\libs\date_time\build\msvc-10.0\debug\link-static\threading-multi")
		link_directories("C:\boost\boost_1_53_0\bin.v2\libs\chrono\build\msvc-10.0\debug\link-static\threading-multi")
	else(CMAKE_CL_64)
		link_directories("${Boost_LIBRARY_DIRS}/x86")
	endif(CMAKE_CL_64)
endif(Boost_FOUND)

add_executable( premiertest ${premier_test})

if(CMAKE_CL_64)
	target_link_libraries( premiertest debug SigmaNIL_2.0_x64 )
	target_link_libraries( premiertest optimized SigmaNIL_2.0_x64 )
	target_link_libraries( premiertest debug libboost_system-vc100-mt-gd-1_53.lib )
	target_link_libraries( premiertest debug libboost_chrono-vc100-mt-gd-1_53.lib )
	target_link_libraries( premiertest debug libboost_date_time-vc100-mt-gd-1_53.lib )
	target_link_libraries( premiertest debug libboost_thread-vc100-mt-gd-1_53.lib )
else(CMAKE_CL_64)
	target_link_libraries( premiertest debug SigmaNIL_2.0_x86 )
	target_link_libraries( premiertest optimized SigmaNIL_2.0_x86 )
endif(CMAKE_CL_64)