# Detailed results

| | All | Acc | Con |
|:-|-|-|-|
| p values |![LQLL20_pvalues](../00_R/00_Plots/TRACCER/LQLL20_pvalues.png)|![LQLL20ac_pvalues](../00_R/00_Plots/TRACCER/LQLL20ac_pvalues.png)|![LQLL20co_pvalues](../00_R/00_Plots/TRACCER/LQLL20co_pvalues.png)|
| FDR |![LQLL20_FDR](../00_R/00_Plots/TRACCER/LQLL20_FDR.png)|![LQLL20ac_FDR](../00_R/00_Plots/TRACCER/LQLL20ac_FDR.png)|![LQLL20co_FDR](../00_R/00_Plots/TRACCER/LQLL20co_FDR.png)|
| FDRp |![LQLL20_FDRp](../00_R/00_Plots/TRACCER/LQLL20_FDRp.png)|![LQLL20ac_FDRp](../00_R/00_Plots/TRACCER/LQLL20ac_FDRp.png)|![LQLL20co_FDRp](../00_R/00_Plots/TRACCER/LQLL20co_FDRp.png)|

- LQLL20

  - p-values (569): there is no particular evidence for enriched significant p-values for foreground genes compared to the control group. There are a few spikes but nothing that seems to be a particular trend.
  - FDR (1): surely there is a different pattern of distribution for false discovery rates. control and foreground overlapped only for a few values, foreground presented a great peak around 1.0 and a long tail on smaller values. in this case, LQLL20 is the only set of genes that present a significant q-value (0.03136311) for the orthogroup OG0004626_x00. It, probably, contains the sequence of an associated heat shock protein.
  - FDR significant p-values. Again, the distribution is different, with a gap that separates most of the foreground FDR values, that are below 1.0, from the control group ones, above 1.0.

  - accelerated p-values (217): going deeper into accelerated genes did not highlight a better distribution of significant p-values. Again, only a few spikes were present, but there was not the distribution we expected.
  - accelerated FDR: same distribution of the general one
  - accelerated FDR significant p-values: same distribution as the general one. maybe even wider the gap

  - constrained p-values (352): as in accelerated, neither constrained p-values manifested a particular p-values structure. Interestingly, in this case, control ones presented a more important present in the higher part of the plot, while foreground p-values decreased to 0.
  - constrained FRD: same distribution of the general one. Controls seem to be more right-skewed.
  - constrained FDR significant p-values: same distribution as the general one. maybe even wider the gap. Maybe, controls are more rigth-skewed.

| | All | Acc | Con |
|:-|-|-|-|
| p values |![3L_pvalues](../00_R/00_Plots/TRACCER/3L_pvalues.png)|![3Lac_pvalues](../00_R/00_Plots/TRACCER/3Lac_pvalues.png)|![3Lco_pvalues](../00_R/00_Plots/TRACCER/3Lco_pvalues.png)|
| FDR |![3L_FDR](../00_R/00_Plots/TRACCER/3L_FDR.png)|![3Lac_FDR](../00_R/00_Plots/TRACCER/3Lac_FDR.png)|![3Lco_FDR](../00_R/00_Plots/TRACCER/3Lco_FDR.png)|
| FDRp |![3L_FDRp](../00_R/00_Plots/TRACCER/3L_FDRp.png)|![3Lac_FDRp](../00_R/00_Plots/TRACCER/3Lac_FDRp.png)|![3Lco_FDRp](../00_R/00_Plots/TRACCER/3Lco_FDRp.png)|

