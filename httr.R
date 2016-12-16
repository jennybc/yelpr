## now posted here
## https://github.com/hadley/httr/issues/384#issuecomment-267540991
## it appears there's an OAuth2 flow httr doesn't currently support
## Client Credentials Grant
## https://tools.ietf.org/html/rfc6749#section-4.4

## brute force

library(httr)

res <- POST("https://api.yelp.com/oauth2/token",
            body = list(grant_type = "client_credentials",
                        client_id = Sys.getenv("YELP_ID"),
                        client_secret = Sys.getenv("YELP_SECRET")))
token <- content(res)$access_token
(url <-
    modify_url("https://api.yelp.com", path = c("v3", "businesses", "search"),
               query = list(term = "coffee",
                            location = "Vancouver, BC", limit = 3)))
res <- GET(url, add_headers('Authorization' = paste("bearer", token)))
http_status(res)
ct <- content(res)
sapply(ct$businesses, function(x) x[c("name", "phone")])

## moving towards the 'httr way'

library(httr)

yelp_app <- oauth_app("yelp", key = Sys.getenv("YELP_ID"),
                      secret = Sys.getenv("YELP_SECRET"))
## API docs offer nothing useful about what to put here?
## I would love to NOT give an `authorize` argument
## but oauth_endpoint() requires it
yelp_endpoint <-
  oauth_endpoint(NULL,
                 authorize = "https://api.yelp.com/oauth2/token",
                 access = "https://api.yelp.com/oauth2/token")
## just enter anything for the authorization code
token <- oauth2.0_token(yelp_endpoint, yelp_app,
                        user_params = list(grant_type = "client_credentials"),
                        use_oob = TRUE)
res2 <- GET(url, config(token = token))
http_status(res2)
ct2 <- content(res2)
sapply(ct2$businesses, function(x) x[c("name", "phone")])

