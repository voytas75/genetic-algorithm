# Genetic Algorithm Module in Powershell

![https://www.freepik.com/](https://image.freepik.com/free-vector/dna-sequence-hands-wireframe-dna-code-molecules-structure-mesh_127544-899.jpg)

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/e06abc1e24c3498387b8003ea0051296)](https://app.codacy.com/gh/voytas75/genetic-algorithm/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade)

This is a genetic algorithm (GA) module written in Powershell.

## [What is GA?](https://en.wikipedia.org/wiki/Genetic_algorithm)

> In computer science and operations research, a genetic algorithm (GA) is a metaheuristic inspired by the process of natural selection that belongs to the larger class of evolutionary algorithms (EA). Genetic algorithms are commonly used to generate high-quality solutions to optimization and search problems by relying on biologically inspired operators such as mutation, crossover and selection.[1] John Holland introduced genetic algorithms in 1960 based on the concept of Darwin’s theory of evolution, and his student David E. Goldberg further extended GA in 1989.

I decided to write it for two reasons. The first reason was to learn what a genetic algorithm is, the second reason was to gain experience in Powershell. The implementation of this algorithm is not difficult, but requires understanding what GA is and how it works.

## Syntax

The command has the following syntax:

```powershell
Start-GA [[-Generations] <int>] [[-PopulationSize] <int>] [[-ChromosomeSize] <int>] [[-CrossOverProbability] <double>] [[-MutationProbability] <double>] [[-Selection] <Object>] [-Log] [-Zeros] [-ShowGraph] [-ShowChart] [-ReturnAllGenerations] [<CommonParameters>]
```

Let us now analyze the command syntax given above. I will describe all the parameters.

### Generations

```[[-Generations] <int>]```

The parameter defines the number of recalculation iterations for the population before we complete the algorithm.

The parameter has a default value and it is **20** generations.

**Example**. We resize the population to 105 genomes:

```powershell
-Generations 105
```

### PopulationSize

```[[-PopulationSize] <int>]```

We define the size of the population used in the GA. Size is understood as the number of genomes - in this abbreviation a genome is equal to a chromosome. The size of the population is constant for the duration of the algorithm's operation and ___must be even___.

The parameter has a default value and it is **30** genomes.

**Example**. We resize the population to 100 genomes:

```powershell
-PopulationSize 50
```

### ChromosomeSize

```[[-ChromosomeSize] <int>]```

The parameter determines the number of genes in the chromosome.

The parameter has a default value and it is **20** chromosomes.

**Example**. We resize the genom/chromosome to 35 genes:

```powershell
-ChromosomeSize 35
```

### CrossOverProbability

```[[-CrossOverProbability] <double>]```

Determines the probability of crossing two chromosomes at a crossing point. The crossing point is random and is not a parameter.

The parameter has a default value and it is **0.6**.

**Example**. We change the probability of crossover to 0.55:

```powershell
-CrossOverProbability 0.55
```

### MutationProbability

```[[-MutationProbability] <double>]```

The parameter determines the probability of a gene mutation in the chromosome. A mutation probability is generated for each gene.

The parameter has a default value and it is **0.001**.

**Example**. We change the probability of mutating gene to 0.0009:

```powershell
-MutationProbability 0.0009
```

### Selection

```[[-Selection] <Object>]```

The value of this parameter specifies the type of selection that will be used in the iteration of the genetic algorithm. The parameter has a defined list of values, they are:

1. ```"Roulette"```
2. ```"Tournament"```

```"Roulette"``` is default one. The default value has been chosen because of its better performance.

**Example**. We change the type of selection to ```"Tournament"```:

```powershell
-Selection Tournament
```

### Log

```[-Log]```

The switch determines whether a log file from the algorithm's operation is to be generated. If there is a log file, new data will be added to it.

It is not possible to specify the path and file name. The default value is ```$env:TEMP\GA.log```

**Example**. To enable the log file:

```powershell
-Log
```

### Zeros

```[-Zeros]```

The switch specifies that the initial population consists of chromosomes, where all genes are 0. By default, the initial population is randomly generated.

**Example**. To change the default behavior:

```powershell
-Zeros
```

### ShowGraph

```[-ShowGraph]```

After the algorithm is completed, an ASCII chart is generated. Draws graph in the Powershell console. The graph is the value of the objective function for the initial population and population from all iterations of the algorithm.

The [Graphical](https://www.powershellgallery.com/packages/Graphical) module is required.

**Example**. To draw graph:

```powershell
-ShowGraph
```

### ShowChart

```[-ShowChart]```

After the algorithm is completed, an PNG chart is generated. The graph is the value of the objective function for the initial population and population from all iterations of the algorithm.

The [System.Windows.Forms](https://docs.microsoft.com/en-us/dotnet/api/system.windows.forms) and [System.Windows.Forms.DataVisualizationmodule](https://docs.microsoft.com/en/dotnet/api/system.windows.forms.datavisualization.charting) namespaces are used.

Regardless of whether the switch is turned on, a PNG image is generated and saved in ```$env:TEMP\GA.png```

**Example**. To draw chart:

```powershell
-ShowChart
```

### ReturnAllGenerations

```[-ReturnAllGenerations]```

Enabled parameter causes the function to return result table of all generations. The first element is the initial generation.

## How to use it

As the syntax is already known, we will learn how to run and use the module.

### Install module

Copy and Paste the following command to install this package using PowerShellGet:

```powershell
Install-Module -Name GeneticAlgorithm
```

Command to install in current user's directory, `$home\Documents\PowerShell\Modules`:

```powershell
Install-Module -Name GeneticAlgorithm -Scope CurrentUser
```

Then the genetic algorithm can be run:

```powershell
Start-GA
```

Sample output result:

```powershell
Best generation: [14]
Best fitness: [390]
Fitness gain: [261,11 %]
OUT DATA: C:\Users\user\AppData\Local\Temp\allGenerations.log
PNG: C:\Users\user\AppData\Local\Temp\GA.png
```

Description of output:

```Best generation: [14]``` - In which iteration the value of the objective function was highest for the first time.

```Best fitness: [390]``` - What was the highest value of the objective function.

```Fitness gain: [261,11 %]``` - By how many percent did the value of the objective function increase compared to the initial population.

```OUT DATA: C:\Users\user\AppData\Local\Temp\allGenerations.log``` - The path of the generated JSON data file. The file contains all data from all iterations: the number of iterations, the values of the objective function of the entire population in that iteration, and the population itself. Iteration 0 refers to the initial population.

```PNG: C:\Users\user\AppData\Local\Temp\GA.png``` - The path of the generated PNG plot file of the objective function in iterations of the algorithm.

### Examples

#### Example 1

Let's run a default algorithm with logging and ASCII graph:

```powershell
Start-GA -Log -ShowGraph
```

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

![Output](https://raw.githubusercontent.com/voytas75/genetic-algorithm/master/GA1.png?raw=true)

```LOG: C:\Users\voytas\AppData\Local\Temp\GA.log``` - The path of the generated log file.

#### Example 2

Let's run a default algorithm with graphic chart:

```powershell
Start-GA -ShowChart
```

Output:

![Output](https://raw.githubusercontent.com/voytas75/genetic-algorithm/master/GA2.png?raw=true)

The green bar is an iteration where the value of the objective function for the population is minimal and the red color means the first iteration in which the value of the objective function was maximal.

#### Example 3

Let's run something else:

```powershell
Start-GA -Generations 100 -PopulationSize 40 -MutationProbability 0.009 -zeros -Log -ShowGraph
```

Output:

![Output](https://raw.githubusercontent.com/voytas75/genetic-algorithm/master/GA3.png?raw=true)

#### Example 4

Let us return an array with data of all populations processed by the algorithm. We display the population from 15's iteration and the value of the objective function::

```powershell
$GAout=Start-GA -Generations 80 -ChromosomeSize 60
$GAout[15][2].foreach{"$_"}
$GAout[30][1]
```
