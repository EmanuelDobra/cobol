## Picture Clause
•	Define format of variables by defining a picture of what you want, use PIC for short.
•	Use a 9 to define one byte to hold a numeric digit.
•	Use a X to define one byte to hold an alpha-numeric character.
•	Use V to indicate an “implied decimal”. To save disk and memory, the period is not stored with the data.
•	Examples:
–	PIC 999999 is same as PIC 9(6) 
–	PIC XXXXXXX is same as PIC X(7) 
–	PIC 99V99 is used to store a number like 12.76 9(2)V9(2)
–	PIC S9V99 is used to store a number that can be positive or negative. 
    •	Example: -3.17

## Literals
•	Examples of numeric literals: 17, -893, 47.592
•	Examples of non-numeric literals: "Cat", "613 544 5400"
•	Programming standards dictate that you declare a variable for all literals.

## Variables
level#  var name   format    data-value   period
```
01 W01-NAME   PIC X(4)  VALUE "Hero".
01            PIC X(5)  VALUE SPACES.
01 W02-TYPE   PIC X(3)  VALUE "Dog".
01            PIC X(5)  VALUE SPACES.
01 W03-SHOW   PIC X(13) VALUE "Parks and Rec".
01            PIC X(5)  VALUE SPACES.
01 W04-WEIGHT PIC 99    VALUE 25.
```

## The Move Statement 
The MOVE statement is used for assignment.  
MOVE sending-variable TO receiving-variable
MOVE "Bob" TO W01-MY-NAME
MOVE W01-MY-NAME TO W02-YOUR-NAME

## Paragraphs 
•	A function is called a paragraph.
•	A paragraph starts with a programmer defined name. It can have many statements and sentences.
•	The first paragraph does not need a paragraph name.
•	The last statement in a paragraph must end with a period. 
•	The main paragraph in the procedure division must end with a STOP RUN followed by a period.

## Paragraph Names 
•	Programmer creates paragraph names.
•	Name should describe what the paragraph does (its function).
•	Paragraph should only do ONE function.
•	Use format of “nnn-verb-noun”.
•	Example  “100-INITIALIZE-PROGRAM”.
•	Follow every paragraph name with a comment describing the paragraph’s functionality.

## The Perform Statement 
•	The PERFORM statement runs a paragraph ie calls a function.
•	Simplest format is:
PERFORM paragraph-name
•	This means go to the paragraph that has this name, execute all the statements in that paragraph, then return to here and fall to the next statement.

## Looping 
•	A loop is used run code repeatedly until a condition is true.
•	Syntax:
	   	PERFORM paragraph-name
	       	UNTIL conditional-expression
•	Example:
		PERFORM 200-PROCESS-RECORD
  		UNTIL W01-EOF-SWITCH = ‘Y’

## File I/O 
Our Cobol applications will read from an input file and write to an output file. To do this, the code will:
•	read a record into memory. It is read into the input record buffer that is defined in the FD statement for the input file.
•	perform calculations, conditions and loops as needed.
•	move it to the output record buffer that is defined in the FD statement for the output file.
•	write the data to the output file from the output record buffer.

## File Handling Verbs
OPEN	The open checks to see if the file is there and the correct permissions are in place. 
READ	The read copies a record instance from the file and places it in the record buffer.
WRITE	The write copies the record in the record buffer to the file.
CLOSE	You must ensure that your program closes all the files it has opened. Failure to do so may result in data not being written to the file or users being prevented from accessing the file.

