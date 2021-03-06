(*
│{$F+}
│PROCEDURE DoNothing; INTERRUPT;
│BEGIN
│END;
│{$F-}

 Would you believe that the code in your DoNothing procedure can be
 improved for smaller size and better speed? (No, I'm not kidding,
 please read on.)  The standard preamble and postamble code generated by
 Turbo Pascal for a procedure of type Interrupt pushes a whole wad of
 registers, sets the BP and DS registers, and then undoes it all before
 the IRET.  Your DoNothing procedure compiles to code that looks
 something like this:

   { preamble }
       PUSH  AX BX CX DX SI DI DS ES BP
       MOV   BP, SP
       MOV   AX, @DATA
       MOV   DS, AX
   { postamble }
       POP   BP ES DS DI SI DX CX BX AX
       IRET

 The following procedure provides identical results and kills the
 overhead.
*)
   {$f+}
   PROCEDURE DoNothing; ASSEMBLER;   { Coded as Int Handler }
     asm
       IRET             { return from interrupt }
     end;
   {$f-}
(*
 With no parameters and no local vars Turbo Pascal generates no preamble
 code, and generates only a long return as postamble.  The resulting
 compiled code from my DoNothing proc looks like this:

   IRET
   RET

 The difference:  26 bytes and many stack memory accesses for the null
 Interrupt procedure versus only 2 bytes in the null Assembler procedure
 with Iret.  The RET never gets executed, of course.
*)
