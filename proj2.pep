;********************************************************************************
;* Program Name: Matrix Multiplication
;* Programmer: Hunter Page
;* Class: CSCI 2160-940
;* Lab: Pep/9 Matrix Multiplication
;* Date (Last Modified): 11/12/2020
;* Purpose:   The purpose of this program is to allow a user to input numbers to form matrices.
;*            Then the user can add, multiply, and change matrices until they are done.
;*            The user input is extracted, character by character, then numbers are strung back together
;*            by checking for spaces/tabs. Then the numbers are added to the heap where they
;*            are stored for when they are needed for adding or multiplying. The addition is 
;*            done through taking numbers from indexed locations and adding them together
;*            then storing them in a thrid matrix, also stored on the heap. The matrices are multiplied
;*            by a certain indexing for the matrix A and a separate way of indexing for 
;*            matrix B, the product of each and sum of them together is then stored on the heap. The purpose of this program is to 
;*            teach the programmer how to make use of the stack, heap, stack-deferred indexing
;*            stack indexing, matrix multiplication, and how to take in and formulate numbers
;*            without using trap handlers.
;******************************************************************************** 
;
;
;
         BR      main        ;branch straight to the program so we don't walk through the vars
matrixA: .BLOCK  2           ;Holds the address of the user input for Matrix A
matrixB: .BLOCK  2           ;Holds the address of the user input for Matrix B
matxAdd: .BLOCK  2           ;Hold the address of the result for adding two matrices
matxMul: .BLOCK  2           ;Holds the address of the result of multiplying the matrices
mARow:   .BLOCK  2           ;holds the number of rows for matrixA
mACol:   .BLOCK  2           ;holds the number of columns for matrixA
mBRow:   .BLOCK  2           ;holds the number of rows for matrixB
mBCol:   .BLOCK  2           ;holds the number of columns for matrixB     
mInput:  .EQUATE 2           ;global variable #1c200a that holds the user input  
j:       .EQUATE 0           ;local variable #2d that holds what location we are at in the user input
dVar:    .BLOCK  2           ;an incremental counter that determines how many times to loop to find the number of vars for a matrix
numMA:   .BLOCK  2           ;how many numbers are in the matrix         
eCount:  .BLOCK  2           ;a counter for the multVar while loop, once the number has been multiplied by ten, it will branch out
eCount2: .BLOCK  2           ;a counter for us to increment through the user input
eCount3: .BLOCK  2           ;a counter to keep track of how many numbers we have incremented through
negID:   .BLOCK  2           ;an identifier to whether the number is negative or not, 0 for non-negative, 1 for negative
;
;
;
;        extractMatrix(char *lpInput, short *matrix):void
lpInput: .EQUATE 2           ;formal parameter #2h for the user input to be iterated through
matrix:  .EQUATE 4           ;formal parameter #2h for the matrix that the user is adding to
temp:    .BLOCK  2           ;a placeholder for the pieces of the number being incremented through until it is finished
eNumM:   .BLOCK  2           ;records what number we are going to be adding through each iteration in the eWhil2 loop
;        
;        
extract: LDWA    numMA,d     ;Prepare the number in matrices for increment so we can compare properly
         ASLA                ;double the number in matrix so when we compare it to the counter(which is incremented by two), it still branches correctly
         STWA    numMA,d     ;store numMA to compare for incrementing
         LDWA    0x0000,i    ;loads null as a placeholder for the temporary number variable 
         STWA    temp,d      ;stores the new line as a temporary variable         
         LDWX    0,i         ;Load 0 to set up the eCount for multiplying loop
         STWX    eCount,d    ;stores 0 in eCount so loop can iterate as needed
         STWX    eCount2,d   ;stores 0 in eCount2 so it can iterate when needed
         STWX    eCount3,d   ;stores 0 in eCOunt3 so it can iterate properly
eWhile:  LDWA    eCount2,d   ;load eCount2 to be compared to the amount of numbers in matrix
         CPWA    numMA,d     ;compares eCount2 so we can determine if we need to end the method
         BRGE    endW        ;branch to the end of the method so we can return to main()
         LDBA    lpInput,sfx ;loads a character from the stack based off index so we can determine what it is
         CPWA    0x000A,i    ;compare the number to new line to see if we have reached the end of the input
         BREQ    mAdd        ;if it does equal new line, we need to add the last number to the matrix
         
         CPWA    '-',i       ;next, we should compare the char to see if it is a negative sign so we know that the number is negative
         BRNE    nonNeg      ;if its not a negative sign, we move on to see what it actually is
         LDWA    1,i         ;if it is a negative sign, we need to increment the negID for later use
         STWA    negID,d     ;store the variable to use later when we add the var to the matrix
         LDWX    eCount3,d   ;now that we have figured out what the char is, we can move on to the next char
         ADDX    1,i         ;increment the count3 to index to the next input
         STWX    eCount3,d   ;store for next increment
         BR      eWhile      ;branch back to the top of the loop for next iteration
nonNeg:  CPBA    ' ',i       ;since it is not a neg sign, we should check for a space
         BREQ    tempChk     ;if it is a space, we need to move to tempChk to find out if we have input we need to add to the matrix
         CPBA    '\t',i      ;now we should check for a tab if the user spaced input with a tab     
         BREQ    tempChk     ;if it is a tab, we should do what was said above and check the temp if it has a number we should add
         LDWA    temp,d      ;if it is neither, load the temp to check if there is previous input
         CPWA    0x0000,i    ;compare to null to see if it is empty
         BREQ    tempAdd     ;if it is empty, then we need to add the current value to it
         BR      multVar     ;if the temp is not empty and we have a value, we need to multiply what is in the temp variable
tempChk: LDWA    temp,d      ;now that we know it is a space or tab as the input, we need to check if the temp var is empty
         CPWA    0x0000,i    ;compare the temp char item to see if a number had already been entered
         BRNE    mAdd        ;If there is already a number in the temp variable, we need to add the number into the matrix         
         LDWX    eCount3,d   ;if there isn't, that means there are just multiple skips, so we move on to the next input
         ADDX    1,i         ;increment the eCount3 to get the next index
         STWX    eCount3,d   ;store the counter for later use to index
         BR      eWhile      ;branch back to the while loop now that we are done with that input
tempAdd: LDBA    lpInput,sfx ;we need to add the current input to the temp variable, so load it in
         CPBA    48,i        ;if it is 0, there is a chance that the number itself is only 0
         BRNE    nonZ        ;if it is 0, we know to continue on
         LDWA    temp,d      ;otherwise, now check the temp var to see if it is empty
         CPWA    0x0000,i    ;if it is still null, we know that the 0 we are holding is the whole number
         BREQ    mAdd        ;so move on to adding to the matrix with the 0 we have
