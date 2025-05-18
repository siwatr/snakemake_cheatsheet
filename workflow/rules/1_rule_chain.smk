# --------------------------------------------------------
# Rule Chain
# --------------------------------------------------------

rule hello:
    output: "results/1_rule_chain/hello_0.txt" # Will be relative path to the location where the script is run
    shell:
        """
        echo "Hello!" > {output}
        """

# Specifying that we need output generated from rule 'hello'
rule hello_hello:
    input: "results/1_rule_chain/hello_0.txt"
    output: "results/1_rule_chain/hello_1.txt"
    shell:
        """
        echo "$(cat {input}), its me. " > {output}
        """

# Rule dependency
# Use the syntax 'rules.<rule_name>.output' to refer to the output of a rule
rule hello_hello_hello:
    input: rules.hello_hello.output
    output: 
        txt = "results/1_rule_chain/hello_2.txt", # Can be referred to as {output.all} or {output[0]}
    shell:
        """
        echo "$(cat {input}), I was wondering if after all these years you'd like to meet ..." > {output.txt}
        """
# Named output:
# if the output has a name, we can refer to it by name, i.e., {output.<name>}, or by index i.e., {output[0]}, in the shell command

# --------------------------------------------------------
# Temporary output
# --------------------------------------------------------

rule other_side:
    # By marking the output as temporary file, it will be created but removed after all downstream rules that use it are done
    output: temp("results/1_rule_chain/other_side.txt") 
    shell:
        """
        echo "Hello from the other side!" > {output}
        """

# --------------------------------------------------------
# Multiple inputs
# --------------------------------------------------------

rule hello_final:
    input: 
        hello = rules.hello_hello_hello.output.txt, # if the output from the upstream rule have name, we can also specify here 'rules.<rule_name>.output.<name>'
        other_side = rules.other_side.output, 
    output: "results/1_rule_chain/hello_final.txt"
    shell:
        """
        printf "$(cat {input.hello})\n$(cat {input.other_side})\n" > {output}
        """
# Similar to the case of output, it can be referred by name in the execution part of the rule.


# /////////////////////////////////////////////////////////////////////////////////////////////////
# EXERCISE
# /////////////////////////////////////////////////////////////////////////////////////////////////
# Task:
# Set up rules that run
# 0) making bowtie2 index from the reference genome (resouce/ref_genome/chr1.fa.gz)
# 1) trim_galore on the input fastq files (from resource/fastq/test_R*.fastq.gz)
# 2) using the outputs from step 0 and 1, run bowtie2 mapping.
