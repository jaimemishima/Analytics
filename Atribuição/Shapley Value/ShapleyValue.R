install.packages("dplyr")
install.packages("GameTheoryAllocation")
library('dplyr')

# Developed by Trevor Paulsen
# Reference: http://datafeedtoolbox.com/attribution-theory-the-two-best-models-for-algorithmic-marketing-attribution-implemented-in-apache-spark-and-r/

setwd("~/R/Scripts/ChannelAtributtion")
base <- read.csv("input_refactored.csv") 

colnames(base)[colnames(base)=="ï..visitor_id"] <- "visitor_id"

data_feed_tbl = base %>%
  group_by(visitor_id) %>%
  arrange(hit_time_gmt) %>%
  mutate(order_seq = ifelse(conversion > 0, 1, NA)) %>%
  mutate(order_seq = lag(cumsum(ifelse(is.na(order_seq), 0, order_seq)))) %>%
  mutate(order_seq = ifelse((row_number() == 1) & (conversion > 0), 
                            -1, ifelse(row_number() == 1, 0, order_seq))) %>% 
  ungroup()


# Summarizing Order Sequences
seq_summaries = data_feed_tbl %>%
  group_by(visitor_id, order_seq) %>%
  summarize(
    email_touches = max(ifelse(mid_campaign == "Email",1,0)),
    natural_search_touches = max(ifelse(mid_campaign == "Natural_Search",1,0)),
    affiliate_touches = max(ifelse(mid_campaign == "Affiliates",1,0)),
    paid_search_touches = max(ifelse(mid_campaign == "Paid_Search",1,0)),
    display_touches = max(ifelse(mid_campaign == "Display",1,0)),
    social_touches = max(ifelse(mid_campaign == "Social_Media",1,0)),
    conversions = sum(conversion)
  ) %>% ungroup()


# Sum up the number of sequences and conversions
# for each combination of marketing channels
conv_rates = seq_summaries %>%
  group_by(email_touches,
           natural_search_touches,
           affiliate_touches,
           paid_search_touches,
           display_touches,
           social_touches) %>%
  summarize(
    conversions = sum(conversions),
    total_sequences = n()
  ) %>% collect()


library(GameTheoryAllocation)

number_of_channels = 6

# The coalitions function is a handy function from the GameTheoryALlocation
# library that creates a binary matrix to which you can fit your
# characteristic function (more on this in a bit) 
touch_combos = as.data.frame(coalitions(number_of_channels)$Binary)
names(touch_combos) = c("Email","Natural_Search","Affiliates",
                        "Paid_Search","Display","Social_Media")

# Now I'll join my previous summary results with the binary matrix
# the GameTheoryAllocation library built for me.
touch_combo_conv_rate = left_join(touch_combos, conv_rates, 
                                  by = c(
                                    "Email"="email_touches",
                                    "Natural_Search" = "natural_search_touches",
                                    "Affiliates" = "affiliate_touches",
                                    "Paid_Search" = "paid_search_touches",
                                    "Display" = "display_touches",
                                    "Social_Media" = "social_touches"
                                  )
)

# Finally, I'll fill in any NAs with 0
touch_combo_conv_rate = touch_combo_conv_rate %>%
  mutate_all(funs(ifelse(is.na(.),0,.))) %>%
  mutate(
    conv_rate = ifelse(total_sequences > 0, conversions/total_sequences, 0)
  )


# Building Shapley Values for each channel combination

shap_vals = as.data.frame(coalitions(number_of_channels)$Binary)
names(shap_vals) = c("Email","Natural_Search","Affiliates",
                     "Paid_Search","Display","Social_Media")
coalition_mat = shap_vals
shap_vals[2^number_of_channels,] = Shapley_value(touch_combo_conv_rate$conv_rate, game="profit")

for(i in 2:(2^number_of_channels-1)){
  if(sum(coalition_mat[i,]) == 1){
    shap_vals[i,which(shap_vals[i,]==1)] = touch_combo_conv_rate[i,"conv_rate"]
  }else if(sum(coalition_mat[i,]) > 1){
    if(sum(coalition_mat[i,]) < number_of_channels){
      channels_of_interest = which(coalition_mat[i,] == 1)
      char_func = data.frame(rates = touch_combo_conv_rate[1,"conv_rate"])
      for(j in 2:i){
        if(sum(coalition_mat[j,channels_of_interest])>0 & 
           sum(coalition_mat[j,-channels_of_interest])==0)
          char_func = rbind(char_func,touch_combo_conv_rate[j,"conv_rate"])
      }
      shap_vals[i,channels_of_interest] = 
        Shapley_value(char_func$rates, game="profit")
    }
  }
}


# Apply Shapley Values as attribution weighting
order_distribution = shap_vals * touch_combo_conv_rate$total_sequences
shapley_value_orders = t(t(round(colSums(order_distribution))))
shapley_value_orders = data.frame(mid_campaign = row.names(shapley_value_orders), 
                                  orders = as.numeric(shapley_value_orders))
