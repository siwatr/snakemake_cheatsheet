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

# Wildcards: --------------------------------------------------------------------------------------
# wildcard: name: "Jane.Doe"
snakemake --dryrun --snakefile ./workflow/rules/2_wildcards.smk results/2_wildcards/hello-0-Jane.Doe.txt
snakemake --cores 1 --snakefile ./workflow/rules/2_wildcards.smk results/2_wildcards/hello-0-Jane.Doe.txt
cat results/2_wildcards/hello-0-Jane.Doe.txt

# wildcard: name: "Max.Mustermann"
snakemake --dryrun --snakefile ./workflow/rules/2_wildcards.smk results/2_wildcards/hello-0-Max.Mustermann.txt
snakemake --cores 1 --snakefile ./workflow/rules/2_wildcards.smk results/2_wildcards/hello-0-Max.Mustermann.txt
cat results/2_wildcards/hello-0-Max.Mustermann.txt


# wildcard_constraints examples:
# Intended wildcards are:
#  - student: "Jane.Doe" 
#  - id_num: "001.1"

# This should activate the rule without constraint on wildcard
# It should detect the following wildcards: [student=Jane_Doe.001, id_num=1], which is not what we want
snakemake --dryrun --snakefile ./workflow/rules/2_wildcards.smk results/2_wildcards/hello_student-0-Jane_Doe.001.1.txt
snakemake --cores 1 --snakefile ./workflow/rules/2_wildcards.smk results/2_wildcards/hello_student-0-Jane_Doe.001.1.txt
cat results/2_wildcards/hello_student-0-Jane_Doe.001.1.txt

# By using the wildcard_constraints, it should now detect the intended wildcards.
snakemake --dryrun --snakefile ./workflow/rules/2_wildcards.smk results/2_wildcards/hello_student-1-Jane_Doe.001.1.txt
snakemake --cores 1 --snakefile ./workflow/rules/2_wildcards.smk results/2_wildcards/hello_student-1-Jane_Doe.001.1.txt
cat results/2_wildcards/hello_student-1-Jane_Doe.001.1.txt

snakemake --dryrun --snakefile ./workflow/rules/2_wildcards.smk "results/2_wildcards/student_info_Jane_Doe.001.1.txt"
snakemake --cores 1 --snakefile ./workflow/rules/2_wildcards.smk "results/2_wildcards/student_info_Jane_Doe.001.1.txt"
cat results/2_wildcards/student_info_Jane_Doe.001.1.txt

# Rule all ---------------------------------------------------------------------------------
snakemake --dryrun --snakefile ./workflow/rules/3_0_target_rule.smk
snakemake --cores 1 --snakefile ./workflow/rules/3_0_target_rule.smk

snakemake --dryrun --snakefile ./workflow/rules/3_1_target_rule.smk
snakemake --cores 1 --snakefile ./workflow/rules/3_1_target_rule.smk

# Note that you can still give snakemake a list of target files that may not be the default of the workflow.
smk_targets="\
results/3_target_rule/student_info_Jane_Doe.001.1.txt \
results/3_target_rule/student_info_John_Doe.001.2.txt \
results/3_target_rule/student_info_Max_Mustermann.002.1.txt \
results/3_target_rule/student_info_Erika_Musterfrau.002.2.txt \
"
snakemake --dryrun --snakefile ./workflow/rules/3_0_target_rule.smk $smk_targets
snakemake --cores 1 --snakefile ./workflow/rules/3_0_target_rule.smk $smk_targets
ls -l results/3_target_rule/

# Python and config file ------------------------------------------------
snakemake --force --dryrun --snakefile ./workflow/rules/4_python_config.smk
snakemake --force --cores 1 --snakefile ./workflow/rules/4_python_config.smk
cat results/4_python_config/All_greetings.txt