nonZ:    LDBA    lpInput,sfx ;if the number is not zero, or the temp is not full, we move on to adding the number to temp
         SUBA    48,i        ;we have to decrement the number by 48 since we are working with chars instead of decimals
         ADDA    temp,d      ;now we add what is in the temp variable to the input number
         STWA    temp,d      ;then store the total in the temp variable to store for later input or implementation into the matrix
         LDWX    eCount3,d   ;load the eCount3 to be incremented
         ADDX    1,i         ;add 1 to increment to the next piece of user input
         STWX    eCount3,d   ;store eCount3 to index to the next char
         BR      eWhile      ;we loop back to continue iterating through the input
multVar: LDWA    temp,d      ;multVar takes the temp number and multiplies it by ten to put it in the ten's or hundreds place ex. 1 -> 10, or 10->100
         STWA    eNumM,d     ;load the already stored temporary number and save it to the number we will be incrementing with
eWhil2:  LDWA    eCount,d    ;load the counter,eCount, and check to see if we have reached the limit
         CPWA    9,i         ;compare to see if we are done incrementing
         BREQ    endW2       ;if we are done, branch to add the current indexed input to the now incremented variable
         LDWA    temp,d      ;otherwise, load the temporary number to be incremented 
         ADDA    eNumM,d     ;increment the number by the number it was when we first read it in as  
         STWA    temp,d      ;store the new number back in temp for the next iteration
         LDWA    eCount,d    ;we need to increment the counter for the next set of addition
         ADDA    1,i         ;so we load it in and then add 1 to it
         STWA    eCount,d    ;then we store it back to be used to increment the value again
         BR      eWhil2      ;we branch back up to continue incrementing until we reach 10
endW2:   LDWA    0,i         ;we have finished incrementing, so we need to reset the counter for the next time it is used
         STWA    eCount,d    ;store the counter for the next time we need to increment
         BR      tempAdd     ;now that we have incremented the temp, we move back to add the current input into temp
mAdd:    LDWA    temp,d      ;we need to add the now finished up temp to the matrix
         LDWX    negID,d     ;first, check to see if the number was negative number to begin with
         CPWX    1,i         ;check for 1 = negative, 0 = not negative
         BRNE    store       ;if it is not equal, move on to storing the var
         NEGA                ;make the number negative
         STWA    temp,d      ;store the variable to be added to the matrix
store:   LDWX    eCount2,d   ;load the counter back to the register so we have the correct positioning for the matrix
         LDWA    temp,d      ;load the number to be stored
         STWA    matrix,sfx  ;store the number into the matrix for later use
         LDWA    0,i         ;Load 0 so we can reset negID
         STWA    negID,d     ;store 0 so that it is reset for next iteration
         LDWX    eCount3,d   ;load eCount3 to be reset
         ADDX    1,i         ;add 1 to the eCOunt3 so it is reset
         STWX    eCount3,d   ;store it for the next increment
         LDWA    eCount2,d   ;load the eCount2 so that it can be reset
         ADDA    2,i         ;add 1 so that is reset
         STWA    eCount2,d   ;store for the next increment
         LDWA    0x0000,i    ;load null to reset the temp var
         STWA    temp,d      ;store null into temp so that it is reset
         BR      eWhile      ;branch back to loop again
endW:    LDWA    numMA,d     ;revert the numMA var to its original form
         ASRA                ;Since we doubled it earlier, we need to half it
         STWA    numMA,d     ;we will use this in other methods, so save it for later
         RET                 ;Go back to where we were in main
;
;
;
;
;        display matrix(short *matrix, byte rows, byte columns):void
dCol:    .EQUATE 2           ;formal parameter #1d  that contains the column dimension
dRow:    .EQUATE 3           ;formal parameter #1d  that contains the row dimension
mDisp:   .EQUATE 4           ;formal parameter #2h  that contains the address of the matrix we are displaying
         
dispM:   LDWX    0,i         ;use 0 to initialize the vars for this method
         STWX    negID,d     ;set to 0 so that we can use to determine whether the number is negative
         STWX    eCount,d    ;set to 0 so we are able to iterate through the entire matrix
         STWX    eCount2,d   ;set to 0 and used to determine what column we are at in the current row
dWhile:  LDWA    numMA,d     ;need to compare our count to the total amount of numbers in the matrix
         ASLA                ;Shift since we are working with words and not vars
         CPWA    eCount,d    ;eCOunt allows us to compare to see where we are at in the matrix
         BRLE    endDis      ;if we have reached over the amount of numbers in the matrix, we need to end the method
dIf:     LDWA    eCount2,d   ;otherwise, check to see what location in the matrix we are at
         CPBA    0,i         ;compare to 0 to check if at beginning of row
         BRNE    dIf2        ;If not at the beginning, move to next checkpoint
         LDBA    '\n',i      ;since at beginning, place a border
         STBA    charOut,d   ;show the border for the visual
         LDBA    '\|',i      ;since at beginning, place a border
         STBA    charOut,d   ;show the border for the visual
         LDWA    eCount2,d   ;now increment for next iteration
         ADDA    1,i         ;increment the counter by 1
         STWA    eCount2,d   ;store for next iteration
dIf2:    LDWA    mDisp,sfx   ;now that the border cond. is checked, load number in
         CPWA    0,i         ;check to see if the number is less than 0 to determine if it is a negative
         BRLT    delsIf5     ;if negative, move to next conditional******
         CPWA    10,i        ;check to see if it is a single digit
         BRGE    delsIf      ;if more than one digit, move on
         CPWA    0,i         ;check to see if it is negative
         BRLT    delsIf4     ;if negative, move to negative conditions 
         LDBA    ' ',i       ;if a single digit number, we need to first place padding so it lines up with the other numbers
         STBA    charOut,d   ;load a space and print it out so it is padded by one space
         STBA    charOut,d   ;load a space and print it out so it is padded by two spaces
         STBA    charOut,d   ;load a space and print it out so it is padded by three spaces
         STBA    charOut,d   ;load a space and print it out so it is padded by four space
         STBA    charOut,d   ;load a space and print it out so it is padded by five spaces
         DECO    mDisp,sfx   ;print out the actual number in decimal form so the actual number can be shown instead of ascii value
         LDBA    ' ',i       ;pad out the number so there is at least one space between each number
         STBA    charOut,d   ;print out the space so it is visual
         BR      dIf3        ;move on to determining if there is a closing bracket needed
