Elo Convergence
===============

    df12 <- read.csv('../data/with_elo_k12.csv')
    df20 <- read.csv('../data/with_elo_k20.csv')
    df32 <- read.csv('../data/with_elo_k32.csv')

    qplot(df12$elo_P1); qplot(df12$elo_P2)

<img src="elo_fit_files/figure-markdown_strict/elo_dist-1.png" width="250" height="250" /><img src="elo_fit_files/figure-markdown_strict/elo_dist-2.png" width="250" height="250" />

    qplot(df20$elo_P1); qplot(df20$elo_P2)

<img src="elo_fit_files/figure-markdown_strict/elo_dist-3.png" width="250" height="250" /><img src="elo_fit_files/figure-markdown_strict/elo_dist-4.png" width="250" height="250" />

    qplot(df32$elo_P1); qplot(df32$elo_P2)

<img src="elo_fit_files/figure-markdown_strict/elo_dist-5.png" width="250" height="250" /><img src="elo_fit_files/figure-markdown_strict/elo_dist-6.png" width="250" height="250" />

Date QA
=======

    df12 %>% 
      qplot(x = Date, y = id, geom = "boxplot", data = df12)

![](elo_fit_files/figure-markdown_strict/unnamed-chunk-1-1.png)

Objective
=========

To assess the fit of our three elo models qualitatively. By assessing
the individual narratives of some of the more high-profile players in
SC2 in this time period, we can get the following:

1.  Whether those stories match known observations at the time.
2.  Whether a larger/smaller k makes for a better model.
3.  What’s an acceptable burn-in rate to exclude games where elo may not
    be representative of the player’s skill.

<!-- -->

    elo_story <- function(player, df = df12){
      df %>% 
        filter(P1 == player | P2 == player) %>% 
        select(id, P1,P2,elo_P1,elo_P2) %>% 
        mutate(player_score = ifelse(P1 == player, elo_P1, elo_P2)) %>%
        select(id, winner = P1, loser = P2, elo = player_score)
    }

    add_time_mark <- function(plot, pos, label, y = 950){
      plot +
        geom_vline(xintercept = pos) + 
        geom_text(x = pos + 800, y = y, label = label, angle = 90) + 
        coord_cartesian(ylim = c(y - 50, 1500))
    }

    tournament_search <- function(search_term, data = df12){
      data %>%
        filter(grepl(search_term, tolower(League))) %>%
        group_by(League) %>%
        summarise(first_game = min(id), last_game = max(id), start_date = min(Date), end_date = max(Date)) %>% 
        arrange(first_game)
    }

    best_elo <- function(df = df12) {
      getmode <- function(v) {
       uniqv <- unique(v)
       uniqv[which.max(tabulate(match(v, uniqv)))]
      }
      
      df %>% 
        {rbind(
            select(., player = P1, elo = elo_P1, race = Race_P1)
          , select(., player = P2, elo = elo_P2, race = Race_P2)
        )} %>% 
        group_by(player) %>% 
        summarise(max = max(elo), min = min(elo), most_played = getmode(race), count = n()) %>% 
        arrange(desc(max)) %>% as.data.frame
    }

IdrA’s Story
------------

    elo_story('600_IdrA') %>% qplot(x = id, y = elo, data = .) %>% 
      add_time_mark(849, "MLG Raliegh 2010") %>%
      add_time_mark(8598, "GSL Code S 2010") %>%
      add_time_mark(17425, "MLG Dallas 2011") %>%
      add_time_mark(36470, "MLG Raleigh 2011") %>%
      add_time_mark(40192, "IEM Guangzhou 2011") %>%
      add_time_mark(49987, "GSL Code S 2012") %>%
      add_time_mark(71768, "ASUS GSP Pro 2012")

![](elo_fit_files/figure-markdown_strict/idra_story-1.png)

    elo_story('600_IdrA', df20) %>% qplot(x = id, y = elo, data = .)

![](elo_fit_files/figure-markdown_strict/idra_story-2.png)

    elo_story('600_IdrA', df32) %>% qplot(x = id, y = elo, data = .)

![](elo_fit_files/figure-markdown_strict/idra_story-3.png)

IdrA is perhaps one of the most wildly popular and controversial SC2
players, and I included him in the QA sample because the narratives
around his performance suggest swings in behavior that our model should
pick up on. And indeed it does.

Our data set starts the day after the SC2 release, with the Go4SC2 Cup,
and quickly moves into the 2010 MLG tournament. Idra did very well
initially, taking first place in MLG 2010 and securing an offer with the
Evil Geniuses, a North American Starcraft 2 team.

By summer 2011, however, IdrA starts showing more moderated performance,
with some disappointing tournament results combined with a string of
games that IdrA conceded, despite having advantageous positions. There’s
a brief uptick in Fall 2011, but by Jan 2012 IdrA begins a period known
as “the long slump”.

The elo model captures this long slump period well, showing IdrA
dropping almost 200 points betweeen Winter and Summer 2012. IdrA does
manage to rebound ~125 points after his low mark, but unfortunately our
data set ends there, so we can’t comment further on his recovery.

Our goal here is to ensure that the elo model follows the narrative arc
of the player sufficiently, and IdrA has a dynamic story to tell over
those two years which the model captures quite nicely. However, we must
take care to not place too much interpretive weight on the model scores
themselves at this point. Because if SC2 was imbalanced against Zerg, we
might expect that bias to get baked into elo over time. The narrative
around IdrA still regards him as one of the greatest Zerg players of all
time, at a time where not many players used Zerg in tournament play.
Thus, in trying to tease out balance issues in the game, IdrA serves a
uniquely important role.