- 3L

  - p-values (1136): it is evident an interesting pattern that shows enriched significant p-values for foreground genes compared to the control group. The graph exhibits a slow decrease in p-values for the foreground from the most significant to the threshold 0.05 where is present an abrupt drop right after the significance limit.
  - FDR: again, there is a clear difference in the pattern between foreground species and control ones. This time it is reversed to the one observable in the LQLL20 attempt: control presents a great spike that accumulate quite every value above 1.0, while the foreground presents a distribution importantly left-skewed with every value above 1.0.
  - FDR significant p-values: the two distributions, again, do not overlap with each other, but they are not so contrasting as they are for total FDRs. This time, the control one is a little bit more right-skewed with every value, again, above 1.0, while the foreground one is all below 0.5 and presents a more compact distribution with higher counts.

  - accelerated p-values (332): the interesting distribution observed in general p-values is quite totally lost when only genes inferred as accelerated are studied. This distribution is more similar to the one observed for LQLL20 with some spikes of the foreground but not a real trend. Going deeper, a vague enrichment in significant p-values is observable below 0.025 with the greatest count of them in the very first bin. Speaking of numbers, significantly accelerated genes are only 29% of all the significant ones.
  - accelerated FDR: the distribution is similar to that of genes, with the one of foreground even more left-skewed.
  - accelerated FDR significant p-values: again the distribution is similar to the one of all genes. In this case, it is more evident that the center of the distribution of the foreground is around 0.4. The control is less dispersed in higher values of the graph.

  - constrained p-values (804): the promising and interesting distribution reappears studying constrained genes. This could mean it is it that drags the pattern that is observable taking into account all genes. As before, there is a little decrease from left to right, going closer and closer to the significance limit. Here, again, is present the sudden drop that separates the interesting part from the not one. Speaking of numbers, 70% of the significant genes are constrained ones.
  - constrained FRD: the distribution is the same of accelerated genes.
  - constrained FDR significant p-values: the distribution is the same of accelerated genes.

| | All | Acc | Con |
|:-|-|-|-|
| p values |![ELL_pvalues](../00_R/00_Plots/TRACCER/ELL_pvalues.png)|![ELLac_pvalues](../00_R/00_Plots/TRACCER/ELLac_pvalues.png)|![ELLco_pvalues](../00_R/00_Plots/TRACCER/ELLco_pvalues.png)|
| FDR |![ELL_FDR](../00_R/00_Plots/TRACCER/ELL_FDR.png)|![ELLac_FDR](../00_R/00_Plots/TRACCER/ELLac_FDR.png)|![ELLco_FDR](../00_R/00_Plots/TRACCER/ELLco_FDR.png)|
| FDRp |![ELL_FDRp](../00_R/00_Plots/TRACCER/ELL_FDRp.png)|![ELLac_FDRp](../00_R/00_Plots/TRACCER/ELLac_FDRp.png)|![ELLco_FDRp](../00_R/00_Plots/TRACCER/ELLco_FDRp.png)|

- ELL

  - p-values (1122): the interesting pattern is present in this graph too, this time maybe even more emphatic. It seems that in the rightest part of the distribution, where are present the most significant p-values, the difference between foreground and control is greater than the one observable in the analogous 3L graph, even though we are maybe speaking about a small number of counts. Surely, the overlap between the two colors is more observable at the right of the significance threshold.
  - FDR: the distribution is similar to the 3L analogous one, with control that presents a great tail with very few counts per bin and a great structure, now, right before 1.0. The foreground is importantly left-skewed and this time overlaps a little bit more with control.
  - FDR significant p-values. the structure is the same as the 3L one, with the two groups importantly different. In this case, it is observable how the space between the two is populated by small control bins, maybe it happens in the other graphs but the counts are so few that they are not visible.

  - accelerated p-values (368): starting from numbers, again we can observe a great disproportion between the accelerated and constrained genes (33% and 67% respectively). As before, the evident greater presence of significant p-values for all genes in foreground species is lost when looking at accelerated genes, only before 0.025/0.020 there is an important portion of p-values that differentiate control from the foreground. Again, the tallest bin is the first, the most significant.
  - accelerated FDR: The distribution is similar to the general one. In this case, the tail of the foreground seems longer and the overlap is smaller.
  - accelerated FDR significant p-values: the distribution is the same as the general one. Again there are no visible bins in the space that separates the control and the foreground.

  - constrained p-values (754): the greater number of constrained genes again maintains the distribution as we can see with all genes. Here, the control keeps a low skyline that allows the foreground to manifest itself a little bit even at the right of the significance limit.
  - constrained FRD: the pattern is similar to the general one, but the overlap is even greater than the one in accelerated genes.
  - constrained FDR significant p-values: again we can observe a few bins in the space between the two distributions. In this case, the counts for the foreground are higher than the ones for the control.

