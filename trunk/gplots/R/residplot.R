# $Id$
#
# $Log$
# Revision 1.3  2002/09/23 13:59:30  warnes
# - Modified all files to include CVS Id and Log tags.
#
#

residplot  <-  function(model, formula, ...)
  {
    data  <- expand.model.frame( model, formula, na.expand=TRUE)

    newform  <- eval(parse( text=paste("as.call(", "resid(model) ~",
                        formula[-1],")" )))
    
    plot( newform, data=data, ylab="Residuals")
    lines(lowess( newform, data=data ), col="red")
    bandplot(newform,data=data)
  }
              
