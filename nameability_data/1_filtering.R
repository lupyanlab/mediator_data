library(tidyverse)
library(here)
root_path <- here()
data_path <- paste(root_path,"nameability_data","data",sep="/")
processed_data_path <- paste(root_path,"nameability_data","processed_data",sep="/")

d <- read.csv(paste(data_path,"all_data_anonymized.csv",sep="/"))

#inspect data values
unique(d$mediator_response)
sum(is.na(d$mediator_response))
sum(d$mediator_response=="idk",na.rm=T)
unique(d$stimulus)

#strip NA and idk responses
d_filter <- d %>%
  filter(!is.na(mediator_response)) %>%
  filter(mediator_response!="idk") %>%
  filter(isRight %in% c(0,1)) %>%
  mutate(isRight=as.numeric(as.character(isRight)))

d_filter_correct <- d_filter %>%
  filter(isRight==1)

#summarize accuracy
summary_accuracy <- d_filter %>%
  group_by(stimulus) %>%
  summarize(N=n(),num_correct=sum(isRight),accuracy=mean(isRight))

#write data
write.csv(d_filter,paste(processed_data_path,"mediator_data_filtered.csv",sep="/"),row.names=F)
write.csv(d_filter_correct,paste(processed_data_path,"mediator_data_filtered_correct.csv",sep="/"),row.names=F)
