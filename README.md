# Objective 

The goal of this project is to provide an objective, quantitative assessment of the balance of the game Starcraft 2 for the first two years after it's release. 

# Background

Starcraft 2 is a computer game, and was a long-awaited sequel of the original Starcraft. The original Starcraft enjoyed a decade-long reign as *the* single best-balanced real time strategy game, and as a result it was the go-to game for competitive tournaments. And while Starcraft wasn't the first computer game to develop a competitive scene, by the early 2000s it was one of the most prominent. In fact it was the only real-time strategy game played competitively - other competitive titles were overwhelmingly first-person shooters. 

[[Add more background here about SC2, the early controversies around balance, etc. Probably just copy stuff from the paper.]]

Originally, the work here was performed for an introductory class on logistic regression, as a response to [this paper](https://arxiv.org/abs/1105.0755v1). Both Hyokun and I were in agreement that using player and map as separate categorical features was fairly cumbersome, and that a better approach was to build an ELO model to rank players with so as to control for player skill. So in my original class project (circa 2013) I performed a balance assessment with elo score as the main variable to control for player skill. I also ignored map effects entirely. 

The work here is best seen as a continuation and response to that class project. Now knowing more about non-linear, tree-based modeling methods, I think there's some opportunity to revisit map effects, and in particular map-race interactions. The latter would be too tricky to model effectively with linear methods without inserting a substantial amount of a priori knowledge. In addition, I lost some of the original work used to build my elo model (it was originally a very cumbersome VBA script). So this assessment has the following outline. 

1. Reconstruct the elo model. Do at least a quick assessment of k choices while we're at it. 
2. Do some qualitative analysis of the elo model as a whole. Does it fit well? Does it tell sensible stories about the individual players?
3. Perform the regression. Was there a prominent global balance issue between the three races? If I can get to it, were there localized periods of heavy imbalance? 
4. Perform the regression using non-linear approaches. Do non-linear models give roughly the same balance estimates? Add back in map as a categorical predictor. At similar skill levels, does the model predict favorable outcomes for certain race matchups and not others? Does that match narratives at the time?





