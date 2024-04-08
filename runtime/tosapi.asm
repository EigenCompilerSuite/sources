; Atari TOS API wrapper
; Copyright (C) Florian Negele

; This file is part of the Eigen Compiler Suite.

; The ECS is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.

; The ECS is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.

; Under Section 7 of the GNU General Public License version 3,
; the copyright holder grants you additional permissions to use
; this file as described in the ECS Runtime Support Exception.

; You should have received a copy of the GNU General Public License
; and a copy of the ECS Runtime Support Exception along with
; the ECS.  If not, see <https://www.gnu.org/licenses/>.

; GEMDOS functions

#define gemdos

	.code #0
		movea.l	(sp)+, a3
		move.w	#1, -(sp)
		trap	1
		addq.l	2, sp
		movea.l	d0, a0
		jmp	(a3)

#enddef

	gemdos	Cauxin, 0x03
	gemdos	Cauxis, 0x12
	gemdos	Cauxos, 0x13
	gemdos	Cauxout, 0x04
	gemdos	Cconin, 0x01
	gemdos	Cconis, 0x0b
	gemdos	Cconos, 0x10
	gemdos	Cconout, 0x02
	gemdos	Cconrs, 0x0a
	gemdos	Cconws, 0x09
	gemdos	Cnecin, 0x08
	gemdos	Cprnos, 0x11
	gemdos	Cprnout, 0x05
	gemdos	Crawcin, 0x07
	gemdos	Crawio, 0x06
	gemdos	Dcreate, 0x39
	gemdos	Ddelete, 0x3a
	gemdos	Dfree, 0x36
	gemdos	Dgetdrv, 0x19
	gemdos	Dgetpath, 0x47
	gemdos	Dsetdrv, 0x0e
	gemdos	Dsetpath, 0x3b
	gemdos	Fattrib, 0x43
	gemdos	Fclose, 0x3e
	gemdos	Fcreate, 0x3c
	gemdos	Fdatime, 0x57
	gemdos	Fdelete, 0x41
	gemdos	Fdup, 0x45
	gemdos	Fforce, 0x46
	gemdos	Fgetdta, 0x2f
	gemdos	Fopen, 0x3d
	gemdos	Fread, 0x3f
	gemdos	Frename, 0x56
	gemdos	Fseek, 0x42
	gemdos	Fsetdta, 0x1a
	gemdos	Fsfirst, 0x4e
	gemdos	Fsnext, 0x4f
	gemdos	Fwrite, 0x40
	gemdos	Malloc, 0x48
	gemdos	Mfree, 0x49
	gemdos	Mshrink, 0x4a
	gemdos	Pexec, 0x4b
	gemdos	Pterm0, 0x00
	gemdos	Pterm, 0x4c
	gemdos	Ptermres, 0x31
	gemdos	Super, 0x20
	gemdos	Sversion, 0x30
	gemdos	Tgetdate, 0x2a
	gemdos	Tgettime, 0x2c
	gemdos	Tsetdate, 0x2b
	gemdos	Tsettime, 0x2d

#undef gemdos

; BIOS functions

#define bios

	.code #0
		movea.l	(sp)+, a3
		move.w	#1, -(sp)
		trap	13
		addq.l	2, sp
		movea.l	d0, a0
		jmp	(a3)

#enddef

	bios	Bconin, 0x02
	bios	Bconout, 0x03
	bios	Bconstat, 0x01
	bios	Bcostat, 0x08
	bios	Drvmap, 0x0a
	bios	Getbpb, 0x07
	bios	Getmpb, 0x00
	bios	Kbshift, 0x0b
	bios	Mediach, 0x09
	bios	Rwabs, 0x04
	bios	Setexc, 0x05
	bios	Tickcal, 0x06

#undef bios

; XBIOS functions

#define xbios

	.code #0
		movea.l	(sp)+, a3
		move.w	#1, -(sp)
		trap	14
		addq.l	2, sp
		movea.l	d0, a0
		jmp	(a3)

#enddef

	xbios	Bioskeys, 0x18
	xbios	Blitmode, 0x40
	xbios	Cursconf, 0x15
	xbios	Dbmsg, 0x0b
	xbios	Dosound, 0x20
	xbios	Flopfmt, 0x0a
	xbios	Floprate, 0x29
	xbios	Floprd, 0x08
	xbios	Flopver, 0x13
	xbios	Flopwr, 0x09
	xbios	Getrez, 0x04
	xbios	Gettime, 0x17
	xbios	Giaccess, 0x1c
	xbios	Ikbdws, 0x19
	xbios	Initmous, 0x00
	xbios	Iorec, 0x0e
	xbios	Jdisint, 0x1a
	xbios	Jenabint, 0x1b
	xbios	Kbdvbase, 0x22
	xbios	Kbrate, 0x23
	xbios	Keytbl, 0x10
	xbios	Logbase, 0x03
	xbios	Mfpint, 0x0d
	xbios	Midiws, 0x0c
	xbios	NVMaccess, 0x2e
	xbios	Offgibit, 0x1d
	xbios	Ongibit, 0x1e
	xbios	Physbase, 0x02
	xbios	Protobt, 0x12
	xbios	Prtblk, 0x24
	xbios	Puntaes, 0x27
	xbios	Random, 0x11
	xbios	Rsconf, 0x0f
	xbios	Scrdmp, 0x14
	xbios	Setcolor, 0x07
	xbios	Setpalette, 0x06
	xbios	Setprt, 0x21
	xbios	Setscreen, 0x05
	xbios	Settime, 0x16
	xbios	Ssbrk, 0x01
	xbios	Supexec, 0x26
	xbios	Unlocksnd, 0x81
	xbios	Vsetscreen, 0x05
	xbios	Vsync, 0x25
	xbios	Xbtimer, 0x1f

#undef xbios