| | All | Acc | Con |
|:-|-|-|-|
| p values |![MLS_pvalues](../00_R/00_Plots/TRACCER/MLS_pvalues.png)|![MLSac_pvalues](../00_R/00_Plots/TRACCER/MLSac_pvalues.png)|![MLSco_pvalues](../00_R/00_Plots/TRACCER/MLSco_pvalues.png)|
| FDR |![MLS_FDR](../00_R/00_Plots/TRACCER/MLS_FDR.png)|![MLSac_FDR](../00_R/00_Plots/TRACCER/MLSac_FDR.png)|![MLSco_FDR](../00_R/00_Plots/TRACCER/MLSco_FDR.png)|
| FDRp |![MLS_FDRp](../00_R/00_Plots/TRACCER/MLS_FDRp.png)|![MLSac_FDRp](../00_R/00_Plots/TRACCER/MLSac_FDRp.png)|![MLSco_FDRp](../00_R/00_Plots/TRACCER/MLSco_FDRp.png)|

- MLS

  - p-values (1041): the pattern observed in 3L and ELL groups is observable in this case too, maybe, a little bit less strong even though it seems to decrease slower than in the other graphs, and after 0.05 we can still observe a great proportion of the foregorund.
  - FDR: the distribution is the same as the 3L and ELL ones.
  - FDR significant p-values: the distribution is the same as the other graphs.

  - accelerated p-values (351): again, accelerated genes are those that lose the pattern observable in the general graph. In this case, it is really difficult to observe even a small portion of interesting genes in foreground species if compared to the control ones: the first bin is more populated by control p-values and also many of the following ones.
  - accelerated FDR: the distribution is similar to the general one.
  - accelerated FDR significant p-values: again, the distribution is similar to the general one.

  - constrained p-values (690): the genes that are significant in this case are 66% of the total. Even if the proportion is smaller than others, the pattern of enriched foreground significant p-values is importantly evident. control is really small while the foreground presents high counts up to the significance limit.
  - constrained FRD: the distribution is the same as the general one.
  - constrained FDR significant p-values: the distribution is the same as the general one.

| | All | Acc | Con |
|:-|-|-|-|
| p values |![LQSL_pvalues](../00_R/00_Plots/TRACCER/LQSL_pvalues.png)|![LQSLac_pvalues](../00_R/00_Plots/TRACCER/LQSLac_pvalues.png)|![LQSLco_pvalues](../00_R/00_Plots/TRACCER/LQSLco_pvalues.png)|
| FDR |![LQSL_FDR](../00_R/00_Plots/TRACCER/LQSL_FDR.png)|![LQSLac_FDR](../00_R/00_Plots/TRACCER/LQSLac_FDR.png)|![LQSLco_FDR](../00_R/00_Plots/TRACCER/LQSLco_FDR.png)|
| FDRp |![LQSL_FDRp](../00_R/00_Plots/TRACCER/LQSL_FDRp.png)|![LQSLac_FDRp](../00_R/00_Plots/TRACCER/LQSLac_FDRp.png)|![LQSLco_FDRp](../00_R/00_Plots/TRACCER/LQSLco_FDRp.png)|

- LQSL
  - p-values (614): in this case, it is not so evident an interesting pattern as it is in other graphs. A little enrichment seems to be present at the very beginning of the x-axis, the lowest p-values, and around the significance threshold. Unfortunately, the foreground counts are not very high and sometimes the control is higher in some bins. Speaking of numbers, this is one of the smallest groups.
  - FDR: the distribution is the same as precedent graphs.
  - FDR significant p-values: the distribution is similar to other graphs, but in this case, everything seems to be translated to the left. Moreover, small bins of control FDRs are present in the left part of the graph, overlapping the foreground distribution. The latter is always the closer to the significance limit.

  - accelerated p-values (183): the pattern is completely absent from this graph. Accelerated genes do not present an enrichment in p-values for any genes and the distribution does not differ from a casual control.
  - accelerated FDR: this graph is similar to the general one.
  - accelerated FDR significant p-values: in this case, the pattern is different than the general one. Again the two distributions are separated by a blank space and some small bins of control FRDs are present in it and even more to the left. Then, it is difficult to say if the control distribution is more left or right-skewed since the tails are quite long. This distribution is also the greater one, since the foreground is, in this case, separated into two smaller chunks of bins that are positioned around 0.9 (control is higher, around 1.2).

  - constrained p-values (431): The proportion of genes in this group seems to be greater than in other groups, but is around 70%. Maybe this is a bias due to the low number of significant genes in general. Here it seems to present the pattern that we observed in other graphs too, and there is an important enrichment in p-values for constrained genes in foreground species. In this case, there is no slow decrease in p-values from 0.00 to 0.05 but the foreground is stably higher than the control for the entire graph portion but a couple of bins.
  - constrained FRD: the distribution is the same as the general one.
  - constrained FDR significant p-values: the distribution is similar to the general one, differently than the accelerated one, and presents greater counts in foregrounds FDR bins.

