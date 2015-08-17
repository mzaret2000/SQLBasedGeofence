data <- read.csv(file.choose(), header=FALSE)
data <- as.vector(data$V1)
data
size <- length(data)
data[(size+1)] <- ""
size <- length(data)

countX <- function(char,s) {
  chr.pos <- which(unlist(strsplit(s,NULL)) == char)
  chr.count <- length(chr.pos)
  return(chr.count)
}

countPrev <- -1
countCurr <- 0
new_data <- numeric()

for (i in 1:size) {
  countCurr = countX("|",data[i])
  if (countCurr > countPrev) {
    new_data[i] <- paste("case when", data[i])}
  else {
    new_data[i] <- paste("when", data[i])}

  if (length(grep(": Bronx", data[i])) == 1) {
    fence =
    new_data[i] <- sub(":.*$", "", new_data[i])
    new_data[i] <- paste(new_data[i], "then 'Bronx'")
  }
  if (length(grep(": Kings", data[i])) == 1) {
    new_data[i] <- sub(":.*$", "", new_data[i])
    new_data[i] <- paste(new_data[i], "then 'Kings'")
  }
  if (length(grep(": Nassau", data[i])) == 1) {
    new_data[i] <- sub(":.*$", "", new_data[i])
    new_data[i] <- paste(new_data[i], "then 'Nassau'")
  }
  if (length(grep(": New York", data[i])) == 1) {
    new_data[i] <- sub(":.*$", "", new_data[i])
    new_data[i] <- paste(new_data[i], "then 'New York'")
  }
  if (length(grep(": Orange", data[i])) == 1) {
    new_data[i] <- sub(":.*$", "", new_data[i])
    new_data[i] <- paste(new_data[i], "then 'Orange'")
  }
  if (length(grep(": Queens", data[i])) == 1) {
    new_data[i] <- sub(":.*$", "", new_data[i])
    new_data[i] <- paste(new_data[i], "then 'Queens'")
  }
  if (length(grep(": Richmond", data[i])) == 1) {
    new_data[i] <- sub(":.*$", "", new_data[i])
    new_data[i] <- paste(new_data[i], "then 'Richmond'")
  }
  if (length(grep(": Rockland", data[i])) == 1) {
    new_data[i] <- sub(":.*$", "", new_data[i])
    new_data[i] <- paste(new_data[i], "then 'Rockland'")
  }
  if (length(grep(": Suffolk", data[i])) == 1) {
    new_data[i] <- sub(":.*$", "", new_data[i])
    new_data[i] <- paste(new_data[i], "then 'Suffolk'")
  }
  if (length(grep(": Westchester", data[i])) == 1) {
    new_data[i] <- sub(":.*$", "", new_data[i])
    new_data[i] <- paste(new_data[i], "then 'Westchester'")
  }
  if (length(grep(": Other", data[i])) == 1) {
    new_data[i] <- sub(":.*$", "", new_data[i])
    new_data[i] <- paste(new_data[i], "then 'Other'")
  }
  if (length(grep(":", data[i])) == 0) {
    new_data[i] <- paste(new_data[i], "then")
  }
  if (countCurr < countPrev) {
    stops <- countPrev - countCurr
    stops <- rep("end", stops)
    stops <- paste(stops,collapse=" ")
    new_data[i] <- paste(stops,new_data[i])
  }
  countPrev <- countCurr
  new_data[i] <- gsub("[|]","",new_data[i])
  new_data[i] <- gsub("geofence[$]combo", "request_lat*request_lng",new_data[i])
  if (i == size) {
    new_data[i] <- gsub("(when|then)","",new_data[i])
    new_data[i] <- paste(new_data[i],"end")
  }
  print(new_data[i])
}
