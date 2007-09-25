\name{SASxport-package}
\alias{SASxport-package}
\alias{SASxport}
\docType{package}
\title{
  Read and Write SAS Export Files
}
\description{
  This package provides functions to read, list contents of, and write
  SAS export files.
}
\details{
  The \code{read.xport} function reads SAS xport formatted files,
  augmenting the functionality of the \code{\link[foreign]{read.xport}}
  function provided in the 'foreign' package with additional features
  borrowed from \code{\link[Hmisc]{sasxport.get}} in Frank Harrell's
  'Hmisc' package.  Namely, variables are properly coerced into the
  types specified by the format field. All standard numeric and string
  SAS formats are supported automatically, while user-defined formats
  are supported when the user has included the appropriate format data
  in the xport file via:
\preformatted{
     PROC FORMAT CNTLOUT=format;
}
   The \code{write.xport} function writes one or more data sets into a
   SAS xport formatted file.  Standard R data types, including date and
   time objects (e.g. \code{Date}, and \code{POSIX.t}) are stored with
   proper SAS format types. Handling of object formatting is
   customizable by providing methods for the function \code{toSAS}.
   This is accomplished by writing a new method for \code{toSAS} for the
   object class of interest. The \code{toSAS} method is responsible for
   converting its argument to either a simple floating point or
   character variable (the only basic types permitted by the xport
   format) and adding the appropriate SAS format code in the
   \code{"format"} attribute.

   The \code{write.xport} function also allows the user to override the
   operating system type and SAS version information, as well as object
   creation and modification times.
}
\section{Index}{
\preformatted{
lookup.xport            Lookup Information on a SAS XPORT Format
                        Library
read.xport              Import SAS XPORT files
toSAS.default           Convert R data object for storage in SAS 
                        xport file
units                   Set or Retrieve the label, format, 
                        iformat, or units Attribute of a Vector
write.xport             Write data to a SAS XPORT file
}
}
\author{
  Unless otherwise noted, the contents of this package were written by
  Gregory R. Warnes \email{greg@random-technologies-llc.com}, are
  Copyright (c) 2007 by Random Technologies LLC \cr
  \url{http://random-technologies-llc.com}, and are provided under the
  terms of the GNU General Public License, version 2.0 or later. 

  The file 'htond.c' is extracted from BRL-CAD
  \url{http://www.brlcad.org/}, written by Michael John Muuss, and is 
  Copyright (c) 2004-2007 United States Government as represented by
  the U.S. Army Research Laboratory, and is utilized and redistributed
  under the terms of the  GNU Lesser General Public License, version 2.1.

  The files 'AFirst.lib.s', 'all.is.numeric.R',
  'importConvertDateTime.R', 'in.opererator.R', 'makeNames.R', 
  'read.xport.R', and 'testDateTime.R' are copied or adapted from the
  'Hmisc' package created by Frank E. Harrell, Jr. 
  \email{f.harrell@vanderbilt.edu}, and are utilized and redistributed under
  the terms of the GNU General Public License, version 2.0 or later.
  }
\section{Funding}{
  This creation of this package was partially funded by Metrum Institute
  \url{http://metruminstitute.org}.
  }
\section{Maintainer}{
  Gregory R. Warnes \email{greg@random-technologies-llc.com}
}
\section{Support}{
  Technical support contracts and other services for R, this package,
  and other packages are available from Random Technologies LLC
  \url{http://random-technologies-llc.com}.
}
\keyword{package}
