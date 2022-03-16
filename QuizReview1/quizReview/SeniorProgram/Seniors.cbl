       IDENTIFICATION DIVISION.
       PROGRAM-ID. SENIOR.
       AUTHOR. ROBERT GRAUER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT F01-STUDENT-FILE ASSIGN TO 'SENIOR.DAT'
                                   ORGANIZATION IS LINE SEQUENTIAL.
           SELECT F02-PRINT-FILE   ASSIGN TO 'SENIORREPORT.DAT'
                                   ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
      * This is the definition of the input file.
       FD  F01-STUDENT-FILE
           RECORD CONTAINS 43 CHARACTERS
           DATA RECORD IS F01-STUDENT-RECORD.
      * All these numbers have to add up to the number of
      * characters written above (43)
       01 F01-STUDENT-RECORD.
         05 F01-STU-NAME PIC X(25).
         05 F01-STU-CREDITS PIC 9(3).
         05 F01-STU-MAJOR PIC X(15).

      * This is the definition of the output file.
       FD  F02-PRINT-FILE
           RECORD CONTAINS 132 CHARACTERS
           DATA RECORD IS F02-PRINT-LINE-RECORD.
       01 F02-PRINT-LINE-RECORD PIC X(132).

       WORKING-STORAGE SECTION.
       01 W01-DATA-REMAINS-SWITCH PIC X(2) VALUE SPACES.

      * All these numbers have to add up to the number of
      * characters written above (132)
       01 W02-HEADING-LINE.
         05 PIC X(10) VALUE SPACES.
         05 PIC X(12) VALUE 'STUDENT NAME'.
         05 PIC X(110) VALUE SPACES.

      * All these numbers have to add up to the number of
      * characters written above (132)
       01 W03-DETAIL-LINE.
         05 PIC X(8) VALUE SPACES.
         05 W03-PRINT-NAME PIC X(25).
         05 PIC X(99) VALUE SPACES.

       PROCEDURE DIVISION.
           OPEN INPUT F01-STUDENT-FILE
           OPEN OUTPUT F02-PRINT-FILE
           READ F01-STUDENT-FILE
               AT END
                   MOVE 'NO' TO W01-DATA-REMAINS-SWITCH
           END-READ
           PERFORM 100-WRITE-HEADING-LINE
           PERFORM 200-PROCESS-RECORDS
             UNTIL W01-DATA-REMAINS-SWITCH = 'NO'
           CLOSE F01-STUDENT-FILE
             F02-PRINT-FILE
           STOP RUN.

      *Start of WRITE-HEADING-LINE paragraph
       100-WRITE-HEADING-LINE.
           MOVE W02-HEADING-LINE TO F02-PRINT-LINE-RECORD
           WRITE F02-PRINT-LINE-RECORD.
      *End of WRITE-HEADING-LINE paragraph

      *Start of PROCESS-RECORDS paragraph
       200-PROCESS-RECORDS.
           IF F01-STU-CREDITS > 110 AND F01-STU-MAJOR = 'ENGINEERING'
               MOVE F01-STU-NAME TO W03-PRINT-NAME
               MOVE W03-DETAIL-LINE TO F02-PRINT-LINE-RECORD
               WRITE F02-PRINT-LINE-RECORD
           END-IF
           READ F01-STUDENT-FILE
               AT END
                   MOVE 'NO' TO W01-DATA-REMAINS-SWITCH
           END-READ.
      *End of PROCESS-RECORDS paragraph
