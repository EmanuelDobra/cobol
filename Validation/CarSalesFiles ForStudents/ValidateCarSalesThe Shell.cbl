       IDENTIFICATION DIVISION.

       PROGRAM-ID.     VALCAR.

       ENVIRONMENT DIVISION.

       INPUT-OUTPUT SECTION.

       FILE-CONTROL.

           SELECT F01-SALE-FILE
               ASSIGN TO "BadCarSales.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

           SELECT F02-REPT-FILE
               ASSIGN TO "AuditRept.dat"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.

       FILE SECTION.
       FD F01-SALE-FILE
          RECORD CONTAINS 50 CHARACTERS
          DATA RECORD IS F01-SALE-RECORD.
       01  F01-SALE-RECORD.
           05  F01-INVOICE             PIC 9(5).
           05  F01-INVOICE-X
               REDEFINES F01-INVOICE   PIC X(5).
           05  F01-YEAR                PIC X(2).
           05  F01-MAKE                PIC X(11).
           05  F01-MODEL               PIC X(13).
           05  F01-ASK                 PIC 9(6).
           05  F01-ASK-X
               REDEFINES F01-ASK       PIC X(6).
           05  F01-SELL                PIC 9(6).
           05  F01-SELL-X
               REDEFINES F01-SELL      PIC X(6)
           05  F01-SALEPERSON          PIC X(7). 
           
       FD  F02-REPT-FILE
           RECORD CONTAINS 120 CHARACTERS
           DATA RECORD IS F02-REPT-RECORD.
       01  F02-REPT-RECORD         PIC X(120).
      

       WORKING-STORAGE SECTION.
        01  W01-SWITCHES.
           05  W01-EOF-SWITCH                PIC X VALUE "N".
               88 W01-EOF-REACHED VALUE "Y".
           05  W01-VALID-RECORD-SWITCH       PIC X.
               88 W01-VALID     VALUE "Y".
               88 W01-NOT-VALID VALUE "N".
           05  W01-VALID-ASK-PRICE-SWITCH    PIC X.
               88 W01-ASK-IS-VALID  VALUE "Y".
               88 W01-ASK-NOT-VALID VALUE "N".

        01  W02-TITLE1.
           05      PIC X(46) VALUE SPACES.
           05      PIC X(24) VALUE "VERY VERY NICE CARS INC.".
           05      PIC X(50) VALUE SPACES.

        01  W02-TITLE2.
           05      PIC X(49) VALUE SPACES.
           05      PIC X(17) VALUE "VALIDATION REPORT".
           05      PIC X(54) VALUE SPACES.

        01  W03-HEAD1.
           05 PIC X(28)      VALUE SPACES.
           05 PIC X(3)       VALUE 'CAR'.
           05 PIC X(6)       VALUE SPACES.
           05 PIC X(3)       VALUE 'CAR'.
           05 PIC X(10)      VALUE SPACES.
           05 PIC X(3)       VALUE 'CAR'.
           05 PIC X(8)       VALUE SPACES.
           05 PIC X(6)       VALUE 'ASKING'.
           05 PIC X(5)       VALUE SPACES.
           05 PIC X(5)       VALUE 'PRICE'.
           05 PIC X(2)       VALUE SPACES.
           05 PIC X(13)      VALUE 'ERROR MESSAGE'.
           05 PIC X(28)       VALUE SPACES.

        01  W03-HEAD2.
           05 PIC X(3)       VALUE SPACES.
           05 PIC X(9)       VALUE 'INVOICE #'.
           05 PIC X(2)       VALUE SPACES.
           05 PIC X(11)      VALUE 'SALESPERSON'.
           05 PIC X(2)       VALUE SPACES.
           05 PIC X(4)       VALUE 'YEAR'.
           05 PIC X(5)       VALUE SPACES.
           05 PIC X(5)       VALUE 'MAKER'.
           05 PIC X(8)       VALUE SPACES.
           05 PIC X(5)       VALUE 'MODEL'.
           05 PIC X(8)       VALUE SPACES.
           05 PIC X(5)       VALUE 'PRICE'.
           05 PIC X(6)       VALUE SPACES.
           05 PIC X(4)       VALUE 'SOLD'.
           05 PIC X(43)      VALUE SPACES.

        01  W04-DETAIL.
           05                        PIC X(5)          VALUE SPACES.
		   05  W04-INVOICE           PIC Z(4)9.
		   05                        PIC X(4)          VALUE SPACES.
           05  W04-SALEPERSON        PIC X(7).
		   05                        PIC X(7)          VALUE SPACES.
           05  W04-YEAR              PIC XX.
		   05                        PIC X(3)          VALUE SPACES.
           05  W04-MAKE              PIC X(11).
		   05                        PIC X(2)          VALUE SPACES.
           05  W04-MODEL             PIC X(13).
		   05                        PIC XX            VALUE SPACES.
           05  W04-ASK               PIC ZZZ,ZZ9.
		   05                        PIC X(3)          VALUE SPACES.
           05  W04-SELL              PIC ZZZ,ZZ9.
		   05                        PIC X(3)          VALUE SPACES.
		   05  W04-ERRMSG            PIC X(40).

		01  W05-ERROR-MESSAGES.
		   05  W05-INVOICE-NOTNUMERIC   PIC X(30) VALUE 'INVOICE IS NOT NUMERIC OR ZERO'.
           05  W05-SELLPRICE-NOTVALID   PIC X(20) VALUE 'SELL PRICE NOT VALID'.
		   05  W05-ASKPRICE-NOTNUMERIC  PIC X(32) VALUE 'ASK PRICE IS NOT NUMERIC OR ZERO'.
		   05  W05-ASKPRICE-OUTOFRANGE  PIC X(34) VALUE 'ASK PRICE NOT IN 1 TO 500000 RANGE'.
		   05  W05-SELLPRICEGTASKPRICE  PIC X(20) VALUE 'SELL PRICE IS GT ASK'.
		   05  W05-SELLPRICE-OUTINRANGE PIC X(35) VALUE 'SELL PRICE NOT IN 1 TO 500000 RANGE'.
		   05  W05-SELLPRICE-NOTNUMERIC PIC X(33) VALUE  'SELL PRICE IS NOT NUMERIC OR ZERO'.
		   
       PROCEDURE DIVISION.
        
           PERFORM 100-INPUT
           PERFORM 200-PROCESS
              UNTIL W01-EOF-REACHED
           PERFORM 300-FINAL
           STOP RUN
           .

       100-INPUT.
      *************
      **   initialize the program
      **
      *************
           OPEN INPUT F01-SALE-FILE
           OPEN OUTPUT F02-REPT-FILE
           PERFORM 110-NEW-PAGE

           READ F01-SALE-FILE
             AT END SET W01-EOF-REACHED TO TRUE
           END-READ
           .

       200-PROCESS.
      *************
      **   process one record at a time
      **
      *************
      *    Clear data and error messages from previous record
           MOVE SPACES TO W04-DETAIL
           MOVE F01-SALEPERSON TO W04-SALEPERSON
           MOVE F01-YEAR TO W04-YEAR
           MOVE F01-MAKE TO W04-MAKE
           MOVE F01-MODEL TO W04-MODEL

           SET W01-VALID TO TRUE

      * Call validation routines here

      ******** WRITE THE DETAIL LINE IF NO ERROR FOUND
           IF W01-VALID
              WRITE F02-REPT-RECORD FROM W04-DETAIL
           END-IF

      ******** READ NEXT RECORD
           READ F01-SALE-FILE
             AT END SET W01-EOF-REACHED TO TRUE
           END-READ
           .

       300-FINAL.
      *************
      **   finish program
      **
      *************

           CLOSE F01-SALE-FILE
           CLOSE F02-REPT-FILE
           .

       110-NEW-PAGE.
      *************
      **   PRINT TITLES AND HEADINGS
      **
      *************
           WRITE F02-REPT-RECORD FROM W02-TITLE1
           WRITE F02-REPT-RECORD FROM W02-TITLE2

      * Write 1 blank line
           WRITE F02-REPT-RECORD FROM SPACES
           WRITE F02-REPT-RECORD FROM W03-HEAD1
           WRITE F02-REPT-RECORD FROM W03-HEAD2

           WRITE F02-REPT-RECORD FROM SPACES
       .

       210-VALIDATE-INVOICE.
      *************
      **  INVOICE MUST BE NUMERIC AND NOT ALL ZEROS
      **
      *************

       .



       220-VALIDATE-ASK.
      *************
      **  ASK PRICE MUST BE NUMERIC AND NOT ALL ZEROS
      **
      *************


       .

       230-VALIDATE-SELL.
      *************
      **  SELL PRICE MUST BE NUMERIC AND NOT ALL ZEROS
      **  SELL PRICE MUST BE LESS THAN OR EQUAL TO ASKING PRICE
      *************



       .

       400-WRITE-ERROR.
           WRITE F02-REPT-RECORD FROM W04-DETAIL
           SET W01-NOT-VALID TO TRUE
       .

 