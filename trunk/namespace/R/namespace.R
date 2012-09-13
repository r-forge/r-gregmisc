# Returns the namespace registry
#' @useDynLib devtools nsreg
.getNameSpaceRegistry <- function() {
  .Call("nsreg", "namespace")
}

# Register a namespace
registerNamespace <- function(name = NULL, env = NULL) {
  # Be careful about what we allow
  if (!is.character(name) || name == "" || length(name) != 1)
    stop("'name' must be a non-empty character string.")

  if (!is.environment(env))
    stop("'env' must be an environment.")

  if (name %in% loadedNamespaces())
    stop("Namespace ", name, " is already registered.")

  # Add the environment to the registry
  nsr <- .getNameSpaceRegistry()
  nsr[[name]] <- env

  env
}


# Unregister a namespace - should be used only if unloadNamespace()
# fails for some reason
unregisterNamespace <- function(name = NULL) {
  # Be careful about what we allow
  if (!is.character(name) || name == "" || length(name) != 1)
    stop("'name' must be a non-empty character string.")

  if (!(name %in% loadedNamespaces()))
    stop(name, " is not a registered namespace.")

  # Remove the item from the registry
  rm(name, envir=.getNameSpaceRegistry())
  invisible()
}

# This is similar to getNamespace(), except that getNamespace will load
# the namespace if it's not already loaded. This function will not.
# In R 2.16, a function called .getNamespace() will have the same effect
# and this will no longer be necessary.
if(exists(".getNamespace", where="package:base", mode="function")) {
  getRegisteredNamespace <- function(name) base::.getNamespace(name)
} else {
  getRegisteredNamespace <- function(name)
  {
    ## Sometimes we'll be passed something like as.name(name), so make sure
    ## it's a string for comparison
    if (!(as.character(name) %in% loadedNamespaces()))
      return(NULL)
    else
      return(getNamespace(name))
  }
}

## Copy of function defined inside of base::loadNamespace
makeNamespace <- function(name, version = NULL, lib = NULL) {
    impenv <- new.env(parent = .BaseNamespaceEnv, hash = TRUE)
    attr(impenv, "name") <- paste("imports", name, sep=":")
    env <- new.env(parent = impenv, hash = TRUE)
    name <- as.character(as.name(name))
    version <- as.character(version)
    info <- new.env(hash = TRUE, parent = baseenv())
    assign(".__NAMESPACE__.", info, envir = env)
    assign("spec", c(name = name,version = version), envir = info)
    setNamespaceInfo(env, "exports", new.env(hash = TRUE, parent = baseenv()))
    dimpenv <- new.env(parent = baseenv(), hash = TRUE)
    attr(dimpenv, "name") <- paste("lazydata", name, sep=":")
    setNamespaceInfo(env, "lazydata", dimpenv)
    setNamespaceInfo(env, "imports", list("base" = TRUE))
    ## this should be an absolute path
    setNamespaceInfo(env, "path",
                     normalizePath(file.path(lib, name), "/", TRUE))
    setNamespaceInfo(env, "dynlibs", NULL)
    setNamespaceInfo(env, "S3methods", matrix(NA_character_, 0L, 3L))
    assign(".__S3MethodsTable__.",
           new.env(hash = TRUE, parent = baseenv()),
           envir = env)
    registerNamespace(name, env)
    env
}
