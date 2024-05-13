(* Linux API wrapper
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

MODULE Linux IN API;

IMPORT SYSTEM;

CONST CLOCK_MONOTONIC* = 1;
CONST CLOCK_MONOTONIC_RAW* = 4;
CONST CLOCK_PROCESS_CPUTIME_ID* = 2;
CONST CLOCK_REALTIME* = 0;
CONST CLOCK_THREAD_CPUTIME_ID* = 3;
CONST CLONE_CHILD_CLEARTID* = 200000H;
CONST CLONE_CHILD_SETTID* = 1000000H;
CONST CLONE_DETACHED* = 400000H;
CONST CLONE_FILES* = 400H;
CONST CLONE_FS* = 200H;
CONST CLONE_KTHREAD* = 10000000H;
CONST CLONE_NEWIPC* = 8000000H;
CONST CLONE_NEWNS* = 20000H;
CONST CLONE_NEWUTS* = 4000000H;
CONST CLONE_PARENT* = 8000H;
CONST CLONE_PARENT_SETTID* = 100000H;
CONST CLONE_PTRACE* = 2000H;
CONST CLONE_SETTLS* = 80000H;
CONST CLONE_SIGHAND* = 800H;
CONST CLONE_STOPPED* = 2000000H;
CONST CLONE_SYSVSEM* = 40000H;
CONST CLONE_THREAD* = 10000H;
CONST CLONE_UNTRACED* = 800000H;
CONST CLONE_VFORK* = 4000H;
CONST CLONE_VM* = 100H;
CONST FUTEX_WAIT* = 0;
CONST FUTEX_WAKE* = 1;
CONST O_ACCMODE* = 3O;
CONST O_APPEND* = 2000O;
CONST O_CLOEXEC* = 2000000O;
CONST O_CREAT* = 100O;
CONST O_DIRECT* = 40000O;
CONST O_DIRECTORY* = 200000O;
CONST O_DSYNC* = 10000O;
CONST O_EXCL* = 200O;
CONST O_LARGEFILE* = 100000O;
CONST O_NOATIME* = 1000000O;
CONST O_NOCTTY* = 400O;
CONST O_NOFOLLOW* = 400000O;
CONST O_NONBLOCK* = 4000O;
CONST O_RDONLY* = 0O;
CONST O_RDWR* = 2O;
CONST O_TRUNC* = 1000O;
CONST O_WRONLY* = 1O;
CONST P_ALL* = 0;
CONST P_PGID* = 2;
CONST P_PID* = 1;
CONST S_IFBLK* = 60000O;
CONST S_IFCHR* = 20000O;
CONST S_IFDIR* = 40000O;
CONST S_IFIFO* = 10000O;
CONST S_IFLNK* = 120000O;
CONST S_IFMT* = 170000O;
CONST S_IFREG* = 100000O;
CONST S_IFSOCK* = 140000O;
CONST S_IRGRP* = 40O;
CONST S_IROTH* = 4O;
CONST S_IRUSR* = 400O;
CONST S_IRWXG* = 70O;
CONST S_IRWXO* = 7O;
CONST S_IRWXU* = 700O;
CONST S_ISGID* = 2000O;
CONST S_ISUID* = 4000O;
CONST S_ISVTX* = 1000O;
CONST S_IWGRP* = 20O;
CONST S_IWOTH* = 2O;
CONST S_IWUSR* = 200O;
CONST S_IXGRP* = 10O;
CONST S_IXOTH* = 1O;
CONST S_IXUSR* = 100O;
CONST SEEK_CUR* = 1;
CONST SEEK_DATA* = 3;
CONST SEEK_END* = 2;
CONST SEEK_HOLE* = 4;
CONST SEEK_SET* = 0;
CONST SIGABRT* = 6;
CONST SIGALRM* = 14;
CONST SIGBUS* = 7;
CONST SIGCHLD* = 17;
CONST SIGCONT* = 18;
CONST SIGFPE* = 8;
CONST SIGHUP* = 1;
CONST SIGILL* = 4;
CONST SIGINT* = 2;
CONST SIGIO* = 29;
CONST SIGIOT* = 6;
CONST SIGKILL* = 9;
CONST SIGPIPE* = 13;
CONST SIGPROF* = 27;
CONST SIGQUIT* = 3;
CONST SIGSEGV* = 11;
CONST SIGSTKFLT* = 16;
CONST SIGSTOP* = 19;
CONST SIGTERM* = 15;
CONST SIGTRAP* = 5;
CONST SIGTSTP* = 20;
CONST SIGTTIN* = 21;
CONST SIGTTOU* = 22;
CONST SIGURG* = 23;
CONST SIGUSR1* = 10;
CONST SIGUSR2* = 12;
CONST SIGVTALRM* = 26;
CONST SIGWINCH* = 28;
CONST SIGXCPU* = 24;
CONST SIGXFSZ* = 25;
CONST WCONTINUED* = 8H;
CONST WEXITED* = 4H;
CONST WNOHANG* = 1H;
CONST WNOWAIT* = 1000000H;
CONST WSTOPPED* = 2H;
CONST WUNTRACED* = 2H;

TYPE TimeT* = LENGTH;

TYPE Timespec* = RECORD-
	tv_sec*: TimeT;
	tv_nsec*: LENGTH;
END;

PROCEDURE ^ Brk* ["sys_brk"] (addr: SYSTEM.ADDRESS): SYSTEM.ADDRESS;
PROCEDURE ^ ClockGetRes* ["sys_clock_getres"] (clk_id: INTEGER; res: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ ClockGetTime* ["sys_clock_gettime"] (clk_id: INTEGER; tp: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ Clone* ["sys_clone"] (flags: INTEGER; newsp, parent_tid, child_tid, regs: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ Close* ["sys_close"] (fd: INTEGER): INTEGER;
PROCEDURE ^ Exit* ["sys_exit"] (status: INTEGER);
PROCEDURE ^ ExitGroup* ["sys_exit_group"] (status: INTEGER);
PROCEDURE ^ Futex* ["sys_futex"] (addr1: SYSTEM.ADDRESS; op: INTEGER; val1: LENGTH; timeout, addr2: SYSTEM.ADDRESS; val3: LENGTH): INTEGER;
PROCEDURE ^ GetPID* ["sys_getpid"] (): INTEGER;
PROCEDURE ^ LSeek* ["sys_lseek"] (fd: INTEGER; offset: LENGTH; origin: INTEGER): LENGTH;
PROCEDURE ^ GetTID* ["sys_gettid"] (): INTEGER;
PROCEDURE ^ NanoSleep* ["sys_nanosleep"] (req: SYSTEM.ADDRESS; rem: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ Open* ["sys_open"] (filename: SYSTEM.ADDRESS; flags, mode: INTEGER): INTEGER;
PROCEDURE ^ Read* ["sys_read"] (fd: INTEGER; buf: SYSTEM.ADDRESS; count: LENGTH): LENGTH;
PROCEDURE ^ Rename* ["sys_rename"] (oldpath, newpath: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ SchedGetaffinity* ["sys_sched_getaffinity"] (pid: INTEGER; len: LENGTH; user_mask_ptr: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ SchedSetaffinity* ["sys_sched_setaffinity"] (pid: INTEGER; len: LENGTH; user_mask_ptr: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ Time* ["sys_time"] (t: SYSTEM.ADDRESS): LONGINT;
PROCEDURE ^ Times* ["sys_times"] (buf: SYSTEM.ADDRESS): LONGINT;
PROCEDURE ^ Unlink* ["sys_unlink"] (pathname: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ WaitID* ["sys_waitid"] (which, upid: INTEGER; infop: SYSTEM.ADDRESS; options: INTEGER; ru: SYSTEM.ADDRESS): INTEGER;
PROCEDURE ^ Write* ["sys_write"] (fd: INTEGER; buf: SYSTEM.ADDRESS; count: LENGTH): LENGTH;

END Linux.
