cmake_minimum_required(VERSION 3.10)

project(sim C)

add_executable(sim main.c)

target_link_libraries(sim "-lsimavr")