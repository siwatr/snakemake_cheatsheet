# -------------------------------------------------------------------------------------------------
# 0 The basic
# -------------------------------------------------------------------------------------------------
# Syntax:
#   snakemake --dryrun --snakefile <snakefile> <target(s)>
# The --dryrun tell us how the workflow 'plans' its action to get the target file we want. No output files are created here.
snakemake --dryrun --snakefile ./workflow/rules/0_hello.smk "results/hello.txt"
# The run without --dryrun will actually execute the workflow and create the target file.
# Minimum resouce for the run is needed to be specificed. This will depends on how we want to run it (e.g., on local shell, or submit as job on cluster)
snakemake --cores 1 --snakefile ./workflow/rules/0_hello.smk "results/hello.txt"


# Rule Chaining: ----------------------------------------------------------------------------------
snakemake --dryrun --snakefile ./workflow/rules/1_rule_chain.smk "results/1_rule_chain/hello_2.txt"
snakemake --cores 1 --snakefile ./workflow/rules/1_rule_chain.smk "results/1_rule_chain/hello_2.txt"
cat results/1_rule_chain/hello_2.txt

snakemake --dryrun --snakefile ./workflow/rules/1_rule_chain.smk "results/1_rule_chain/hello_4.txt"
cat results/1_rule_chain/hello_4.txt

snakemake --force --cores 1 --snakefile ./workflow/rules/1_rule_chain.smk \
 "results/1_rule_chain/hello_0.txt" \
 "results/1_rule_chain/hello_1.txt" \
 "results/1_rule_chain/hello_2.txt" \
 "results/1_rule_chain/hello_3.txt" \
 "results/1_rule_chain/hello_4.txt" \
 "results/1_rule_chain/hello_5.txt"
cat results/1_rule_chain/hello_5.txt

snakemake --dag --snakefile "./workflow/rules/1_rule_chain.smk" "results/1_rule_chain/hello_4.txt" | dot -Tsvg > results/1_rule_chain/dag.svg