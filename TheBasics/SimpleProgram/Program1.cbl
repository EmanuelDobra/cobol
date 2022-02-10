       IDENTIFICATION DIVISION.
       PROGRAM-ID. SimpleProgram.
       AUTHOR.     Dobra.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       
       DATA DIVISION.
       FILE SECTION.

       WORKING-STORAGE SECTION.

       PROCEDURE DIVISION.
           DISPLAY 'Starting'
           PERFORM 100-INIT
           PERFORM 200-FINAL
           DISPLAY 'Ending'
           STOP RUN
       .

       100-INIT.
           DISPLAY 'I am in init'
       .

       200-FINAL.
           DISPLAY 'I am in final'
       .
