       IDENTIFICATION DIVISION.
       PROGRAM-ID.       PutIDHere.
       AUTHOR.           EmanuelDobra.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT F01-SomeFile ASSIGN TO 'someinputfile.dat'
                                   ORGANIZATION IS LINE SEQUENTIAL.
           SELECT F02-SomeFile   ASSIGN TO 'someoutputfile.dat'
                                   ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       

       WORKING-STORAGE SECTION.
      
       PROCEDURE DIVISION.
            
       STOP RUN
       .

       