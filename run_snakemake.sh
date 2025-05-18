# -------------------------------------------------------------------------------------------------
# 0 The basic
# -------------------------------------------------------------------------------------------------
# Syntax:
#   snakemake --dryrun --snakefile <snakefile> <target(s)>
# The --dryrun tell us how the workflow 'plans' its action to get the target file we want. No output files are created here.
snakemake --dryrun --snakefile ./workflow/rules/0_hello.smk "results/0_hello/hello.txt"
# The run without --dryrun will actually execute the workflow and create the target file.
# Minimum resouce for the run is needed to be specificed. This will depends on how we want to run it (e.g., on local shell, or submit as job on cluster)
snakemake --cores 1 --snakefile ./workflow/rules/0_hello.smk "results/0_hello/hello.txt"
cat results/0_hello/hello.txt


# Rule Chaining: ----------------------------------------------------------------------------------
snakemake --dryrun --snakefile ./workflow/rules/1_rule_chain.smk "results/1_rule_chain/hello_2.txt"
snakemake --cores 1 --snakefile ./workflow/rules/1_rule_chain.smk "results/1_rule_chain/hello_2.txt"
cat results/1_rule_chain/hello_2.txt

snakemake --dryrun --snakefile ./workflow/rules/1_rule_chain.smk "results/1_rule_chain/hello_final.txt"
snakemake --cores 1 --snakefile ./workflow/rules/1_rule_chain.smk "results/1_rule_chain/hello_final.txt"
cat results/1_rule_chain/hello_final.txt

smk_targets="\
results/1_rule_chain/hello_0.txt \
results/1_rule_chain/hello_1.txt \
results/1_rule_chain/hello_2.txt \
results/1_rule_chain/hello_final.txt \
"
# Force running:
# Notice the difference between the rule that will be run when we use --force and when we don't
# By default, snakemake won't re-run the files that are already exist, unless necessary -- for example, when it notice that the rule to make that file has been modified, etc.
snakemake --dryrun --snakefile ./workflow/rules/1_rule_chain.smk $smk_targets
snakemake --force --dryrun --snakefile ./workflow/rules/1_rule_chain.smk $smk_targets
# snakemake --force --cores 1 --snakefile ./workflow/rules/1_rule_chain.smk $smk_targets

# Showing which rules are run to get certain target file
snakemake --dag --snakefile "./workflow/rules/1_rule_chain.smk" "results/1_rule_chain/hello_final.txt" | dot -Tsvg > results/1_rule_chain/dag.svg

