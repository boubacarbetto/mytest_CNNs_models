2 + 5
#demo comment
print("Hello world R")

x <-2
y = c(1,2,3,4,5,6)
y <-1:10
x<-y<-1:5
x+y
z=x+y
z2 <-z*y
ls()
X<-10
rm(x)
rm(list=ls())

browseURL("http://cran.r-project.org/web/views")

install.packages("LiblineaR")
library()
search()
require(LiblineaR)
detach("package:LiblineaR", unload = TRUE)
remove.packages("LiblineaR")

? ggplot2
data()

library(help="datasets")
? iris
str(iris)
iris
data("iris")
x3 <- seq(5,50, by=5)
x4<-scan()
path <- "/Users/apple/Udemy_works/Artificial_Neural_Networks_with_Py_and_R/Product.txt"
Product <- read.table("/Users/apple/Udemy_works/Artificial_Neural_Networks_with_Py_and_R/Product.txt",header = TRUE, sep = "\t")
str(Product)

Customer <-read.csv("/Users/apple/Udemy_works/Artificial_Neural_Networks_with_Py_and_R/Customer.csv",header = TRUE)
Customer
View(Customer)

y <- table(Customer$Region)
y
View(y)
barplot(y)
barplot(y[order(-y)])
barplot(y[order(y)],horiz=TRUE)
barplot(y[order(y)],horiz=TRUE,col=c("red","blue","green","grey"), border = NA)

barplot(y[order(y)],horiz=TRUE,col=c("red","blue","green","grey"), border = NA,main = "Freq of Regions")
barplot(y[order(y)],horiz=TRUE,col=c("red","blue","green","grey"), border = NA,main = "Freq of Regions", xlab = "Number of Customers")

png(filename = "/Users/apple/Udemy_works/Artificial_Neural_Networks_with_Py_and_R/freq.png", width = 888, height = 571)
barplot(y[order(y)],horiz=TRUE,col=c("red","blue","green","grey"), border = NA,main = "Freq of Regions", xlab = "Number of Customers")
dev.off()

hist(Customer$Age)
hist(Customer$Age, breaks = 5)
hist(Customer$Age, breaks = c(0,40,60,100), freq = TRUE)

hist(Customer$Age, breaks = c(0,40,60,100),col = "blue",main = "Histogram of Age")
