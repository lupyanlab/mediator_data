library(tidyverse)
library(here)
root_path <- here()
processed_data_path <- paste(root_path,"nameability_data","processed_data",sep="/")

name_filter <- read.csv(paste(processed_data_path,"mediator_nameability_filtered.csv",sep="/"))
name_filter_correct <- read.csv(paste(processed_data_path,"mediator_nameability_filtered_correct.csv",sep="/"))

name_all <- bind_rows(name_filter,name_filter_correct)

#plot distribution
ggplot(name_all,aes(simpson_diversity,fill=trials))+
  geom_histogram()+
  geom_density(aes(fill=NULL))+
  facet_wrap(~trials)
ggsave("figures/histogram_mediator_name_allvscorrect.jpg")

#pivot
name_all_wide <- name_all %>%
  pivot_wider(
    names_from = trials,
    values_from = number_responses:modal_response
  )

#write wide data
write.csv(name_all_wide ,"processed_data/mediator_nameability.csv",row.names=F)

#plot correlation - all trials vs. correct only
ggplot(name_all_wide,aes(simpson_diversity_all_trials,simpson_diversity_correct_only))+
  geom_point(size=2)+
  geom_smooth(method="lm")

ggsave("figures/mediator_name_correlation_allvscorrect.jpg")
