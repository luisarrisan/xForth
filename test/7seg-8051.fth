\ This program exercises the 4 digit 7 segment display
\   and the serial port in a ZS5100 development board.

\ The program updates the 7 segment displays showing a
\   countdown from ffff to 0000, it also prints the counter
\   over the serial port 9600/8/N/1 (no flow control).

\ Tested using a Nuvoton W78E052D (cheap 8052 clone) with
\   a 11.0592 MHz crystal.

\ The W78E052D has 256 bytes of internal ram 8k of
\   code memory and no external ram.

\ For more information...
\ W78E052D -> https://www.nuvoton.com/products/microcontrollers/8bit-8051-mcus/standard-8051-series/w78e052d
\ W78E052D -> https://alselectro.wordpress.com/2019/09/12/nuvotone-w78e052-89s52-programming-through-serial-port/
\ ZS5100 -> https://www.instructables.com/Cheap-AVR51-Development-board/

include target/8051/uart.fth

hex

: > swap - 0< ;

: rshift ( x n -- x' )
  1- for 2/ next ;

: hex-digit-tuck ( x -- d x>>4 )
  dup f and 30 + dup 39 > if 7 + then
  swap 4 rshift ;

: cr 0d emit ;

: .hex ( n -- )
  3 for hex-digit-tuck next
  drop
  3 for emit next ;

code p0!
  dpl lda,
  a cpl,
  p0 sta,
  ' drop ajmp,
end-code

code p1!
  dpl lda,
  a cpl,
  p1 sta,
  ' drop ajmp,
end-code

here constant 7seg_digits
3F c, 06 c, 5B c, 4F c,
66 c, 6D c, 7D c, 07 c,
7F c, 6f c, 77 c, 7C c,
58 c, 5E c, 79 c, 71 c,

: display-digit ( d x -- d>>1 x>>4 )
  0 p1!
  \ The longer this delay the dimmer the display.
  10 for next
  dup f and 7seg_digits + c@c p0!
  swap dup p1! 2/
  swap 4 rshift ;

: display-counter ( n -- )
  \ The longer this loop the slower the countdown.
  40 begin
    over 8 swap 
    3 for display-digit next
    0 p1!
    2drop 
  1- dup 0= until 2drop ;

\ Jump here from COLD.
: hex-countdown then
  setup-uart
  ffff for 
    r@ .hex cr
    r@ display-counter
  next
  bye ;

