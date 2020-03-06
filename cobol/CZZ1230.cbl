       IDENTIFICATION      DIVISION.
       PROGRAM-ID.         CZZ1230.

       ENVIRONMENT         DIVISION.
       CONFIGURATION       SECTION.

       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.

       SELECT  FDZZ9C0  ASSIGN TO "FDZZ9C0"                                     "ec2_datarow.csv"
               ORGANIZATION       IS   LINE SEQUENTIAL.
       SELECT  FDZZ9C4  ASSIGN TO "FDZZ9C4"                                     "ec2_dataconv.json"
               ORGANIZATION       IS   LINE SEQUENTIAL.

      ******************************************************************
      *** DATA             DIVISION
      ******************************************************************
       DATA                DIVISION.
       FILE                SECTION.
       FD FDZZ9C0 RECORDING MODE IS V.
          01 FDZZ9C0-IN-REC                 PIC X(200).
       FD FDZZ9C4 RECORDING MODE IS V.
          01 FDZZ9C4-OUT-REC                PIC X(300).

      ******************************************************************
       WORKING-STORAGE     SECTION.
      ******************************************************************
       01  WK-CSV-IN-FILE.
           03 WK-IN-SNO                      PIC X(20).
           03 WK-IN-DATE                     PIC X(20).
           03 WK-IN-PROVINCE                 PIC X(30).
           03 WK-IN-COUNTRY                  PIC X(15).
           03 WK-IN-LASTUPDATE               PIC X(20).
           03 WK-IN-CONFIRMED                PIC X(15).
           03 WK-IN-DEATHS                   PIC X(15).
           03 WK-IN-RECOVERED                PIC X(15).
           
       01  WK-AREA.
           03 WK-IN-EOF-FLG                  PIC 9(1) VALUE 0.
           03 WK-CNT-FDZZ9C0                 PIC 9(6) VALUE 0.
           03 WK-CNT-FDZZ9C4                 PIC 9(6) VALUE 0.

       01  WK-DB-INDEX                       PIC X(12).                         corona-index

      ******************************************************************
       PROCEDURE           DIVISION.
      ******************************************************************
       MAIN-PROC.
           PERFORM   INIT-RTN.

           PERFORM   MAIN-RTN UNTIL  WK-IN-EOF-FLG = 1.

           PERFORM   END-RTN.

           STOP RUN
           .

      ******************************************************************
      * イニシャル処理
      ******************************************************************
       INIT-RTN.
           DISPLAY "START: CZZ1230"
           OPEN   INPUT  FDZZ9C0
                  OUTPUT FDZZ9C4

           ACCEPT WK-DB-INDEX FROM ARGUMENT-VALUE

      *    ヘッダを読み飛ばす
           PERFORM   FDZZ9C0-READ-RTN.

      *    明細取り込み
           PERFORM   FDZZ9C0-READ-RTN.
           .
      ******************************************************************
      * データファイル取り込む処理
      ******************************************************************
       FDZZ9C0-READ-RTN.
           INITIALIZE            WK-CSV-IN-FILE
           READ FDZZ9C0
                AT END
                    MOVE   1     TO WK-IN-EOF-FLG
                NOT AT END
                    UNSTRING     FDZZ9C0-IN-REC
                    DELIMITED    BY ","
                                 INTO    WK-IN-SNO
                                         WK-IN-DATE
                                         WK-IN-PROVINCE
                                         WK-IN-COUNTRY
                                         WK-IN-LASTUPDATE
                                         WK-IN-CONFIRMED
                                         WK-IN-DEATHS
                                         WK-IN-RECOVERED
           
                    ADD    1     TO      WK-CNT-FDZZ9C0
           END-READ
           .
      ******************************************************************
      * メイン処理
      ******************************************************************
       MAIN-RTN.
           PERFORM   DATA-WRITE-RTN.

           PERFORM   FDZZ9C0-READ-RTN.
           .
      ******************************************************************
      * データ編集・出力処理
      ******************************************************************
       DATA-WRITE-RTN.
           INITIALIZE   FDZZ9C4-OUT-REC
           STRING "{ ""index"" : { ""_index"" : """  DELIMITED BY SIZE
                  FUNCTION TRIM(WK-DB-INDEX)
                  """} }"                            DELIMITED BY SIZE
                 INTO FDZZ9C4-OUT-REC
           END-STRING

           WRITE FDZZ9C4-OUT-REC

           INITIALIZE   FDZZ9C4-OUT-REC

           STRING "{""Date"":"""          DELIMITED BY SIZE
                  FUNCTION TRIM(WK-IN-DATE)
                  """,""Province"":"""    DELIMITED BY SIZE
                  FUNCTION TRIM(WK-IN-PROVINCE)
                  """,""Country"":"""     DELIMITED BY SIZE
                  FUNCTION TRIM(WK-IN-COUNTRY)
                  """,""LastUpdate"":"""  DELIMITED BY SIZE
                  FUNCTION TRIM(WK-IN-LASTUPDATE)
                  """,""Confirmed"":"     DELIMITED BY SIZE
                  FUNCTION TRIM(WK-IN-CONFIRMED)    
                  ",""Deaths"":"          DELIMITED BY SIZE
                  FUNCTION TRIM(WK-IN-DEATHS)       
                  ",""Recovered"":"       DELIMITED BY SIZE
                  FUNCTION TRIM(WK-IN-RECOVERED)    
                  "}"                     DELIMITED BY SIZE
                 INTO FDZZ9C4-OUT-REC
           END-STRING

      *    DISPLAY "FDZZ9C4-OUT-REC: "        FDZZ9C4-OUT-REC

           WRITE FDZZ9C4-OUT-REC
           ADD   1     TO      WK-CNT-FDZZ9C4
           .
      ******************************************************************
      * 終了処理
      ******************************************************************
       END-RTN.
           CLOSE   FDZZ9C0 FDZZ9C4

           DISPLAY "FDZZ9C0: "  WK-CNT-FDZZ9C0 "件"
           DISPLAY "FDZZ9C4: "  WK-CNT-FDZZ9C4 "件"

           MOVE    ZERO    TO RETURN-CODE
           DISPLAY "END: CZZ1230"
           .

