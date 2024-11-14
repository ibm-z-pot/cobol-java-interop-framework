      *****************************************************************
      * Proxy for invoking a JAVA program from COBOL in CICS.
      * Stub to handle DFHEIBLK DFHCOMMAREA requirement.
      * NB. Intended for demo purposes and not for general use.
      *****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. JAVA.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
       COPY DFHEIBLC.
       01  DFHCOMMAREA             PIC X(1).
      *
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
      *
       PROCEDURE DIVISION  USING     JAVA-PROGRAM
                                     JAVA-INPUT
                                     JAVA-OUTPUT
                                     JAVA-INPUT-L
                                     JAVA-OUTPUT-L.
      *
           CALL 'JAVACICS' USING     DFHEIBLK
                                     DFHCOMMAREA
                                     JAVA-PROGRAM
                                     JAVA-INPUT
                                     JAVA-OUTPUT
                                     JAVA-INPUT-L
                                     JAVA-OUTPUT-L.
      *
           EXIT PROGRAM.