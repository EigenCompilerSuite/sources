// Atari TOS API wrapper
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

#ifndef ECS_TOS_HEADER_INCLUDED
#define ECS_TOS_HEADER_INCLUDED

// error numbers

#define EACCDN (-36)
#define EBADRQ (-5)
#define EBADSF (-16)
#define E_CHNG (-14)
#define E_CRC (-4)
#define EDRIVE (-46)
#define EDRVNR (-2)
#define EFILNF (-33)
#define EGSBF (-67)
#define EIHNDL (-37)
#define EIMBA (-40)
#define EINTRN (-65)
#define EINVFN (-32)
#define EMEDIA (-7)
#define ENHNDL (-35)
#define ENMFIL (-47)
#define ENSMEM (-39)
#define E_OK 0
#define EOTHER (-17)
#define EPAPER (-9)
#define EPLFMT (-66)
#define EPTHNF (-34)
#define ERANGE (-64)
#define EREADF (-11)
#define ERROR (-1)
#define ESECNF (-8)
#define E_SEEK (-6)
#define EUNCMD (-3)
#define EUNDEV (-15)
#define EWRITF (-10)
#define EWRPRO (-13)

// GEMDOS functions

#define DEFAULT_DRIVE 0
#define DEV_BUSY 0
#define DEV_READY (-1)
#define FA_ARCHIVE 0x20
#define FA_DIR 0x10
#define FA_HIDDEN 0x2
#define FA_INQUIRE 0
#define FA_READONLY 0x1
#define FA_SET 1
#define FA_SYSTEM 0x4
#define FA_VOLUME 0x8
#define FD_INQUIRE 0
#define FD_SET 1
#define GSH_AUX 2
#define GSH_BIOSAUX (-2)
#define GSH_BIOSCON (-1)
#define GSH_BIOSPRN (-3)
#define GSH_CONIN 0
#define GSH_CONOUT 1
#define GSH_MIDIIN (-4)
#define GSH_MIDIOUT (-5)
#define GSH_PRN 3
#define PE_BASEPAGE 5
#define PE_GO 4
#define PE_LOAD 3
#define PE_LOADGO 0
#define SEEK_CUR 1
#define SEEK_END 2
#define SEEK_SET 0
#define TERM_BADPARAMS 2
#define TERM_CRASH (-1)
#define TERM_CTRLC (-32)
#define TERM_ERROR 1
#define TERM_OK 0

struct BASEPAGE
{
	long p_lowtpa;
	long p_hitpa;
	long p_tbase;
	long p_tlen;
	long p_dbase;
	long p_dlen;
	long p_bbase;
	long p_blen;
	long p_dta;
	long p_parent;
	long p_reserved;
	long p_env;
	char p_undef[80];
	char p_cmdlin[128];
};

struct DISKINFO
{
	unsigned long b_free;
	unsigned long b_total;
	unsigned long b_secsize;
	unsigned long b_clsize;
};

struct DTA
{
	char d_reserved[21];
	unsigned char d_attrib;
	unsigned d_time;
	unsigned d_date;
	long d_length;
	char d_fname[14];
};

