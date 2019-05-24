####lift weights for model liftover
library(argparse)
library(dplyr)
library(data.table)

parser <- ArgumentParser()
parser$add_argument("-o", "--out", help="as plink out - prefix of output optionaly including path information", type="character",default="./cpos_hg38_weights")
parser$add_argument("-w","--weights", help="weights file from elastic net")
parser$add_argument("-d","--dict", help="file containing dictionary translation for rsids to cpos")
args <- parser$parse_args()

"%&%" = function(a,b) paste(a,b,sep="")

##cfread stands for check fread
cfread<-function(file_name, head = T){
  zipped<-grepl(".gz$",file_name)
  if(zipped == T){
    file<-fread('zcat ' %&% file_name, header = head, showProgress = T)
    return(file)
  } else{
    file<-fread(file_name, header = head, showProgress = T)
    return(file)
  }
}

weights <- cfread(args$weights, head = F)
colnames(weights)<-c("gene","rsid","hg19varid","refallele","altallele","beta")
dict <- cfread(args$dict, head = F)
colnames(dict)<-c("chr","pos1","pos2","rsid","hg19varid","hg38cpos","hg38varid")

final<-inner_join(weights, dict, by = c("rsid","hg19varid")) %>% select(gene,hg38cpos,hg38varid,refallele,altallele,beta)
fwrite(final,args$out %&% ".txt", sep = '\t',col.names = F, quote = F, row.names = F)
