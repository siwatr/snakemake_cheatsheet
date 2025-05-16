# Here is the simplest structure of rules for Snakemake
# We need the output and the execution (in this case, shell) parts

rule hello_world:
    output: "results/hello.txt" # Will be relative path to the location where the script is run
    shell:
        """
        echo "Hello, world!" > {output}
        """
