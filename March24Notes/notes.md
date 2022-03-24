## March 24 Notes

### 3 min discussion
```
Wrong open mode or access mode for write
```

What could be wrong?
- File access not set to write (could be set to read or not set at all) 
- Trying to access file write permissions when not allowed 
- Server down

What would you check in the code:
- Check where file access is declared
- Check where file writing is done, verify if intended (could be trying to write to file outside of scope)
- Check file permissions (could get a readonly file)

Answer: ```It was missing STOP RUN``` 

### Contition Names
```
// 88 level variables are a unique and powerful way of writing conditions. 
// These special variables use condition names to define code or range test values.
// Define the validation rule in the file or working storage section and use it in the procedure division.
05   F01-CAMPUS-CODE           PIC X.
     88  F01-CAMPUS-KINGSTON   VALUE "K". 
     88  F01-CAMPUS-BROCKVILLE VALUE "B".
     88  F01-CAMPUS-CORNWALL   VALUE "C".
     88  F01-CAMPUS-VALID      VALUE "K" "B" "C".

IF F01-CAMPUS-KINGSTON
	Do something  
END-IF

IF NOT F01-CAMPUS-VALID
	Account for invalid campus data  
END-IF
```

#### 88 Level Example
```
05 F01-YEAR-CODE  PIC 9.
   88  F01-FRESHMAN         VALUE 1.
   88  F01-SOPHOMORE        VALUE 2.
   88  F01-JUNIOR           VALUE 3.
   88  F01-SENIOR           VALUE 4.
   88  F01-GRAD-STUDENT     VALUE 5 THRU 8.
   88  F01-VALID-YEAR-CODES VALUE 1 THRU 8.

You can then code:

IF F01-FRESHMAN …        	[is the year code 1]
IF F01-GRAD-STUDENT…		[is the year code in the range 5 – 8]
IF F01-VALID-YEAR-CODES …	[is the year code in the range 1 – 8]
```

#### 88 Level and ReDefines
```
05 F01-MONTH  PIC 99.
   88  F01-VALID-MONTH VALUE 1 THRU 12.
05 F01-MONTH-X REDEFINES  
       F01-MONTH PIC XX.

IF F01-MONTH NOT NUMERIC OR NOT F01-VALID-MONTH
    Do something  
END-IF
```

#### PS
(True/False checks do not look at the second element if the first already passes, so your application could run for a really long time).
