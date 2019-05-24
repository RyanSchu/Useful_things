# GWAS QC
Each and every gwas is different so there is no perfect standard of how to run GWAS. However many of the steps we must take are predictable. Most commonly, we find ourselves filtering by missingness, removing related individuals and removing snps that are in linkage disequilibrium with each other. Finally, we usually want to run PCA on our population to validate that they have been adequately filtered. This pipeline combines these general steps and more into three coherent scripts to easily perform gwas qc.

# Running the Pipeline
The pipeline is broken into three scripts main scripts that performs one of the steps mentioned above. Each has a handful of options and produces multiple output files for the user. I would encourage you to look at the project [wiki](https://github.com/WheelerLab/gwasqc_pipeline/wiki) and get an understanding of what each option does and what files are produced. While the pipeline produces predicatble results, it is largely up to the user to give direction and decide on what outputs from each script are useful for your particular GWAS. For every file set produced there will be a log file containing details on how that file was produced. Don't be afraid to dive into the plink [documentation](https://www.cog-genomics.org/plink2) if you don't understand what a file is.

## Test Data
For this example we will be using some bfiles produced by Peter. These are files he created by performing some additional preprocessing that the pipeline does not perform yet. These files can be found at `/home/peter/AA_nonGAIN_SCZ/QCSteps/QCStep0/NoHH` on wheeler lab 3. The files look like `QCStep0NoHH.bed/.bim/.fam` Please copy this to your directory or simply make note of their location. Additioanlly please find a summary stats file at `/home/peter/AA_GAIN_SCZ/summarystatistics.txt`

## 01MissingnessFiltering
This script performs missingness filtering for the user as well as hardy weinburg filtering. For validation, the pipeline produces two sets of plots. The first, call rate distributions,  one should see the peak at 1.0 virtually disappear after filtering. The second set, based on HWE statistics, should look relatively similar, however one should see that either the scale decreases or the peak at 0.0 decreases. This is because the pipeline is set to remove serious genotyping errors, which result HWE stats with absurdly low p values.

Which files from this do we want to use as input for our next steps? (If there are multiple candidates don't be afraid to run them all)

## 02RelatednessFiltering
This script is engineered to perform relatedness filtering. The script produces two plots that may be of interest to the user. 1) There is an identity by descent plot that may be useful for determining the overall relatedness of the population. By default this script does not perform relatedness filtering unless specified, instead performing LD pruning alone. 2) This script produces a plot of heterozygosity as well as a list of individuals who are considered outliers in terms of this.

Which files from this do we want to use as input for our next steps? (If there are multiple candidates don't be afraid to run them all)
Are there any samples we want to remove? How would we do so?
Do our snp ids need to be translated in any way? How could we do such a thing?

## 03HapmapMerge
This script is engineered to merge our plink files with hapmap data for pca analysis. The purpose of this is to introduce reference populations to our data set, that, when pca analyzed, will show the ethnic stratification of our test data. This will produce a pdf file pca_plots.pdf within the PCA folder of our output. Don't worry if it looks wonky the first couple times you run this, I've made plenty of mistakes running PCA. 

Please see the file `/home/ryan/example_wrapper` for a complete example of how to run on this data set
