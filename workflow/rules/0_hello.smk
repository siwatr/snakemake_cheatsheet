# Here is the simplest structure of rules for Snakemake
# We need the output and the execution (in this case, shell) parts

rule hello_world:
    output: "results/0_hello/hello.txt" # Will be relative path to the location where the script is run
    shell:
        """
        echo "Hello, world!" > {output}
        """

# The `{output}` here is referreing to the name of output file specified in the rule

# /////////////////////////////////////////////////////////////////////////////////////////////////
# EXERCISE
# /////////////////////////////////////////////////////////////////////////////////////////////////
# Set up:
# make a new folder called `workflow_ex/rules`, for rules files for this exercise
# In resouce/fastq folder you will find fastq files

# Task:
# Making a simple rule(s) for running FastQC on these files
