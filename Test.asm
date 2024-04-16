;  =========================================================================
; |                           CRC32 TEST                                    |
;  =========================================================================

		opt	l.					; . is the local label symbol
		opt	ws+					; allow statements to contain white-spaces
		opt	w+					; print warnings
		opt	m+					; do not expand macros - if enabled, this can break assembling
		
year:		equ _year+1900
month:		substr ((_month-1)*3)+1,((_month-1)*3)+3,"JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
date:		equs "\#year\.\month"				; e.g. "1991.APR" for use in header

; ===========================================================================

ROM_Start:
Vectors:	dc.l 0						; Initial stack pointer value
		dc.l EntryPoint					; Start of program
		dcb.l 26,ErrorTrap
		dc.l HBlank
		dc.l ErrorTrap
		dc.l VBlank
		dcb.l 33,ErrorTrap
		dc.b "SEGA MEGA DRIVE "				; Hardware system ID (Console name)
		dc.b "(C)SEGA \date"				; Copyright holder and release date (generally year)
		dc.b "CRC32 TEST                                      " ; Domestic name
		dc.b "CRC32 TEST                                      " ; International name
		dc.b "GM 00000000-00"				; Serial/version number

Checksum: 	dc.w $0
		dc.b "J6              "				; I/O support
ROM_Start_Ptr:	dc.l ROM_Start					; Start address of ROM
ROM_End_Ptr:	dc.l ROM_End-1					; End address of ROM
		dc.l $FF0000					; Start address of RAM
		dc.l $FFFFFF					; End address of RAM

		dc.l $20202020					; dummy values (SRAM disabled)
		dc.l $20202020					; SRAM start
		dc.l $20202020					; SRAM end

		dc.b "                                                    "
		dc.b "JUE             "				; Region (Country code)
EndOfHeader:

; ===========================================================================

ErrorTrap:
		nop
		nop
		bra.s	ErrorTrap
		
HBlank:
VBlank:
		rte
; ===========================================================================

EntryPoint:
		lea	S1_ROM,a1				; set start address
		move.l	#sizeof_S1,d0				; set length
		bsr.s	CalcCRC32				; d1 = CRC32
		move.l	d1,($FF0000).l				; write to RAM
		bra.s	ErrorTrap				; that's all

		include	"CalcCRC32.asm"
S1_ROM:		incbin	"s1built.bin"
sizeof_S1:	equ *-S1_ROM
		
ROM_End:
		END
