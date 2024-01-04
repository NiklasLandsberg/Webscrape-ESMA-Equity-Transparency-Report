# ESMA-Equity-Transparency-Report
The code is to webscrape ESMA's Equity Transparency table based on FIRDS Transparency System (https://registers.esma.europa.eu/publication/searchRegister?core=esma_registers_fitrs_equities).
Given that the table is rendered dynamically, the code utilises Selenium.
As such, the original function is in Python.
Nevertheless, I created an R script using reticulate for non-Python users.

The script needs Google Chrome.
It opens Chrome to load the website to render the table.
Then it webscrapes the table identified with detailParent.
Finally, the website closes it.

Disclaimer: The script is only for equity instruments and only for the YEAR method, yearly calculations.
