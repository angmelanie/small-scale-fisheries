# Question 1: 

# What are the projected impacts on catches of small-scale fisheries within the region/EEZs?
# AKA how does catch amount change in the future between Alaska, Canada, USA and Mexico?

# Let's work within each EEZ - find total catch by year within each EEZ
# change path for RCP scenarios and EEZ

# specify path, generate list of files to loop through
path <- "C:/Users/angmel/Documents/firstchapter/SAU_DBEM_RESULTS/Alaska/GFDL26/avg/"
filename <- dir(path)
filepath <- paste("C:/Users/angmel/Documents/firstchapter/SAU_DBEM_RESULTS/Alaska/GFDL26/avg/", filename, sep = "")

# AGGREGATE TOTAL - FOR LOOP
# create empty list for aggregation
datalist <- list()

# loop through each .csv file in folder and sum by year
for (i in 1:length(filepath)){

# upload average years
avg_catch <- read.csv(filepath[i])

# rename columns, remove X
colnames(avg_catch) <- c("cellID", 2000:2051)

# this still maintains cellID info
p <- avg_catch %>% 
  gather(year, catch, -c(cellID), na.rm=TRUE) %>% 
  dplyr::select(.,year, catch) %>% 
  group_by(year) %>% 
  summarize(year_total = sum(catch))

datalist[[i]] <- p # attaches each csv file as a new list
}

# bind all the list together
mydata <- dplyr::bind_rows(datalist)

# Aggregate all species within EEZ by year
# Repeat this for each RCP scenario for each EEZ!
# Canada 8.5
Canada85 <- mydata %>% 
  group_by(year) %>% 
  summarize(year_total = sum(year_total)) %>% 
  rename(Canada85 = year_total)
write.csv(Canada85, "C:/Users/angmel/Documents/firstchapter/SAU_DBEM_RESULTS/AGGREGATE/Canada85")

#Canada 2.6
Canada26 <- mydata %>% 
  group_by(year) %>% 
  summarize(year_total = sum(year_total)) %>% 
  rename(Canada26 = year_total)
write.csv(Canada26, "C:/Users/angmel/Documents/firstchapter/SAU_DBEM_RESULTS/AGGREGATE/Canada26")

#Alaska85
Alaska85 <- mydata %>% 
  group_by(year) %>% 
  summarize(year_total = sum(year_total)) %>% 
  rename(Alaska85 = year_total)
write.csv(Alaska85, "C:/Users/angmel/Documents/firstchapter/SAU_DBEM_RESULTS/AGGREGATE/Alaska85")

#Alaska26
Alaska26 <- mydata %>% 
  group_by(year) %>% 
  summarize(year_total = sum(year_total)) %>% 
  rename(Alaska26 = year_total)
write.csv(Alaska26, "C:/Users/angmel/Documents/firstchapter/SAU_DBEM_RESULTS/AGGREGATE/Alaska26")

#USA85
USA85 <- mydata %>% 
  group_by(year) %>% 
  summarize(year_total = sum(year_total)) %>% 
  rename(USA85 = year_total)
write.csv(USA85, "C:/Users/angmel/Documents/firstchapter/SAU_DBEM_RESULTS/AGGREGATE/USA85")

#USA26
USA26 <- mydata %>% 
  group_by(year) %>% 
  summarize(year_total = sum(year_total)) %>% 
  rename(USA26 = year_total)
write.csv(USA26, "C:/Users/angmel/Documents/firstchapter/SAU_DBEM_RESULTS/AGGREGATE/USA26")

#Mexico26
Mexico26 <- mydata %>% 
  group_by(year) %>% 
  summarize(year_total = sum(year_total)) %>% 
  rename(Mexico26 = year_total)
write.csv(Mexico26, "C:/Users/angmel/Documents/firstchapter/SAU_DBEM_RESULTS/AGGREGATE/Mexico26")

Mexico26 %>% 
  ggplot(aes(x=year, y=Mexico26)) +
  geom_point()

#Mexico85
Mexico85 <- mydata %>% 
  group_by(year) %>% 
  summarize(year_total = sum(year_total)) %>% 
  rename(Mexico85 = year_total)
write.csv(Mexico85, "C:/Users/angmel/Documents/firstchapter/SAU_DBEM_RESULTS/AGGREGATE/Mexico85")

# join all data into one massive PNA dataframe
PNAcatch <- Canada85 %>% 
  full_join(Canada26, by = "year") %>% 
  full_join(Alaska85, by = "year") %>% 
  full_join(Alaska26, by = "year") %>% 
  full_join(USA85, by = "year") %>% 
  full_join(USA26, by = "year") %>% 
  full_join(Mexico26, by = "year") %>% 
  full_join(Mexico85, by = "year") 

PNAcatch_long <- PNAcatch %>% 
  gather(scenario, catch, -c(year)) 

# plot it! altogether
plotme <- PNAcatch_long %>% 
  ggplot(aes(x=year, y=catch)) +
  geom_point(aes(colour=scenario)) +
  theme_bw() +
  labs(title = "BY EEZ - Projection of a sample of small-scale fisheries catches in PNA") +
  theme(axis.text.x = element_text(angle = 90)) +
  scale_y_continuous(labels = scales::comma) + #get rid of sci notation with scales::comma
  scale_x_discrete(breaks = c("2000", "2010", "2020", "2030", "2040", "2050"))
  
ggsave("catch-by-eez.png", path = "C:/Users/angmel/Documents/firstchapter/SAU_DBEM_RESULTS/AGGREGATE/")


# lets do between eez for RCP85 scenario
EEZ_RCP85 <- Canada85 %>% 
  full_join(Alaska85, by = "year") %>% 
  full_join(USA85, by = "year") %>% 
  full_join(Mexico85, by = "year") %>% 
  gather(scenario, catch, -c(year)) %>% 
  ggplot(aes(x=year, y=catch)) +
  geom_point(aes(colour = scenario))