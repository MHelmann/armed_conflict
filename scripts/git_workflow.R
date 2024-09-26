install.packages("usethis")
library(usethis) 

usethis::use_git_config(user.name = "My Name", user.email = "myemail@email.com")

# to confirm, generate a git situation-report, your user name and email should appear under Git config (global)
usethis::git_sitrep()