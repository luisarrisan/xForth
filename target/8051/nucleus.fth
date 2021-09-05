hex

also assembler
   \ Interrupt vectors.
   ahead, nop,
   reti, 7 allot
   reti, 7 allot
   reti, 7 allot
   reti, 7 allot \ Breakpoint here for successful test.
   reti, 7 allot \ Breakpoint here for failed test.
end-code

code cold
   then,
   FF # r0 movi,
   7 # sp movi,
   ahead, nop,
end-code

code dup
   r0 dec,
   dph lda,
   @r0 sta,
   r0 dec,
   dpl lda,
   @r0 sta,
   ret,
end-code

code r>
   ' dup acall,
   3 pop,
   2 pop,
   dph pop,
   dpl pop,
   2 push,
   3 push,
   ret,
end-code

code r@
   ' dup acall,
   sp r1 ldm,
   r1 dec,
   r1 dec,
   @r1 dph stm,
   r1 dec,
   @r1 dpl stm,
   ret,
end-code

code swap
   @r0 lda,
   r2 sta,
   r0 inc,
   @r0 lda,
   r3 sta,
label semiswap
   dph lda,
   @r0 sta,
   r0 dec,
   dpl lda,
   @r0 sta,
   r3 dph stm,
   r2 dpl stm,
   ret,
end-code

code over
   @r0 lda,
   r2 sta,
   r0 inc,
   @r0 lda,
   r3 sta,
   r0 dec,
   r0 dec,
   semiswap sjmp,
end-code

code invert
   FF # dpl xrlm,
   FF # dph xrlm,
   ret,
end-code

: negate   invert 1+ ;
: 1-   1 [  \ Fall through.
: -   negate [  \ Fall through.

code +
   @r0 lda,
   r0 inc,
   dpl add,
   dpl sta,
   @r0 lda,
   r0 inc,
   dph addc,
   dph sta,
   ret,
end-code

code xor
   @r0 lda,
   r0 inc,
   a dpl xrlm,
   @r0 lda,
   r0 inc,
   a dph xrlm,
   ret,
end-code

code and
   @r0 lda,
   r0 inc,
   a dpl anlm,
   @r0 lda,
   r0 inc,
   a dph anlm,
   ret,
end-code

code or
   @r0 lda,
   r0 inc,
   a dpl orlm,
   @r0 lda,
   r0 inc,
   a dph orlm,
   ret,
end-code

code 2*   
   dpl lda,
   dpl add,
   dpl sta,
   dph lda,
   rlc,
   dph sta,
   ret,
end-code

code 2/   
   dph lda,
   rlc,
   dph lda,
   rrc,
   dph sta,
   dpl lda,
   rrc,
   dpl sta,
   ret,
end-code

code @x \ fetch word from external ram address
   @dptr xlda,
   r2 sta,
   A3 c, \ dptr inc,
   @dptr xlda,
   dph sta,   
   r2 dpl stm,
   ret,
end-code

code c@x \ fetch byte from external ram address
   @dptr xlda,
   dpl sta,
   0 # dph movi,
   ret,
end-code

code c!x \ store byte into external ram address
   @r0 xlda,
   @dptr xsta,
   \ Fall through to "2drop".
end-code

code 2drop
   r0 inc,
   r0 inc,
   \ Fall through to "drop".
end-code

code drop
   @r0 lda,
   dpl sta,
   r0 inc,
   @r0 lda,
   dph sta,
   r0 inc,
   ret,
end-code

code c@c \ fetch byte from code memory address
   a clr,
   @dptr_clda,
   dpl sta,
   0 # dph movi,
   ret,
end-code

code @c \ fetch word from code memory address
   a clr,
   @dptr_clda,
   r1 sta,
   a3 c, \ dptr inc,
   a clr,
   @dptr_clda,
   dph sta,
   r1 dpl stm,
   ret,
end-code

code @ \ fetch word from internal ram address
  dpl r1 ldm,
  @r1 dpl stm,
  r1 inc,
  @r1 dph stm,
  ret,
end-code

code c@ \ fetch byte from internal ram address
  dpl r1 ldm,
  @r1 dpl stm,
  0 # dph movi,
  ret,
end-code

code c! \ store byte into internal ram address
  dpl r1 ldm,
  @r0 lda,
  @r1 sta,
  r0  inc,
  r0  inc,
  ' drop ajmp,
end-code

code execute
  dpl push,
  dph push,
  ' drop ajmp,
end-code

code >r
   3 pop,
   2 pop,
   dpl push,
   dph push,
   2 push,
   3 push,
   ' drop sjmp,
end-code

\ add into internal ram address value
: +!   dup >r @ + r> [  \ Fall through.

code ! \ store word into internal ram address
  dpl r1 ldm,
  @r0 lda,
  @r1 sta,
  r0  inc,
  r1  inc,
  @r0 lda,
  @r1 sta,
  r0  inc,
  ' drop ajmp,
end-code

\ add into external ram address value
: +!x   dup >r @x + r> [  \ Fall through.

code !x
   @r0 xlda,
   r0 inc,
   @dptr xsta,
   A3 c, \ dptr inc,
   @r0 xlda,
   r0 inc,
   @dptr xsta,
   ' drop sjmp,
end-code

code swap
   @r0 lda,
   r2 sta,
   r0 inc,
   @r0 lda,
   r3 sta,
   dph lda,
   @r0 sta,
   r0 dec,
   dpl lda,
   @r0 sta,
   r3 dph stm,
   r2 dpl stm,
   ret,
end-code

code branch?
   dpl lda,
   dph orl,
   r4 sta,
   ' drop acall,
   r4 lda,
   ret,
end-code

code 0<
   dph lda,
   rlc,
   cs, if,
     FF # dph movi,
     FF # dpl movi,
   else,
     0 # dph movi,
     0 # dpl movi,
   then,
   ret,
end-code

: ?dup   dup if dup then ;
: =   - [  \ Fall through.
: 0=   if 0 else -1 then ;
: <>   - [  \ Fall through.
: 0<>   0= 0= ;

code bye
   1B ljmp,
end-code

code panic
   23 ljmp,
end-code
