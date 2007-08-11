\name{SASxport-package}
\alias{SASxport-package}
\alias{SASxport}
\docType{package}
\title{
  Read and write SAS export files
}
\description{
  This package provides functions to read, list contents of, and write
  SAS export files.
}
\details{

  The read.xport function for reading xport files augments the
  functionality of the read.xport function provided in the "recommended" 
  package 'foreign' with additional features borrowed from Frank Harrell's
  sasxport.get() in the 'Hmisc' package.  Namely, variables are properly
  coerced into the types specified by the format field. All standard
  numeric and string formats are supported  automatically, while
  user-defined formats are supported when the used has included the format
  data in the xport file via

     PROC FORMAT CNTLOUT=format;

  The write.xport function writes one or more data sets into a SAS xport
  file.  Standard R data types, including date and time objects
  (e.g. Date, and POSIX.t) are stored with proper SAS format types.
  Handling of object formatting is customizable by providing methods for
  the function toSAS().  This is accomplished by writing a new method
  for toSAS() for the object class of interest. The toSAS() method is
  responsible for converting its argument to either a simple floating
  point or character variable (the only basic types permitted by the
  xport format) and adding the appropriate SAS format code in the
  'format' attribute. 

  The write.xport() function, further, allows the user to override the
  operating system type and SAS version information, as well as object
  creation and modification times.

  
  This package was created by Random Technologies LLC
  <http://random-technologies-llc.com> with funding by Metrum Institute
  <http://metruminstitute.org>. 

}
\section{Index}{
\preformatted{
lookup.xport            Lookup Information on a SAS XPORT Format
                        Library
read.xport              Import SAS XPORT files
toSAS.default           Convert R data object for storage in SAS 
                        xport file
units                   Set or Retreive the label, format, 
                        iformat, or units Attribute of a Vector
write.xport             Write data to a SAS XPORT file
}
}
\author{
  Gregory R. Warnes <greg@random-technologies-llc.com>, includes
  code from Frank E. Harrell, Jr.'s Hmisc package.

  Maintainer: Gregory R. Warnes <greg@random-technologies-llc.com>
}
\section{Support}{
  Technical support contracts and other services for for R, this package,
  and other packages are available from Random Technologies LLC
  <http://random-technologies-llc.com>.
}
\keyword{ package }
