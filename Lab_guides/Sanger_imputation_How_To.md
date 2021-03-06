## Preimputation steps

Read the [Sanger How-to page](https://imputation.sanger.ac.uk/?instructions=1#prepareyourdata) to make sure your vcf file meets all the requirements for Sanger imputation. 

The preimputation steps for UMichigan and Sanger are relatively similar. The main difference is that VCF files are not split by chromosome under sanger imputation.  I recommend carrying out the [Michigan preimputation steps](https://github.com/WheelerLab/Prostate-Cancer-Study/blob/master/10_MICHIGANIMP_AA.md) anyways. If you have already carried out the preimputation steps for U Mich imputation then the only other requirement will be to merge the chr.vcf files into one vcf file and sort the result.

```
#merge vcf files from list of files
bcftools concat --file-list ~/preimputation/vcf_list.txt -o merged.vcf
gzip merged.vcf
#or merge files sequentially
bcftools concat chr1.vcf.gz chr2.vcf.gz ... chrX.vcf.gz -o merged.vcf
gzip merged.vcf
#sort vcf file
vcf-sort ~/preimputation/merged.vcf.gz |  bgzip -c > merged_sorted.vcf.gz
```

## Upload through Globus

Read the following or read the [Sanger How-to page](https://imputation.sanger.ac.uk/?instructions=1#uploadyourdata)

Uploading to the Sanger Imputation server requires the user to install and set-up globus on their machine. This is viable as long as the user has access to the files from their machine, even through SFTP. Once Globus is set up, one can add new folders to extract from/write to. Open the globus options menu and in the bottom right side there should be a small square with a plus (+) on it. click this and select the folder containing your genotype files. Once this is set up it is possible to upload files and begin imputation.

To upload files once Globus has been installed, submit a job through the sanger home page. You will shortly after receive an email with a link to your globus transfer. Click this, login, and on the right side of the page select the file you wish to submit for imputation. Select the blue arrow pointing left. You should receive another email containing a link from the imputation server. Click this link and then click confirm and your imputation will begin. Keep an eye out over the next few days for an email from globus, as this will tell you the final status of your imputation.

## troubleshooting problems

Read the [Sanger How-to page](https://imputation.sanger.ac.uk/?instructions=1#prepareyourdata). If your imputation fails often the most common problems are met by not meeting the preimputation requirements.

Check the [Sanger Resources page](https://imputation.sanger.ac.uk/?resources=1) for various solutions to common problems.

**Basic check**
Allelic swaps betweent the reference and the alternate allele was a problem I in particular faced. Here is how I fixed it
```
##Check how the vcf file compares to a reference file. See below for reference file link
bcftools norm --check-ref w -f ~/Data/human_g1k_v37.fasta.gz ~/preimputation/merged_sorted.vcf.gz -Ou -o /dev/null
##Now fix the file to match the reference
bcftools +fixref ~/preimputation/merged_sorted.vcf.gz -o ~/preimputation/merged_sorted.vcf.gz -- -d -f ~/Data/human_g1k_v37.fasta.gz -i ~/preimputation/All_20170710.vcf.gz
```
[Download reference file](https://bit.ly/2M28YNz) 

[ALL file download](https://bit.ly/2YrHAiS)
## Extracting Dosages

You may notice that the sanger imputation does not contain the R2 or MAF scores that U Mich imputation provides. In place of R2 it is recommended that users filter by the INFO metric. This score is generated by the IMPUTE2 algorithm used by Sanger. From the [IMPUTE2 website](https://mathgen.stats.ox.ac.uk/impute/output_file_options.html#info_metric_details) The INFO metric is similar in many respects to the R2 statistic and can be used as a basis for filtering. As for the MAF score, this can be calculated using the `fill-tags` plugin of bcftools.

```
bcftools +fill-tags 1.vcf.gz -o 1_withMAF.vcf -- -t MAF
gzip 1_withMAF.vcf
```
From there you can filter based on the INFO statistic using the dosage_extract.py script as found in the [QTPipe](https://github.com/WheelerLab/QTPipe/blob/master/codes/filtering/dosage_extract.py). Please be aware that this script handles the impute2 INFO metric the same as the R2 statistic. It is up to user discretion to filter by different thrsholds for these two statistics.