delsIf:  LDWA    mDisp,sfx   ;load the number in again so it can be checked
         CPWA    100,i       ;compare to 100 to see if we have a triple digit number
         BRGE    delsIf2     ;if it is triple digit, move to the delsIf2 conditional
         LDBA    ' ',i       ;otherwise, we have a two digit number
         STBA    charOut,d   ;load a space and print it out so it is padded by one space
         STBA    charOut,d   ;load a space and print it out so it is padded by two spaces
         STBA    charOut,d   ;load a space and print it out so it is padded by three space
         STBA    charOut,d   ;load a space and print it out so it is padded by four spaces
         DECO    mDisp,sfx   ;print out the actual number in decimal form so the actual number can be shown instead of ascii value
         LDBA    ' ',i       ;pad out the number so there is at least one space between each number
         STBA    charOut,d   ;print out the space so it is visual
         BR      dIf3        ;move on to determining if there is a closing bracket needed
delsIf2: LDWA    mDisp,sfx   ;load the number to be checked again
         CPWA    1000,i      ;compre to 1000 to see if we have a four digit number
         BRGE    delsIf3     ;if four digits, move on to next conditional
         LDBA    ' ',i       ;otherwise, we need to pad for a three digit number
         STBA    charOut,d   ;get a space and print it out so we have the padding to line it up
         STBA    charOut,d   ;load a space and print it out so it is padded by two spaces
         STBA    charOut,d   ;load a space and print it out so it is padded by three spaces
         DECO    mDisp,sfx   ;print out the actual number in decimal form so the actual number can be shown instead of ascii value
         LDBA    ' ',i       ;pad out the number so there is at least one space between each number
         STBA    charOut,d   ;print out the space so it is visual
         BR      dIf3        ;move on to determining if there is a closing bracket needed
delsIf3: LDWA    mDisp,sfx   ;load the number so we can compare it
         CPWA    10000,i     ;compare to 10,000 to see what padding we need
         BRGE    delsIf4     ;If five digits, move on to next if statement
         LDBA    ' ',i       ;load space for padding
         STBA    charOut,d   ;get a space and print it out so we have the padding to line it up
         STBA    charOut,d   ;load a space and print it out so it is padded by two spaces
         DECO    mDisp,sfx   ;since we have determined the number is four digits big, we can print the num without padding
         LDBA    ' ',i       ;pad out the number so there is at least one space between each number
         STBA    charOut,d   ;print out the space so it is visual
         BR      dIf3        ;move on to determining if there is a closing bracket needed
delsIf4: LDWA    mDisp,sfx   ;if reached five digits, only one one space is needed
         LDBA    ' ',i       ;load space for padding
         STBA    charOut,d   ;have padding so there is one space
         DECO    mDisp,sfx   ;print out the actual number in decimal form so the actual number can be shown instead of ascii value
         LDBA    ' ',i       ;pad out the number so there is at least one space between each number
         STBA    charOut,d   ;print out the space so it is visual
         BR      dIf3        ;move on to determining if there is a closing bracket needed
delsIf5: LDWA    mDisp,sfx   ;load the number to be worked with
         NEGA                ;negate so we can see the number without the negative
         CPWA    10000,i     ;compare to 10,000 to check for five digits number
         BRGE    neg4        ;move to section with the correct padding
         CPWA    1000,i      ;compare to 1000 to check for four digits number
         BRGE    neg3        ;move to section with correct padding
         CPWA    100,i       ;compare to 100, to check for three digit number
         BRGE    neg2        ;move to section with correct padding
         CPWA    10,i        ;compare to ten to check for two digit number
         BRGE    neg1        ;move to section with correct padding
         LDBA    ' ',i       ;since number is less than 10, print four spaces
         STBA    charOut,d   ;add padding to output
neg1:    LDBA    ' ',i       ;if two digits, print three spaces
         STBA    charOut,d   ;add padding to output
neg2:    LDBA    ' ',i       ;if three digits print two spaces
         STBA    charOut,d   ;add padding to output
neg3:    LDBA    ' ',i       ;if four digits, print one space
         STBA    charOut,d   ;add padding to output
neg4:    DECO    mDisp,sfx   ;if five digits, no padding needed
         LDBA    ' ',i       ;load space for padding after the number
         STBA    charOut,d   ;add padding to output
         BR      dIf3        ;move to check if ending border is needed
dIf3:    LDWA    eCount2,d   ;check our column position in the current row
         CPBA    dCol,s      ;compare to the actual number of columns in matrix to see if we are at end
         BRLT    endDIf3     ;if not, iterate the next number
         STRO    endMtx,d    ;otherwise, print the ending border
         LDWA    -1,i        ;now reset eCount2
         STWA    eCount2,d   ;set up eCount for next iteration
endDIf3: LDWA    eCount2,d   ;now we need to increment eCount2 for the next number in the row
         ADDA    1,i         ;add one so we are in the next column
         STWA    eCount2,d   ;have it stored for next iteration
         ADDX    2,i         ;increase the register by 2 so we move onto the next number in the indexed matrix
         STWX    eCount,d    ;store for next iteration
         BR      dWhile      ;branch back to beginning of while to restart
endDis:  RET                 ;we have finished printing, move back to main
;
;                              
;                  
;        addMatrices(short *matrixA, byte rowsA, byte colsA, short *matrixB, byte rowsB, byte colsB):short*
AMatxA:  .EQUATE 2           ;formal parameter #2h that stores the address to matrix A on the heap
AMatxB:  .EQUATE 4           ;formal parameter #2h that stores the address to matrix B on the heap
AMatxC:  .EQUATE 6           ;return value #2h that stores the address to the sum of matrix A and matrix B
colsA:   .EQUATE 8           ;formal parameter #1d that stores the number of columns for matrix A
colsB:   .EQUATE 9           ;formal parameter #1d that represents the number columns for matrix B
rowsA:   .EQUATE 10          ;formal parameter #1d that represents the number of rows in matrix A
rowsB:   .EQUATE 11          ;formal parameter #1d that represents the number of rows in matrix B
;         
;
addMatx: LDBA    charIn,d    ;get rid of any newline space
         LDBA    colsA,s     ;prepare to compare column of matrix A to Matrix B
         CPBA    colsB,s     ;compare because we need to make sure that the program can properly add
         BRNE    notEq       ;if !=, leave the loop to exit the program
         LDBA    rowsA,s     ;prepare row matrix A to compare to matrix B
         CPBA    rowsB,s     ;compare because we need to make sure that the program can properly add
         BRNE    notEq       ;if !=, leave the loop to exit the program
         LDWX    0,i         ;otherwise, the dim. are equal and we can start setting counters
         STWX    eCount,d    ;initialize eCount
