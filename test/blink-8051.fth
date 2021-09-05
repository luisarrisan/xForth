include target/8051/uart.fth

hex

code !p0
  dpl lda,
  a cpl,
  p0 sta,
  ' drop ajmp,
end-code

code !p1
  dpl lda,
  a cpl,
  p1 sta,
  ' drop ajmp,
end-code

: more ( x -- x' ) dup 40 = if drop 1 then ;
: cycle ( x -- x' ) dup dup + swap !p0 more ;

\ Variables will be at the bottom of the data stack
fe constant n \ n address
fc constant x \ x address

: setup  setup-uart
  200 n !  100 x ! ;
: delay  for next ;
: led-on   01 !p1 300 delay ;
: led-off   0 !p1 300 delay ;
\ Jump here from COLD.
: warm then
  dup dup \ Make room for n and x at the bottom of the data stack
  setup 01 begin led-off led-on 41 emit key emit cycle again ;
