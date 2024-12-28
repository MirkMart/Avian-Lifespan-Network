# Data

Our databse counted in 150 species of aves of which we knew genomes were present. Six of these species had their genomes uploaded in [Ensamble](https://www.ensembl.org/index.html) database, while the others in [NCBI](https://www.ncbi.nlm.nih.gov/).

## Download

### NCBI

From a list containing all birds with an annotated genomes in NCBI we filtered accession numbers of those whose MLS and weight value we already had. For those species that presented more than one accession number, we manually checked and eliminated the ones that we did not want to use (AN dismissed or GCA ones where GCFs were available). Two species needed particular attention:

- _Colinus virginianus_: presence of contaminations in the genome. Removed.
- _Gallus gallus_: GCF_016700215.2 used since higher BUSCO.

We downloaded using NCBI aves genomes and gffs using the ([download_genome_gff_url_ncbi](./Scripts/download_genome_gff_url_ncbi.sh)) found in internet and modified to fit our needs. To use it, we needed summary tables that can be found inside the FTP database at these links [GenBank](https://ftp.ncbi.nlm.nih.gov/genomes/genbank/vertebrate_other/assembly_summary.txt) and [RefSeq](https://ftp.ncbi.nlm.nih.gov/genomes/refseq/vertebrate_other/assembly_summary.txt). This script could work with both names and accession numbers, but we preferred the second ones since are unique. This script was runned and genomes were downloaded on 15/09/2023.

### Ensambl

Ensambl species were manually searched in the [FTP ensamble database](https://ftp.ensembl.org/pub/) and their FTP links listed in a file. With a for loop we then downloaded them. The six ensamble species were:

- Bubo bubo.
- Passer domesticus.
- Malurus cyaneus.
- Falco tinnunculus.
- Anas zonorhyncha.
- Strix occidentalis.

The download was performed on 2023-09-12 for both genomes and gff files. Passer's files were more difficult to find since they were stored in a different part of FTP database, [rapid release site](https://rapid.ensembl.org/index.html). In particular we decided always to download "dna.toplevel.fa" as genome and as gff the one that was not abinitio (thus the file that always reported .gff3 directly after the name). In fact, abinitio gff3 is not used to generate the real gff, and it is only runned to produce an informative document.

## ID

We created a uinque ID from the scientific name of our species extracting the first two letters from the genre and the first three from the specific name. It has been done in this way since only one of genre was returning non unique IDs.

```bash
IFS=$'\n'
sed -i 's/ /_/' unique_AN_aves.txt #first column genre_name, second AN
for i in $(cat unique_AN_aves.txt); do name=$(echo $i | cut -f1,2); ID=$(echo $i | cut -f1 | sed -E 's/([A-Z][a-z])([a-z]+_)([a-z]{3})([a-z]+|$)/\1\3/'); echo -e $name"\t"$ID; done > aves_ID.txt #sintax to obtain unique ID of species. Between () there are patterns that we want to elaborate separated that are recalled through their position later. {n} is the number of time a particular pattern is repeated. within the fourth bracket with | we mean a logic or: one of our species presented a name with only three letters, so we had to specify other character after our matched pattern or the end of the row. 

#folder was then cleaned eliminating sorted file and unique_AN_aves.txt too since now we had a more complete one.
```

We used this IDs to change the names of the downloaded genome and gff files.

## AGAT (v1.2.0) and proteomes

Using [AGAT](https://github.com/NBISweden/AGAT), we filter and extract the [longest isoforms](https://agat.readthedocs.io/en/latest/tools/agat_sp_keep_longest_isoform.html) from the gff files. Then we [extracted](https://agat.readthedocs.io/en/latest/tools/agat_sp_extract_sequences.html) and translated from the genome these CDS using, again, AGAT.

```bash
for i in *_longest.gff; do agat_sp_extract_sequences.pl -g $i -f ${i/_longest.gff/}".fna" -t cds -p --cfs --output ${i/_longest.gff/}".faa"; done
# we mantained --cfs (--clean-final-stop) since we did not want to make explicit the end of proteins
```

### Renaming headers

As a good practise, we changed proteome headers (>species_ID|protein_ID) before starting program runs as Orthofinder, making easier to recognize sequences. We wrote a customed script able to elaborate all types of header present in GenBank, RefSeq or Ensambl genomes [change_proteome_headers](./Scripts/change_proteome_headers.sh).

### Pseudogenes

Even if we are using already annotated genomes, sometimes it happened that some sequences were not annotated at their best, and proteomes contained amino acids sequences that were interrupted (presence in their sequence of a `*` obtained from the option `--cfs`). As follows, it is important to eliminate these sequences, because they do not represent real CDS that can be used by the organism as proteins.

We then run the script ([pseudogene_find&eliminate](./Scripts/pseudogene_find&eliminate.sh)) that extracted only the names of sequences that presented at least one "\*", this only after having made every proteome oneliner, and removed these sequences from each proteome. In the end, the compelte proteome decreased its dimension to 2177028 proteins.

## BUSCO

To assess the quality of hte extracted and polished proteome we used BUSCO (5.4.2). When busco finished, we created a summary file with all our results with [busco_output](./Scripts/busco_output.sh).

```bash
busco -i <proteome> -o <proteome>_busco -m prot -l aves_odb10 -c <n_CPUs>
```

Since much more had a very good one, above 90% or even 95%, we knew that we could hope to use very polished proteomes. This lead  us to removing proteomes with BUSCO scores lower than 65%. We did this becase, with this threshold, we retained _Phoenicopterus ruber_. It was the bird with the highest LQ in our genome dataset. The list of removed species is:

- _Balaeniceps rex_
- _Cathartes aura_
- _Limosa lapponica_
- _Pandion haliaetus_
- _Podiceps cristatus_
- _Spizella passerina_
- _Thalassarche chlororhynchos_
- _Todus mexicanus_
