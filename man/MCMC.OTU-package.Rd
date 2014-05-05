\name{MCMC.OTU-package}
\alias{MCMC.OTU-package}
\alias{MCMC.OTU}
\docType{package}
\title{
Bayesian analysis of metabarcoding counts data
}
\description{
This package implements generalized linear mixed model analysis of metabarcoding counts data using MCMC. By default, it is assumed that variation in total counts per sample reflects sequencing effort and is not biologically relevant. The results are summarized and plotted using ggplot2 functions.
}
\details{
\tabular{ll}{
Package: \tab MCMC.OTU\cr
Type: \tab Package\cr
Version: \tab 1.0.8\cr
Date: \tab 2014-04-27\cr
License: \tab GPL-3\cr
}
At the moment, the package handles experimental design with a single multilevel
fixed factor or two fully crossed multilevel fixed factors. Any number of scalar (OTU-specific)
random factors (i.e. blocking factors) are allowed. See example below. 

See help for the core function mcmc.otu() for more details. 
}
\author{
Mikhail V. Matz <matz@utexas.edu>
}
\references{
Elizabeth A. Green, Sarah W. Davies, Mikhail V. Matz, Monica Medina Next-generation sequencing reveals cryptic Symbiodinium diversity within Orbicella faveolata and Orbicella franksi at the Flower Garden Banks, Gulf of Mexico. PeerJ 2014 https://peerj.com/preprints/246/ 
}
\examples{

# Symbiodinium sp diversity in two coral species at two reefs (banks)
data(green.data)

# removing outliers
goods=purgeOutliers(
	data=green.data,
	count.columns=c(4:length(green.data[1,])),
	zero.cut=0.25 # remove this line for real analysis
)

# stacking the data table
gs=otuStack(
	data=goods,
	count.columns=c(4:length(goods[1,])),
	condition.columns=c(1:3)
	)

# fitting the model
mm=mcmc.otu(
	fixed="bank+species+bank:species",
	data=gs,
	nitt=3000,burnin=2000 # remove this line for real analysis!
	)

# selecting the OTUs that were modeled reliably
acpass=otuByAutocorr(mm,gs)

# calculating effect sizes and p-values:
ss=OTUsummary(mm,gs,summ.plot=FALSE)

# correcting for mutliple comparisons (FDR)
ss=padjustOTU(ss)

# getting significatly changing OTUs (FDR<0.05)
sigs=signifOTU(ss)

# plotting them
ss2=OTUsummary(mm,gs,otus=sigs)

# bar-whiskers graph of relative changes:
# ssr=OTUsummary(mm,gs,otus=signifOTU(ss),relative=TRUE)

# displaying effect sizes and p-values for significant OTUs
ss$otuWise[sigs]

}
