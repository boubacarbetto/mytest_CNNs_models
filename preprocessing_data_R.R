df <- read.csv("House_Price.csv", header=TRUE)
# gives what kind of data 
str(df)

summary(df)
hist(df$crime_rate)
pairs(~price+crime_rate+n_hot_rooms+rainfall, data=df)

barplot(table(df$airport))
barplot(table(df$waterbody))
barplot(table(df$bus_ter))

# outliers
quantile(df$n_hot_rooms, 0.99)
uv = 3*quantile(df$n_hot_rooms, 0.99)
df$n_hot_rooms[df$n_hot_rooms > uv] <- uv

summary(df$n_hot_rooms)

lv = 0.3*quantile(df$rainfall, 0.01)
df$rainfall[df$rainfall<lv] <- lv
summary(df$rainfall)


### Missing Values
mean(df$n_hos_beds)
mean(df$n_hos_beds, na.rm =TRUE)
which(is.na(df$n_hos_beds))
df$n_hos_beds[is.na(df$n_hos_beds)] <- mean(df$n_hos_beds, na.rm = TRUE)

summary(df$n_hos_beds)
which(is.na(df$n_hos_beds))

# Transformation

pairs(~price+crime_rate, data=df)
plot(df$price,df$crime_rate)

df$crime_rate=log(1+df$crime_rate)

df$avg_dist = (df$dist1+df$dist2+df$dist3+df$dist4)/4
df2 <- df[,-7:-10]
df <- df2
rm(df2)

df <-df[,-14]

### Dummy variables

install.packages("dummy")

df <- dummy(df)
df <- df[,-1]


# Test Train Split
install.packages("caTools")

set.seed(0)
split = sample.split(df, SplitRatio = 0.8)
training_set = subset(df, split ==TRUE)
test_set = subset(df, split == FALSE)

lm_a = lm(price ~ ., training_set)
 # lm(price~., data=training_set)
train_a = predict(lm_a, training_set)
test_a = predict(lm_a, test_set)

mean((training_set$price-train_a)^2)
mean((test_set$price-test_a)^2)

