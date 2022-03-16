       IDENTIFICATION DIVISION.
       PROGRAM-ID. NumericEditedExercise.
       AUTHOR. Janis Michael.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       DATA DIVISION.

       FILE SECTION.

       WORKING-STORAGE SECTION.
       01 W01-NAME PIC X(15).
       01 W02-AGE PIC 999.
       01 W03-NUM PIC 9999V99 VALUE 1234.56.
       01 W04-NUM-OUT PIC $9,999.99.

       PROCEDURE DIVISION.
           DISPLAY "Welcome to Numeric Edited Exercise"
           DISPLAY "What is your name?"
           ACCEPT W01-NAME
           DISPLAY "What is your age?"
           ACCEPT W02-AGE
           ADD 10 TO W02-AGE ROUNDED
           DISPLAY "Hi " W01-NAME ". In 10 years, you will be " W02-AGE

           MOVE W03-NUM TO W04-NUM-OUT
           DISPLAY "W03-NUM has the value " W03-NUM
           DISPLAY "W04-NUM-OUT has the value " W04-NUM-OUT
           STOP RUN.