AWhile:  LDWA    numMA,d     ;prepare the matrix num holder to be incremented
         ASLA                ;double it since working with words within the matrix
         CPWA    eCount,d    ;compare to the count so we know if we need to stop
         BRLE    endAdd      ;if numMA is smaller than or equals our count, then we have iterated through the matrices
         LDWA    AMatxA,sfx  ;otherwise, load the number based off the index so it can be added onto
         ADDA    AMatxB,sfx  ;add B's num so we get the sum of the two matrices at that location
         STWA    AMatxC,sfx  ;store the sum so it can be represented later
         ADDX    2,i         ;increment by two to move onto the next variable in each matrix
         STWX    eCount,d    ;store for comparing in next increment
         BR      AWhile      ;loop back for next number
notEq:   STRO    nEqMsg,d    ;the dimensions are not equal,
         LDWA    0x0000,i    ;load null to signify that we shouldn't display the matrix
         STWA    AMatxC,d    ;store it for when it goes back to main
endAdd:  RET                 ;return to main to continue iterating
;
;
;
;        multMatrices(short *matrixA, byte rowsA, byte colA, short*matrixB, byte rowsB, byte colB):short*
MmatxA:  .EQUATE 2           ;formal parameter #2h pointer to where matrix A is stored on the heap
MmatxB:  .EQUATE 4           ;formal parameter #2h pointer to where matrix B is stored on the heap
MmatX:   .EQUATE 6           ;formal parameter #2h pointer to where the product matrix will be stored on the heap
MACol:   .EQUATE 8           ;formal parameter #1d column of matrix A
MARow:   .EQUATE 9           ;formal parameter #1d row of matrix A
MBCol:   .EQUATE 10          ;formal parameter #1d column of matrix B
MBRow:   .EQUATE 11          ;formal parameter #1d row of matrix B
tempA:   .BLOCK  2           ;will be used to store the number from matrix A
tempB:   .BLOCK  2           ;will be used to store the number from matrix B
tempC:   .BLOCK  2           ;will be used to hold the number for the row we are incrementing to
tempX:   .BLOCK  2           ;the var holding the number while it is being multiplied
tempY:   .BLOCK  2           ;the var holding the number that is being added to after a number has been multiplied
tempZ:   .BLOCK  2           ;holds the total number that is being implemented into MmatX
mulloopC:.BLOCK  2           ;holds the number of times iterated through the multiply loop 
matXLoc: .BLOCK  2           ;holds on to the position that we are inputting into the product matrix
addMtxC: .BLOCK  2           ;holds onto the number of times iterated through the addMMtx to know when to go to the next row in matrix A
matBC:   .BLOCK  2           ;holds the amount eCount3 should be incremented by when figuring out what column in matrix B to move to
numTrkA: .BLOCK  2           ;keeps track of the position of what number we are multiplying

multMtx: LDWX    0,i         ;initializes multiple varibles
         STWX    eCount,d    ;eCount will represent what row in matrix A to be using
         STWX    eCount2,d   ;eCount2 will refernce what position in matrix A we will be using
         STWX    eCount3,d   ;eCount3 will represent what position in matrix B we will be using
         STWX    negID,d     ;negID is going to be an identifier on whether the number in multiplicand is negative or not
         LDBA    MACol,s     ;check to see if dimensions are correct between the column A and row B
         CPBA    MBRow,s     ;they must be the same to get the correct dimensions for the product matrix
         BRNE    noGood      ;if they are not equal, then it cannot multiply correctly, so end the method
mWhil1:  LDWA    eCount,d    ;overall while loop that will iterate through every row in matrix A
         CPBA    MARow,s     ;compare the counter to see if we have iterated through all of the rows
         BRGT    endMult     ;end the method if we have done all of the columns
rowFinA: LDWA    tempC,d     ;rowFinA finds the rows we are supposed to be on for mult. so load tempC which will hold what row we will be on
         CPWA    eCount,d    ;compare to see if we have reached the row we are supposed to be at
         BREQ    rowFnd      ;if we have reached that point, we can move on to multiplying the variables  
         LDBA    MACol,s     ;otherwise, get eCount2 to increment it to the var we are supposed to be on
         ASLA                ;add the column number so the we can skip an entire row 
         STWA    eCount2,d   ;store for later use in the program
         LDWA    tempC,d     ;increment for the next iteration
         ADDA    1,i         ;add 1 so we go to the next row
         STWA    tempC,d     ;store for the top of the loop
         BR      rowFinA     ;branch back until we get to the appropriate row to work with
rowFnd:  CPWA    0,i         ;rowFnd is we have found the row we are on, so check to see if it first row in matrix A
         BREQ    calc        ;first row we dont need to add anything, so move on to multiplying the matrices
         LDWA    numTrkA,d   ;if it is not the first row, we have to add on until we are where we need to be
         ADDA    eCount2,d   ;eCount2 holds position we need to increment to
         STWA    numTrkA,d   ;store for when needed for indexing to the correction location in matrix A
         LDWA    0,i         ;reset eCount2 since so it can increment correctly when moving through the row
         STWA    eCount2,d   ;store for indexing within matrix A
calc:    LDWA    eCount2,d   ;need to compare where we are at in the row with the end of the row
         ASRA                ;shift right since working with words
         CPBA    MACol,s     ;check to see if we have hit the end of the row in matrix A
         BREQ    addMMtx     ;if so, time to add our number total to the matrices
         LDWX    numTrkA,d   ;load the location for the var for MatrixA
         LDWA    MmatxA,sfx  ;load matrixA to use for multiplication
         STWA    tempA,d     ;store in the temporary var for loop use
         LDWX    eCount3,d   ;load eCount3 to grab the matrixB var needed
         LDWA    MmatxB,sfx  ;grab the number in the location we need
         STWA    tempB,d     ;store it in a temp for loop use
