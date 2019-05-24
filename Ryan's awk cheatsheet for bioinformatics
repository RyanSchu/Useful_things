## About Awk

Awk is a text processing language that comes standard with most distributions of Linux/Unix. In my personal experience, awk is faster at parsing, filtering, and writing text files than either python or R with few exceptions. This cheat sheet goes over the basic awk commands that I use the most. 

### How does awk work

Awk processes a text file line by line and is used to apply some condition to each based on its contents. I have found the most use for it on text files of large matrices (that is text files with distinct, consistent columns) or on text that has clear consistent delimeters. Awk interpretes each column in your line and stores it as a variable from 1 to n where n is the number of columns you have. Say you have a file that looks as such:
```
ID  gene_name type  start stop Chr
ENSG0  C1orf22 protein_coding 178965  183312 chr2
ENSG4  C22orf25 pseudogene  60000 70000 chr12
```
By default, awk will automatically interpret any whitespace as a delimeter. That means we have three lines here with three columns each. We can do any number of things to this data now.
lets run awk on this data. Awk follows the syntax:

```
awk [optional flags] '{[code you'd like to execute]}' [text file to execute on]
### for this example data
awk '{print $1 "\t" $2 "\t" $3}' example_data
```
will print the first second and third columns in tab seperated format to the standard out 
```
##Output
ID  gene_name type
ENSG0  C1orf22 protein_coding 
ENSG4  C22orf25 pseudogene 
```

## The good stuff
here are all the funtions that I find most useful

### print everything, not just specific columns
```
awk '{print $0}' example_data
```

### reorder columns
This is fairly straightforward, just write the columns in whatever order you want
```
awk '{print $1 "\t" $3 "\t" $2}' example_data
##prints first then third then second column
```

### awk redirection (split whole genome file based on chr)
awk has a handy redirection feature that interprets and redirects the contents of each line of a file independently of one another and can append them different files. This is really useful if you have a combined whole genome file and you need to make 22 individual files.

```
### example data
ID  gene_name type  start stop Chr
ENSG0  C1orf22 protein_coding 178965  183312 chr2
ENSG4  C22orf25 pseudogene  60000 70000 chr12
###  split this data based on the contents of the chr column
awk '{print $0 >> $6 ".txt"}' example_data
```
This will actually create 3 files named `Chr.txt`,`chr2.txt`, and `chr12.txt` as awk does not handle the header any differently than the rest of the file. An easy work around is to create 22 files before hand that contain the header information and set the redirection to append (`>>`) rather than overwrite (`>`).


### filtering based on column content
Awk supports if else statements and the common conditional statements ( !=, >, <=, ==, etc.)
```
awk '{if ($4 < 90000) print $0}' example_data
## prints the 3rd line
```
Please be aware when using this if your file has a header. Awk compares strings and numbers lexicall. Depending on your boolean operation this may or may not print your header, which may or may not be desirable. Usually to avoid this I print the header to your output file file first, then use tail to pipe the rest of the file to awk like so
```
head -n 1 file > out
tail -n +2 file | awk '{if ($4 < 90000) print $0}' >> out
```
### gsub ( adding or removing "chr" to your files)
to remove chr from your column(s) you can use awk gsub which follows this syntax `gsub("string_to_remove","string_to_rplace_with",column_to_replace_within)`
```
awk '{gsub("chr","",$0); print $0}' example_data
```
will remove the chrs from the entire line of a file. Please be aware when using gsub with such a large scope as it may remove items you wish to keep (for example header info). gsub default does exact case match so in our example_data it is not an issue.

adding chr to a column is simple. Rather than using gsub we take advantage of how awk concatonates lines in its print statement. basically just put "chr" before the column you want to have it in.
```
awk '{print "chr" $6 }' example_data
```
### split a string in awk
splits a delimited string into an array. This is useful for processing VarID's and any snp_IDs that are in c:pos format.
`split($1, array,"delimeter"` splits the string in column 1 into an array named array based on the delimeter. Arrays indices in awk start at 1.

```
##example data
1_178938_A_G_b37
2_465468_T_C_b37
awk '{split($1,a,"_"); print a[1] "\t" a[5]}' example_data

##resultant output
1 b37
2 b37
```

### passing variables to awk

awk does not inherently work well with shell variables. Instead users need to pass those variables to the awk interpreter using the `-v` flag which takes as its first argument a comma separated list of variable_name=value pairs. So for example if you have the shell variables NAME=josh BIRTHDAY=tomorrow you can pass them to awk as such.

```
NAME=josh 
BIRTHDAY=tomorrow
awk -v var1=$NAME,var2=$BIRTHDAY '{print var1 "\t" var2}' example_data

###output
>josh  tomorrow
```