(Maybe look into Nestea here too)

Note, Idra’s story really captures the “long slump” well I think
[](https://liquipedia.net/starcraft2/IdrA)

Stephano’s Story
----------------

    elo_story('1996_Stephano') %>% qplot(x = id, y = elo, data = .) %>%
      add_time_mark(17425, "MLG Dallas 2011") %>%
      add_time_mark(28459, "ESWC France 2011") %>%
      add_time_mark(35275, "IEM VI Cologne 2011") %>%
      add_time_mark(41932, "ESWC France Finals 2011") %>%
      add_time_mark(47480, "Blizzard Cup 2011") %>%
      add_time_mark(49626, "eOSL Winter 2012") %>%
      add_time_mark(58402, "Lone Star Clash 2012") %>%
      add_time_mark(76359, "MLG Summer 2012")

![](elo_fit_files/figure-markdown_strict/stephano_story-1.png)

Stephano doesn’t have a reliable tournament presence prior to 2011. This
is possibly because he started playing Starcraft under the handle Sat.
Unfortunately, this set doesn’t include games from that handle.

Stephano’s presence in the tournament scene seems to be marked by a
slow, steady climb to top-tier play. By July 2011, Stephano had placed
1st in the Master Series, and by Oct 2011 he would go on and win the
ESWC against MarineKing and MaNa.

In November 2011, Stephano has a disappointing run in the Battle of
Berlin, Dreamhack, and the Blizzard Cup. The model captures this run
nicely, and Stephano quickly rebounds shortly after.

By March 2012, Stephano has reached his prime.

Stephano could be an interesting contrast to IdrA. But the key objection
to contrasting him to IdrA is that you’re comparing a largely French
player to an American one. Those talent pools may be different, and thus
their elos not comparable. In order to use Stephano as a contrast we
need to demonstrate that his elo gives good expectations regarding his
tournament wins/losses.

Here’s an idea - create a data set of before/after games just after a
balance change. Among all players of a specific race, does average elo
go up or down?

MarineKing’s Story
------------------

    elo_story('959_MarineKing') %>% qplot(x = id, y = elo, data = .) %>% 
      add_time_mark(3731, "GSL S2 2010") %>%
      add_time_mark(8598, "GSL Code S 2011") %>%
      add_time_mark(21707, "GSL Up 2011") %>%
      add_time_mark(33671, "GSL Code A 2011") %>%
      add_time_mark(41730, "GSL Up Oct 2011")

![](elo_fit_files/figure-markdown_strict/mk_story-1.png)

    elo_story('959_MarineKing', df20) %>% qplot(x = id, y = elo, data = .)

![](elo_fit_files/figure-markdown_strict/mk_story-2.png)

    elo_story('959_MarineKing', df32) %>% qplot(x = id, y = elo, data = .)

![](elo_fit_files/figure-markdown_strict/mk_story-3.png)

Made himself famous at GSL S2 with marine split stimming and 2-rax.

Dec. 7, 2010, Blizzard puts him on a top 200 list.

Mvp’s Story
-----------

    elo_story('590_Mvp') %>% qplot(x = id, y = elo, data = .)

![](elo_fit_files/figure-markdown_strict/mvp_story-1.png)

    elo_story('590_Mvp', df20) %>% qplot(x = id, y = elo, data = .)

![](elo_fit_files/figure-markdown_strict/mvp_story-2.png)

    elo_story('590_Mvp', df32) %>% qplot(x = id, y = elo, data = .)

![](elo_fit_files/figure-markdown_strict/mvp_story-3.png)

Life’s
------

    elo_story('2747_Life') %>% qplot(x = id, y = elo, data = .)

![](elo_fit_files/figure-markdown_strict/life_story-1.png)

    elo_story('2747_Life', df20) %>% qplot(x = id, y = elo, data = .)

![](elo_fit_files/figure-markdown_strict/life_story-2.png)

    elo_story('2747_Life', df32) %>% qplot(x = id, y = elo, data = .)

![](elo_fit_files/figure-markdown_strict/life_story-3.png)

hG’s Story
----------

    elo_story('1736_hG') %>% qplot(x = id, y = elo, data = .)

![](elo_fit_files/figure-markdown_strict/hg_story-1.png)

    df32 %>% 
      group_by(P1) %>% 
      summarise(high_score = max(elo_P1)) %>% arrange(desc(high_score)) %>% 
      head(20)

    ## # A tibble: 20 x 2
    ##    P1             high_score
    ##    <fct>               <dbl>
    ##  1 1849_TaeJa          1569.
    ##  2 969_Squirtle        1551.
    ##  3 959_MarineKing      1545.
    ##  4 1979_jjakji         1534.
    ##  5 1971_Leenock        1526.
    ##  6 590_Mvp             1515.
    ##  7 640_MC              1512.
    ##  8 2627_DongRaeGu      1508.
    ##  9 1856_Polt           1501.
    ## 10 1771_Nerchio        1501.
    ## 11 2747_Life           1497.
    ## 12 1996_Stephano       1489.
    ## 13 1988_aLive          1481.
    ## 14 2321_Seed           1481.
    ## 15 665_MMA             1479.
    ## 16 2838_Creator        1478.
    ## 17 662_Symbol          1478.
    ## 18 2306_Alicia         1466.
    ## 19 2092_Monster        1463.
    ## 20 2322_PartinG        1454.