multSec: LDWA    0,i         ;reset the temp vars from previous iteration, multSec will now iterate through the row in A and columns in B
         STWA    tempY,d     ;set var to 0 so number from previous iteration does not interfere
         STWA    tempX,d     ;set var to 0 so number from previous iteration does not interfere
         STWA    mulloopC,d  ;set var to 0 so number from previous iteration does not interfere
         LDWA    tempA,d     ;load the current number from matrix A into accumulator 
         LDWX    tempB,d     ;load the current number from matrix B into accumulator
         CPWX    0,i         ;compare to zero to check for a negative number
         BRGE    mulLoop     ;if not, go ahead and begin iterating
         NEGX                ;otherwise we need to change the negative number to a positive then change it back after the multiplying is finished
         LDWA    negID,d     ;need to keep note that this number was a negative
         ADDA    1,i         ;set to 1 so that we know later it is a negative, if positive it will stay 0
         STWA    negID,d     ;store for later comparison
         LDWA    tempA,d     ;load the number from matrix A 
mulLoop: ASRX                ;arithmetic shift right to see if we need to add. mulLoop continuously checks C bit until all eight bits have been shifted
         BRC     add         ;check C bit if it is 1, if so we need to add the multiplicand onto the current total  
         BR      incC4       ;if not 1, move on to shifting and incrementing to next bit
add:     STWA    tempA,d     ;store the multiplicand for next loop
         ADDA    tempY,d     ;add current 'total' to the temp A var
         STWA    tempY,d     ;store the current total until we either add to it again or print it out
         LDWA    tempA,d     ;load the number from matrix A 
incC4:   STWX    tempX,d     ;store what is left of multiplier into tempX
         LDWX    mulloopC,d  ;load the number of times we have iterated through the loop
         CPWX    7,i         ;compare to see if we have hit all 8 bits
         BREQ    negChk      ;if so, move on to storing the product
         ADDX    1,i         ;add one if all bits haven't been checked
         STWX    mulloopC,d  ;store for next loop around
         LDWX    tempX,d     ;load what is left of the multiplier in
         ASLA                ;double the multiplicand 
         BR      mulLoop     ;loop back to iterate the next bit
negChk:  LDWA    tempY,d     ;now that total is made, prepare to add element 
         LDWX    negID,d     ;check to see if the multiplier was negative before
         CPWX    1,i         ;if 1, we negate, the number, if 0, leave as is
         BRNE    addE1       ;0, we move on to adding it to the temp matrix num holder
         NEGA                ;otherwise, negate since multiplier was negative
         SUBX    1,i         ;reset the counter
         STWX    negID,d     ;store for next iteration
addE1:   ADDA    tempZ,d     ;add what has already been implemented into the temp var to the number we just got from multiplying
         STWA    tempZ,d     ;store the number in case we are not done with the current column in matrix B
         LDWX    eCount2,d   ;increment matrix A counter
         ADDX    2,i         ;by two so we move on the next number in the row
         STWX    eCount2,d   ;store position for next increment
         LDWX    numTrkA,d   ;need to increment so we know the next number to multiply with in matrix A
         ADDX    2,i         ;increment by two since we are working with words
         STWX    numTrkA,d   ;store for next loop
         LDBX    MBCol,s     ;now we need to move to the next number in the column in matrix B
         ASLX                ;we do this by taking the column count, doubling it (since words)
         ADDX    eCount3,d   ;then adding current index
         STWX    eCount3,d   ;store for next loop
         BR      calc        ;go back to calculate the next number in A and B
addMMtx: LDWA    tempZ,d     ;addMMtx is when all the numbers in the row in A have been multiplied by column in matrix B and added all together
         LDWX    matXLoc,d   ;prepare the current index in the product matrix
         STWA    MmatX,sfx   ;store the total into the product matrix
         ADDX    2,i         ;increment the index to the next position
         STWX    matXLoc,d   ;store for next iteration
         LDWX    1,i         ;load 1 to increment the counter that holds which column we are at
         ADDX    addMtxC,d   ;add the current column number to 1 to represent new column
         STWX    addMtxC,d   ;store for next loop comparisons
         LDWA    eCount,d    ;need to see if we are at the first row in A or any other row
         CPWA    0,i         ;if 0, we are on the first row, if any other number, we are in a different row
         BREQ    frstRw      ;if 0, move to code implemented for the first row
         BRNE    otherRw     ;if any other row, move to code implemented for other rows
conAddM: LDWX    0,i         ;need to reset some vars for the next number 
         STWX    eCount2,d   ;reset eCount2 so it can be iterated to the correct position in next increment
         STWX    tempZ,d     ;reset the var that holds the total that is inserted into the product matrix
         LDWX    matBC,d     ;need to increment matrix B counter so we start in the next column to the right 
         ADDX    2,i         ;add by two so we are in the correct position
         STWX    matBC,d     ;store for next increment
         STWX    eCount3,d   ;since we are starting on top row in matrix B in next increment, use same position as matrix B Counter
         LDWA    addMtxC,d   ;now we need to check if we have reached the end of the columns in matrix B
         CPBA    MBCol,s     ;compare to the column count for B
         BRNE    calc        ;if not, we can continue incrementing
         LDWA    eCount,d    ;otherwise, increment the counter so we know to move to the next row in A
         ADDA    1,i         ;increment by one to synbolize moving to next row
         STWA    eCount,d    ;store for the next loop around when we check for what row we should be on
         LDWA    0,i         ;since moving to a new row in A, need to reset a couple variables
         STWA    eCount3,d   ;reset index in Matrix B to 0 so we start at the beginning
         STWA    matBC,d     ;reset column count holder for matrix B to 0 so we know to start at the beginning
         STWA    addMtxC,d   ;reset matrix counter so we can count properly when adding to the product matrix
         BR      mWhil1      ;go back to the loop where we find the row in A to use 
frstRw:  LDWX    0,i         ;since we are first row in A, reset the index location in A to 0 so it starts at beginning of first row
         STWX    numTrkA,d   ;store 0 to reset for next loop
         BR      conAddM     ;go back to incrementing vars
otherRw: LDWA    numTrkA,d   ;if a different row than the first...
         SUBA    eCount2,d   ;subtract eCount2 which takes us back to beginning of the row in A
         STWA    numTrkA,d   ;store so we know to start at the beginning of the row in next iteration
         BR      conAddM     ;go back to incrementing/resetting vars
noGood:  STRO    endMMsg,d   ;the dimesnions are not correct to multiply, so send a msg saying so
         LDWA    0x0000,i    ;load a null pointer to be stored in the product matrix
         STWA    MmatX,sf    ;store the null pointer so the program knows not to print anything 
endMult: RET                 ;we are done with method, go back to main
;
;
;         
;
;;;;;;;; main()        
main:    STRO    init0,d     ;greet the user an ask to enter input
         STRO    init1,d     ;space between greeting and options
         STRO    init2,d     ;offer the first option, matrix A
         STRO    init3,d     ;offer the second option, matrix B
         STRO    init4,d     ;offer the third option, adding matrices
         STRO    init5,d     ;offer the fourth option, multiplying the matrices
         STRO    init6,d     ;offer the fifth option, exit the program
         STRO    initI,d     ;create space for the user to place input