extern "C" auto Cauxin () -> int;
extern "C" auto Cauxis () -> int;
extern "C" auto Cauxos () -> int;
extern "C" auto Cauxout (int ch) -> void;
extern "C" auto Cconin () -> long;
extern "C" auto Cconis () -> int;
extern "C" auto Cconos () -> int;
extern "C" auto Cconout (int ch) -> void;
extern "C" auto Cconrs (char* str) -> void;
extern "C" auto Cconws (const char* str) -> int;
extern "C" auto Cnecin () -> long;
extern "C" auto Cprnos () -> int;
extern "C" auto Cprnout (int ch) -> int;
extern "C" auto Crawcin () -> long;
extern "C" auto Crawio (int ch) -> long;
extern "C" auto Dcreate (const char* path) -> long;
extern "C" auto Ddelete (const char* path) -> long;
extern "C" auto Dfree (DISKINFO* buf, int drive) -> long;
extern "C" auto Dgetdrv () -> int;
extern "C" auto Dgetpath (char* buf, int drive) -> long;
extern "C" auto Dsetdrv (int drive) -> long;
extern "C" auto Dsetpath (const char* path) -> long;
extern "C" auto Fattrib (const char* fname, int flag, int attr) -> long;
extern "C" auto Fclose (int handle) -> long;
extern "C" auto Fcreate (const char* fname, int attr) -> long;
extern "C" auto Fdatime (void* timeptr, int handle, int flag) -> long;
extern "C" auto Fdelete (const char* fname) -> long;
extern "C" auto Fdup (int shandle) -> long;
extern "C" auto Fforce (int shandle, int nhandle) -> long;
extern "C" auto Fgetdta () -> DTA*;
extern "C" auto Fopen (const char* fname, int mode) -> long;
extern "C" auto Fread (int handle, long length, char* buf) -> long;
extern "C" auto Frename (int zero, const char* oldname, const char* newname) -> long;
extern "C" auto Fseek (long offset, int handle, int mode) -> long;
extern "C" auto Fsetdta (DTA* ndta) -> void;
extern "C" auto Fsfirst (const char* fspec, int attribs) -> int;
extern "C" auto Fsnext () -> int;
extern "C" auto Fwrite (int handle, long count, const char* buf) -> long;
extern "C" auto Malloc (long amount) -> void*;
extern "C" auto Mfree (void* startadr) -> int;
extern "C" auto Mshrink (int zero, long block, long newsize) -> int;
extern "C" auto Pexec (int mode, const char* fname, const char* cmdline, const char* envstr) -> long;
extern "C" auto Pterm0 [[noreturn]] () -> void;
extern "C" auto Pterm [[noreturn]] (int retcode) -> void;
extern "C" auto Ptermres [[noreturn]] (long keepcnt, int rercode) -> void;
extern "C" auto Super (void* stack) -> void*;
extern "C" auto Sversion () -> unsigned;
extern "C" auto Tgetdate () -> unsigned;
extern "C" auto Tgettime () -> unsigned;
extern "C" auto Tsetdate (unsigned date) -> int;
extern "C" auto Tsettime (unsigned time) -> int;

// BIOS functions

#define DEV_AUX 1
#define DEV_CONSOLE 2
#define DEV_IKBD 4
#define DEV_MIDI 3
#define DEV_PRINTER 0
#define DEV_RAW 5
#define K_ALT 0x8
#define K_CAPSLOCK 0x10
#define K_CLRHOME 0x20
#define K_CTRL 0x4
#define K_INSERT 0x40
#define K_LSHIFT 0x2
#define K_RSHIFT 0x1
#define MED_CHANGED 2
#define MED_NOCHANGE 0
#define MED_UNKNOWN 1
#define RW_NOMEDIACH 0x2
#define RW_NORETRIES 0x4
#define RW_NOTRANSLATE 0x8
#define RW_READ 0x1
#define RW_WRITE 0x1
#define VEC_ADDRESSERROR 0x3
#define VEC_BIOS 0x2d
#define VEC_BUSERROR 0x2
#define VEC_CRITICALERROR 0x101
#define VEC_GEM 0x21
#define VEC_GEMDOS 0x21
#define VEC_ILLEGALINSTRUCTION 0x4
#define VEC_TERMINATE 0x102
#define VEC_TIMER 0x100
#define VEC_XBIOS 0x2e

struct BPB
{
	int recsiz;
	int clsiz;
	int clsizb;
	int rdlen;
	int fsiz;
	int fatrec;
	int datrec;
	int numcl;
	int bflags;
};

struct MD
{
	MD* m_link;
	void* m_start;
	long m_length;
	BASEPAGE* m_own;
};

struct MPB
{
	MD* mp_mfl;
	MD* mp_mal;
	MD* mp_rover;
};

extern "C" auto Bconin (int dev) -> long;
extern "C" auto Bconout (int dev, int ch) -> long;
extern "C" auto Bconstat (int dev) -> long;
extern "C" auto Bcostat (int dev) -> long;
extern "C" auto Drvmap () -> unsigned long;
extern "C" auto Getbpb (int dev) -> BPB*;
extern "C" auto Getmpb (MPB* mpb) -> void;
extern "C" auto Kbshift (int mode) -> long;
extern "C" auto Mediach (int dev) -> long;
extern "C" auto Rwabs (int mode, void* buffer, int count, int recno, int dev, long lrecno) -> long;
extern "C" auto Setexc (int num, void (*newvec) ()) -> void (*) ();
extern "C" auto Tickcal () -> long;

// XBIOS functions

