SAS/R: Coverting PDF tables to SAS datasets (simple example)

  WORKING CODE
  WPS/PROC-R - could use IML/R


  file <- "d:/pdf/class.pdf";
  Rpdf <- readPDF(control = list(text = "-layout"));
  corpus <- VCorpus(URISource(file),
        readerControl = list(reader = Rpdf));
  classtext <- as.data.frame(content(content(corpus)[[1]]));  ** first table;

see
SAS Forum: PDF to SAS Dataset
https://communities.sas.com/t5/Base-SAS-Programming/PDF-to-SAS-Dataset/m-p/401636


WPS/SAS/R: Coverting PDF tables to SAS datasets (simple example)

There are more options in the TM (text mining package)

HAVE ( PDF file with the table below)
======================================

  NAME        SEX     AGE    HEIGHT   WEIGHT

  Alfred       M       14        69    112.5
  Alice        F       13      56.5       84
  Barbara      F       13      65.3       98
  Carol        F       14      62.8    102.5
  Henry        M       14      63.5    102.5
  James        M       12      57.3       83
  Jane         F       12      59.8     84.5
  Janet        F       15      62.5    112.5
  Jeffrey      M       13      62.5       84
  John         M       12        59     99.5
  Joyce        F       11      51.3     50.5
  Judy         F       14      64.3       90
  Louise       F       12      56.3       77
  Mary         F       15      66.5      112
  Philip       M       16        72      150
  Robert       M       12      64.8      128
  Ronald       M       15        67      133
  Thomas       M       11      57.5       85
  William      M       15      66.5      112

WANT  (SAS dataset)
===================

Up to 40 obs from sashelp.class total obs=19

Obs    NAME        SEX    AGE   HEIGHT  WEIGHT

  1    Alfred       M      14       69   112.5
  2    Alice        F      13     56.5      84
  3    Barbara      F      13     65.3      98
  4    Carol        F      14     62.8   102.5
  5    Henry        M      14     63.5   102.5
  6    James        M      12     57.3      83
  7    Jane         F      12     59.8    84.5
  8    Janet        F      15     62.5   112.5
  9    Jeffrey      M      13     62.5      84
 10    John         M      12       59    99.5
 11    Joyce        F      11     51.3    50.5
 12    Judy         F      14     64.3      90
 13    Louise       F      12     56.3      77
 14    Mary         F      15     66.5     112
 15    Philip       M      16       72     150
 16    Robert       M      12     64.8     128
 17    Ronald       M      15       67     133
 18    Thomas       M      11     57.5      85
 19    William      M      15     66.5     112


WORKING CODE
============

  file <- "d:/pdf/class.pdf";
  Rpdf <- readPDF(control = list(text = "-layout"));
  corpus <- VCorpus(URISource(file),
        readerControl = list(reader = Rpdf));
  classtext <- as.data.frame(content(content(corpus)[[1]]));


FULL SOLUTION
=============

* create a pdf;
title;footnote;
ods pdf file="d:/pdf/class.pdf";
proc print data=sashelp.class noobs;
run;quit;
ods pdf close;

* xpdf executables have to be in the path;
%utl_submit_wps64('
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library("tm");
library("slam");
file <- "d:/pdf/class.pdf";
Rpdf <- readPDF(control = list(text = "-layout"));
corpus <- VCorpus(URISource(file),
      readerControl = list(reader = Rpdf));
array <- as.data.frame(content(content(corpus)[[1]]));
colnames(array)<-"lines";
endsubmit;
import r=array data=wrk.array;
run;quit;
');

proc print data=array(where=(lines ne ' ')) width=min;
run;quit;

Obs    LINES

  1    NAME SEX AGE HEIGHT WEIGHT
  3    Alfred M   14 69.0 112.5
  5    Alice  F   13 56.5  84.0
  7    Barbara F  13 65.3  98.0
  9    Carol F    14 62.8 102.5
 11    Henry M    14 63.5 102.5
 13    James M    12 57.3  83.0
 15    Jane   F   12 59.8  84.5
 17    Janet F    15 62.5 112.5
 19    Jeffrey M  13 62.5  84.0
 21    John   M   12 59.0  99.5
 23    Joyce F    11 51.3  50.5
 25    Judy   F   14 64.3  90.0
 27    Louise F   12 56.3  77.0
 29    Mary   F   15 66.5 112.0
 31    Philip M   16 72.0 150.0
 33    Robert M   12 64.8 128.0
 35    Ronald M   15 67.0 133.0
 37    Thomas M   11 57.5  85.0
 39    William M  15 66.5 112.0


