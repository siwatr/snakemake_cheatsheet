# -------------------------------------------------------------------------------------------------
# Python environment and configuration file
# -------------------------------------------------------------------------------------------------
# Snakemake is build on python, so we can also use normal python script in the snakefile.
# In this example, we will write a workflow to greet a list of people.
#  Instead of specifying the person by target file name, we will get the information of how we greet people from a config file.

# import python packages
import yaml
import os
import pandas as pd
# import cowsay

# ------------------------------------------------------
# The config file
# ------------------------------------------------------
# Snakemake has specific directive called `configfile`,
#   which allows it to read the specified YAML files to dictionary called `config`

config_path = "./config/4_greeting_config.yaml"
configfile: config_path

# This should be equivalent to the normal python code:
with open(config_path, "r") as file:
    config = yaml.safe_load(file)


# In this example, the yaml file should have a field called 'name_table' in it.
# This indicates where the pipeline can find the information of the person it need to saying hi to
name_table_path = config["name_table"]
name_table = pd.read_csv(name_table_path, sep="\t", header=0)

print("\nname_table:\n", name_table, "\n")
print("\n")


#region MARK: Rules

# Default target file:
rule all:
    input: "results/4_python_config/All_greetings.txt"


# ------------------------------------------------------
# The run directive 
# ------------------------------------------------------
# The 'run' directive allows us to write Python code directly in the rule
# This has certain advantage over shell directive as it have all access to current python variables and packages loaded in the snakefile.
rule greet_all:
    output: "results/4_python_config/All_greetings.txt"
    run:
        # The pythong scripts can access the rule-specific directive variables
        #   such as output, input, params, wildcards, etc.
        # Construct the greeting message and save to file
        with open(output[0], "a") as f:
            for _, row in name_table.iterrows():
                greeting = f"{row['greeting']}, {row['title']} {row['name']} {row['family_name']}!"
                f.write(greeting + "\n")
            f.write(f"\n{config["ending"]}\n")
