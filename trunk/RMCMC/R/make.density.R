make.density <- function(m, data)
{
  if(!is.call(m)) stop("The model 'm' is not a model object (see ?model)")
  
  newcode <- function(...)
    {
      parms <- list(...)
      if(length(parms)==1 && is.list(parms[[1]])) parms <- parms[[1]]
      attach(parms)
      loglik <- 0.0
      # added code goes here
    }
  index <- 6

  if(missing(data))
    {
      data <- m$data
    }
  m$data <- NULL

  for( expr in as.list(m))
    {
      if(expr=="model") next
      if(length(expr)==3)
        {
          CALL <- expr[[1]]
          LHS <- expr[[2]]
          RHS <- expr[[3]]
          if(CALL=="~")
            {
              newCALL <- insert.arg(RHS, LHS)

              # convert from name to distribution function
              CALL = as.character(newCALL[[1]])
              fun <- lookup.table[[CALL]]$logdensity
              if(is.null(fun))
                {
                  fun <- lookup.table[[CALL]]$density
                  if(is.null(fun))
                    stop("Unable to find a density function for '", CALL,
                         "' in lookup.table")
                  else
                    {
                      newCALL[[1]] <- as.symbol(fun) 
                      newCALL <- bquote( log(.(newCALL)) )
                    }
                }
              else
                {
                  newCALL[[1]] <- as.symbol(fun)
                }

              
              # put into function
              body(newcode)[[index]] <- bquote( loglik <- loglik + sum
                                               (.(newCALL)) )
              index <- index + 1
            }
          else if (CALL=="<-")
            {
              body(newcode)[[index]] <- expr
              index <- index + 1
            }
        }
      else if (!is.null(expr) && nchar(as.character(expr)) > 0 )
        {
          cat("Skipping expression with length!=3: '",
              deparse(substitute(expr)), "'\n", sep='')
        }
      else
        {
          cat("Skipping empty line\n")
        }
    }
  body(newcode)[[index]] <- quote(detach(parms))
  index <- index+1

  body(newcode)[[index]] <- quote(loglik)
  index <- index+1
  

  # Create an environment to hold the constant data

  newenv <- new.env()
  for(n in names(data))
    {
      cat("Added",n,"to the function environment.\n") 
      assign(n, data[[n]], env=newenv)
    }

  environment(newcode) <- newenv
  
  newcode
}