### OPEN
Before you can use a file, you have to open it (make it available to the program and say how you will use it (read, write or add to the end). Each file placed in the Open statement must be declared with a Select statement in the environment division.

### CLOSE
CLOSE InternalFileName

### READ
```
READ InternalFilename
	INTO Identifier
	AT END StatementBlock
	NOT AT END StatementBlock
END-READ
```

### Write
To write data to a file move the data to the output record buffer (declared in the FD entry) and then write the contents of the record buffer to the file. As a shortcut, the from clause can be used to specify a record name. You have 2 options for writing to the file:
```
MOVE W03-DETAIL-LINE TO F02-PRINT-LINE-RECORD
WRITE F02-PRINT-LINE-RECORD
		or
WRITE F02-PRINT-LINE-RECORD FROM W03-DETAIL-LINE
```

## Find Errors
```
       IDENTIFICATION DIVISION.
       PROGRAM-ID.       FIRSTTRY.
      [AUTHOR.]         ROBERT GRAUER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT F01-EMPLOYEE-FILE  ASSIGN TO 'FIRSTTRY.DAT'
                                ORGANIZATION IS LINE SEQUENTIAL.
          [SELECT] F02-PRINT-FILE
                              ASSIGN TO 'FIRSTTRYREPORT.DAT'
                                ORGANIZATION IS LINE SEQUENTIAL.
      [DATA DIVISION.]
       FILE SECTION.
       FD  F01-EMPLOYEE-FILE
           RECORD CONTAINS 44 CHARACTERS
           DATA RECORD IS F01-EMPLOYEE-RECORD.
       01  F01-EMPLOYEE-RECORD.
           05  F01-EMP-NAME            PIC X(25).
           05  F01-EMP-TITLE           PIC X(10).
           05  F01-EMP-AGE             PIC 99.
           05  FILLER                  PIC XX.
           05  F01-EMP-SALARY          PIC 9(5).

     FD  [F02-PRINT-FILE]
           RECORD CONTAINS 132 CHARACTERS
           DATA RECORD IS F02-PRINT-LINE.

       01  F02-PRINT-LINE.
           05 FILLER               PIC X.
          05 F02-PRINT-NAME       [PIC X(25).]    
           05 FILLER               PIC X(2).
           05 F02-PRINT-AGE        PIC 99.
           05 FILLER               PIC X(3).
           05 F02-PRINT-SALARY     PIC 9(5).
           05 FILLER               PIC X(94).

     [WORKING-STORAGE SECTION.]
     01  W01-END-OF-DATA-FLAG    PIC X(3) VALUE SPACES   
 

   PROCEDURE DIVISION.

       [OPEN] INPUT F01-EMPLOYEE-FILE
           OUTPUT F02-PRINT-FILE
           MOVE 'SALARY REPORT FOR PROGRAMMERS UNDER 30' TO 
                F02-PRINT-LINE
           WRITE F02-PRINT-LINE  
           READ F01-EMPLOYEE-FILE
              AT END MOVE 'YES' TO [W01-]END-OF-DATA-FLAG
           END-READ

         [PERFORM] 100-PROCESS-EMPLOYEE-RECORDS
               UNTIL W01-END-OF-DATA-FLAG = 'YES'
         CLOSE F0[1]-EMPLOYEE-FILE
                 F02-PRINT-FILE
   STOP RUN
   .
   100-PROCESS-EMPLOYEE-RECORDS.
           IF F01-EMP-TITLE = 'PROGRAMMER' AND F01-EMP-AGE < 30
               MOVE F01-EMP-NAME TO F02-PRINT-NAME
             MOVE TO F0[-EMP]-AGE
               MOVE F01-EMP-SALARY TO F02-PRINT-SALARY
               WRITE F02-PRINT-LINE
           END-IF
           READ F01-EMPLOYEE-FILE
               AT END MOVE ['YES'] TO W01-END-OF-DATA-FLAG
           END-READ
   .
```

## No rounding
Don't forget there is no auto rounding (use ROUNDED)

## If statements
Be very careful to not place period(s) anywhere in an IF statement. A single period will act as an end if for all nested ifs.  
```
IF W01-MY-CITY = "Kingston"
   MOVE 10.00 TO W02-DELIVERY-FEE
   MOVE "LOCAL" TO W02-CARRIER-NAME
ELSE
   MOVE 25.00 TO W02-DELIVERY-FEE
   MOVE "UPS" TO W02-CARRIER-NAME
END-IF

IF W01-A > W02-B
     IF W01-A > W03-C
          MOVE W01-A TO W04-LARGEST
     ELSE
          MOVE W03-C TO W04-LARGEST 
     END-IF
ELSE
     IF W03-C > W02-B
          MOVE W03-C TO W04-LARGEST
     ELSE
          MOVE W02-B TO W04-LARGEST
     END-IF
END-IF
```

## Write Description Excercise
```
    * This is the definition of the input file.
    FD  F01-STUDENT-FILE
        RECORD CONTAINS 27 CHARACTERS
        DATA RECORD IS F01-STUDENT-RECORD.
    * All these numbers have to add up to the number of
    * characters written above (27)
    01  F01-STUDENT-RECORD.
        05  F01-STUDENT-NAME
            10  F01-LNAME          PIC X(15).
            10  F01-INITIALS       PIC X(2).
        05  F01-CREDITS            PIC 9(2).
        05  F01-UNIONMBR           PIC X.
        05  F01-SCHOLARSHIP        PIC 9(4).
        05  F01-GPA                PIC 9V9(2).
```

## Calculations 
``` 
WORKING-STORAGE SECTION.
01 W01-TOTALS.
   05  W01-SUBTOTAL       PIC 999V99. 
   05  W01-PST            PIC 99V99. 
   05  W01-GST            PIC 99V99. 
   05  W01-TOTALWITHTAX   PIC 999V99.
```

## Numeric Edited
PIC 9999.99. 
Use for when you want to display to file.
Example:
PIC 9999V99. (use when you read from file)
PIC 9999.99. -> 4124.53 (use when you output to file)
PIC 9,999.99. -> 4,124.53

## Data Types 
•	COBOL treats numeric variables different than text variables.
•	Numeric variables can only contain numbers, an assumed decimal and a sign. 
•	Arithmetic can only be done on numeric variables. 
•	A numeric variable is defined as:
		01 AMOUNT-DUE  PIC 9999V99.
•	Be sure to use the implied decimal for numerics. 
•	Do not use the period for numeric variables. Note that
		01 AMOUNT-DUE-OUT  PIC 9999.99.
	is a numeric edited variable. 

## Math 
•	Use numeric variables for math (not numeric-edited ones).
•	Examples:
   	COMPUTE W01-AMOUNT-DUE ROUNDED = W01-AMOUNT-DUE + 1234.55
		ADD 1234.55 TO W01-AMOUNT-DUE ROUNDED
      	MULTIPLY W01-AMOUNT-DUE BY 0.90 ROUNDED
•	Because AMOUNT-DUE-OUT is a numeric edited variable, you cannot do:
   		ADD 25.25 TO W02-AMOUNT-DUE-OUT ROUNDED
•	Programming standards dictate that the above literals are to be declared in working storage.

## Output 
•	In order to print a numeric value, it is best to convert it to the formatted text variable.
•	The idea is similar to a function that converts an int to a string.
•	First, move the data from the numeric field to the numeric edited field:
	MOVE W01-AMOUNT-DUE TO W02-AMOUNT-DUE-OUT
•	The assumed decimal is always matched to the actual decimal.

## Sample Move 
```
01 W01-AMOUNT-DUE PIC 9999V99. 	|5|4|3|2|1|9|   numeric 5432.19

01 W02-AMOUNT-DUE-OUT PIC 9,999.99.    	numeric edited

MOVE W01-AMOUNT-DUE TO W02-AMOUNT-DUE-OUT

01 W02-AMOUNT-DUE-OUT PIC 9,999.99. |5|,|4|3|2|.|1|9|    "5,432.19"
```

## Generating Blank Lines 
Cobol has a variety of methods for adding a blank line. One approach:
MOVE SPACES TO F02-PRINT-LINE-RECORD
	WRITE F02-PRINT-LINE-RECORD

## Arithmetic
```
ADD  X  TO  Y |	Y = Y + X
ADD  X  TO  Y  GIVING  Z |	Z = X + Y
ADD  X  Z  TO  A   B |	A = A + X + Z
ADD  1  TO  A   B   C |	
    A = A + 1
    B = B + 1
    C = C + 1
SUBTRACT  X FROM  Y	| Y = Y - X
SUBTRACT  X  Y FROM  Z GIVING  A |	A = Z – X - Y

```
```
ADD Takings TO CashTotal ROUNDED
ADD Cats TO Dogs GIVING Total ROUNDED 
SUBTRACT Tax FROM GrossPay ROUNDED
SUBTRACT Tax FROM GrossPay GIVING NetPay ROUNDED
DIVIDE Total BY Members GIVING MemberAverage ROUNDED
DIVIDE Members INTO Total GIVING MemberAverage ROUNDED
MULTIPLY 10 BY Magnitude ROUNDED
MULTIPLY Members BY Subs GIVING TotalSubs ROUNDED
	DIVIDE 201 BY 10 GIVING Quotient REMAINDER Remain ROUNDED
```

## Questions
```
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

```