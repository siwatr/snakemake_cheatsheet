# -------------------------------------------------------------------------------------------------
# Using wildcards
# -------------------------------------------------------------------------------------------------
# It's quite often that we would want to make our pipeline flexible - i.e., adaptive to the type of output we want to have.
# One way to achieve this in snakemake is to use wildcards.

# The wildcards are placeholders in the output file name, which will be replaced by the actual values when the rule is executed.
# In this example, if the target file is `results/2_wildcards/hello-0-Jane_Doe.txt`, the wildcard `{name}` will be replaced by `Jane_Doe` when the rule is executed.
# The wildcard variable can be accessed inside the execution part of the rule using `{wildcards.<wildcard_name>}`.
rule hello_stranger:
    output: "results/2_wildcards/hello-0-{name}.txt"
    shell:
        """
        echo "Hello, {wildcards.name}!" > {output}
        """

# -------------------------------------------------------------------------------------------------
# Wildcards constraints
# -------------------------------------------------------------------------------------------------
# By default, the wildcard is deduced by snakemake using the defatult regex pattern `.+` (any character).


# Let's say we want to say heelo to a student called 'Jane Doe' with ID '001.1'.
# We could write a rule like this:
rule hello_student:
    output: "results/2_wildcards/hello_student-0-{student}.{id_num}.txt"
    shell:
        """
        echo "Hello, {wildcards.student}!" > {output}
        """
## The dry-run output for target file `results/2_wildcards/hello_student-0-Jane_Doe.001.1.txt` will be:
# rule hello_student:
#     output: results/2_wildcards/hello_student-0-Jane_Doe.001.1.txt
#     jobid: 0
#     reason: Missing output files: results/2_wildcards/hello_student-0-Jane_Doe.001.1.txt
#     wildcards: student=Jane_Doe.001, id_num=1
#     resources: tmpdir=<TBD>

## Notice that the wildcard is not exactly what we want!


# While we can better format the output file name to solve this problem, it may not always be possible in the complicated pipeline.
# A workaround for this is to use the `wildcard_constraints` directive, which allows us to specify a regex pattern for the wildcard.
rule hello_student_constraints:
    output: "results/2_wildcards/hello_student-1-{student}.{id_num}.txt"
    wildcard_constraints:
        student = r"\w+",
        id_num = r"\d+\.\d+"
    shell:
        """
        echo "Hello, {wildcards.student}!" > {output}
        """

# -------------------------------------------------------------------------------------------------
# Rule chaining with wildcards
# -------------------------------------------------------------------------------------------------

# The wildcard can also be used in other section of the rule, such as input and params.
# Here is an example of a rule that uses wildcards in the input.
rule student_info:
    input: "results/2_wildcards/hello_student-1-{student}.{id_num}.txt"
    output: "results/2_wildcards/student_info_{student}.{id_num}.txt"
    wildcard_constraints:
        student = r"\w+",
        id_num = r"\d+\.\d+"
    shell:
        """
        echo "The student: {wildcards.student} have the ID: {wildcards.id_num}." > {output}
        """

# It is important to note that the wildcard only deduced from the output file name, not the input or any other part of the rule.
# So this set of rules will not work:
if False: # NB: put in False to avoid error during execution
    rule hello_student_2:
        input: "results/2_wildcards/hello_student-1-{student}.{id_num}.txt"
        output: "results/2_wildcards/student_info_Jane.Doe.001.1.txt"
        wildcard_constraints:
            student = r"\w+",
            id_num = r"\d+\.\d+"
        shell:
            """
            echo "The student: {wildcards.student} have the ID: {wildcards.id_num}." > {output}
            """

