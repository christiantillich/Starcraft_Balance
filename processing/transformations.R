get_raw_data <- function(path = "C://Users/Christian Tillich/Documents/GitHub/Starcraft_Balance/data/raw.txt"){
  read.csv(path, header = FALSE, stringsAsFactors = FALSE) %>% 
    `colnames<-`(c("Date","Leage","Map","P1","Race_P1","P2","Race_P2")) %>%
    mutate(id = as.integer(rownames(.)))
}


elo_init <- function(){ 
  .Elo <<- new.env(parent = .GlobalEnv)
  .Elo$scores <- get_raw_data() %>% 
    {c(as.character(.$P1), as.character(.$P2))} %>% 
    unique %>% 
    {`names<-`(rep(1000, length(.)), .)}
}

get_elo <- function(){
  .Elo$scores
}

#Add an update elo function here
update_elo <- function(player, elo){
  .Elo$scores[player] <- elo
}

score_single_game <- function(k, P1, P2, id){
  #Remember here that we should choose k to minimize auto-correlation
  #P1 here is always the winner, this is consistent with the data formatting. 
  prior <- get_elo()[c(P1,P2)] %>% 
    {data.frame(player = names(.), elo = ., stringsAsFactors = FALSE)} %>%
    mutate(r = 10^(elo/400), exp = r / sum(r))
  
  update <- prior %>%
    mutate(
        winner = as.integer(player == P1)
      , r_prime = r + k*(winner - exp)
      , elo_prime = 400*log10(r_prime)
    )
  
  update %>% filter(player == P1) %>% {update_elo(.$player, .$elo_prime)}
  update %>% filter(player == P2) %>% {update_elo(.$player, .$elo_prime)}
  
  cbind(
     id
    ,update %>% filter(player == P1) %>% select(elo_P1 = elo, exp_P1 = exp)
    ,update %>% filter(player == P2) %>% select(elo_P2 = elo, exp_P2 = exp)
  )
} 

score_all_games <- function(df, k = 32){
  elo_init()
  
  df %>% 
    arrange(desc(id)) %>% 
    {mapply(score_single_game, 32, .$P1, .$P2, .$id, SIMPLIFY = FALSE)} %>% 
    bind_rows() %>% 
    {merge(df, ., by = "id")} 
}



