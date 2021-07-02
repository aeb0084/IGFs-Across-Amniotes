# We need to talk, about IGF2. 
Abby Beatty, Alexander M Rubin, Haruka Wada, Britt Heidinger, Wendy R. Hood, and Tonia S. Schwartz 

This repository holds all supplemental files for "We need to talk, about IGF2".

## Abstract: 
"A historical bias exists in the study of the vertebrate Insulin and Insulin-like Signaling (IIS) network. Insulin-like growth factor 1 (IGF1) and 2 (IGF2) are the key hormones regulating the IIS network through binding the Insulin-like Growth Factor 1 Receptor. Humans express both IGF1 and IGF2 as juveniles and adults. Rodent models for biomedical research have provided the wealth of information we currently have on this network; but they lack postnatal IGF2 gene expression. This has led to the physiological effects of IGF2 and its regulation of the IIS network during juvenile and adult stages to be largely ignored in biomedicine. This bias has translated to research in functional ecology, where IGF2 has also been understudied, likely due to the assumption that rodent-like IGF expression patterns exist across vertebrate species. To test this assumption, we quantify the relative liver gene expression of IGF1 and IGF2 across amniote lineages using two approaches: (1) analysis of adult liver RNAseq data from 82 amniote species from NCBI, and (2) qPCR on liver cDNA at embryonic, juvenile and adult stages of six species. Here, we present a cross species comparison that clearly demonstrates that IGF2 is expressed postnatally in nearly all other amniotes tested, contradicting accepted patterns from laboratory rodent models. Additionally, we found that IGF2 is expressed across embryonic, juvenile, and adult mammals, reptiles, and birds - often at higher relative expression compared to IGF1. Additionally, we find evidence of sex-biased adult expression in some species, and that outbred mouse strains lack IGF2 expression consistent with the lab-selected strains across two families. Our results demonstrate that postnatal expression of IGF2 is typical for amniotes, illustrating the need to pivot away from the null hypothesis defined by the laboratory rodents. Further, this study highlights a need for future studies examining the roles of IGF2, alongside IGF1, in mediating variation in growth patterns and other life-history traits."

### Quick Key to File Directory: Detailed Descriptions of file use can be found below.
Analysis| File Type | &nbsp;
-------------------------------------|------------------------------------ | -----------------------------------------------------
RNAseq Data Mining                   |Raw Data                             | [Raw Data]()
&nbsp;                               |&nbsp;                               | [Cleaned Data](MetaData_Counts_Cleaned.csv)
&nbsp;                               |&nbsp;                               | [Dendrogram for Phylogeny](amniota_2.txt)
&nbsp;                               |Statistical Code                     | [RNAseq Analysis Code]()
IGF Expression Analysis              |Raw Data                             | [IGF Publication Over Time](Timeline_IGFs_pub.csv)
                                     |&nbsp;                               | [qPCR IGF Expression Across Species](Species_Combined_edited_2.csv)
                                     |&nbsp;                               | [Relative IGF Expression Across Amniotic Tree](datafile3_plotID.csv)
                                     |Statistical Code                     | [Quantitative Analysis R Code](CrossSpecGraph_Final.rmd)
                                     |RMarkdown Output Files               | [HTML Markdown Output](CrossSpecGraph_Final.html)
                                     |&nbsp;                               | [PDF Markdown Output](CrossSpecGraph_Final.pdf)
                                     


## Statistical Modeling and Data: 

The statistical analyses were performed in R (version 3.5.1) using [downloadable code](Regneration_publication.code.final.Rmd) in an R Markdown format. [Code output](Regneration_publication.code.final.html) displays all statistical models, results, and figures produced. Note, you will have to download the HTML file to visualize the data output. 

Examples of required packages, statistical models, and plots used can be seen below. Note: These are generalized examples produced for ease of adaptation. [Downloadable code](Regneration_publication.code.final.Rmd) contains the specific models used for publication, and the output can be found in the [Code output](Regneration_publication.code.final.html).

```ruby
#Required Packages
library(multcomp)
library(ggplot2)
library(nlme)
library(grid)
library(Rmisc)
library(gridExtra)
library(emmeans)
library(cowplot)

#Linear Mixed Models
#Run linear model comparing variable of interest across time including Maternal ID as a random effect variable
model=(lme(Dependent_Variable~Independent_Variable, data=dat, na.action=na.omit, random=~1|MaternalID))
#Run an anova output to display F-values and P-values
anova(model)

#Run EmMeans package to get pairwise comparisons of Independent Variables (Times or Treatments)
model.em=emmeans(model, list(pairwise ~ Independent_Variable), adjust = "tukey")
#Report adjusted means and P-values
model.em
#Report confidence intervals from EmMeans model
confint(model.em)

#Graph patterns using ggplot2 package
plot=ggplot(data=dat, aes(x=Independent_Variable, y=Dependent_Variable, fill=Independent_Variable)) + geom_violin(trim=F) + 
geom_boxplot(width=0.2, color="black") + geom_point (position=dodge, shape=1) + scale_fill_manual(values= c('gray62','darkslategray', 'darkseagreen2')) +
  xlab('x_IndependentVariable_Title') +
  ylab('y_DependentVariable_Title')
```

## Supplementary Figures: 
<img src="SFig1_Github.png" width="700">
<img src="SFig2_Github.png" width="500">
<img src="SFig3_Github2.png" width="450">
<img src="SFig4_Github.png" width="700">
<img src="STable1_Github.png" width="600">
