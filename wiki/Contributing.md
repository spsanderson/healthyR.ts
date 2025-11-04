# Contributing Guide

Thank you for your interest in contributing to **healthyR.ts**! This guide will help you get started.

## Ways to Contribute

### 1. Report Bugs 🐛

Found a bug? Please help us fix it:

1. Check [existing issues](https://github.com/spsanderson/healthyR.ts/issues) to avoid duplicates
2. Create a [new issue](https://github.com/spsanderson/healthyR.ts/issues/new)
3. Include:
   - Clear description of the problem
   - Minimal reproducible example
   - Your R version and package version
   - Error messages (if any)

**Example bug report:**
```markdown
## Bug Description
`ts_auto_arima()` fails when data has missing values in date column

## Reproducible Example
​```r
library(healthyR.ts)

data <- data.frame(
  date = c(as.Date("2020-01-01"), NA, as.Date("2020-01-03")),
  value = c(100, 110, 105)
)

ts_auto_arima(
  .data = data,
  .date_col = date,
  .value_col = value,
  ...
)
#> Error: date column contains NA values
​```

## Environment
- R version: 4.3.0
- healthyR.ts version: 0.3.1
- OS: Windows 10
```

### 2. Suggest Features 💡

Have an idea for improvement?

1. Check [existing feature requests](https://github.com/spsanderson/healthyR.ts/labels/enhancement)
2. Open a new issue with `[Feature Request]` in the title
3. Describe:
   - The problem your feature would solve
   - Your proposed solution
   - Example usage

**Example feature request:**
```markdown
## Feature Description
Add support for multivariate time series forecasting

## Motivation
Many healthcare applications require forecasting multiple correlated variables (e.g., different departments' admissions)

## Proposed Usage
​```r
ts_auto_var(
  .data = multi_var_data,
  .date_col = date,
  .value_cols = c(var1, var2, var3),
  ...
)
​```
```

### 3. Improve Documentation 📖

Documentation improvements are always welcome:

- Fix typos
- Clarify confusing sections
- Add examples
- Improve function documentation
- Write tutorials

### 4. Submit Code 🔧

Ready to contribute code? Great!

## Development Setup

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/healthyR.ts.git
   cd healthyR.ts
   ```

3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/spsanderson/healthyR.ts.git
   ```

### Install Dependencies

```r
# Install devtools
install.packages("devtools")

# Install package dependencies
devtools::install_deps()

# Install suggested packages
devtools::install_dev_deps()
```

### Build the Package

```r
# Load the package
devtools::load_all()

# Build documentation
devtools::document()

# Check the package
devtools::check()
```

## Coding Standards

### Style Guide

Follow the [tidyverse style guide](https://style.tidyverse.org/):

**Good:**
```r
# Use snake_case for functions and variables
calculate_moving_average <- function(data, window_size) {
  # Use <- for assignment
  result <- data %>%
    # Indent with 2 spaces
    mutate(
      ma = slider::slide_dbl(
        value,
        mean,
        .before = window_size - 1
      )
    )
  
  return(result)
}
```

**Bad:**
```r
# Don't use camelCase
calculateMovingAverage <- function(data,windowSize){
result=data%>%mutate(ma=slider::slide_dbl(value,mean,.before=windowSize-1))
return(result)}
```

### Function Structure

```r
#' Function Title
#'
#' @family Category
#'
#' @description
#' One-line description of what the function does.
#'
#' @details
#' Detailed explanation if needed.
#'
#' @param .data The input data (tibble/data.frame)
#' @param .date_col The date column name (unquoted)
#' @param .value_col The value column name (unquoted)
#'
#' @examples
#' library(healthyR.ts)
#' 
#' data <- ts_to_tbl(AirPassengers)
#' 
#' result <- your_function(
#'   .data = data,
#'   .date_col = date_col,
#'   .value_col = value
#' )
#'
#' @return
#' A tibble with the transformed data
#' 
#' @export
#' @rdname your_function

your_function <- function(.data, .date_col, .value_col) {
  # Input validation
  if (!is.data.frame(.data)) {
    rlang::abort(
      message = ".data must be a data frame or tibble",
      use_cli_format = TRUE
    )
  }
  
  # Tidy evaluation
  date_col_var_expr <- rlang::enquo(.date_col)
  value_col_var_expr <- rlang::enquo(.value_col)
  
  # Main logic
  result <- .data %>%
    dplyr::mutate(
      new_col = some_transformation(!!value_col_var_expr)
    )
  
  # Return
  return(result)
}
```

### Naming Conventions

- **Functions**: `ts_*` for time series functions
  - `ts_auto_*` for automated workflows
  - `ts_wfs_*` for workflow sets
  - `*_augment()` for augmentation
  - `*_vec()` for vector operations
  - `*_plot()` / `*_plt()` for plotting
  
- **Variables**: `snake_case`
- **Parameters**: Start with `.` (e.g., `.data`, `.date_col`)
- **Internal functions**: No export, documented with `@keywords internal`

## Testing

### Write Tests

All new functions should have tests:

```r
# tests/testthat/test-your-function.R

test_that("your_function works with basic input", {
  data <- data.frame(
    date = seq.Date(as.Date("2020-01-01"), by = "day", length.out = 100),
    value = rnorm(100)
  )
  
  result <- your_function(
    .data = data,
    .date_col = date,
    .value_col = value
  )
  
  expect_s3_class(result, "tbl_df")
  expect_true("new_col" %in% names(result))
  expect_equal(nrow(result), nrow(data))
})

test_that("your_function handles missing values", {
  data <- data.frame(
    date = seq.Date(as.Date("2020-01-01"), by = "day", length.out = 10),
    value = c(1, 2, NA, 4, 5, NA, 7, 8, 9, 10)
  )
  
  result <- your_function(data, date, value)
  
  expect_true(any(is.na(result$new_col)))
})

test_that("your_function validates inputs", {
  expect_error(
    your_function(.data = "not a dataframe", .date_col = date, .value_col = value),
    ".data must be a data frame"
  )
})
```

### Run Tests

```r
# Run all tests
devtools::test()

# Run specific test file
devtools::test_file("tests/testthat/test-your-function.R")

# Check code coverage
covr::package_coverage()
```

## Pull Request Process

### 1. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### 2. Make Changes

- Write code
- Add tests
- Update documentation
- Check code style

### 3. Commit Changes

Write clear commit messages:

**Good:**
```bash
git commit -m "Add ts_multivariate_forecast() function

- Implement multivariate forecasting
- Add tests for edge cases
- Update documentation
- Closes #123"
```

**Bad:**
```bash
git commit -m "updates"
```

### 4. Update Documentation

```r
# Regenerate documentation
devtools::document()

# Build vignettes (if applicable)
devtools::build_vignettes()
```

### 5. Run Checks

```r
# Run checks
devtools::check()

# Should pass with 0 errors, 0 warnings, 0 notes
```

### 6. Push and Create PR

```bash
# Push to your fork
git push origin feature/your-feature-name
```

Then on GitHub:
1. Navigate to your fork
2. Click "Pull Request"
3. Fill in the template:

```markdown
## Description
Brief description of changes

## Related Issue
Closes #123

## Changes Made
- Added new function `ts_multivariate_forecast()`
- Updated documentation
- Added tests

## Checklist
- [x] Tests pass locally
- [x] Documentation updated
- [x] Code follows style guide
- [x] Added examples
- [x] NEWS.md updated
```

### 7. Respond to Review

- Address reviewer comments
- Push additional commits if needed
- Be patient and respectful

## Development Workflow

### Keep Your Fork Updated

```bash
# Fetch upstream changes
git fetch upstream

# Merge into your main branch
git checkout main
git merge upstream/main

# Update your fork
git push origin main
```

### Working on Multiple Features

```bash
# Always branch from updated main
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feature/new-feature
```

## Code Review Guidelines

When reviewing PRs:

- Be constructive and respectful
- Suggest improvements, don't demand
- Explain reasoning behind suggestions
- Acknowledge good work

**Good review comments:**
```markdown
Nice implementation! One suggestion: consider adding validation for empty data frames.

Suggestion:
​```r
if (nrow(.data) == 0) {
  rlang::abort("Data frame is empty")
}
​```
```

**Bad review comments:**
```markdown
This is wrong. Do it this way instead.
```

## Documentation

### Function Documentation

Use roxygen2 comments:

```r
#' @param .data A data frame or tibble containing the time series data.
#'   Must include at least two columns: one for dates and one for values.
```

### README and Vignettes

- Keep README.md concise
- Use vignettes for detailed tutorials
- Include executable examples

### NEWS.md

Update NEWS.md with your changes:

```markdown
# healthyR.ts (development version)

## New Features
1. Add `ts_multivariate_forecast()` function (#123)

## Bug Fixes
1. Fix issue with missing values in `ts_auto_arima()` (#124)
```

## Package Standards

### Dependencies

- Minimize new dependencies
- Justify any new imports
- Use `Suggests` for optional features

```r
# In DESCRIPTION
Imports:
    dplyr,
    rlang
Suggests:
    testthat,
    knitr
```

### Exported Functions

Only export functions users need:

```r
# Export (user-facing)
#' @export
ts_auto_arima <- function(...) { }

# Don't export (internal)
#' @keywords internal
validate_inputs <- function(...) { }
```

## Communication

### Ask Questions

Don't hesitate to ask:
- Open an issue for clarification
- Comment on PRs
- Email: spsanderson@gmail.com

### Be Patient

- Reviews take time
- Maintainers are volunteers
- Be respectful of their time

## Recognition

All contributors will be:
- Listed in DESCRIPTION file
- Mentioned in release notes
- Appreciated in the community!

## Code of Conduct

Be respectful, inclusive, and professional:

- Welcome newcomers
- Be patient with questions
- Respect differing viewpoints
- Focus on what's best for the project

## Resources

### Learning Resources

- [R Packages Book](https://r-pkgs.org/) by Hadley Wickham
- [Tidyverse Style Guide](https://style.tidyverse.org/)
- [Advanced R](https://adv-r.hadley.nz/)
- [Writing R Extensions](https://cran.r-project.org/doc/manuals/r-release/R-exts.html)

### Related Documentation

- [Package website](https://www.spsanderson.com/healthyR.ts/)
- [Function reference](https://www.spsanderson.com/healthyR.ts/reference/)
- [Vignettes](https://www.spsanderson.com/healthyR.ts/articles/)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to healthyR.ts! 🎉