#define BAUD_110 13
#define BAUD_1200 7
#define BAUD_134 12
#define BAUD_150 11
#define BAUD_1800 6
#define BAUD_19200 0
#define BAUD_2000 5
#define BAUD_200 10
#define BAUD_2400 4
#define BAUD_300 9
#define BAUD_3600 3
#define BAUD_4800 2
#define BAUD_50 15
#define BAUD_600 8
#define BAUD_75 14
#define BAUD_9600 1
#define BAUD_INQUIRE (-2)
#define BLIT_HARD 1
#define BLIT_SOFT 0
#define COL_INQUIRE (-1)
#define CURS_BLINK 2
#define CURS_GETRATE 5
#define CURS_HIDE 0
#define CURS_NOBLINK 3
#define CURS_SETRATE 4
#define CURS_SHOW 1
#define DB_COMMAND 0xf100
#define DB_NULLSTRING 0xf000
#define DISK_DSDD 3
#define DISK_DSED 5
#define DISK_DSHD 4
#define DISK_DSSD 1
#define DISK_NOCHANGE (-1)
#define DISK_SSDD 2
#define DISK_SSSD 0
#define EXEC_NO 0
#define EXEC_NOCHANGE (-1)
#define EXEC_YES 1
#define FLOP_DRIVEA 0
#define FLOP_DRIVEB 1
#define FLOP_MAGIC 0x87654321
#define FLOP_NOSKEW 1
#define FLOPPY_DSDD 0
#define FLOPPY_DSED 2
#define FLOPPY_DSHD 1
#define FLOP_SKEW (-1)
#define FLOP_VIRGIN 0xe5e5
#define FLOW_BOTH 3
#define FLOW_HARD 2
#define FLOW_NONE 0
#define FLOW_SOFT 1
#define FRATE_12 1
#define FRATE_2 2
#define FRATE_3 3
#define FRATE_6 0
#define FRATE_INQUIRE 1
#define GI_DTR 0x10
#define GI_FLOPPYA 0x2
#define GI_FLOPPYB 0x4
#define GI_FLOPPYSIDE 0x1
#define GI_GPO 0x40
#define GI_RTS 0x8
#define GI_SCCPORT 0x80
#define GI_STROBE 0x20
#define IM_ABSOLUTE 2
#define IM_DISABLE 0
#define IM_KEYCODE 4
#define IM_RELATIVE 1
#define MFP_200HZ 5
#define MFP_ACIA 6
#define MFP_BAUDRATE 4
#define MFP_BITBLT 3
#define MFP_CTS 2
#define MFP_DCD 1
#define MFP_DISK 7
#define MFP_DMASOUND 13
#define MFP_HBLANK 8
#define MFP_MONODETECT 15
#define MFP_PARALLEL 0
#define MFP_RBF 12
#define MFP_RERR 11
#define MFP_RING 14
#define MFP_TBE 10
#define MFP_TERR 9
#define MFP_TIMERA 13
#define MFP_TIMERB 8
#define MFP_TIMERD 4
#define NVM_READ 0
#define NVM_RESET 2
#define NVM_WRITE 1
#define PRT_ATARI 0x0
#define PRT_COLOR 0x2
#define PRT_CONTINUOUS 0x0
#define PRT_DAISY 0x1
#define PRT_DOTMATRIX 0x0
#define PRT_DRAFT 0x0
#define PRT_EPSON 0x4
#define PRT_FINAL 0x8
#define PRT_INQUIRE (1)
#define PRT_MONO 0x0
#define PRT_PARALLEL 0x0
#define PRT_SERIAL 0x10
#define PRT_SINGLE 0x20
#define PSG_APITCHHIGH 1
#define PSG_APITCHLOW 0
#define PSG_AVOLUME 8
#define PSG_BPITCHHIGH 3
#define PSG_BPITCHLOW 2
#define PSG_BVOLUME 9
#define PSG_CPITCHHIGH 5
#define PSG_CPITCHLOW 4
#define PSG_CVOLUME 10
#define PSG_ENABLEA 0x1
#define PSG_ENABLEB 0x2
#define PSG_ENABLEC 0x4
#define PSG_ENVELOPE 13
#define PSG_FREQHIGH 12
#define PSG_FREQLOW 11
#define PSG_MODE 7
#define PSG_NOISEA 0x8
#define PSG_NOISEB 0x10
#define PSG_NOISEC 0x20
#define PSG_NOISEPITCH 6
#define PSG_PORTA 14
#define PSG_PORTB 15
#define PSG_PRTBOUT 0x80
#define RS_15STOP 0x10
#define RS_1STOP 0x8
#define RS_2STOP 0x18
#define RS_5BITS 0x60
#define RS_6BITS 0x40
#define RS_7BITS 0x20
#define RS_8BITS 0x0
#define RS_BRKDETECT 0x8
#define RS_BUFFULL 0x80
#define RS_CLK16 0x80
#define RS_EVENPARITY 0x0
#define RS_FRAMEERR 0x10
#define RS_INQUIRE (-1)
#define RS_LASTBAUD 2
#define RS_MATCHBUSY 0x4
#define RS_NOSTOP 0x0
#define RS_ODDPARITY 0x2
#define RS_OVERRUNERR 0x40
#define RS_PARITYENABLE 0x4
#define RS_PARITYERR 0x20
#define RS_RECVENABLE 0x1
#define RS_SYNCSTRIP 0x2
#define SCR_MODECODE 3
#define SCR_NOCHANGE 1
#define SERIAL_NOCHANGE (-1)
#define SERIAL_RANDOM 0x01000001
#define SNDNOTLOCK (-128)
#define XB_TIMERA 0
#define XB_TIMERB 1
#define XB_TIMERC 2
#define XB_TIMERD 3

