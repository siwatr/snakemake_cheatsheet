# By default, Snakemake always wants to execute the first rule in the snakefile. 
# This gives rise to pseudo-rules at the beginning of the file that can be used to define build-targets similar to GNU Make:

# While you can name this rule anything you want, 
#  it is a convention to name it `all` to indicate that it is the default target of the workflow.
#  the input directive is used, so when this rule is executed, it will try it best to make the input file exist.
rule all:
    input: "results/3_target_rule/student_info_Jane_Doe.001.1.txt"


# Slightly modify the rules from the previous example (2_wildcards.smk)
rule hello_student_constraints:
    output: temp("results/3_target_rule/hello_student-1-{student}.{id_num}.txt")
    wildcard_constraints:
        student = r"\w+",
        id_num = r"\d+\.\d+"
    shell:
        """
        echo "Hello, {wildcards.student}!" > {output}
        """

rule student_info:
    input: "results/3_target_rule/hello_student-1-{student}.{id_num}.txt"
    output: "results/3_target_rule/student_info_{student}.{id_num}.txt"
    wildcard_constraints:
        student = r"\w+",
        id_num = r"\d+\.\d+"
    shell:
        """
        echo "The student: {wildcards.student} have the ID: {wildcards.id_num}." > {output}
        """

