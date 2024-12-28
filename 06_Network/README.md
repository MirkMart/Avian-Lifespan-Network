# Lifespan network construction

## STRING

We explored lifespan genes (genes resulted significant after codeml analyses) using [STRING](https://string-db.org/), selecting _Calydrix Pygmeus_ as our reference organism.

We used ’databases’ and ’experiments’ as active interaction sources and ’high confidence (0.700)’ as the minimum required interaction score.

From the site, we retrieved the containing [all networks](./Files/net_notext_complete_pure.tsv) constructed using lifespan genes. We then [split it](./Files/multinet_lifespan.tsv) and filtered only the biggest one (the red one following the colour-code of STRING). Finally we further clustered genes in this last network (the one we named lifespan network) using the k-means algorithm in STRING ([net_biggest_k11](./Files/net_biggest_k11.tsv)).

## Cytoscape

All this information was uploaded into [Cytoscape](./Files/lifespan_network.cys) and processed both graphically and statistically.

### Metric analysis

The elaboration was performed on key metrics used to decribe a network, its topology, and the role each node could have in transferrinf information from one node to another (average shortest path length, clustering coefficient, closeness centrality, eccentricity, stress, degree, betweenness centrality, neighborhood connectivity, radiality, topological coefficient). We tested the differential contributions of genes to the network based on:

- different evolutionary forces (accelerated vs. constrained)
- association with distinct evolutionary traits (long-lived vs. short-lived)
- known roles in longevity regulation in other species (present vs. absent in the HAGR databases)
- whether the genes were shared between long-lived and short-lived species or specific to only one longevity phenotype.

To do so, we wrote a the following script [network_analyses.R](./Scripts/network_analyses.R) that use as input the table exported from Cytoscape after the network analysis.
