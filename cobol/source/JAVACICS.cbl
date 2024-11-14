      *****************************************************************
      * Proxy for invoking a Java program from COBOL in CICS.
      * NB. Only intended for demo purposes and not for general use.
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. JAVACICS.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
      ***************************************************************
       WORKING-STORAGE SECTION.
       01  WORK-FIELDS.
           05  JAVA-CHANNEL        PIC X(16).                           .
           05  INPUT-CONTAINER     PIC X(16).                           .
           05  OUTPUT-CONTAINER    PIC X(16).                           .
           05  MAX-LENGTH          PIC S9(9) COMP.
      ***************************************************************
       LINKAGE SECTION.
       77  JAVA-PROGRAM            PIC X(8).
       01  JAVA-INPUT.
           05  FILLER              PIC X OCCURS 1 TO 999999999
                                    DEPENDING ON JAVA-INPUT-L.
       01  JAVA-OUTPUT.
           05  FILLER              PIC X OCCURS 1 TO 999999999
                                    DEPENDING ON JAVA-OUTPUT-L.
       77  JAVA-INPUT-L            PIC S9(9) COMP.
       77  JAVA-OUTPUT-L           PIC S9(9) COMP.
      ***************************************************************
       PROCEDURE DIVISION USING     DFHEIBLK
                                    DFHCOMMAREA
                                    JAVA-PROGRAM
                                    JAVA-INPUT
                                    JAVA-OUTPUT
                                    JAVA-INPUT-L
                                    JAVA-OUTPUT-L.
      ***************************************************************
       MAIN-PROCESSING SECTION.
           MOVE 'COBOL2JAVA'     TO JAVA-CHANNEL.

           IF JAVA-INPUT-L > ZERO
              PERFORM PUT-INPUT-CONTAINER
           END-IF.

           EXEC CICS LINK PROGRAM(JAVA-PROGRAM)
               CHANNEL(JAVA-CHANNEL)
           END-EXEC.

           IF JAVA-OUTPUT-L > ZERO
              PERFORM GET-OUTPUT-CONTAINER
           END-IF.

       MAIN-PROCESSING-EXIT.
           EXIT PROGRAM.
      ***************************************************************
      ***************************************************************
       PUT-INPUT-CONTAINER SECTION.
           MOVE SPACES           TO INPUT-CONTAINER.
           STRING JAVA-PROGRAM DELIMITED BY SPACE
                  '-INPUT'     DELIMITED BY SIZE
                  INTO INPUT-CONTAINER.

           EXEC CICS PUT CONTAINER(INPUT-CONTAINER)
                CHANNEL(JAVA-CHANNEL)
                FROM(JAVA-INPUT)
                CHAR
           END-EXEC.

       PUT-INPUT-CONTAINER-EXIT.
           EXIT.
      ***************************************************************
      ***************************************************************
       GET-OUTPUT-CONTAINER SECTION.
           MOVE SPACES           TO OUTPUT-CONTAINER.
           STRING JAVA-PROGRAM DELIMITED BY SPACE
                  '-OUTPUT'    DELIMITED BY SIZE
                  INTO OUTPUT-CONTAINER.
           COMPUTE MAX-LENGTH     = JAVA-OUTPUT-L.

           EXEC CICS GET CONTAINER(OUTPUT-CONTAINER)
                CHANNEL(JAVA-CHANNEL)
                INTO(JAVA-OUTPUT)
                FLENGTH(MAX-LENGTH)
           END-EXEC.

       GET-OUTPUT-CONTAINER-EXIT.
           EXIT.