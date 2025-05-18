# -------------------------------------------------------------------------------------------------
# Wildcard function
# -------------------------------------------------------------------------------------------------
# Setting: using the setting similar to the previous example (4_python_config.smk)
# The goal of this workflow is to greet individual people
# This aims to demonstrate the use of wildcard function

# import python packages
import yaml
import os
import pandas as pd
# import cowsay

config_path = "./config/4_greeting_config.yaml"
configfile: config_path

# This should be equivalent to the normal python code:
with open(config_path, "r") as file:
    config = yaml.safe_load(file)


# Reading and processing the person table
name_table_path = config["name_table"]
name_table = pd.read_csv(name_table_path, sep="\t", header=0)

# Adding a new column indicate a unique ID for each person
# Constructing from row_index_initials
# e.g., ID0_JD for the person "Jane Doe" on the first row
name_table["ID"] = name_table.index.astype(str) + "_" + name_table["name"].str[0] + name_table["family_name"].str[0]

print("\nname_table:\n", name_table, "\n")
print("\n")

#region MARK: Targets
# Listing target files:
# Having the sample table allows us to dynamically generate the target files.
TARGETS = []
for _, row in name_table.iterrows():
    TARGETS.append(f"results/5_wildcard_function/greet_{row['ID']}.txt")

#region MARK: Rules

# Default target file:
rule all:
    input: TARGETS

# -------------------------------------------------------------------------------------------------
# The Wildcard Function
# -------------------------------------------------------------------------------------------------
# The function that use `wildcards` as input can be used within certain directive within the rule
#    e.g., input and params
# The function can be used to get the value of the wildcard

def get_wc_greeting(wildcards):
    # Get the greeting column for the row that ID column matches wildcards.unique_id
    unq_id=wildcards.unique_id
    row = name_table[name_table["ID"] == unq_id]
    return str(row["greeting"].values[0])

def get_wc_name(wildcards):
    unq_id=wildcards.unique_id
    row = name_table[name_table["ID"] == unq_id]
    title = row["title"].values[0]
    name = row["name"].values[0]
    family_name = row["family_name"].values[0]
    return f"{title} {name} {family_name}"

rule greet_person:
    # The unique_id wildcard is corresponding to the "ID" column in the `name_table`
    output: "results/5_wildcard_function/greet_{unique_id}.txt"
    params:
        # Notice that we feed the entire function to the params, e.g., not get_wc_greeting(wildcards)
        greeting = get_wc_greeting,
        name = get_wc_name
    shell:
        """
        printf "{params.greeting}, {params.name}!\n{config[ending]}\n\n" > {output}
        """