| | All | Acc | Con |
|:-|-|-|-|
| p values |![MLSSL_pvalues](../00_R/00_Plots/TRACCER/MLSSL_pvalues.png)|![MLSSLac_pvalues](../00_R/00_Plots/TRACCER/MLSSLac_pvalues.png)|![MLSSLco_pvalues](../00_R/00_Plots/TRACCER/MLSSLco_pvalues.png)|
| FDR |![MLSSL_FDR](../00_R/00_Plots/TRACCER/MLSSL_FDR.png)|![MLSSLac_FDR](../00_R/00_Plots/TRACCER/MLSSLac_FDR.png)|![MLSSLco_FDR](../00_R/00_Plots/TRACCER/MLSSLco_FDR.png)|
| FDRp |![MLSSL_FDRp](../00_R/00_Plots/TRACCER/MLSSL_FDRp.png)|![MLSSLac_FDRp](../00_R/00_Plots/TRACCER/MLSSLac_FDRp.png)|![MLSSLco_FDRp](../00_R/00_Plots/TRACCER/MLSSLco_FDRp.png)|

- MLSSL
  - p-values (878): in this graph, we can again observe an interesting distribution where foreground p-values are enriched for significant values. There are two great groups separated by a couple of control bins around 0.030, but surely in the first, the pattern is more evident, particularly in the most significant p-values (the ones more to the left). As for others, there is a decrease in counts from the left to the right, but in this interval, from the second significant group, the counts seem to maintain a stabilized mean and do not go lower than the control.
  - FDR: the distribution is similar to the other graphs.
    FDR significant p-values. the distribution seems similar to the others: greater counts for the foreground than the control and small bins for both distributions that populate the blank space to their left, respectively, with a very minimal overlap for the farthest control bins.

  - accelerated p-values (463): for the first time, the accelerated distribution shows an interesting pattern too. In this case, the significant genes are equally distributed between the two types of genes, meaning, maybe, that a great number of genes is not necessary to highlight a particular structure. The decrease seems to be stretched, so, at the significance limit, the counts are still higher than the control ones.
  - accelerated FDR: the distribution is similar to the control one.
  - accelerated FDR significant p-values: the distribution is similar to the control one.

  - constrained p-values (415): in this case too we can observe a portion of the graph with an interesting pattern. In fact, the more significant one, below 0.025, is enriched for foreground species. Then, this distribution disappears and the control gets higher in counts, reaching the foreground that equally decreases from left to right.
  - constrained FRD: the distribution is similar to the general one. It seems there are no overlapping bins between the two groups.
  - constrained FDR significant p-values: the distribution is similar to the general one.

| | All | Acc | Con |
|:-|-|-|-|
| LQLL15  |![LQLL15_pvalues](../00_R/00_Plots/TRACCER/LQLL15_pvalues.png)|![LQLL15ac_pvalues](../00_R/00_Plots/TRACCER/LQLL15ac_pvalues.png)|![LQLL15co_pvalues](../00_R/00_Plots/TRACCER/LQLL15co_pvalues.png)|
| LQLL175 |![LQLL175_FDR](../00_R/00_Plots/TRACCER/LQLL175_pvalues.png)|![LQLL175ac_FDR](../00_R/00_Plots/TRACCER/LQLL175ac_pvalues.png)|![LQLL175co_FDR](../00_R/00_Plots/TRACCER/LQLL175co_pvalues.png)|

- LQLL15 and LQLL175
  - LQLL175: in this case, there is no particular pattern in the distribution of p-values in none of the three graphs.
  - LQLL15: amusingly, the pattern we were expecting is reversed, and the control group is the one with enrichment in significant p-values. As for the other distribution, this pattern is not observable for accelerated genes, but for constrained ones where it is quite strong. Speaking of numbers, the total control significant genes are 646, accelerated genes are 204, and constrained genes are 442. This follows the proportion that is observable in the other studied groups.

The all following tables talk about significant genes.

