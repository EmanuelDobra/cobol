       IDENTIFICATION DIVISION.
       PROGRAM-ID.       Q1P1.
       AUTHOR.           EmanuelDobra.

       ENVIRONMENT DIVISION. 
       INPUT-OUTPUT SECTION. 
       FILE-CONTROL. 
           SELECT F01-SONGS-FILE ASSIGN TO 'songs.dat'
                                ORGANIZATION IS LINE SEQUENTIAL.
           SELECT F02-PRINT-FILE ASSIGN TO 'songs.dat'
                                ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION. 
       FILE SECTION. 
      * Input file description for F01-SONGS-RECORD
       FD F01-SONGS-FILE
           RECORD CONTAINS 18 CHARACTERS
           DATA RECORD IS F01-SONGS-RECORD.
      * F01-SONG-NAME: string, 15 bytes
      * F01-LENGTH-IN-MINUTES: numeric, 3 digits (1 decimal)
       01 F01-SONGS-RECORD.
           05 F01-SONG-NAME            PIC X(15).
           05 F01-LENGTH-IN-MINUTES    PIC 99V9.
      *  Output file definition
       FD  F02-PRINT-FILE
          RECORD CONTAINS 18 CHARACTERS
          DATA RECORD IS F02-PRINT-LINE-RECORD.
       01  F02-PRINT-LINE-RECORD  PIC 9(18).
         
       01  W01-DATA-REMAINS-SWITCH  PIC X(2)       VALUE SPACES.
      * client requirements: one line of output with 19 columns.
       01  W02-DETAIL-LINE.
          05                       PIC X(4)       VALUE SPACES.
          05  W02-SONG-NAME        PIC X(15).
?
       PROCEDURE DIVISION. 
          OPEN INPUT F01-SONGS-FILE
          PERFORM 100-READ-SONGS-FILE
          PERFORM 200-PROCESS-SONGSRECORD
               UNTIL W01-DATA-REMAINS-SWITCH = 'NO'
          CLOSE F01-SONGS-FILE
          CLOSE F02-PRINT-FILE
       . 
       100-READ-SONGS-FILE.
           READ F01-SONGS-FILE
                AT END MOVE 'NO' TO W01-DATA-REMAINS-SWITCH
           END-READ
       .
       200-PROCESS-SONGS-RECORD.
            MOVE F01-SONG-NAME TO W02-SONG-NAME
            MOVE W02-DETAIL-LINE TO F02-PRINT-FILE
            WRITE F02-PRINT-LINE-RECORD
       .
