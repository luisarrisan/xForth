hex

code >spi>
  dpl      lda,
  08 # r2 movi,
           rlc,
label loop_spi
  92 c, p0.0 c, (  mov mosi, c )
  d2 c, p0.2 c, ( setb sck     )
  a2 c, p0.1 c, (  mov c, miso )
           rlc,
  c2 c, p0.2 c, (  clr sck     )
  dpl      sta,
  loop_spi r2 djnz,
           ret,
end-code

code spi+
 c2 c, p0.3 c, ret,
end-code ( clr p0.3 )
code spi-
 d2 c, p0.3 c, ret,
end-code ( setb p0.3 )
code setclk
 c2 c, p0.2 c, ret,
end-code ( clr p0.2 )
code resclk
 d2 c, p0.2 c, ret,
end-code ( setb p0.2 )

: spi-init spi- resclk ;