mainIf:  LDBA    charIn,d    ;take the user input in to see what they chose
         CPBA    'a',i       ;see if user wants to insert matrix A 
         BRNE    elsif1      ;if not check for b at next conditional
         LDBA    charIn,d    ;Gets rid of the new line entered
rowInp:  STRO    rowMsg,d    ;Asks user for the number of rows for Matrix A
         DECI    mARow,d     ;Enters the user input for the number of Rows for matrix A
         LDWA    mARow,d     ;check to see if the input for the row is at five or below
         CPWA    5,i         ;five is the highest the matrices should go
         BRGT    rowInp      ;if over five, go back and ask the user again
colInp:  STRO    colMsg,d    ;asks the user to enter the number of columns for matrix A
         DECI    mACol,d     ;Loads the user input of the column to be stored
         LDWA    mACol,d     ;check to see if the input for column is higher than five
         CPWA    5,i         ;five is the highest we want to go
         BRGT    colInp      ;ask the user again if the input is higher than five
         LDWA    0,i         ;we need to reset the total amount of numbers in the matrix
         STWA    numMA,d     ;so we add 0 to the numMA for this iteration
         STWA    dVar,d      ;we also need to reset dVar from any previous iteration
diWhile: LDWA    dVar,d      ;diWhile is a while loop to find how many numbers are in the matrix
         CPWA    mARow,d     ;check dVar to see if it matches the num of rows in A
         BREQ    endDi       ;branch to continue main
         LDWA    numMA,d     ;otherwise,load numMA variable so it can be added to
         ADDA    mACol,d     ;add the number of columns since each column will have a number
         STWA    numMA,d     ;store for the next loop
         LDWA    dVar,d      ;now prepare dVar to be incremented
         ADDA    1,i         ;increment by one so it is one closer to the number of rows
         STWA    dVar,d      ;store for comparison next loop
         BR      diWhile     ;go back to beginning of loop
endDi:   STRO    totNMsg,d   ;once finished with diWhile, print a message that represents total number
         DECO    numMA,d     ;print the number so the user can see how many numbers to input
         LDWA    numMA,d     ;now take the number so we can pass that amount to the heap
         ASLA                ;double it since we are using words
         CALL    malloc      ;call malloc so we can allocate to the heap the amount of numbers * 2 that will be on the heap
         STWX    matrixA,d   ;store the address from the heap in matrixA address holder
         LDWX    0,i         ;set register to 0 
         SUBSP   202,i       ;push #mInput #j
         LDWA    0,i         ;Adds 0 to j to begin the loop
         STWA    j,s         ;stores 0 into j on the stack so the loop can start at 0
         STRO    aMsg,d      ;asks the user to place in input for Matrix A
while1:  LDWA    j,s         ;loads j to be checked for the max number of entries. while1 takes all of the input and stores it on the stack
         CPWA    200,i       ;Compares j to 200, the maximum amount of entries
         BRGE    endWh1      ;Branches to end the while loop since the max number of entries was hit
         LDBA    charIn,d    ;Loads the char input to determine if it is the end of the input line
         CPBA    '\n',i      ; checks for end of input line to move on to extracting the input into the matrix
         BREQ    endWh1      ;Breaks if equal to new line to extract the input to matrix A
         STBA    mInput,sx   ;if not the new line, add the char to the stack
         LDWX    j,s         ;loads j from the stack to be incremented to move on to the next char input
         ADDX    1,i         ;adds 1 to j to increment
         STWX    j,s         ;stores j back once incremented
         BR      while1      ; loops back to the while loop to capture the next char of user input
endWh1:  STBA    mInput,sx   ;stores the newline so we can reference it for when we want to end extracting the matrix
         ADDSP   2,i         ;pop #j
         SUBSP   4,i         ;push #matrix #lpInput 
         LDWA    matrixA,d   ;need to add matrixA address to the stack 
         STWA    2,s         ;place it at position 2 within stack
         MOVSPA              ;move stack pointer so it can be changed
         ADDA    4,i         ;add four for input string starting offset
         STWA    0,s         ;place at the top of the stack
         CALL    extract     ;call extract to take all the numbers from the input and place them on the heap
         ADDSP   204,i       ;pop #lpInput #matrix #mInput
         SUBSP   4,i         ;push #mDisp #dRow #dCol
         LDWA    mACol,d     ;display method will require the number of columns
         STBA    0,s         ;place the number of columns at the top of the stack
         LDWA    mARow,d     ;display method will require the number of rows
         STBA    1,s         ;place the number in the second position in the stack
         LDWA    matrixA,d   ;load the address of matrix A so display knows where to look
         STWA    2,s         ;place in third position in the stack 
         CALL    dispM       ;display the matrix to the user
         ADDSP   4,i         ;pop #dCol #dRow #mDisp
         BR      main        ;go back to the top and let user choose next option
;
elsif1:  CPBA    'b',i       ;check for b if wanting to input matrix b
         BRNE    elsif2      ;if not, move on to next conditional
         LDBA    charIn,d    ;get rid of new line entered 
rowBInp: STRO    rowMsg,d    ;ask the user to enter the number of rows for matrix B
         DECI    mBRow,d     ;take user input into the holder for the row 
         LDWA    mBRow,d     ;now load to check if valid input
         CPWA    5,i         ;compare to see if it is greater than or equal to 5
         BRGT    rowBInp     ;if so, ask the user again for input
colBInp: STRO    colMsg,d    ;now ask the user for input for the column
         DECI    mBCol,d     ;take the user input into the holder for the column
         LDWA    mBCol,d     ;now load to check if valid input
         CPWA    5,i         ;compare to see if it greater than or equal to 5
         BRGT    colBInp     ;if so, ask the user for valid input
         LDWA    0,i         ;we need to reset the total amount of numbers in the matrix
         STWA    numMA,d     ;so we add 0 to the numMA for this iteration
         STWA    dVar,d      ;we also need to reset dVar from any previous iteration
diWhil2: LDWA    dVar,d      ;diWhil2 is similar to diWhile1, except specifically for matrix B
         CPWA    mBRow,d     ;load dVar so we can compare to the number of rows in B
         BREQ    endDi2      ;if they are equal we have the amount of numbers in matrix B, so move on
         LDWA    numMA,d     ;load numMA so it can be added to
         ADDA    mBCol,d     ;add the number of columns in B since each column holds a number
         STWA    numMA,d     ;store for next loop to be added to again
         LDWA    dVar,d      ;load so it can be incremented
         ADDA    1,i         ;increment it by 1 so we are 1 closer to the number of rows
         STWA    dVar,d      ;store for comparison in next loop
         BR      diWhil2     ;branch back to check to continue looping
