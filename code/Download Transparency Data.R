#===============================================================================
# DOWNLOAD TRANSPARENCY DATA FROM ESMA ----------------------------------------=
# Author: Niklas Landsberg ----------------------------------------------------=
#===============================================================================

# ONLY NEEDED IN THE FIRST RUN EVER THAN COMMENT OUT ---------------------------
# Install reticulate package
if (!requireNamespace("reticulate", quietly = TRUE)) {
  install.packages("reticulate")
}

library(reticulate)

install_python(version = '3.11.6')

# Install required Python packages
py_install("selenium")
py_install("pandas")
#-------------------------------------------------------------------------------

# Function to download transparency report
download_transparency_report <- function(isin, year) {
  
  # Download Transparency Report uses reticulate and thus Python.
  # The function is created for R users.
  
  require(reticulate)
  
  # Load the required Python modules
  selenium <- import("selenium")
  pandas <- import("pandas")
  
  # Function body
  url <- paste0("https://registers.esma.europa.eu/publication/details?core=esma_registers_fitrs_equities&docId=", isin, "YEAR", year, "0101000000", year, "1231000000ESMA")
  
  # Set up WebDriver
  driver <- selenium$webdriver$Chrome()
  
  # Open URL
  driver$get(url)
  
  Sys.sleep(3.5)
  
  # Find 'detailsParent'
  table <- driver$find_element("id", "detailsParent")
  
  # Extract data
  rows <- table$find_elements("tag name", "tr")
  
  # Initialize lists
  category <- list()
  values <- list()
  
  # Iterate through rows
  for (row in rows) {
    columns <- row$find_elements("tag name", "td")
    
    if (length(columns) == 2) {
      # Add attribute and value to the respective lists
      category <- c(category, columns[[1]]$text)
      values <- c(values, columns[[2]]$text)
    }
  }

  category <- Reduce("cbind", category)
  
  values <- Reduce("cbind", values)
  
  # Convert to DataFrame
  df <- data.frame(values)
  
  colnames(df) <- category
  
  # Close browser
  driver$quit()
  
  df
}

# Example usage
result <- download_transparency_report("DE0005140008", "2018")

print(result)

#===============================================================================
# END -------------------------------------------------------------------------=
#===============================================================================