|              |  3L  |  ELL |  MLS | LQLL20 | LQSL | MLSSL |
|:-------------|:----:|:----:|:----:|:------:|:----:|:-----:|
|    general   | 1136 | 1122 | 1041 |   569  |  614 |  878  |
|  accelerated |  332 |  368 |  351 |   217  |  183 |  463  |
|  constrained |  804 |  754 |  690 |   352  |  431 |  415  |

Constrained gene overlap

| Groups   |     | ELL |  3L | MLS(4th) | LQLL20 | LQLL175 | LQLL15 |
|----------|:---:|:---:|:---:|:--------:|:------:|:-------:|:------:|
|          |     | 754 | 804 |    690   |   352  |   285   |   221  |
| ELL      | 754 |  -  | 189 |    545   |   65   |    53   |   29   |
| 3L       | 804 | 189 |  -  |    131   |   25   |    12   |    4   |
| MLS(4th) | 690 | 545 | 131 |     -    |   72   |    59   |   43   |
| LQLL20   | 352 |  65 |  25 |    72    |    -   |   154   |   75   |
| LQLL175  | 285 |  12 |  12 |    59    |   165  |    -    |   103  |
| LQLL15   | 221 |  4  |  4  |    43    |   75   |   103   |    -   |

Accelerated gene overlap

| Groups   |     | ELL |  3L | MLS(4th) | LQLL20 | LQLL175 | LQLL15 |
|----------|:---:|:---:|:---:|:--------:|:------:|:-------:|:------:|
|          |     | 368 | 332 |    351   |   217  |   183   |   164  |
| ELL      | 368 |  -  |  12 |    252   |   27   |    17   |   11   |
| 3L       | 332 |  12 |  -  |    18    |    4   |    1    |    0   |
| MLS(4th) | 351 | 252 |  18 |     -    |   28   |    23   |   16   |
| LQLL20   | 217 |  27 |  4  |    28    |    -   |    75   |   39   |
| LQLL175  | 183 |  17 |  1  |    23    |   75   |    -    |   78   |
| LQLL15   | 164 |  11 |  0  |    16    |   39   |    78   |    -   |

Observing the last two tables, we can see that 3L is the groups that present the greater number of significantly constrained genes, while ELL has the accelerated one. Focusing on constrained genes, the overlap between 3L and ELL is small, while the one between ELL and MLS is close to the totality of MLS-inferred genes. This confirms the similarity that characterizes these two groups, even if ELL produced a more extensive output. LQLL groups are tiny in numbers, both constrained and accelerated, and the most remarkable overlaps are between each other, while it seems they have small in common with different groups.

Going deeper into the overlap groups, considering the two different selective pressures, 'accelerated' and 'constrained'.

|           | Constrained |       | Accelerated |       |
|-----------|-------------|-------|-------------|-------|
|           |    MLS LS   | LQ SL |    MLS LS   | LQ SL |
| MLS LL    |      0      |       |      0      |       |
| LQ LL 20  |             |   10  |             |   2   |
| LQ LL 175 |             |   6   |             |   2   |
| LQ LL 150 |             |   5   |             |   0   |

In this way, we can appreciate that there is not a single gene overlapping between MLS short-lived and MLS  long-lived when they are concordant with the evolutionary behavior. At the same time, it is present, even if minor, between the LQLL and LQSL conditions. This could mean that, practically, no genes present the same type of evolution in opposite longevity patterns.

Instead, if we observe different evolutionary behaviors in opposite labels, we can see that, again, LQ is not particularly interesting, while MLS is much more because there are genes that exhibit opposite behaviors in opposite groups.

|                  | MLSLL accelerated |   |                  | MLSSL accelerated |
|:----------------:|:-----------------:|---|:----------------:|:-----------------:|
| MLSL constrained |        118        |   | MLLL constrained |        193        |

|                     | LQSL accelerated |   |                     | LQSL constrained |
|:-------------------:|:----------------:|:-:|:-------------------:|:----------------:|
| LQLL20 contrained   |         9        |   |  LQLL20 accelerated |        13        |
| LQLL175 constrained |         4        |   | LQLL175 accelerated |         9        |
| LQLL150 constrained |         3        |   |  LQLL15 accelerated |        12        |

To assess if there were more genes than expected in these cross-references, we performed a [chi-squared test](./chi_squared_overlap_acc_con.xlsx).
