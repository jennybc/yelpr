
<!-- README.md is generated from README.Rmd. Please edit that file -->
ryelp
=====

The goal of ryelp is to ... *MAYBE CALL [YELP FUSION API V3](https://www.yelp.ca/developers) ONE DAY*? In the meantime, check out the brute force example below. This repo created just to get a STAT 545 student unstuck and then I got intrigued.

Installation
------------

You can install ryelp from github with:

``` r
# install.packages("devtools")
devtools::install_github("jennybc/ryelp")
```

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
## basic example code
```

Brute force
-----------

Example of working with [Yelp Fusion API](https://www.yelp.ca/developers) from first principles (vs really exploiting [httr](https://github.com/hadley/httr)).

``` r
library(httr)
library(purrr)

res <- POST("https://api.yelp.com/oauth2/token",
            body = list(grant_type = "client_credentials",
                        client_id = Sys.getenv("YELP_ID"),
                        client_secret = Sys.getenv("YELP_SECRET")))
token <- content(res)$access_token

yelp <- "https://api.yelp.com"
term <- "coffee"
location <- "Vancouver, BC"
limit <- 3
(url <-
    modify_url(yelp, path = c("v3", "businesses", "search"),
               query = list(term = term, location = location, limit = limit)))
#> [1] "https://api.yelp.com/v3/businesses/search?term=coffee&location=Vancouver%2C%20BC&limit=3"
res <- GET(url, add_headers('Authorization' = paste("bearer", token)))
http_status(res)
#> $category
#> [1] "Success"
#> 
#> $reason
#> [1] "OK"
#> 
#> $message
#> [1] "Success: (200) OK"
ct <- content(res)
ct$businesses %>% 
  map_df(`[`, c("name", "phone"))
#> # A tibble: 3 × 2
#>                          name        phone
#>                         <chr>        <chr>
#> 1                    Revolver +16045584444
#> 2 Timbertrain Coffee Roasters +16049159188
#> 3        49th Parallel Coffee +16048724901
```

The httr way
------------

See [httr.R](https://github.com/jennybc/yelpr/blob/master/httr.R).
