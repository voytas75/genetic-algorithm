# Genetic Algorithm Module in PowerShell

![DNA Sequence](https://image.freepik.com/free-vector/dna-sequence-hands-wireframe-dna-code-molecules-structure-mesh_127544-899.jpg)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/A0A6KYBUS)

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/GeneticAlgorithm?label=GeneticAlgorithm)](https://www.powershellgallery.com/packages/GeneticAlgorithm/1.0.0) &nbsp; [![Codacy Badge](https://app.codacy.com/project/badge/Grade/e06abc1e24c3498387b8003ea0051296)](https://app.codacy.com/gh/voytas75/genetic-algorithm/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade) &nbsp; [![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/GeneticAlgorithm)](https://www.powershellgallery.com/packages/GeneticAlgorithm)

The Genetic Algorithm Module in PowerShell is a module that implements a genetic algorithm (GA). Genetic algorithms are metaheuristics inspired by the process of natural selection and belong to the class of evolutionary algorithms. They are commonly used to solve optimization and search problems by employing biologically inspired operators such as mutation, crossover, and selection. This module provides a PowerShell implementation of a genetic algorithm.

## What is GA?

To understand the genetic algorithm, it is helpful to refer to the [Wikipedia page](https://en.wikipedia.org/wiki/Genetic_algorithm) that provides a comprehensive definition and explanation. In brief, a genetic algorithm is a metaheuristic that generates high-quality solutions by mimicking the process of natural selection and evolution. It was introduced by John Holland in 1960 based on the principles of Darwin's theory of evolution.

## Syntax

The module provides the following command:

```powershell
Start-GA [[-Generations] <int>] [[-PopulationSize] <int>] [[-ChromosomeSize] <int>] [[-CrossOverProbability] <double>] [[-MutationProbability] <double>] [[-Selection] <Object>] [-Log] [-Zeros] [-ShowGraph] [-ShowChart] [-ReturnAllGenerations] [<CommonParameters>]
```

### Parameters

- `Generations`: Specifies the number of recalculation iterations for the population before completing the algorithm. The default value is 20.
- `PopulationSize`: Defines the size of the population used in the genetic algorithm. The size refers to the number of genomes (chromosomes), and it must be an even number. The default value is 30.
- `ChromosomeSize`: Determines the number of genes in each chromosome. The default value is 20.
- `CrossOverProbability`: Sets the probability of crossing two chromosomes at a random crossing point. The default value is 0.6.
- `MutationProbability`: Specifies the probability of a gene mutation in each chromosome. The default value is 0.001.
- `Selection`: Determines the type of selection used in the genetic algorithm. The available options are "Roulette" (default) and "Tournament".
- `Log`: Generates a log file from the algorithm's operation. The log file is automatically saved with a default path and filename.
- `Zeros`: Specifies that the initial population consists of chromosomes with all genes set to 0.
- `ShowGraph`: Displays an ASCII graph representing the value of the objective function for the initial population and populations from all iterations of the algorithm.
- `ShowChart`: Generates a PNG chart showing the value of the objective function for the initial population and populations from all iterations of the algorithm.
- `ReturnAllGenerations`: Returns a result table containing data for all generations, including the initial generation.

## How to Use

To use the Genetic Algorithm Module, follow these steps:

### Installation

Install the module from the PowerShell Gallery using the following command:

```powershell
Install-Module -Name GeneticAlgorithm
```

You can also install it in the current user's directory by adding the `-Scope CurrentUser` parameter.

### Running the Algorithm

Once the module is installed, you can run the genetic algorithm using the `Start-GA` command:

```powershell
Start-GA
```

The algorithm will execute with default parameters and provide output with the best generation, best fitness, fitness gain percentage, and file paths for the log and PNG plot.

### Examples

Here are a few examples to demonstrate different usage scenarios:

#### Example 1

Running the algorithm with logging and an ASCII graph:

```powershell
Start-GA -Log -ShowGraph
```

This command will execute the genetic algorithm with default parameters, generate a log file, and display an ASCII graph representing the value of the objective function.

Output:

```powershell
Best generation: [20]
Best fitness: [374]
Fitness gain: [144,44 %]
┌ GA ──────────────────────────┐
│                              │
│   380┤                    ▄  │
│   370┤                ██  █  │
│   360┤            █ █ ██▄██  │
│   350┤            █ ███████  │
│   340┤            █ ███████  │
│   330┤         █  █▄███████  │
│   320┤      ▄  █  █████████  │
│   310┤      █  █  █████████  │
│   300┤      █  █  █████████  │
│F  290┤      █▄ █▄ █████████  │
│i  280┤     ▄██ ██ █████████  │
│t  270┤     ███ ████████████  │
│n  260┤     ███▄████████████  │
│e  250┤     ████████████████  │
│s  240┤ █ ▄ ████████████████  │
│s  230┤ █ █ ████████████████  │
│   220┤ █▄█ ████████████████  │
│   210┤ ███▄████████████████  │
│   200┤ ████████████████████  │
│   190┤ ████████████████████  │
│   180┤ ████████████████████  │
│   170┤ ████████████████████  │
│   160┤▄████████████████████  │
│      └─────────┬─────────┬─  │
│               10        20   │
│            Generations       │
└──────────────────────────────┘
LOG: C:\Users\voytas\AppData\Local\Temp\GA.log
OUT DATA: C:\Users\voytas\AppData\Local\Temp\allGenerations.log
PNG: C:\Users\voytas\AppData\Local\Temp\GA.png
```

![Output](https://github.com/voytas75/genetic-algorithm/blob/master/images/GA1.png?raw=true)

```LOG: C:\Users\voytas\AppData\Local\Temp\GA.log``` - The path of the generated log file.

#### Example 2

Running the algorithm with a PNG chart:

```powershell
Start-GA -ShowChart
```

This command will execute the genetic algorithm with default parameters and generate a PNG chart representing the value of the objective function.

Output:

![Output](https://github.com/voytas75/genetic-algorithm/blob/master/images/GA2.png?raw=true)

#### Example 3

Customizing the algorithm parameters:

```powershell
Start-GA -Generations 100 -PopulationSize 40 -MutationProbability 0.009 -Zeros -Log -ShowGraph
```

This command will execute the genetic algorithm with specific parameter values, including a different number of generations, population size, mutation probability, and using an initial population consisting of chromosomes with all genes set to 0.

Output:

![Output](https://github.com/voytas75/genetic-algorithm/blob/master/images/GA3.png?raw=true)

#### Example 4

Accessing the data of all populations processed by the algorithm:

```powershell
$GAout = Start-GA -Generations 10 -ChromosomeSize 30 -ReturnAllGenerations
$GAout[10][2].foreach{"$_"}
$GAout[10][1]
```

These commands will execute the genetic algorithm with specific parameter values and store the output in the `$GAout` variable. You can then access the data of specific populations using array indexing (switch `ReturnAllGenerations`). In this example, it retrieves the data of the 10th iteration and displays the chromosomes, as well as the value of the objective function for the iteration.

Output:

```powershell
> $GAout = Start-GA -Generations 10 -ChromosomeSize 30 -ReturnAllGenerations
Best generation: [10]
Best fitness: [450]
Fitness gain: [69,81 %]
OUT DATA: C:\Users\voytas\AppData\Local\Temp\allGenerations.json
PNG: C:\Users\voytas\AppData\Local\Temp\GA.png

> $GAout[10][2].foreach{"$_"}
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 0 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 0 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0
0 1 1 0 0 1 1 1 0 0

> $GAout[10][1]
450
```

Feel free to experiment with different parameter values and explore the generated output to analyze the results of the genetic algorithm.

Please note that the module may require additional dependencies, such as the [Graphical module](https://www.powershellgallery.com/packages/Graphical) for displaying graphs and charts.
