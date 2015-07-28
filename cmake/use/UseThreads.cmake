include(project)

set(THREADS_PREFER_PTHREAD_FLAG ON)

register_project(Threads LIBRARIES CMAKE_THREAD_LIBS_INIT)