endDi2:  STRO    totNMsg,d   ;now that number has been found print message to represent it
         DECO    numMA,d     ;print the number
         LDWA    numMA,d     ;now prepare for allocating to the heap based off numMA
         ASLA                ;double it since we are working with numbers
         CALL    malloc      ;call malloc to allocate for matrix B
         STWX    matrixB,d   ;store the address of matrixB on the heap in the address holder
         LDWX    0,i         ;reset to 0 so we can add to the stack properly
         SUBSP   202,i       ;push #mInput #j
         LDWA    0,i         ;Adds 0 to j to begin the loop
         STWA    j,s         ;stores 0 into j on the stack so the loop can start at 0
         STRO    bMsg,d      ;asks the user to place in input for Matrix B
while2:  LDWA    j,s         ;loads j to be checked for the max number of entries
         CPWA    200,i       ;Compares j to 200, the maximum amount of entries
         BRGE    endWh1      ;Branches to end the while loop since the max number of entries was hit
         LDBA    charIn,d    ;Loads the char input to determine if it is the end of the input line
         CPBA    '\n',i      ;checks for end of input line to move on to extracting the input into the matrix
         BREQ    endWh2      ;Breaks if equal to new line to extract the input to matrix B
         STBA    mInput,sx   ;if not the new line, add the char to the stack
         LDWX    j,s         ;loads j from the stack to be incremented to move on to the next char input
         ADDX    1,i         ;adds 1 to j to increment
         STWX    j,s         ;stores j back once incremented
         BR      while2      ;loops back to the while loop to capture the next char of user input
endWh2:  STBA    mInput,sx   ;stores the newline so we can reference it for when we want to end extracting the matrix
         ADDSP   2,i         ;pop #j
         SUBSP   4,i         ;push #matrix #lpInput 
         LDWA    matrixB,d   ;load the pointer of matrix B so we can add to the stack
         STWA    2,s         ;store it in stack where method params can access it
         MOVSPA              ;move stack pointer so it can be modified
         ADDA    4,i         ;add for input string starting offset
         STWA    0,s         ;store where lpInput can access it
         CALL    extract     ;once the user input has all been extracted, the input will be extracted into matrix A
         ADDSP   204,i       ;pop #lpInput #matrix #mInput
         SUBSP   4,i         ;push #mDisp #dRow #dCol
         LDWA    mBCol,d     ;load the column in so it can be placed on the stack
         STBA    0,s         ;place it where accessible to the display param for column
         LDWA    mBRow,d     ;load the row so it can be placed onto the stack
         STBA    1,s         ;place it where accessible to the display param for row
         LDWA    matrixB,d   ;load the pointer of matrix B so it can be added to stack
         STWA    2,s         ;store where accessible to matrix param in display method
         CALL    dispM       ;call the method so it can print the user's matrix
         ADDSP   4,i         ;pop #dCol #dRow #mDisp 
         BR      main        ;go back to the top and let user choose next option
elsif2:  CPBA    'c',i       ;if the user input c, then the user wants to add matrices together
         BRNE    elsif3      ;if not, move down to check for d
         STRO    ADDMsg,d    ;send a msg telling the user what they chose
         LDWA    numMA,d     ;prepare the amount of numbers in matrix so we can allocate to the heap
         ASLA                ;double it since we are working with words
         CALL    malloc      ;allocate space to the heap for the add matrix
         STWX    matxAdd,d   ;store the address of where allocation begins in matrixAdd address holder
         SUBSP   10,i        ;push #rowsB #rowsA #colsB #colsA #AMatxC #AMatxB #AMatxA 
         LDWA    mBRow,d     ;load the number of rows in B to the stack 
         STBA    9,s         ;address of where method's var can reach it
         LDWA    mARow,d     ;load number of rows in A so it can be stored
         STBA    8,s         ;address of where method's var can reach it
         LDWA    mBCol,d     ;load number of columns in B so it can be stored
         STBA    7,s         ;address of where method's version of var can reach it
         LDWA    mACol,d     ;load number of columns in A so it can be stored
         STBA    6,s         ;address of where method's version of var can reach it
         LDWA    matxAdd,d   ;load address of add matrix so it can be stored
         STWA    4,s         ;address of where method's version of var can reach it
         LDWA    matrixB,d   ;load address of matrix B so it can be stored
         STWA    2,s         ;address of where method's version of var can reach it
         LDWA    matrixA,d   ;load address of matrix A so it can be stored
         STWA    0,s         ;address of where method's version of var can reach it
         CALL    addMatx     ;call method to add the matrices
         ADDSP   10,i        ;pop #AMatxA #AMatxB #AMatxC #colsA #colsB #rowsA #rowsB
         CPWA    0x0000,i    ;compare to null pointer if the dimensions were not correct
         BREQ    main        ;go back to main without printing if bad dim.
         SUBSP   4,i         ;push #mDisp #dRow #dCol 
         LDWA    mACol,d     ;load number of columns of A to be stored on stack
         STBA    0,s         ;address of method's version of column count is stored
         LDWA    mARow,d     ;load number of rows in A to be stored onto the stack
         STBA    1,s         ;address of method's var of row count is stored
         LDWA    matxAdd,d   ;load the addres of where the add matrix is stored
         STWA    2,s         ;address of method's var of add matrix address is stored
         CALL    dispM       ;call method to display the results from the add method
         ADDSP   4,i         ;pop #dCol #dRow #AMatxC
         BR      main        ;go back to the top and let user choose next option
