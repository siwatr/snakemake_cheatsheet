# The default first-rule-execution behavior of snakemake can be overwritten by specifying this directive `default_target: True`.
rule all:
    input: "results/3_target_rule/student_info_Jane_Doe.001.1.txt"

# The `default_target: True` specification makes this rule the default target rule of the workflow.
rule real_all:
    input: "results/3_target_rule/student_info_Max_Mustermann.002.1.txt"
    default_target: True

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

