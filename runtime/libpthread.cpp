// Pthreads API wrapper
// Copyright (C) Florian Negele

// This file is part of the Eigen Compiler Suite.

// The ECS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// The ECS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// Under Section 7 of the GNU General Public License version 3,
// the copyright holder grants you additional permissions to use
// this file as described in the ECS Runtime Support Exception.

// You should have received a copy of the GNU General Public License
// and a copy of the ECS Runtime Support Exception along with
// the ECS.  If not, see <https://www.gnu.org/licenses/>.

#include "linuxlib.hpp"

LIBRARY (libpthread, "libpthread.so.0")
FUNCTION (libpthread, pthread_barrier_destroy, 1)
FUNCTION (libpthread, pthread_barrier_init, 3)
FUNCTION (libpthread, pthread_barrier_wait, 1)
FUNCTION (libpthread, pthread_cond_broadcast, 1)
FUNCTION (libpthread, pthread_cond_destroy, 1)
FUNCTION (libpthread, pthread_cond_init, 2)
FUNCTION (libpthread, pthread_cond_signal, 1)
FUNCTION (libpthread, pthread_cond_wait, 2)
FUNCTION (libpthread, pthread_create, 4)
FUNCTION (libpthread, pthread_exit, 1)
FUNCTION (libpthread, pthread_getaffinity_np, 3)
FUNCTION (libpthread, pthread_getspecific, 1)
FUNCTION (libpthread, pthread_join, 2)
FUNCTION (libpthread, pthread_key_create, 2)
FUNCTION (libpthread, pthread_key_delete, 1)
FUNCTION (libpthread, pthread_mutex_destroy, 1)
FUNCTION (libpthread, pthread_mutex_init, 2)
FUNCTION (libpthread, pthread_mutex_lock, 1)
FUNCTION (libpthread, pthread_mutex_unlock, 1)
FUNCTION (libpthread, pthread_self, 0)
FUNCTION (libpthread, pthread_setaffinity_np, 3)
FUNCTION (libpthread, pthread_setspecific, 2)
FUNCTION (libpthread, pthread_yield, 0)
FUNCTION (libpthread, sem_destroy, 1)
FUNCTION (libpthread, sem_init, 3)
FUNCTION (libpthread, sem_post, 1)
FUNCTION (libpthread, sem_trywait, 1)
FUNCTION (libpthread, sem_wait, 1)
