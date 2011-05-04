data<-read.table("performance-data-latency", header=T, sep="\t")
files<-data$files
initial<-data$initial
subsequent<-data$subsequent
d<-rbind(initial, subsequent)
colors<-c("darkgray", "white")
postscript(file="images/performance-latency.eps", onefile=T, horizontal=FALSE)
barplot(d, main="Backup & Initial Startup Times for Differing Numbers of Files
on a Latent Low-Bandwidth Network", ylab="Time taken (s)", xlab="Number of files", beside=TRUE, names.arg=files, cex.names=0.9, col=colors)
legend("topleft", inset=0.05, rownames(d), fill=colors)
dev.off()
