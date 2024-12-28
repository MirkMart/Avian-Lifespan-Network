# Convergence Analysis

To study gene convergence to understand if LL or SL species relied on the exact genetic mechanisms, we used a program named [TRACCER](https://github.com/harris-fishlab/TRACCER).

## TRACCER

The species tree we inferred with IQ-Tree and RAxML-NG represented the general and mean evolution of species. TRACCER aimed to discover if, among the proteins of a species, some presented a different evolutionary rate (RER) compared to the mean evolution of the species. For this reason, we inferred trees with branches proportional to the evolution of the amino acid sequences for every OGs.

To work, TRACCER needed the [species tree](../02_Species_Gene_Trees/Files/species_tree_kuhl.nwk) with branch lengths representing relatedness and a single file listing all gene trees fixed on the same species tree topology. This file could be organized in two ways:

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

We decided to use the second [syntax](./Files/gene_trees_kuhl.nwk). To parse this file we used the custom script [gene_tree_lister.sh](./Scripts/gene_tree_lister.sh).

We run an analysis for each group of long- and short-lived species labeled using all three metrics (MLSLL, MLSSL, LQLL, LQSL and 3L and ELL). TRACCER requires, as an input, the outgroup composition of the analysis. This is way we, from the beginning, choose to filter out every orthogroup that lost its internal outgroup.

```bash
python3 TRACCER.py --mastertree=species_tree_kuhl.nwk --gtrees=gene_trees_kuhl.nwk --hastrait=<has_trait_species> --outgroup=Cacas,Drnov,Stcam --cpus=20  --outname=<output_name>
```

### Random control

To check if our species of interest (test-analysis) had something in common when compared to the a random group of species, we created ten random control groups for each TRACCER run. To do so, we employed the function `-random_notrait` that we wrote using the already written `-random` function. We modified the function 'initialize_species_groups' and its option as reported below (we are thinking of suggesting to TRACCER writer this modification, since allows to incorporate a control run without externally elaborate species name strings). The TRACCER_random.py script we employed is provided [here](./Scripts/TRACCER_random.py).

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

- **ELL**: Phrub,Prate,Bubub,Amaes,Sthab,Fugla,Cyolo,Eoros,Nenot,Ayful,Altor,Uraal,Coliv,Tyalb,Aqchr,Stpar,Frmag,Gagal,Haalb,Pypap,Gycal,Anpla,Grame,Pecri,Spmag,Stcam,Apfor,Spdem,Bareg,Phcar,Appat,Cacas
- **ELL control**: Cefam,Secan,Anzon,Oxjam,Phmel,Sieur,Gecal,Popod,Cimag,Pyjoc,Moalb,Gaste,Moate,Canic,Resat,Arint,Loleu,Cebra,Sphum,Lelut,Aigal,Pabia,Cohaw,Hahar,Cimex,Tored,Cafus,Sybor,Phcol,Cobra,Lalud,Locur

- **3L**: Pecri,Stcam,Apfor,Appat,Cacas,Megal,Drnov
- **3L control**: Cyolo,Lerot,Macya,Pamon,Acgen,Acaru,Meund

### MLS

To decide which MLS to use as a threshold to split our species between those with the trait and those without it, we first observed the distribution of MLS values across our dataset. We decided to identify as long-lived species those that fall in the fourth quartile of our distribution (more than 27 years). On the other hand, short-lived species had their MLS whithin the first quartile of the distribution (less than or equal to 11.1 years.)

Disclaimer: results we obtained support our hypothesis that this longevity metric (MLS) is the most appropriate to group species with similar genomic charactestics that can be studied using convergent evolution methods. Multiple random control, the phylogenetic control, and the weight control have been performed, for this reason, only on long- and short-lived species labeled using the MLS distribution. For a detailed explanation of this choice, we remand the reader to the main text of the paper.

- **MLSLL**: Phrub,Prate,Bubub,Amaes,Sthab,Fugla,Cyolo,Eoros,Nenot,Cacar,Ayful,Altor,Uraal,Coliv,Tyalb,Aqchr,Stpar,Ritri,Cegry,Frmag,Gagal,Haalb,Pypap,Gycal,Amgui,Anpla,Grame,Pecri,Spmag,Stcam,Apfor,Spdem,Bareg,Phcar,Cacas
- **MLSLL control1**: Agpho,Popod,Pocae,Cefam,Gecal,Stvul,Gaste,Caust,Stocc,Caann,Padom,Faper,Ananh,Paamo,Eggar,Apcoe,Pamon,Hirus,Thlud,Fanau,Apapu,Moalb,Secan,Oeoen,Errub,Cimex,Farus,Meund,Acaru,Lamut,Lelut,Capug,Sieur,Sphum,Sudac
- **MLSLL control2**: Apapu,Agpho,Lostr,Allat,Laleu,Popod,Euhel,Numel,Lamut,Phmel,Caann,Poatr,Oeoen,Cobra,Hiict,Fache,Sybor,Sekir,Rynig,Paamo,Canic,Hahar,Lerot,Cimex,Pamon,Lalud,Thlud,Cyatr,Ananh,Sudac,Sieur,Stvul,Tored,Cimag,Pocae
- **MLSLL control3**: Lamut,Faper,Sphum,Lostr,Qumex,Pabia,Poatr,Chgou,Hiict,Fanau,Popod,Cojap,Errub,Arint,Moate,Meund,Chpel,Phmel,Upepo,Paamo,Macya,Hirus,Cucan,Tored,Laleu,Acgen,Anzon,Numel,Fatin,Zoalb,Cobra,Fialb,Stocc,Apcoe,Cimag
- **MLSLL control4**: Caann,Hihim,Paamo,Thlud,Cohaw,Sybor,Chgou,Memel,Cebra,Poatr,Sieur,Tagut,Acaru,Moalb,Laleu,Caust,Oeoen,Numel,Gaste,Costr,Cucan,Rynig,Gecal,Allat,Syatr,Agpho,Oxjam,Lerot,Cecet,Fanau,Arint,Pyjoc,Pocae,Cojap,Eumin
- **MLSLL control5**: Lelut,Acgen,Acaru,Apcoe,Cobra,Stvul,Locur,Pamon,Ancar,Pamaj,Pabia,Qumex,Sudac,Orori,Caust,Apapu,Ceuro,Phmel,Lamut,Cyatr,Hihim,Appat,Stocc,Zoalb,Drpub,Ananh,Atcun,Numel,Cojap,Euhel,Popod,Pocae,Allat,Anzon,Fache
- **MLSLL control6**: Appat,Popod,Allat,Stocc,Fatin,Pafas,Ceuro,Tored,Pocae,Cecet,Caann,Agpho,Resat,Cimag,Meund,Lelut,Sudac,Stcin,Cohaw,Fanau,Cocor,Pabia,Syatr,Cucan,Hihim,Secan,Thlud,Fache,Emtra,Sphum,Eggar,Errub,Ananh,Gaste,Bogar
- **MLSLL control7**: Allat,Apcoe,Emtra,Errub,Gecal,Oeoen,Drpub,Hihim,Cohaw,Faper,Stvul,Phmel,Sphum,Secan,Caust,Cojap,Fatin,Numel,Aecau,Orori,Cycae,Sekir,Drnov,Megal,Stcin,Apapu,Pabia,Pamaj,Arint,Moalb,Lostr,Paamo,Hirus,Aigal,Sybor
- **MLSLL control8**: Hirus,Cycae,Popod,Pamaj,Rynig,Anzon,Hahar,Caust,Cucan,Aigal,Tagut,Faper,Fatin,Appat,Cyatr,Euhel,Lostr,Zoalb,Cohaw,Pamon,Cobra,Cafus,Megal,Apcoe,Orori,Caann,Gaste,Cecet,Bogar,Sieur,Typal,Pabia,Emtra,Moalb,Padom
- **MLSLL control9**: Fache,Aigal,Pocae,Allat,Rynig,Errub,Typal,Cucan,Loleu,Cecet,Megal,Caann,Sybor,Eumin,Sphum,Stcin,Cocor,Ananh,Gecal,Cimag,Ancar,Ninip,Pafas,Phmel,Lerot,Cycae,Lalud,Cohaw,Popod,Emtra,Canic,Sieur,Caust,Syatr,Poatr
- **MLSLL control10**0: Farus,Appat,Gaste,Drnov,Sudac,Chvoc,Fache,Tagut,Aigal,Emtra,Popod,Drpub,Cyatr,Ceuro,Gecal,Cycae,Agpho,Macya,Lostr,Phmel,Ananh,Sybor,Lamut,Arint,Upepo,Stvul,Stocc,Hirus,Pabia,Rynig,Padom,Atcun,Caust,Eumin,Apcoe

- **MLSSL**: Caust,Chgou,Ceuro,Caann,Cojap,Emtra,Upepo,Anzon,Fanau,Pabia,Cafus,Fialb,Chvoc,Thlud,Pyjoc,Cefam,Sekir,Hiict,Atcun,Hihim,Gecal,Resat,Acaru,Pocae,Lostr,Loleu,Tored,Macya,Paamo,Cimex,Oeoen,Aecau,Aigal,Cecet,Cebra,Popod
- **MLSSL control1**: Pafas,Drnov,Zoalb,Pamaj,Coliv,Cohaw,Prate,Tagut,Frmag,Costr,Phmel,Moate,Fugla,Gagal,Bareg,Sudac,Lalud,Chpel,Cacas,Errub,Sthab,Hirus,Appat,Farus,Cyatr,Poatr,Lamut,Stcin,Stpar,Ritri,Cobra,Spmag,Apcoe,Nenot,Pecri,Phcar
- **MLSSL control2**: Amgui,Cohaw,Ninip,Sybor,Bogar,Oxjam,Lalud,Apfor,Cimag,Cegry,Spmag,Cyatr,Sieur,Lelut,Megal,Acgen,Poatr,Lamut,Anpla,Eumin,Cucan,Arint,Pypap,Cobra,Costr,Cacar,Phcol,Rynig,Padom,Grame,Capug,Pamon,Appat,Bubub,Eoros,Bareg
- **MLSSL control3**: Lamut,Numel,Cycae,Altor,Spdem,Phcar,Amaes,Tyalb,Stcam,Ritri,Haalb,Lelut,Sieur,Memel,Bareg,Apfor,Apcoe,Cobra,Cegry,Hirus,Laleu,Fache,Stcin,Cacar,Uraal,Chpel,Appat,Pecri,Hahar,Eggar,Phcol,Orori,Amgui,Locur,Faper,Pafas
- **MLSSL control4**: Ananh,Moalb,Eggar,Capug,Zoalb,Lamut,Phmel,Coliv,Grame,Apfor,Meund,Bubub,Cyatr,Arint,Qumex,Stocc,Canic,Amgui,Ninip,Anpla,Orori,Cacar,Locur,Ritri,Chpel,Cocor,Fugla,Gaste,Sphum,Rynig,Pamon,Cobra,Costr,Phcol,Pypap,Euhel
- **MLSSL control5**: Phrub,Allat,Phcol,Spdem,Cegry,Bogar,Megal,Padom,Poatr,Frmag,Capug,Fugla,Moalb,Uraal,Pafas,Cacar,Ancar,Numel,Drpub,Spmag,Ninip,Grame,Faper,Laleu,Nenot,Chpel,Tagut,Ayful,Sphum,Anpla,Pypap,Euhel,Ritri,Appat,Secan,Cobra
- **MLSSL control6**: Apapu,Sudac,Cohaw,Lalud,Agpho,Aqchr,Frmag,Stocc,Typal,Cycae,Eoros,Bareg,Cimag,Altor,Canic,Numel,Memel,Secan,Cocor,Phcar,Eumin,Allat,Zoalb,Stpar,Pamon,Coliv,Gagal,Phrub,Hahar,Uraal,Ayful,Stcam,Haalb,Sthab,Amaes,Ritri
- **MLSSL control7**: Faper,Sudac,Zoalb,Cyatr,Fugla,Acgen,Pecri,Phmel,Appat,Cobra,Tagut,Anpla,Pamon,Apfor,Orori,Tyalb,Spmag,Megal,Chpel,Canic,Ancar,Ananh,Typal,Bareg,Prate,Amgui,Eoros,Stocc,Laleu,Aqchr,Poatr,Syatr,Sphum,Cacar,Haalb,Locur
- **MLSSL control8**: Fatin,Fache,Phcol,Tagut,Drnov,Apapu,Grame,Hirus,Costr,Stocc,Agpho,Phcar,Gaste,Farus,Canic,Lerot,Tyalb,Prate,Numel,Pafas,Ananh,Euhel,Syatr,Apcoe,Poatr,Zoalb,Drpub,Cobra,Bubub,Nenot,Moate,Ninip,Cycae,Eoros,Uraal,Locur
- **MLSSL control9**: Canic,Lalud,Lamut,Cobra,Sieur,Eoros,Cohaw,Apfor,Cegry,Faper,Cycae,Laleu,Drnov,Costr,Poatr,Apapu,Hirus,Fatin,Drpub,Sthab,Allat,Pecri,Ancar,Secan,Hahar,Bareg,Ritri,Coliv,Eggar,Phmel,Aqchr,Cimag,Numel,Cucan,Tyalb,Apcoe
- **MLSSL control10**0: Sybor,Prate,Apfor,Sudac,Cycae,Phrub,Eoros,Ritri,Pamaj,Chpel,Megal,Meund,Canic,Numel,Grame,Allat,Cobra,Euhel,Poatr,Pamon,Faper,Lelut,Orori,Gagal,Tyalb,Stvul,Agpho,Haalb,Frmag,Phcar,Stcam,Fatin,Coliv,Spdem,Appat,Pecri

### Weight control

To assess if the results we obseved in MLSLL and MLSSL analyses were biased due to the weight characteristic of trait-bearing species, we performed weight controls. We chose species having their weight in the lower an upper 25th percentile of the weight distribution that were not short-lived or long-lived, respecitvely. This analysis was perfomed only on trait-bearing species labeled using the MLS distribution for the reason explained in main text of this work.

- **Heavy (not long-lived) control**: Appat,Phcol,Hahar,Drnov,Sudac,Anzon,Gaste,Allat,Eumin,Sphum,Megal,Numel,Cimag,Ananh,Cyatr,Ninip,Farus,Ceuro
- **Light (not short-lived) control**: Tagut,Drpub,Sybor,Zoalb,Padom,Pamaj,Syatr,Pamon,Lelut,Moalb,Poatr,Sieur,Errub,Chpel,Cycae,Memel,Secan,Hirus

### Phylogenetic control

To assess if the results we observed in MLSLL and MLSSL analyses were biased due to the phylogenetic belonging of trait-bearing species, we perfomed phylogenetic controls. We chose a number of species equal to the one in the respective test-analysis, preferentially selecting similar, or direclty sister, species to the studied one when possible. This analysis was performed only on trait-bearing species labeled using the MLS distribution for the reason explained in main text of this work.

- **LL phylogenetic control**: Typal,Ayful,Costr,Meund,Oxjam,Gecal,Laleu,Acgen,Arint,Hihim,Apapu,Ananh,Phmel,Popod,Chvoc,Paamo,Drpub,Anzon,Fanau,Appat,Pafas,Phcol,Rynig,Sphum,Cocor,Canic,Ceuro,Atcun,Eggar,Cyatr,Drnov,Upepo,Anpla,Lamut,Sudac
- **SL phylogenetic control**: Amgui,Stvul,Hirus,Qumex,Typal,Zoalb,Fatin,Padom,Lalud,Pamaj,Anpla,Locur,Apcoe,Farus,Tagut,Bogar,Orori,Drpub,Cobra,Cucan,Apfor,Memel,Secan,Phmel,Sybor,Agpho,Lerot,Sieur,Stcam,Lelut,Chgou,Canic,Gycal,Poatr,Cacar,Moalb,Phrub

## Results

More or less a run is about **2-2.5** hours. If interested, additional information of shared species between different group is provided in the additional file [Considered Species](./Considered_species.md)

Once a run finished, we extracted genes with p-values below 0.05. More detailed output and consideration about TRACCER results of each run is provided in the additional file [Detailed results](./Detailed_Results.md). How the final results have been plotted as shown in the main text, we remand the reader to the R script [TRACCER](./Scripts/)

Interestingly, after a TRACCER run, an error could occour (visible only in the standard output)

```Bash
"Permutations on the most significant hits may be insufficient. Re-run with more --time and/or --cpus to improve sensitivity. This will use more memory however. If TRACCER runs out of memory, it will stall indefinitely."
```

With low number of CPUs, the program the program affirms that it can not reach its ends. This error was outputted in two different situations: after a complete run or as the explanation of an incomplete one, which did not reach the normal 16th permutation cycle. For this reason, we suggest to use at least 15-20 CPUs when datasets have similar dimension.
