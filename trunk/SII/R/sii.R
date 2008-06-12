sii <- function(
                speech=c("normal","raised","loud","shout"),
                noise,
                threshold,
                loss,
                freq,
                method=c(
                  "interpolate",                        
                  "critical",
                  "equal-contributing",
                  "one-third octave",
                  "octave"
                  ),
                importance=c(
                  "SII",
                  "NNS",
                  "CID22",
                  "NU6",
                  "DRT",
                  "ShortPassage",
                  "SPIN",
                  "CST"
                  )
                )
{
  ## Assumptions:
  ##
  ## freq: If provided, frequencies in Hz at which speech, noise, and/or
  ##    threshold values are measured.  If missing, frequencies will
  ##    corresponding to those utilized by the specified method.
  ##    Note that, frequencies must be provided for method="interpolate"
  ##
  ## speech: Speech level in dB at each frequency, or one of levels of
  ##    stated vocal effort ("raised",  "normal",  "loud", "shout")
  ##    provided by the standard, in which case the reference levels
  ##    in dB will be applied.
  ##
  ## noise: Noise dB at each frequency, defaults to -50 dB at each
  ##   frequency (as required by ANSI S3.5-1997 section 4.2)
  ##
  ## threshold: Hearing threshold level in dB at each frequency. If
  ##   missing, assumed to be 0.
  ##
  ## loss: Hearing threshold loss factor due to the presence of
  ##   conductive hearing loss in dB.  If missing, assumed to be 0

  ## Determine which method will be used
  method=match.arg(method)

  ## Get the appropriate table of constants
  data.name <- switch(method,
                      "interpolate"="critical",
                      "critical"="critical",
                      "one-third octave"="onethird",
                      "equal-contributing"="equal",
                      "octave"="octave"
                      )
  data(list=data.name, package="SII")
  table <- get(data.name)

  ## Get the correct importance functions
  if(missing(importance) || is.character(importance) )
    {
      importance=match.arg(importance)  
      if(importance!="SII")
        {
          sic.name <- paste("sic.",data.name, sep="")
          data(list=sic.name, package="SII")
          sic.table <- get(sic.name)
          table[,"Ii"] <- sic.table[[importance]]
        }
    }
  else
    if(length(importance) != nrow(table))
      stop("`importance' vector have length ", nrow(table), "for method `",method,"'.")
    else
      table[,"Ii"] <- importance

  
  ## Handle missing freq
  if(missing(freq))
    if(method=="interpolate")
      stop("`freq' must be specified when `method=\"interpolate\"'")
    else
      freq <- table$fi

  ## Get appropriate reference values for speech 
  if(is.character(speech))
    {
      const.speech=TRUE
      speech <- match.arg(speech)
      speech <- table[[speech]]
    }
  else
    const.speech=FALSE

  ## Handle missing noise
  if(missing(noise))
    noise <- rep(-50, length(freq))
  
  ## Handle missing threshold
  if(missing(threshold))
    threshold <- rep(0, length(freq))

  ## Handle missing loss
  if(missing(loss))
    loss <- rep(0, length(freq))

  ## Ensure that speech, noise, and threshold are the correct size
  nfreq <- length(freq)
  if(length(speech)    != nfreq && !const.speech)
    stop("`speech' must have the same length as `freq'.")
  if(
     length(noise)     != nfreq ||
     length(threshold) != nfreq ||
     length(loss)      != nfreq
     )
    stop("`noise', `threshold', and `loss` must have the same length as `freq'.")
  
  ## Check for & handle missing values
  nas <- (is.na(noise) | is.na(threshold) | is.na(loss) | is.na(freq) )
  if(!const.speech)
    nas <- nas | is.na(speech)
  
  if(any(nas) )
    {
      if(method=="interpolate")
        {
          warning(sum(nas), " missing values omitted.")
          if(!const.speech)
            speech     <- speech   [!nas]
          
          noise      <- noise    [!nas]
          threshold  <- threshold[!nas]
          loss       <- loss     [!nas]
          freq       <- freq     [!nas]

        }
      else
        stop("Missing values only permitted for method `interpolate'")
    }

  ## Sort values into frequency order
  ord <- order(freq)
  freq      <- freq     [ord]
  noise     <- noise    [ord]
  threshold <- threshold[ord]
  loss      <- loss     [ord]

  if(!const.speech)
    speech    <- speech   [ord]

  
  ## Store these values in the return object.
  retval <- list()
  retval$call <- match.call()
  retval$orig <- list( freq, speech, noise, threshold, loss )
  
  if(method=="interpolate")
    {
      approx.l <- function(x,y)
        { 
          tmp <- approx(
                        log(x),
                        y,
                        log(sii.freqs),
                        method="linear",  
                        rule=2
                        )
          tmp$y
        }

      sii.freqs <- table[,"fi"]
      
      ## Interpolate unobserved frequencies
      noise     <- approx.l(freq, noise)
      threshold <- approx.l(freq, threshold)
      loss      <- approx.l(freq, loss)

      if(!const.speech)
        speech    <- approx.l(freq, speech)
      
      freq   <- sii.freqs
    }
      
  #########
  ## Calcuate SII following ANSI S3.5-1997 Section 4
  #########
  
  ## Setup: Create worksheet
  col.names <- c("Fi", "E'i", "N'i", "T'i", "Vi", "Bi", "Ci", "Zi",
                 "Xi", "X'i", "Di", "Ui", "Ji", "Li", "Ki", "Ai",
                 "Ii", "IiAi")  
  sii.tab <- matrix(nrow=length(freq),ncol=length(col.names))
  colnames(sii.tab) <- col.names
  rownames(sii.tab) <- 1:nrow(sii.tab)

  sii.tab <- as.data.frame(sii.tab)

  #####
  ## Step 1: Select calculation method
  #####

  ## The calculation method is already stored in 'method'

  ## Copy midband frequencies into the table
  sii.tab$"Fi" <- freq

  #####
  ## Step 2: Equivalent speech E'i, noise N'i, and hearing threshold
  ##         T'i spectra
  #####
  sii.tab$"E'i" <- speech
  sii.tab$"N'i" <- noise
  sii.tab$"T'i" <- threshold
  sii.tab$"Ji"  <- loss

  #####
  ## Step 3: Equivalent masking spectrum level (Zi)
  #####
  if(method=="octave")
    ## 4.3.1
    sii.tab$"Zi" <- sii.tab$"N'i"
  else 
    {
      ## 4.3.2.1 self-speech masking level
      sii.tab$"Vi" <- sii.tab$"E'i" - 24

      ## 4.3.2.2
      sii.tab$"Bi" <- pmax(sii.tab$"N'i", sii.tab$"Vi")

      ## 4.3.2.3 slope per octive of spread of masking, Ci
      if(method=="critical" ||
         method=="interpolate" ||
         method=="equal-contributing")
        {
          sii.tab$"Ci" <- -80 + 0.6*( sii.tab$"Bi" + 10*log10(table$"hi" - table$"li") )
        }
      else # method=="one-third octave"
        {
          sii.tab$"Ci" <- -80 + 0.6*( sii.tab$"Bi" + 10*log10(table$"fi") - 6.353 )          
        }

      if(method=="critical" ||
         method=="interpolate" ||
         method=="equal-contributing")
        {
          Zifun <- function(i) 
            {
              slow <- TRUE

              if(slow)
                {
                  accum <- 10 ^ (0.1 * sii.tab[i,"N'i"])
                  if(i>1)
                    for(k in 1:(i-1))
                      accum <- accum + 10 ^ (0.1 * (sii.tab[k,"Bi"] + 3.32*sii.tab[k,"Ci"] * log10( table[i,"fi"] / table[k,"hi"] ) ) )
                  retval <- 10 * log10(accum)
                }
              else
                {
                  if(i>1)
                    inner <- sum( 10 ^ (0.1 * ( sii.tab[1:(i-1),"Bi"] + 3.32*sii.tab[1:(i-1),"Ci"] * log10( table[i,"fi"] / table[1:(i-1),"hi"] ) ) ) )
                  else
                    inner <- 0
                  retval <- 10 * log10( 10 ^ (0.1 * sii.tab[i,"N'i"] ) + inner )
                }

              retval
            }
          
          sii.tab$"Zi" = sapply(1:nrow(sii.tab), Zifun)

        }
      else # method=="one-third octave"
        {

          
          Zifun <- function(i) 
            {
              slow <- FALSE
              
              if(slow)
                {
                  accum <- 10 ^ (0.1 * sii.tab[i,"N'i"])
                  if(i>1)
                    for(k in 1:(i-1))
                      accum <- accum + 10 ^ (0.1 * ( sii.tab[k,"Bi"] + 3.32*sii.tab[k,"Ci"] * log10( 0.89 * table[i,"fi"] / table[k,"fi"] ) )  )
                  retval <- 10 * log10(accum)
                }
              else
                {

                  if(i>1)
                    inner <- sum( 10 ^ (0.1 * ( sii.tab[1:(i-1),"Bi"] + 3.32*sii.tab[1:(i-1),"Ci"] * log10( 0.89 * table[i,"fi"] / table[1:(i-1),"fi"] ) ) ) )
                  else
                    inner <- 0
              
                  retval <- 10 * log10( 10 ^ (0.1 * sii.tab[i,"N'i"] ) + inner )
                }
            }
          sii.tab$"Zi" = sapply(1:nrow(sii.tab), Zifun)
        }

      ## 4.3.2.4
      sii.tab[1,"Zi"] <- sii.tab[1,"Bi"]

    }
  
  #####
  ## Step 4: Equivalent internal noise spectrum level, X'i
  #####
  ## Copy reference internal noise spectrum Xi
  sii.tab$"Xi" <- table$"Xi"
  
  ## Calculate  X'i
  sii.tab$"X'i" <- sii.tab$"Xi" + sii.tab$"T'i" 

  #####
  ## Step 5: Equivalent disturbance spectrum, Di
  #####
  sii.tab$"Di" <- pmax( sii.tab$"Zi", sii.tab$"X'i" )

  #####
  ## Step 6: Level distortion factor, Li
  #####
  
  ## Standard speech spectrum level at normal vocal level Ui
  sii.tab$"Ui" <- table$"normal"
  
  ##         Calculate speech level distortion factor Li
  enforce.range <- function(x) 
    {
      x[x < 0] <- 0  # min is 0
      x[x > 1] <- 1  # max is 1
      x
    }
  ## Formula A1, which extends formula 11 to handle conductive
  ## hearing loss (Ji)
  sii.tab$"Li" <- 1 - (sii.tab$"E'i" - sii.tab$"Ui" - 10 - sii.tab$"Ji" )/160 
  sii.tab$"Li" <- enforce.range(sii.tab$"Li")
  
  ## Step 7: Calculate Ki
  sii.tab$"Ki" <- (sii.tab$"E'i" - sii.tab$"Di" + 15)/30
  sii.tab$"Ki" <- enforce.range( sii.tab$"Ki" )
  
  ##         Calculate Ai
  sii.tab$"Ai" <- sii.tab$"Li" * sii.tab$"Ki"
  
  ## Step 8: Copy band importance function values
  sii.tab[,"Ii"] <- table[,"Ii"]
  
  ##         Calculate Ii * Ai
  sii.tab[,"IiAi"] <- table[,"Ii"] * sii.tab[,"Ai"]
  
  ##         Sum IiAi to determine SII
  sii.val <- sum(sii.tab[,"IiAi"])  

  ## Package it all up to return to the user
  retval$speech    <- speech
  retval$noise     <- noise
  retval$threshold <- threshold
  retval$loss      <- loss
  retval$freq      <- freq
  retval$method    <- method
  retval$table     <- sii.tab
  retval$sii       <- sii.val
  
  class(retval) <- "SII"
  
  retval
}
