svg(filename="chess.svg", width=8, height=5, pointsize=10, bg="black")

par(bg = "black")
par(fg="#999999")
par(mar=c(1, 3, 2, 8))

data <- read.csv("chess.csv", head=FALSE)

player1 = as.vector(t(data[1]))
player2 = as.vector(t(data[3]))
result = as.vector(t(data[2]))

numEntries = length(result)

players = sort(union(player1, player2))
numPlayers = length(players)

template = rep.int(1600, numEntries+1)
scores = data.frame(template)
for (name in players){
	scores[,name] <- template
}

K = 32

for (i in 2:(numEntries+1)){
	p1 = player1[i-1]
	r1 = 10 ^ (scores[i-1, p1] / 400)
	
	p2 = player2[i-1]
	r2 = 10 ^ (scores[i-1, p2] / 400)
	
	# Expected scores
	e1 = r1 / (r1 + r2)
	e2 = r2 / (r1 + r2)
	
	if (result[i-1] == "win"){
		s1 = 1
		s2 = 0
	} else {
		s1 = 0.5
		s2 = 0.5
	}
	
	for (j in i:(numEntries+1)){
		scores[j, p1] = scores[j, p1] + K * (s1 - e1)
		scores[j, p2] = scores[j, p2] + K * (s2 - e2)
	}
}

# Remove leading 1600s from new players
scores[1,"Timothy"]
for (player in players){
    for (i in 1:(numEntries-1)){
        if (scores[i, player] == 1600 && scores[i+1, player] == 1600)
            scores[i,player] = NA
    }
}

lowest = 1600
highest = 1600
for (name in players) {
        tempScores = scores[name]
        tempScores[is.na(tempScores)] = 1600
        lowest = min(lowest, min(tempScores[name]))
        highest = max(highest, max(tempScores[name]))
}

plot(
	NULL,
	xlim=c(1, numEntries+1),
	ylim=c(lowest, highest),
	ylab="",
	xlab="",
	col.lab="#999999", col.main="#999999", col.axis="#999999",
	xaxt='n'
)

library("RColorBrewer")
colors = brewer.pal(max(3, length(players)), "Set1")

i = 0
for (name in players){
	i = i + 1
	lines(
		x=1:(numEntries+1),
		y=t(scores[name]),
		col=colors[i]
	)
	
	#xData = 1:(numEntries+1)
	#yData = (apply(scores[name], 1, function(x) x))
	#lo = loess(yData~xData)
	#xl <- seq(1, numEntries+1, 0.1)
	#lines(xl, predict(lo, xl), col=colors[i])
	
	currentScore = scores[numEntries+1, name]
	roundedScore = round(currentScore, 0)
	label = paste(roundedScore, " ", name)
	axis(
		4,
		at=c(currentScore),
		labels=c(label),
		col=colors[i], col.ticks=colors[i], col.axis = colors[i],
		las=2
	)
}

#legend("topleft", legend=players, fill=colors, bg="black")