struct IOREC
{
	char *ibuf;
	int ibufsize;
	int ibufhd;
	int ibuftl;
	int ibuflow;
	int ibufhi;
};

struct KBDVECS
{
	void (*midivec) (unsigned char data);
	void (*vkbderr) (unsigned char data);
	void (*vmiderr) (unsigned char data);
	void (*statvec) (char* buf);
	void (*mousevec) (char* buf);
	void (*clockvec) (char* buf);
	void (*joyvec) (char* buf);
	void (*midisys) ();
	void (*ikbdsys) ();
	char ikbdstate;
};

struct KEYTAB
{
	char* unshift;
	char* shift;
	char* caps;
};

struct PRTBLK
{
	void* blkptr;
	unsigned offset;
	unsigned width;
	unsigned height;
	unsigned left;
	unsigned right;
	unsigned srcres;
	unsigned destres;
	unsigned *colpal;
	unsigned type;
	unsigned port;
	char *masks;
};

extern "C" auto Bioskeys () -> void;
extern "C" auto Blitmode (int mode) -> int;
extern "C" auto Cursconf (int mode, int rate) -> int;
extern "C" auto Dbmsg (int rsrvd, int msg_num, long msg_arg) -> void;
extern "C" auto Dosound (const char *cmdlist) -> void;
extern "C" auto Flopfmt (void* buf, int* skew, int dev, int spt, int track, int side, int intlv, long magic, int virgin) -> int;
extern "C" auto Floprate (int dev, int rate) -> int;
extern "C" auto Floprd (void* buf, long rsrvd, int dev, int sector, int track, int side, int count) -> int;
extern "C" auto Flopver (void* buf, long rsrvd, int dev, int sector, int track, int side, int count) -> int;
extern "C" auto Flopwr (void* buf, long rsrvd, int dev, int sector, int track, int side, int count) -> int;
extern "C" auto Getrez () -> int;
extern "C" auto Gettime () -> long;
extern "C" auto Giaccess (int data, int register_) -> int;
extern "C" auto Ikbdws (int len, const char* buf) -> void;
extern "C" auto Initmous (int mode, void* param, void (*vec) ()) -> void;
extern "C" auto Iorec (int dev) -> IOREC*;
extern "C" auto Jdisint (int intno) -> void;
extern "C" auto Jenabint (int intno) -> void;
extern "C" auto Kbdvbase () -> KBDVECS*;
extern "C" auto Kbrate (int delay, int rate) -> int;
extern "C" auto Keytbl (char* unshift, char* shift, char* caps) -> KEYTAB*;
extern "C" auto Logbase () -> void*;
extern "C" auto Mfpint (int intno, int (*vector) ()) -> void;
extern "C" auto Midiws (int count, const char* buf) -> void;
extern "C" auto NVMaccess (int op, int start, int count, char* buffer) -> int;
extern "C" auto Offgibit (int mask) -> void;
extern "C" auto Ongibit (int mask) -> void;
extern "C" auto Physbase () -> void*;
extern "C" auto Protobt (void* buf, long serial, int type, int execflag) -> void;
extern "C" auto Prtblk (PRTBLK* blk) -> int;
extern "C" auto Puntaes () -> void;
extern "C" auto Random () -> long;
extern "C" auto Rsconf (int speed, int flow, int ucr, int rsr, int tsr, int scr) -> unsigned long;
extern "C" auto Scrdmp () -> void;
extern "C" auto Setcolor (int idx, int new_) -> int;
extern "C" auto Setpalette (int* palette) -> void;
extern "C" auto Setprt (int new_) -> int;
extern "C" auto Setscreen (void* log, void* phys, int mode) -> void;
extern "C" auto Settime (long time) -> void;
extern "C" auto Ssbrk (int len) -> void*;
extern "C" auto Supexec (long (*func) ()) -> long;
extern "C" auto Unlocksnd () -> long;
extern "C" auto VsetScreen (void* log, void* phys, int mode, int modecode) -> void;
extern "C" auto Vsync () -> void;
extern "C" auto Xbtimer (int timer, int control, int data, void (*hand) ()) -> void;

#endif // ECS_TOS_HEADER_INCLUDED
