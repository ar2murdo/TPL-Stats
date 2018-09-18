# script to read all passes/events from a season of TUC parity league games

# necessary packages
library(dplyr)
library(jsonlite)

# example of loading data from one team in one game (every team/game combo has a unique url)
# data <- read_json("http://tuc-tpl.herokuapp.com/gameEvents/34830/6916", simplifyVector = TRUE)

# now, load all teams, all games from the whole season
# Fall 2016: 473 - this one has different formatting
# Winter 2017: 493
# Fall 2017: 530
# Winter 2018: 538
season <- 538

game_listing <- read_json(paste0("http://tuc-tpl.herokuapp.com/games/", season), simplifyVector = TRUE)

for (i in 1:nrow(game_listing)) {
  # load two additional stats files (one for each team playing)
  # some games didn't have any stats tracked
  home1 <- read_json(paste0("http://tuc-tpl.herokuapp.com/gameEvents/", game_listing$id[i], "/", game_listing$homeTeamId[i]), simplifyVector = TRUE)
  if(class(home1) == "data.frame") {
    home1$player_name <- home1$player$playerName
    home1$player_gender <- home1$player$gender
    home1 <- select(home1,-player)
  }
  
  away1 <- read_json(paste0("http://tuc-tpl.herokuapp.com/gameEvents/", game_listing$id[i], "/", game_listing$awayTeamId[i]), simplifyVector = TRUE)
  if(class(away1) == "data.frame") {
    away1$player_name <- away1$player$playerName
    away1$player_gender <- away1$player$gender
    away1 <- select(away1,-player)
  }

  if (i == 1) {
    # rbind two tables with master sheet
    all_results <- rbind(home1, away1)
  } else {
    if(class(home1) == "data.frame") {
      all_results <- rbind(all_results, home1)
    }
    if(class(away1) == "data.frame") {
      all_results <- rbind(all_results, away1)
    }
  }
}


# now, make tables of all events by gender
# table(all_results$player_gender, all_results$eventType)