elsif3:  CPBA    'd',i       ;if the user entered d they want to multiply the matrices
         BRNE    elsif4      ;if not, move on to the next elseif to check if it is bad input
         STRO    MMsg,d      ;Let the user know they have decided to multiply
         LDBA    charIn,d    ;get rid of new line input
         CALL    malloc      ;call malloc to allocate space for the multiplication matrix
         STWX    matxMul,d   ;store the address of first allocated space for the mult. matrix
         SUBSP   10,i        ;push #MBRow #MBCol #MARow #MACol #MmatX #MmatxB #MmatxA 
         LDWA    mBRow,d     ;load the number of rows for B so it can be stored
         STBA    9,s         ;store where method's var of number of B rows is stored
         LDWA    mBCol,d     ;load the number of columns for B so it can be stored
         STBA    8,s         ;store where method's var of number of B columns is stored
         LDWA    mARow,d     ;load the number of rows for A so it can be stored
         STBA    7,s         ;store where method's var of number of A rows is stored
         LDWA    mACol,d     ;load the number of columns for A so it can be stored
         STBA    6,s         ;store where method's var of number of A columns is stored
         LDWA    matxMul,d   ;load the address of mult. matrix on heap so it can be stored on stack
         STWA    4,s         ;store where method's var of address holder for matrix mult. is stored
         LDWA    matrixB,d   ;load the address of matrix B on heap so it can be stored on stack
         STWA    2,s         ;store where method's var of address holder for matrix B is stored
         LDWA    matrixA,d   ;load the address of matrix A on heap so it can be stored on stack
         STWA    0,s         ;store where method's var of address holder for matrix A is stored
         CALL    multMtx     ;call method to multiply the matrices
         ADDSP   10,i        ;pop #MmatxA #MmatxB #MmatX #MACol #MARow #MBCol #MBRow
         CPWA    0x0000,i    ;compare the returned pointer in accumulator to null if the dimensions were bad
         BREQ    main        ;if so, skip printing and go back to main
         LDWA    0,i         ;we need to reset the total amount of numbers in the matrix for printing the multiplication
         STWA    numMA,d     ;so we add 0 to the numMA to reset
         STWA    dVar,d      ;we also need to reset dVar from any previous iteration
mWhil2:  LDWA    dVar,d      ;load to see if we have looped as many times as there are rows
         CPWA    mARow,d     ;compare to the number of rows to see if we have looped enough
         BREQ    endMDi2     ;if so, we can end looping
         LDWA    numMA,d     ;otherwise we need to add to numMA
         ADDA    mBCol,d     ;add the number of columns
         STWA    numMA,d     ;store to be added to next loop
         LDWA    dVar,d      ;load dVar to add to
         ADDA    1,i         ;add one to dVar so we are one closer to the number of rows
         STWA    dVar,d      ;store for comparison next loop
         BR      mWhil2      ;go back to start of loop
endMDi2: STRO    totNMsg,d   ;let the user know the total amount of numbers that will be in the product matrix
         DECO    numMA,d     ;print the total amount of numbers that will be in the product matrix
         SUBSP   4,i         ;push #mDisp #dRow #dCol
         LDWA    mBCol,d     ;load mBCol since we need B's column count for the product columns
         STBA    0,s         ;store where method's var of columns can reference it
         LDWA    mARow,d     ;load mARow since we need A's row count for the product rows
         STBA    1,s         ;store where methods's var of rows can reference it
         LDWA    matxMul,d   ;load the address of the product matrix so we can store on the stack
         STWA    2,s         ;store where method's var of address holder can reference it
         CALL    dispM       ;call method to display the product matrix
         ADDSP   4,i         ;pop #dCol #dRow #mDisp 
         BR      main        ;go back to the top and let user choose next option
elsif4:  CPBA    'e',i       ;if the pressed e, then the user wants to exit the program
         BRNE    else        ;if not e, then the user has placed incorrect input
         STRO    EMsg,d      ;print that the user has selected to leave
         BR      end         ;branch to end the program
else:    STRO    IMsg,d      ;let the user know that their input is incorrect
         LDBA    charIn,d    ;laod the new line to get rid of it
         BR      mainIf      ;branch back to the main program so they can enter new input
end:     STOP                ;now that the user is done, end the program
;            
;
init0:   .ASCII  "\n\nPlease enter the letter for the function you want to use\n\x00" ;Greets the user with a message so that they can traverse through the program
init1:   .ASCII  "----------------------------------------------------------\n\x00" ;Separates the beginning statement from the options
init2:   .ASCII  "(a). Input matrix A\n\x00"                                            ;Provides the option too input matrix A
init3:   .ASCII  "(b). Input Matrix B\n\x00"                                            ;Provides the option to input Matrix B
init4:   .ASCII  "(c). Add the Matrices\n\x00"                                          ;Provides the option to add the matrices together
init5:   .ASCII  "(d). Multiply the input matrices\n\x00"                               ;Provides the option to multiply the matrices together
init6:   .ASCII  "(e). Exit the Program\n\x00"                                          ;Provides the user with the option to exit the program
initI:   .ASCII  "\nInput: \x00"                                                        ;Provides a line for the user to place their input
aMsg:    .ASCII  "\nPlease Enter Matrix A: \x00"                                        ;Provides the user a line to input the numbers for matrix A
bMsg:    .ASCII  "\nPlease Enter Matrix B: \x00"                                        ;Line for the user to enter matrix B 
ADDMsg:  .ASCII  "\nYou have chosen to add the matrices\n\x00"                          ;tells the user thry chose to add
MMsg:    .ASCII  "\nYou have chosen to multiply the matrices\n\x00"                     ;Tells the user they chose to multiply
EMsg:    .ASCII  "\nYou have chosen to exit, goodbye\n\x00"                             ;Tells the user they are going to exit
IMsg:    .ASCII  "This input is incorrect, please try again.\n\x00"                     ;Tells the user that their input is incorrect
colMsg:  .ASCII  "Enter the number of columns (1-5): \x00"                              ;Provides input for the number of columns
rowMsg:  .ASCII  "Enter the number of rows (1-5): \x00"                                 ;Provides input for the number of rows
nEqMsg:  .ASCII  "\nThe two matrices cannot be added together because they are different dimensions. Please enter the same dimensions.\n\x00"                                                                      ;Tells the user that the dimensions are incorrect
spc:     .ASCII  " \x00"                                                                ;a space for padding when printing the matrices
endMtx:  .ASCII  "\|\x00"                                                               ;Provides the end border for a matrix
endMMsg: .ASCII  "\nThe matrices are not in the correct dimensions to be multiplied, please try again.\n\n\x00" ;Tells the user that the dimensions are incorrect
totNMsg: .ASCII  "Total Matrix Numbers: \x00"                                           ;Used to represent the total amount of numbers in the matrix
;     
;
;
;******* malloc()
;
;
malloc:  LDWX hpPtr,d        ;get current location in the heap
         ADDA hpPtr,D        ;add number of bytes to be allocated to the heap     
         STWA hpPtr,d        ;update the first unallocated byte in the heap
         RET                 ;go back to main 
hpPtr:   .ADDRSS heap        ;the current address of the first unallocated byte
heap:    .BLOCK 1            ;first byte in the heap
         .END                ;Ends the program