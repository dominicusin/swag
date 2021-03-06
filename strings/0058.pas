{*****************************************************************************
 * Function ...... UpperCase()
 * Purpose ....... To convert a string to upper case
 * Parameters .... s          String to convert
 * Returns ....... <s> with all capital letters
 * Notes ......... None
 * Author ........ Martin Richardson
 * Date .......... October 2, 1992
 *****************************************************************************}
FUNCTION UpperCase( s: STRING ): STRING; ASSEMBLER;
ASM
      PUSH   DS
      CLD
      LDS    SI, s
      XOR    AX, AX
      LODSB
      XCHG   AX, CX
      LES    DI, @Result
      MOV    BYTE PTR ES:[DI], CL
      JCXZ   @@3
      INC    DI

@@1:  LODSB
      CMP    AL, 'a'
      JB     @@2
      CMP    AL, 'z'
      JA     @@2
      XOR    AL, $20

@@2:  STOSB
      LOOP   @@1

@@3:  POP    DS
END;

