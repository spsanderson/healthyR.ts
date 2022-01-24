# On library attachment, print message to user.
.onAttach <- function(libname, pkgname) {

    msg <- paste0(
        "\n",
        "== Welcome to healthyR.ts ===========================================================================",
        "\nIf you find this package useful, please leave a star: ",
        "\n   https://github.com/spsanderson/healthyR.ts'",
        "\n",
        "\nIf you encounter a bug or want to request an enhancement please file an issue at:",
        "\n   https://github.com/spsanderson/healthyR.ts/issues",
        "\n",
        "\nThank you for using healthyR.ts"
    )

    packageStartupMessage(msg)

}


.onLoad = function(libname, pkgname) {
    maybe_register_s3_methods()
}
# nocov start
maybe_register_s3_methods <- function() {

    ns <- asNamespace("healthyR.ts")
    names <- names(ns)

    # # ----------------------------------------------------------------------------

    tidy_names <- c(
        grep("tidy.step",  names, fixed = TRUE, value = TRUE),
        grep("tidy.check", names, fixed = TRUE, value = TRUE)
    )

    tidy_classes <- gsub("tidy.", "", tidy_names)

    for (i in seq_along(tidy_names)) {
        class <- tidy_classes[[i]]
        s3_register("generics::tidy", class)
    }

    # # ----------------------------------------------------------------------------

    tidy_check_names <- grep("tidy.check", names, fixed = TRUE, value = TRUE)
    tidy_check_classes <- gsub("tidy.", "", tidy_check_names)

    for (i in seq_along(tidy_check_names)) {
        class <- tidy_check_classes[[i]]
        s3_register("generics::tidy", class)
    }

    # ----------------------------------------------------------------------------

    if (rlang::is_installed("tune") && utils::packageVersion("tune") >= "0.1.1.9000") {

        req_pkgs_names <- grep("^required_pkgs\\.", names, value = TRUE)
        req_pkgs_classes <- gsub("required_pkgs.", "", req_pkgs_names)

        for (i in seq_along(req_pkgs_names)) {
            class <- req_pkgs_classes[[i]]
            s3_register("tune::required_pkgs", class)
        }
    }

    # ----------------------------------------------------------------------------

    invisible()
}

# vctrs:::s3_register()
s3_register <- function(generic, class, method = NULL) {
    stopifnot(is.character(generic), length(generic) == 1)
    stopifnot(is.character(class), length(class) == 1)

    pieces <- strsplit(generic, "::")[[1]]
    stopifnot(length(pieces) == 2)
    package <- pieces[[1]]
    generic <- pieces[[2]]

    caller <- parent.frame()

    get_method_env <- function() {
        top <- topenv(caller)
        if (isNamespace(top)) {
            asNamespace(environmentName(top))
        } else {
            caller
        }
    }
    get_method <- function(method, env) {
        if (is.null(method)) {
            get(paste0(generic, ".", class), envir = get_method_env())
        } else {
            method
        }
    }

    method_fn <- get_method(method)
    stopifnot(is.function(method_fn))

    # Always register hook in case package is later unloaded & reloaded
    setHook(
        packageEvent(package, "onLoad"),
        function(...) {
            ns <- asNamespace(package)

            # Refresh the method, it might have been updated by `devtools::load_all()`
            method_fn <- get_method(method)

            registerS3method(generic, class, method_fn, envir = ns)
        }
    )

    # Avoid registration failures during loading (pkgload or regular)
    if (!isNamespaceLoaded(package)) {
        return(invisible())
    }

    envir <- asNamespace(package)

    # Only register if generic can be accessed
    if (exists(generic, envir)) {
        registerS3method(generic, class, method_fn, envir = envir)
    }

    invisible()
}
