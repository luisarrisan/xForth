hex

\ This is for an 8051 running at 11.0592 MHz.

\ Setup UART for 9600 baud 8N1 no flow control
code setup-uart
  0 # ie movi,
  0 # pcon movi,
  20 # tmod movi,
  fd # th1 movi,
  d2 c, 8e c,       ( setb TCON.6 )
  52 # scon movi,
  ret,
end-code

code emit
  30 c, 99 c, fd c, ( ' emit scon.1 jnb, )
  c2 c, 99 c,       ( scon.1 clr,        )
  dpl lda,
  sbuf sta,
  ' drop ajmp,
end-code

code key
  30 c, 98 c, fd c, ( ' key scon.0 jnb, )
  c2 c, 98 c,       ( scon.0 clr,       )
  ' dup acall,
  sbuf lda, dpl sta,
  0 # dph movi,
  ret,
end-code

