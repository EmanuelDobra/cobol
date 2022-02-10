       IDENTIFICATION DIVISION.
       PROGRAM-ID.       PAINTING.
       AUTHOR.           JANIS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT F01-PAINTING-FILE ASSIGN TO 'art.dat'
                                   ORGANIZATION IS LINE SEQUENTIAL.
           SELECT F02-PRINT-FILE   ASSIGN TO 'artreport.dat'
                                   ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
      * This is the definition of the input file.
       FD  F01-PAINTING-FILE
           RECORD CONTAINS 36 CHARACTERS
           DATA RECORD IS F01-PAINTING-RECORD.
      * All these numbers have to add up to the number of
      * characters written above (36)
       01  F01-PAINTING-RECORD.
           05  F01-NAME            PIC X(25).
           05  F01-VALUE           PIC 9(7).
           05  F01-YEAR            PIC 9999.
       
      * This is the definition of the output file.
       FD  F02-PRINT-FILE
           RECORD CONTAINS 31 CHARACTERS
           DATA RECORD IS F02-PRINT-LINE-RECORD.
       01  F02-PRINT-LINE-RECORD   PIC X(31).

       WORKING-STORAGE SECTION.
       01  W01-DATA-REMAINS-SWITCH PIC X(2)      VALUE SPACES.
       
       01  W02-HEADING-LINE.
           05                      PIC X(4)      VALUE 'NAME'.
           05                      PIC X(23)     VALUE SPACES.
           05                      PIC X(4)      VALUE 'YEAR'.
       
       01  W03-DETAIL-LINE.
           05  W03-PRINT-NAME      PIC X(25).
           05                      PIC X(2)      VALUE SPACES.
           05  W03-PRINT-YEAR      PIC 9(4).

       PROCEDURE DIVISION.
           OPEN INPUT  F01-PAINTING-FILE
           OPEN OUTPUT F02-PRINT-FILE
           READ F01-PAINTING-FILE
               AT END MOVE 'NO' TO W01-DATA-REMAINS-SWITCH
           END-READ
           PERFORM 100-WRITE-HEADING-LINE
           PERFORM 200-PROCESS-RECORDS
               UNTIL W01-DATA-REMAINS-SWITCH = 'NO'
           CLOSE F01-PAINTING-FILE
                 F02-PRINT-FILE
           STOP RUN
           .

      *Start of WRITE-HEADING-LINE paragraph
       100-WRITE-HEADING-LINE.
           MOVE W02-HEADING-LINE TO F02-PRINT-LINE-RECORD
           WRITE F02-PRINT-LINE-RECORD
       .
      *End of WRITE-HEADING-LINE paragraph

      *Start of PROCESS-RECORDS paragraph
       200-PROCESS-RECORDS.
           MOVE F01-NAME TO W03-PRINT-NAME
           MOVE F01-YEAR TO W03-PRINT-YEAR
           MOVE W03-DETAIL-LINE TO F02-PRINT-LINE-RECORD
           WRITE F02-PRINT-LINE-RECORD
        
           READ F01-PAINTING-FILE
               AT END MOVE 'NO' TO W01-DATA-REMAINS-SWITCH
           END-READ
           .
      *End of PROCESS-RECORDS paragraph
