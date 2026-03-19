#' ---
#' title: Time Series Week NNN
#' author: You
#' date: Today
#' ---

# 1. R Scratchpad ------------------------------------------------------------
#   You will only write in R Markdown for code and results
#   that are more or less finalised.
#   In the meantime, you can use this R scratchpad.
#   Delete all this text and write your own code
#   Don't forget to add explanatory comments
#   And to separate out different bits with headings or
#   subheadings

# 2. Use Sectioning ----------------------------------------------------------
#   Comment lines start with #, they are not read by R
#   If you end comment lines with space and four minus signs -
#   they will be interpreted as section headings.
#   You can add more - to visually separate sections.
#   CTRL+SHIFT+R / ⌘+SHIFT+R creates a new section and adds the hyphens.
#
#   These sections are accessible in
#     - the drop-down list on the bottom left of the scripting area,
#       ALT+SHIFT+J / ⌘+SHIFT+J brings it up
#   and
#     - the outline section on the top-right corner of the scripting area
#       CTRL+SHIFT+O / ⌘+SHIFT+O brings it up

## 2.1 Subsection -----------------------------------
#   You can also have subsections
#   RStudio does not treat them differently from sections
#   but if you add a extra #, number or spaces they will look
#   different in the outline section.
#   This makes it easier to navigate your R file
#   I use less hyphens for subsections to help visually

### 2.1.1 Subsection -------------------
#   And sub-subsections,...

# 3. Folding sections -----------------------------------------------------
#   You can fold sections by clicking on the little grey down-arrow on the left
#   of the section heading. Or hitting ALT+L/⌘+ALT+L
#   This is useful to hide sections you are not working on
#   SHIFT+ALT+L / ⌘+SHIFT+⌥+L unfolds the section
#   ALT+O / ⌘+⌥+O folds all sections
#   SHIFT+ALT+O / ⌘+SHIFT+⌥+O unfolds all sections

# 4. Etiquette ------------------------------------------------------------
#   It is a good idea (valued in any business environment) to have a certain
#   etiquette when writing code (or anything else really).
#   For instance, I write a blank line before a section heading and not after
#   You can choose your own style, but be consistent, and have the least
#   amount of random variations in your style as possible.

install.packages("readxl")
library(readxl)
# load data
data_raw <- read_excel("CPI-UK.xlsx")
# rename columns
colnames(data_raw) <- c("ds", "y")
# convert date
data_raw$ds <- as.Date(data_raw$ds)
# make sure y is numeric
data_raw$y <- as.numeric(data_raw$y)
# remove missing values (just in case)
data_clean <- na.omit(data_raw)
# check
head(data_clean)
str(data_clean)


plot(data_clean$ds, data_clean$y, type = "l",main = "UK CPI over Time",xlab = "Date",ylab = "CPI")

library(prophet)
model <- prophet(data_clean)
future <- make_future_dataframe(model, periods = 24, freq = "month")
forecast <- predict(model, future)
plot(model, forecast)
prophet_plot_components(model, forecast)


train <- data_clean[1:700, ]
test <- data_clean[701:nrow(data_clean), ]
model_train <- prophet(train)
future_train <- make_future_dataframe(model_train, periods = nrow(test), freq = "month")
forecast_train <- predict(model_train, future_train)
plot(model_train, forecast_train)
