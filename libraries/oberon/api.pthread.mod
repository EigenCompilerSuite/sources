(* Pthreads API wrapper
Copyright (C) Florian Negele

This file is part of the Eigen Compiler Suite.

The ECS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The ECS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Under Section 7 of the GNU General Public License version 3,
the copyright holder grants you additional permissions to use
this file as described in the ECS Runtime Support Exception.

You should have received a copy of the GNU General Public License
and a copy of the ECS Runtime Support Exception along with
the ECS.  If not, see <https://www.gnu.org/licenses/>. *)

MODULE PThread IN API;

IMPORT SYSTEM;

CONST BarrierSerialThread* = -1;
CONST CPUSetSize* = 128;

TYPE Attr* = RECORD-
	reserved1-: ARRAY 5 OF SYSTEM.ADDRESS;
	reserved2-: ARRAY 4 OF INTEGER;
END;

TYPE Barrier* = RECORD-
	reserved1-: ARRAY 3 OF SYSTEM.ADDRESS;
	reserved2-: ARRAY 2 OF INTEGER;
END;

TYPE BarrierAttr* = RECORD-
	reserved-: INTEGER;
END;

TYPE Cond* = RECORD-
	reserved-: ARRAY 12 OF INTEGER;
END;

TYPE CondAttr* = RECORD-
	reserved-: INTEGER;
END;

TYPE CPUSet* = ARRAY CPUSetSize DIV (MAX (SET) - MIN (SET) + 1) OF SET;

TYPE Key* = SYSTEM.ADDRESS;

TYPE Mutex* = RECORD-
	reserved1-: ARRAY 2 OF SYSTEM.ADDRESS;
	reserved2-: ARRAY 6 OF INTEGER;
END;

TYPE MutexAttr* = RECORD-
	reserved-: INTEGER;
END;

TYPE RWLock* = RECORD-
	reserved1-: ARRAY 3 OF SYSTEM.ADDRESS;
	reserved2-: ARRAY 8 OF INTEGER;
END;

TYPE RWLockAttr* = RECORD-
	reserved-: ARRAY 2 OF INTEGER;
END;

TYPE Sem* = RECORD-
	reserved1-: ARRAY 4 OF SYSTEM.ADDRESS;
END;

TYPE Thread* = SYSTEM.ADDRESS;

PROCEDURE ^ BarrierDestroy* ["pthread_barrier_destroy"] (barrier: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ BarrierInit* ["pthread_barrier_init"] (barrier: SYSTEM.ADDRESS; attr: SYSTEM.ADDRESS; count: INTEGER): INTEGER;
PROCEDURE ^ BarrierWait* ["pthread_barrier_wait"] (barrier: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ CondBroadcast* ["pthread_cond_broadcast"] (cond: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ CondDestroy* ["pthread_cond_destroy"] (cond: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ CondInit* ["pthread_cond_init"] (cond: SYSTEM.ADDRESS; condattr: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ CondSignal* ["pthread_cond_signal"] (cond: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ CondWait* ["pthread_cond_wait"] (cond: SYSTEM.ADDRESS; mutex: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ Create* ["pthread_create"] (newthread: SYSTEM.ADDRESS; attr: SYSTEM.ADDRESS; start_routine: PROCEDURE (arg: SYSTEM.ADDRESS); arg: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ Exit* ["pthread_exit"] (retval: SYSTEM.ADDRESS);
PROCEDURE ^ GetAffinityNP* ["pthread_getaffinity_np"] (thread: Thread; cpusetsize: LENGTH; cpuset: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ GetSpecific* ["pthread_getspecific"] (key: Key): SYSTEM.ADDRESS;
PROCEDURE ^ Join* ["pthread_join"] (thread: Thread; return: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ KeyCreate* ["pthread_key_create"] (key: SYSTEM.ADDRESS; destructor: PROCEDURE): INTEGER;
PROCEDURE ^ KeyDelete* ["pthread_key_delete"] (key: Key): INTEGER;
PROCEDURE ^ MutexDestroy* ["pthread_mutex_destroy"] (mutex: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ MutexInit* ["pthread_mutex_init"] (mutex: SYSTEM.ADDRESS; mutexattr: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ MutexLock* ["pthread_mutex_lock"] (mutex: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ MutexUnlock* ["pthread_mutex_unlock"] (mutex: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ Self* ["pthread_self"] (): Thread;
PROCEDURE ^ SemDestroy* ["sem_destroy"] (sem: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ SemInit* ["sem_init"] (sem: SYSTEM.ADDRESS; pshared: INTEGER; value: INTEGER): INTEGER;
PROCEDURE ^ SemPost* ["sem_post"] (sem: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ SemTryWait* ["sem_trywait"] (sem: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ SemWait* ["sem_wait"] (sem: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ SetAffinityNP* ["pthread_setaffinity_np"] (thread: Thread; cpusetsize: LENGTH; cpuset: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ SetSpecific* ["pthread_setspecific"] (key: Key; value: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ Yield* ["pthread_yield"] (): INTEGER;

END PThread.
