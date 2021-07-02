# We need to talk, about IGF2. 
Abby Beatty, Alexander M Rubin, Haruka Wada, Britt Heidinger, Wendy R. Hood, and Tonia S. Schwartz 

This repository holds all supplemental files for "We need to talk, about IGF2".

## Abstract: 
> "A historical bias exists in the study of the vertebrate Insulin and Insulin-like Signaling (IIS) network. Insulin-like growth factor 1 (IGF1) and 2 (IGF2) are the key hormones regulating the IIS network through binding the Insulin-like Growth Factor 1 Receptor. Humans express both IGF1 and IGF2 as juveniles and adults. Rodent models for biomedical research have provided the wealth of information we currently have on this network; but they lack postnatal IGF2 gene expression. This has led to the physiological effects of IGF2 and its regulation of the IIS network during juvenile and adult stages to be largely ignored in biomedicine. This bias has translated to research in functional ecology, where IGF2 has also been understudied, likely due to the assumption that rodent-like IGF expression patterns exist across vertebrate species. To test this assumption, we quantify the relative liver gene expression of IGF1 and IGF2 across amniote lineages using two approaches: (1) analysis of adult liver RNAseq data from 82 amniote species from NCBI, and (2) qPCR on liver cDNA at embryonic, juvenile and adult stages of six species. Here, we present a cross species comparison that clearly demonstrates that IGF2 is expressed postnatally in nearly all other amniotes tested, contradicting accepted patterns from laboratory rodent models. Additionally, we found that IGF2 is expressed across embryonic, juvenile, and adult mammals, reptiles, and birds - often at higher relative expression compared to IGF1. Additionally, we find evidence of sex-biased adult expression in some species, and that outbred mouse strains lack IGF2 expression consistent with the lab-selected strains across two families. Our results demonstrate that postnatal expression of IGF2 is typical for amniotes, illustrating the need to pivot away from the null hypothesis defined by the laboratory rodents. Further, this study highlights a need for future studies examining the roles of IGF2, alongside IGF1, in mediating variation in growth patterns and other life-history traits."

### Quick Key to File Directory: Detailed Descriptions of file use can be found below.
Analysis| File Type | &nbsp;
-------------------------------------|------------------------------------ | -----------------------------------------------------
RNAseq Data Mining                   |Raw Data                             | [All Samples Analyzed]()
&nbsp;                               |&nbsp;                               | [Raw Data Analysis Output]()
&nbsp;                               |&nbsp;                               | [Cleaned Data](MetaData_Counts_Cleaned.csv)
&nbsp;                               |&nbsp;                               | [Dendrogram for Phylogeny](amniota_2.txt)
&nbsp;                               |Statistical Code                     | [RNAseq Analysis Code]()
IGF Expression Analysis              |Raw Data                             | [IGF Publication Over Time](Timeline_IGFs_pub.csv)
&nbsp;                               |&nbsp;                               | [qPCR IGF Expression Across Species](Species_Combined_edited_2.csv)
&nbsp;                               |&nbsp;                               | [Relative IGF Expression Across Amniotic Tree](datafile3_plotID.csv)
&nbsp;                               |Statistical Code                     | [Statistical Analysis/Visualization Code](CrossSpecGraph_Final.rmd)
&nbsp;                               |RMarkdown Output Files               | [HTML Markdown Output](CrossSpecGraph_Final.html)
&nbsp;                               |&nbsp;                               | [PDF Markdown Output](CrossSpecGraph_Final.pdf)

## Project Summary: 
> This project has two distinct components. The first is a RNAseq analysis across amniotes using publicly available data. The second is a quantitative expression analysis of IGF1 and IGF2 expression in two lizards (the brown anole and eastern fence lizards), two birds (the zebra finch and house sparrow), and two mice (the house mouse and deer mouse) across developmental stages in liver tissue. Relative levels of IGF1 and IGF2 expression are examined across the animote clade in order to further detail IGF1 and IGF2 gene expression patterns across the lifespan in other species  outside  of  laboratory  rodent  models,  and  to  determine  the  overall  prevalence  of IGF2 postnatal expression across the amniote phylogeny.


### RNAseq Data Curration: 

### Statistical Modeling and Data Visualization: 

The statistical analyses were performed in R (version 4.0.3) using the code file titled [Quantitative Analysis R Code] in an R Markdown format. The code output displays all statistical models, results, and figures produced in either [PDF](CrossSpecGraph_Final.pdf) or [HTML](CrossSpecGraph_Final.html) format. Note, you will have to download the HTML file to visualize the data output. 

Examples of required packages, statistical models, and plots used can be seen below. Note: These are generalized examples produced for ease of adaptation. Both  files containing [RNAseq Analysis Code]() and all [Statistical Analysis/Visualization Code](CrossSpecGraph_Final.rmd) contains the specific models used for publication.

```ruby
#Required Packages
library(tidyverse)
library(viridis)
library(Rmisc)
library(ggplot2)
library(nlme)
library(arsenal)
library(janitor)
library(ggforce)
library(ggalt)
library(dplyr)
library(ggalt)
library(ggforce)

#Linear Mixed Models
#Run linear model comparing variable of interest across time, including Content as a random effect variable to account for triplicate replication in qPCR runs.
model=(lme(Dependent_Variable~Independent_Variable, data=dat, na.action=na.omit, random=~1|Content))
#Run an anova output to display F-values and P-values
anova(model)
#Run summary output to obtain Estimates, Confidence Intervals and p-values
summary(model)


#Graph patterns using ggplot2 package
plot=ggplot(data=dat, aes(x=Independent_Variable, y=Dependent_Variable, fill=GeneTarger)) + geom_violin(trim=F, position=dodge, scale="width") + 
 geom_boxplot(width=0.15, position= dodge, outlier.shape = NA, color="black") +
 geom_point(data = Independent_Variable, size =2, shape = 19, color="black", position=position_dodge(width=0.6)) +
 geom_point(position=position_jitterdodge(jitter.width = 0.05, dodge.width = 0.6), size=1, alpha=0.5, aes(group= GeneTarget),   color="white") + 
    theme_bw() +
  xlab('x_IndependentVariable_Title') +
  ylab('y_DependentVariable_Title')
```

## Supplementary Materials: 

Table of RNAseq Samples included in Analysis. The raw file is available for download at link to the left, or in table above.

**INSERT IMAGE**

Image of phylogenetic tree produced from the [Dendrogram for Phylogeny](amniota_2.txt). This image was used to create plot3ID CSV file and produce Figure 1 in BioRender.

<img src="Amniota_tree.jpeg" width="600">



