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

# Alternatively, use this syntax to specify which rule does the input come from
rule hello_hello_hello:
    input: rules.hello_hello.output
    output: 
        "results/1_rule_chain/hello_2_0.txt",    # Can be referred to as {output[1]}
        All = "results/1_rule_chain/hello_2.txt", # Can be referred to as {output.all} or {output[0]}
    shell:
        """
        echo "$(cat {input}), I was wondering if after all these years you'd like to meet ..." > {output.All}
        echo "I was wondering if after all these years you'd like to meet ..." > {output[0]}
        """

# --------------------------------------------------------
# Temporary output
# --------------------------------------------------------

rule other_side:
    # By marking the output as temporary file, it will be created but removed after all downstream rules that use it are done
    output: temp("results/1_rule_chain/hello_3.txt") 
    shell:
        """
        echo "Hello from the other side!" > {output}
        """

# --------------------------------------------------------
# Multiple inputs
# --------------------------------------------------------

rule hello_from_the_other_side:
    input: 
        rules.hello_hello_hello.output.All, # if the output from the upstream rule have name, we can also specify here 'rules.<rule_name>.output.<name>'
        text = rules.other_side.output, 
    output: "results/1_rule_chain/hello_4.txt"
    shell:
        """
        printf "$(cat {input[0]}) \n $(cat {input.text}) \n" > {output}
        """


rule final:
    input: 
        "results/1_rule_chain/hello_0.txt",
        rules.hello_hello.output[0],
        rules.hello_hello_hello.output, 
        rules.other_side.output,
    output: "results/1_rule_chain/hello_5.txt"
    shell:
        """
        printf "$(cat {input[0]}) \n $(cat {input[1]}) \n $(cat {input[2]}) \n $(cat {input[3]}) \n $(cat {input[4]}) \n" > {output}
        """
