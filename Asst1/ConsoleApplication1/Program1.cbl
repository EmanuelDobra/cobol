       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAINTING.
       AUTHOR. JANIS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT F01-GRADES-FILE ASSIGN TO 'CodingAsst.dat'
                                   ORGANIZATION IS LINE SEQUENTIAL.
           SELECT F02-PRINT-FILE   ASSIGN TO 'UniReport.dat'
                                   ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
      * This is the definition of the input file.
       FD  F01-GRADES-FILE
           RECORD CONTAINS 53 CHARACTERS
           DATA RECORD IS F01-GRADES-RECORD.
      * All these numbers have to add up to the number of
      * characters written above (53)
       01 F01-GRADES-RECORD.
         05 F01-STUDENT-ID PIC (5).
         05 F01-COURSE-1 PIC X(7).
         05 F01-GRADE-1 PIC X.
         05 F01-COURSE-2 PIC X(7).
         05 F01-GRADE-2 PIC X.
         05 F01-COURSE-3 PIC X(7).
         05 F01-GRADE-3 PIC X.
         05 F01-COURSE-4 PIC X(7).
         05 F01-GRADE-4 PIC X.
         05 F01-COURSE-5 PIC X(7).
         05 F01-GRADE-5 PIC X.
         05 F01-COURSE-6 PIC X(7).
         05 F01-GRADE-6 PIC X.

      * This is the definition of the output file.
       FD  F02-PRINT-FILE
           RECORD CONTAINS 59 CHARACTERS
           DATA RECORD IS F02-PRINT-LINE-RECORD.
       01 F02-PRINT-LINE-RECORD PIC X(59).

       WORKING-STORAGE SECTION.
       01 W01-DATA-REMAINS-SWITCH PIC X(2) VALUE SPACES.

       01 W02-HEADING-LINE.
         05 PIC X(4) VALUE 'NAME'.
         05 PIC X(23) VALUE SPACES.
         05 PIC X(4) VALUE 'YEAR'.

       01 W03-DETAIL-LINE.
         05 W03-PRINT-NAME PIC X(25).
         05 PIC X(2) VALUE SPACES.
         05 W03-PRINT-YEAR PIC 9(4).

       PROCEDURE DIVISION.
           OPEN INPUT F01-GRADES-FILE
           OPEN OUTPUT F02-PRINT-FILE
           READ F01-GRADES-FILE
               AT END
                   MOVE 'NO' TO W01-DATA-REMAINS-SWITCH
           END-READ
           PERFORM 100-WRITE-HEADING-LINE
           PERFORM 200-PROCESS-RECORDS
             UNTIL W01-DATA-REMAINS-SWITCH = 'NO'
           CLOSE F01-GRADES-FILE
             F02-PRINT-FILE
           STOP RUN.

      *Start of WRITE-HEADING-LINE paragraph
       100-WRITE-HEADING-LINE.
           MOVE W02-HEADING-LINE TO F02-PRINT-LINE-RECORD
           WRITE F02-PRINT-LINE-RECORD.
      *End of WRITE-HEADING-LINE paragraph

      *Start of PROCESS-RECORDS paragraph
       200-PROCESS-RECORDS.
           MOVE F01-NAME TO W03-PRINT-NAME
           MOVE F01-YEAR TO W03-PRINT-YEAR
           MOVE W03-DETAIL-LINE TO F02-PRINT-LINE-RECORD
           WRITE F02-PRINT-LINE-RECORD

           READ F01-GRADES-FILE
               AT END
                   MOVE 'NO' TO W01-DATA-REMAINS-SWITCH
           END-READ.
      *End of PROCESS-RECORDS paragraph
