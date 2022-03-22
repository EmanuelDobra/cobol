/* TODO 
Page 70 - Fix the errors of the debugging excercise
      
      IDENTIFICATION DIVISION. 
       PROGRAM-ID.    TUIT6COM. 
       AUTHOR.        CAROL VAZQUEZ VILLAR.
 
       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL. 
           SELECT STUDENT-FILE      ASSIGN TO 'tuitiondebug.dat'.     // Extra period
                                    ORGANIZATION IS LINE SEQUENTIAL.
           SELECT PRINT-FILE
                                    ASSIGN TO 'tuitiondebug.dat'
                                    ORGANIZATION IS LINE SEQUENTIAL.
 
       DATA DIVISION. 
       FILE SECTION. 
       FD  STUDENT-FILE 
           RECORD CONTAINS 28 CHARACTERS.  // Only 26 defined below
       01  STUDENT-RECORD. 
           05  STU-NAME. 
               10  STU-LAST-NAME    PIC X(15). 
               10  STU-INITIALS     PIC XX. 
           05  STU-CREDITS          PIC 9(2). 
           05  STU-UNION-MEMBER     PIC X. 
           05  STU-SCHOLARSHIP      PIC 9(4). 
           05  STU-GPA              PIC 9V99. 
 
       FD  PRINT-FILE 
           RECORD CONTAINS 132 CHARACTERS.     // Missing line -> DATA RECORD IS F02-PRINT-LINE.
       01  PRINT-LINE               PIC X(132). 
      
       WORKING-STORAGE SECTION. 
       01  DATA-REMAINS-SWITCH      PIC X(2)  VALUE SPACES. 
       
       01  INDIVIDUAL-CALCULATIONS. 
           05  IND-TUITION          PIC 9(4)  VALUE ZEROS. 
           05  IND-ACTIVITY-FEE     PIC 9(2)  VALUE ZEROS. 
           05  IND-UNION-FEE        PIC 9(2)  VALUE ZEROS. 
           05  IND-SCHOLARSHIP      PIC 9(3)  VALUE ZEROS. 
           05  IND-BILL             PIC 9(6)  VALUE ZEROS. 
       
       01  UNIVERSITY-TOTALS.
           05  UNI-TUITION          PIC 9(6)  VALUE ZEROS. 
           05  UNI UNION FEE        PIC 9(4)  VALUE ZEROS. 
           05  UNI-ACTIVITY-FEE     PIC 9(4)  VALUE ZEROS.
           05  UNI-SCHOLARSHIP      PIC X(6)  VALUE ZEROS. 
           05  UNI-IND-BILL         PIC 9(6)  VALUE ZEROS. 

       01  CONSTANTS-AND-RATES.
           05  PRICE-PER-CREDIT     PIC 9(3)  VALUE 200.
           05  UNION-FEE            PIC 9(2)  VALUE 25.
           05  ACTIVITY-FEES.
               10  1ST-ACTIVITY-FEE PIC 99    VALUE 25.
               10  1ST-CREDIT-LIMIT PIC 99    VALUE 6.
               10  2ND-ACTIVITY-FEE PIC 99    VALUE 50.
               10  2ND-CREDIT-LIMIT PIC 99    VALUE 12.
               10  3RD-ACTIVITY-FEE PIC 99    VALUE 75.
           05  MINIMUM-SCHOLAR-GPA  PIC 9V9   VALUE 2.5.
           
       01  HEADING-LINE. 
           05  FILLER               PIC X     VALUE SPACES.
           05  FILLER               PIC X(12) VALUE 'STUDENT NAME'. 
           05  FILLER               PIC X(10) VALUE SPACES  
           05  FILLER               PIC X(7)  VALUE 'CREDITS'. 
           05  FILLER               PIC X(2)  VALUE SPACES. 
           05  FILLER               PIC X(7)  VALUE 'TUITION'. 
           05  FILLER               PIC X(2)  VALUE SPACES. 
           05  FILLER               PIC X(9)  VALUE 'UNION FEE'. 
           05  FILLER               PIC X(2)  VALUE SPACES. 
           05  FILLER               PIC X(7)  VALUE 'ACT FEE'. 
           05  FILLER               PIC X(2)  VALUE SPACES. 
           05  FILLER               PIC X(11) VALUE 'SCHOLARSHIP'. 
           05  FILLER               PIC X(2)  VALUE SPACES. 
           05  FILLER               PIC X(10) VALUE 'TOTAL BILL'. 
           05  FILLER               PIC X(48) VALUE SPACES. 
       
       01  DETAIL-LINE. 
           05  FILLER               PIC X     VALUE SPACES.
           05  DET-LAST-NAME        PIC X(15). 
           05  FILLER               PIC X(2)  VALUE SPACES. 
           05  DET-INITIALS         PIC X(2). 
           05  FILLER               PIC X(5)  VALUE SPACES. 
           05  STU-CREDITS          PIC 9(2). 
           05  FILLER               PIC X(6)  VALUE SPACES. 
           05  DET-TUITION          PIC 9(6). 
           05  FILLER               PIC X(7)  VALUE SPACES. 
           05  DET-UNION-FEE        PIC 9(3). 
           05  FILLER               PIC X(6)  VALUE SPACES. 
           05  DET-ACTIVITY-FEE     PIC 9(3). 
           05  FILLER               PIC X(8)  VALUE SPACES. 
           05  DET-SCHOLARSHIP      PIC 9(5). 
           05  FILLER               PIC X(6)  VALUE SPACES. 
           05  DET-IND-BILL         PIC 9(6). 
           05  FILLER               PIC X(49) VALUE SPACES. // Should be 51 to add up to 132 

        01  DASH-LINE.
            05  FILLER               PIC X(31) VALUE SPACES.
            05  FILLER               PIC X(8)  VALUE ALL '-'.
            05  FILLER               PIC X(2)  VALUE SPACES.
            05  FILLER               PIC X(8)  VALUE ALL '-'.
            05  FILLER               PIC X(2)  VALUE SPACES. 
            05  FILLER               PIC X(7)  VALUE ALL '-'.
            05  FILLER               PIC X(6)  VALUE SPACES. 
            05  FILLER               PIC X(7)  VALUE ALL '-'.
            05  FILLER               PIC X(5)  VALUE SPACES. 
            05  FILLER               PIC X(7)  VALUE ALL '-'.
            05  FILLER               PIC X(49) VALUE SPACES. 

        01  TOTAL-LINE. 
            05  FILLER               PIC X(8)  VALUE SPACES. 
            05  FILLER               PIC X(17) VALUE 'UNIVERSITY TOTALS'. 
            05  FILLER               PIC X(8)  VALUE SPACES. 
            05  TOT-TUITION          PIC 9(6). 
            05  FILLER               PIC X(6)  VALUE SPACES. 
            05  TOT-UNION-FEE        PIC 9(4). 
            05  FILLER               PIC X(5)  VALUE SPACES. 
            05  TOT-ACTIVITY-FEE     PIC 9(4). 
            05  FILLER               PIC X(7)  VALUE SPACES. 
            05  TOT-SCHOLARSHIP      PIC 9(6). 
            05  FILLER               PIC X(6)  VALUE SPACES. 
            05  TOT-IND-BILL         PIC 9(6). 
            05  FILLER               PIC X(49) VALUE SPACES. 
       
       PROCEDURE DIVISION. 
       START. 
           OPEN INPUT STUDENT-FILE 
                OUTPUT PRINT-FILE
           PERFORM WRITE-HEADING-LINE
           PERFORM READ-STUDENT-FILE
           PERFORM PROCESS-STUDENT-RECORD
                UNTIL DATA-REMAINS-SWITCH = 'NO'
           PERFORM WRITE-UNIVERSITY-TOTALS
           CLOSE STUDENT-FILE 
                 PRINT-FILE
           STOP RUN. 
      
       WRITE-HEADING-LINE. 
           MOVE HEADING-LINE TO PRINT-LINE
           WRITE PRINT-LINE 
           MOVE SPACES TO PRINT-LINE
           WRITE PRINT-LINE.
       
       READ-STUDENT-FILE. 
           READ STUDNET-FILE 
               AT END MOVE 'NO' TO DATA-REMAINS-SWITCH

       
       PROCESS-STUDENT-RECORD. 
           PERFORM COMPUTE-INDIVIDUAL-BILL
           PERFORM INCREMENT-UNIVERSITY-TOTALS 
           PERFORM WRITE-DETAIL-LINE
           PERFORM READ-STUDENT-FILE
           .
       
       COMPUTE-INDIVIDUAL-BILL. 
           PERFORM COMPUTE-TUITION
           PERFORM COMPUTE-UNION-FEE
           PERFORM COMPUTE-ACTIVITY-FEE
           PERFORM COMPUTE-SCHOLARSHIP
           COMPUTE IND-BILL ROUNDED = IND-TUITION + IND-UNION-FEE +
                              IND-ACTIVITY-FEE - IND-SCHOLARSHIP
           .

       COMPUTE-TUITION. 
           COMPUTE IND-TUITION=PRICE-PER-CREDIT * STU-CREDITS
           .
      
       COMPUTE-UNION-FEE.
               IF STU-UNION-MEMBER = 'Y'
                  MOVE ZERO TO IND-UNION-FEE.
               ELSE
                  MOVE UNION-FEE  TO IND-UNION-FEE
               END-IF
               .

       COMPUTE-ACTIVITY-FEE. 
           EVALUATE TRUE
               WHEN STU-CREDITS <= 1ST-CREDIT-LIMIT
                   MOVE 1ST-ACTIVITY-FEE TO IND-ACTIVITY-FEE
               WHEN STU-CREDITS > 1ST-CREDIT-LIMIT
                   AND STU-CREDITS <= 2ND-CREDIT-LIMIT
                       MOVE 2ND-ACTIVITY-FEE TO IND-ACTIVITY-FEE 
               WHEN STU-CREDITS > 2ND-CREDIT-LIMIT
                   MOVE 3RD-ACTIVITY-FEE TO IND-ACTIVITY-FEE
               WHEN OTHER
                   DISPLAY 'INVALID CREDITS FOR: ' STU-NAME
           END-EVALUATE
           .

       COMPUTE-SCHOLARSHIP. 
           IF STU-GPA > MINIMUM-SCHOLAR-GPA
              MOVE STU-SCHOLARSHIP TO IND-SCHOLARSHIP
           ELSE 
              MOVE ZERO TO IND-SCHOLARSHIP
           END-IF
           .

       INCREMENT-UNIVERSITY-TOTALS. 
           ADD IND-TUITION      TO UNI-TUITION ROUNDED
           ADD IND-ACTIVITY-FEE TO UNI-ACTIVITY-FEE ROUNDED
           ADD IND-SCHOLARSHIP  TO UNI-SCHOLARSHIP ROUNDED
           ADD IND-BILL         TO UNI-IND-BILL ROUNDED
           .
       
       WRITE-DETAIL-LINE. 
           MOVE STU-LAST-NAME TO DET-LAST-NAME
           MOVE STU-INITIALS TO DET-INITIALS
           MOVE STU-CREDITS TO DET-CREDITS
           MOVE IND-TUITION TO DET-TUITION
           MOVE IND-UNION-FEE TO DET-UNION-FEE
           MOVE IND-ACTIVITY-FEE TO DET-ACTIVITY-FEE
           MOVE IND-SCHOLARSHIP TO DET-SCHOLARSHIP
           MOVE IND-BILL TO DET-IND-BILL
           MOVE DETAIL-LINE TO PRINT-LINE
           WRITE PRINT-LINE
           .
       
       WRITE-UNIVERSITY-TOTALS. 
           MOVE DASH-LINE TO PRINT-LINE
           WRITE PRINT-LINE
           MOVE UNI-TUITION TO TOT-TUITION
           MOVE UNI-UNION-FEE TO TOT-UNION-FEE
           MOVE UNI-ACTIVITY-FEE TO TOT-ACTIVITY-FEE
           MOVE UNI-SCHOLARSHIP TO TOT-SCHOLARSHIP
           MOVE IND-BILL TO TOT-IND-BILL
           WRITE PRINT-LINE FROM SPACES
           MOVE TOTAL-LINE TO PRINT-LINE
           WRITE PRINT-FILE
           .
