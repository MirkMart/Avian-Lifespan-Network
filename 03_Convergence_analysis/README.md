# Convergence Analysis

To study gene convergence to understand if LL or SL species relied on the exact genetic mechanisms, we used a program named [TRACCER](https://github.com/harris-fishlab/TRACCER).

## TRACCER

The species tree we inferred with IQ-Tree and RAxML-NG represented the general and mean evolution of species. TRACCER aimed to discover if, among the proteins of a species, some presented a different evolutionary rate (RER) compared to the mean evolution of the species. For this reason, we inferred trees with branches proportional to the evolution of the amino acid sequences for every OGs.

To work, TRACCER needed the species tree with branch lengths representing relatedness and a single file listing all gene trees fixed on the same species tree topology. This file could be organized in two ways:

```Bash
unique_gene_name_1\t(newick_tree)
unique_gene_name_2\t(newick_tree)
```

or

```bash
>unique_gene_name_1
(newicktree)
>unique_gene_name_2
(newicktree)
```

We decided to use the second [syntax](./Files/gene_trees_kuhl.nwk).

We run an analysis for each group of long- and short-lived species labeled using all three metrics (MLSLL, MLSSL, LQLL, LQSL and 3L and ELL). TRACCER require, as an input, the outgroup composition of the analysis. This is way we, from the beginning, choose to filter out every orthogroup that lost its internal outgroup.

```bash
python3 TRACCER.py --mastertree=species_tree_kuhl.nwk --gtrees=gene_trees_kuhl.nwk --hastrait=<has_trait_species> --outgroup=Cacas,Drnov,Stcam --cpus=20  --outname=<output_name>
```

### Random control

To check if our species of interest (test-analysis) had something in common when compared to the a random group of species, we created ten random control groups for each TRACCER run. To do so, we employed the function `-random_notrait` that we wrote using the already written `-random` function. We modified the function 'initialize_species_groups' and its option as reported below (we are thinking of suggesting to TRACCER writer this modification, since allows to incorporate a control run without externally elaborate species name strings). The TRACCER.py script we embloyed is provided in this folder.

```Python
#option added to the script
parser.add_option("--random_notrait", dest="random_notrait", action='store_true',
        help="Use random species selections of specifically non-trait; should still provide --hastrait=species to determine the number of species to pick. Can be used as control run.")

#modified function
def initialize_species_groups():
    with open(options.mastertree_path) as infile:
        for row in infile:
            if row.startswith('>'): continue
            if '\t' in row: row = row.split('\t')[-1]
            try:
                mastertree = Tree(row, format=1)
            except:
                help_text("MASTER SPECIES TREE MISFORMATTED. Confirm it fulfills newick requirements, has no tabs, and does not start with '>'.")
            break
    try:
        allspecies = frozenset([x.name for x in mastertree.get_leaves()])
    except:
        help_text("MASTER SPECIES TREE MISFORMATTED. Confirm it fulfills newick requirements.")
    groupA = set(options.groupA.split(','))
    # create a rough control using half A and half B ensuring the length will be equal as hastrait discarting each B group that has any overlap
    if options.random:
       while True:
           halfA = set(random.sample(list(allspecies),int(len(groupA)/2)))
           halfB = set(random.sample(list(allspecies),len(groupA) - len(halfA)))
           if not halfA & halfB:
               break
       groupA = halfA|halfB
    #Option to create a random sample with lenght equal to groupA using only species that do no manifest the interested trait
    if options.random_notrait:
        groupB = allspecies - groupA
        groupA = set(random.sample(list(groupB),len(groupA))) 
    #Option to define groupB (lacks trait), or groupC (skipped), such that some species can be left out.
    if options.groupB and options.groupC:
        help_text("USE EITHER --lackstrait or --skipped. NOT BOTH")
    if options.groupB:
        groupB = set(options.groupB.split(','))
        skippedspecies = allspecies - (groupA | groupB)
        allspecies = frozenset(groupA | groupB)
        mastertree.prune(list(allspecies))
    elif options.groupC:
        groupC = set(options.groupC.split(','))
        allspecies = frozenset(allspecies - groupC)
        skippedspecies = list(groupC)
        groupB = allspecies - groupA
        mastertree.prune(list(allspecies))
    else:
        groupB = allspecies - groupA
        skippedspecies = ['none']
    print("Has Trait: %s" %','.join(groupA))
    print("Lacks Trait: %s" %','.join(groupB))
    print("Skipped species: %s" %','.join(skippedspecies))
    return groupA,groupB,allspecies,mastertree
```

## LQ

Using species LID, we decided to test if different LQ thresholds could highlight different enrichments. We launched three different LQ TRACCER runs for long-lived species and only once for short-lived ones. The long-lived thresholds we explored in depth were 2.0, 1.75, and 1.5. Short-lived species, instead, were those with LQ below 0.5. The lists of species choosen as random group are provided

- **LQLL2.0**: Amaes,Ayful,Bubub,Cacar,Eoros,Fugla,Nenot,Padom,Phmel,Phrub,Prate,Secan,Sthab,Sybor
- **LQLL2.0 control**: Laleu,Stvul,Sieur,Cyolo,Farus,Numel,Cohaw,Chpel,Oeoen,Cyatr,Hihim,Stpar,Uraal,Aigal
- **LQLL1.75**: Altor,Amaes,Apapu,Ayful,Bubub,Cacar,Coliv,Cyolo,Eoros,Errub,Fugla,Lerot,Meund,Nenot,Padom,Phmel,Phrub,Prate,Secan,Sthab,Sybor,Uraal
- **LQLL1.75 control**: Lalud,Cegry,Pyjoc,Cycae,Canic,Sieur,Faper,Hihim,Acgen,Lelut,Resat,Pafas,Apfor,Popod,Phcol,Spdem,Chvoc,Sphum,Frmag,Syatr,Anpla,Appat
- **LQLL1.5**: Agpho,Altor,Amaes,Apapu,Ayful,Bubub,Cacar,Cegry,Coliv,Cycae,Cyolo,Eoros,Errub,Fugla,Hirus,Lerot,Meund,Nenot,Pamaj,Padom,Phmel,Phrub,Prate,Ritri,Secan,Stpar,Sthab,Stcin,Stvul,Sybor,Tyalb,Uraal
- **LQLL1.5 control**: Eumin,Cobra,Aigal,Stocc,Pecri,Oxjam,Resat,Cebra,Spmag,Moate,Cacas,Lamut,Sudac,Aecau,Capug,Arint,Fache,Atcun,Poatr,Sekir,Caust,Syatr,Typal,Macya,Popod,Loleu,Paamo,Fatin,Anzon,Frmag,Hahar,Gagal
- **LQSL**: Aigal,Allat,Anzon,Ceuro,Cojap,Drnov,Gecal,Loleu,Megal,Popod,Tored
- **LQSL control**: Gycal,Stvul,Cefam,Caann,Pocae,Stcam,Gagal,Zoalb,Eumin,Coliv,Poatr

### PCA-LID

The use of phylogenetic PCA (principal component analysis) allowed us to distinguish two phenotypes more: extremely long-lived (ELL) and longe-lived large-bodied (3L) species (positive values for the first and second principal components, respectively). These are the results of a PCA elaboration of avian MLS and weight values in the database, considering phylogenetic relationships between species. We did not expect a total overlap between species identified in this way, and with LQ was surely greater when comparing LQLL and ELL.

- ELL: Phrub,Prate,Bubub,Amaes,Sthab,Fugla,Cyolo,Eoros,Nenot,Ayful,Altor,Uraal,Coliv,Tyalb,Aqchr,Stpar,Frmag,Gagal,Haalb,Pypap,Gycal,Anpla,Grame,Pecri,Spmag,Stcam,Apfor,Spdem,Bareg,Phcar,Appat,Cacas
- ELL control: Cefam,Secan,Anzon,Oxjam,Phmel,Sieur,Gecal,Popod,Cimag,Pyjoc,Moalb,Gaste,Moate,Canic,Resat,Arint,Loleu,Cebra,Sphum,Lelut,Aigal,Pabia,Cohaw,Hahar,Cimex,Tored,Cafus,Sybor,Phcol,Cobra,Lalud,Locur
- 3L: Pecri,Stcam,Apfor,Appat,Cacas,Megal,Drnov
- 3L control: Cyolo,Lerot,Macya,Pamon,Acgen,Acaru,Meund

### MLS

To decide which MLS to use as a threshold to split our species between those with the trait and those without it, we first observed the distribution of MLS values across our dataset. We decided to identify as long-lived species those that fall in the fourth quartile of our distribution (more than 27 years).

Discalimer: results we obtained support our hypothesis that this longevity metric (MLS) is the most appropriate to group species with similar genomic charactestics that can be studied using convergent evolution methods. Multiple random control, the phylogenetic control, and the weight control have been performed, for this reason, only on long- and short-lived species labeled using the MLS distribution. For a detailed explanation of this choice, we remand the reader to the main text of the paper.

- MLSLL: Phrub,Prate,Bubub,Amaes,Sthab,Fugla,Cyolo,Eoros,Nenot,Cacar,Ayful,Altor,Uraal,Coliv,Tyalb,Aqchr,Stpar,Ritri,Cegry,Frmag,Gagal,Haalb,Pypap,Gycal,Amgui,Anpla,Grame,Pecri,Spmag,Stcam,Apfor,Spdem,Bareg,Phcar,Cacas
- MLSLL control1:
- MLSLL control2:
- MLSLL control3:
- MLSLL control4:
- MLSLL control5:
- MLSLL control6:
- MLSLL control7:
- MLSLL control8:
- MLSLL control9:
- MLSLL control10:

### Weight control

To assess if the results we obseved in MLSLL and MLSSL analyses were biased due to the weight characteristic of trait-bearing species, we performed weight controls. We chose species having their weight in the lower an upper 25th percentile of the weight distribution that were not short-lived or long-lived, respecitvely. This analysis was perfomed only on trait-bearing species labeled using the MLS distribution for the reason explained in main text of this work.

- Heavy (not long-lived) control:
- light (not short-lived) control:

### Phylogenetic control

To assess if the results we observed in MLSLL and MLSSL analyses were biased due to the phylogenetic belonging of trait-bearing species, we perfomed phylogenetic controls. We chose a number of species equal to the one in the respective test-analysis, preferentially selecting similar, or direclty sister, species to the studied one when possible. This analysis was performed only on trait-bearing species labeled using the MLS distribution for the reason explained in main text of this work.

- LL phylogenetic control:
- SL phylogenetic control:

## Results

More or less a run is about **2-2.5** hours. If interested, additional information of shared species between different group is provided in the additional file [Considered Species](./Considered_species.md)

Once a run finished, we extracted genes with p-values below 0.05. More detailed output and consideration about TRACCER results of each run is provided in the additional file [Detailed results](./Detailed_Results.md). How the final results have been plotted as shown in the main text, we remand the reader to the R script [TRACCER](./Scripts/)

Interestingly, after a TRACCER run, an error could occour (visible only in the standard output)

```Bash
"Permutations on the most significant hits may be insufficient. Re-run with more --time and/or --cpus to improve sensitivity. This will use more memory however. If TRACCER runs out of memory, it will stall indefinitely."
```

With low number of CPUs, the program the program affirms that it can not reach its ends. This error was outputted in two different situations: after a complete run or as the explanation of an incomplete one, which did not reach the normal 16th permutation cycle. For this reason, we suggest to use at least 15-20 CPUs when datasets have similar dimension.
