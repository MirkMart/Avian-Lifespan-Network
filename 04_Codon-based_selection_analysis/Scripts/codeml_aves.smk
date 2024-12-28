#This script aims to perform codeml analalyses for the longevity in aves project. We perfomed a 2 vs 2 model

LONG_CON = glob_wildcards("01_LL_trees/00_con/{long_con}.nwk")[0]
LONG_ACC = glob_wildcards("01_LL_trees/01_acc/{long_acc}.nwk")[0]
SHORT_CON = glob_wildcards("02_SL_trees/00_con/{short_con}.nwk")[0]
SHORT_ACC = glob_wildcards("02_SL_trees/01_acc/{short_acc}.nwk")[0]

rule all:
	input:
		"LRT_results.txt"

#LONG CON
rule long_con_ctl:
	input:
		config="codeml_snake.ctl",
		alignment="00_alignments/{long_con}_retro_masked2.fna",
		tree_10="01_LL_trees/02_con_terminal1/{long_con}.nwk",
		tree_120="01_LL_trees/00_con/{long_con}.nwk"
	output:
		ctl_10=temp("con_{long_con}_10.ctl"),
		ctl_120=temp("con_{long_con}_120.ctl")
	shell:
		"""
		seq=$(realpath {input.alignment} | sed 's/\\//\\\\\\//g')
		tree10=$(realpath {input.tree_10} | sed 's/\\//\\\\\\//g')
		tree120=$(realpath {input.tree_120} | sed 's/\\//\\\\\\//g')
		sed -E "s/SEQUENCE/$seq/; s/TREEFILE/$tree10/; s/OUTFILE/long_con\\/{wildcards.long_con}_10\\.txt/" {input.config} > {output.ctl_10}
		sed -E "s/SEQUENCE/$seq/; s/TREEFILE/$tree120/; s/OUTFILE/long_con\\/{wildcards.long_con}_120\\.txt/" {input.config} > {output.ctl_120}
		"""

rule long_con_10:
	input:
        "con_{long_con}_10.ctl"
	log:
		"log/{long_con}_10.log"
	output:
		"long_con/{long_con}_10.txt"
	shadow:
		"shallow"
	conda:
		"IQ_tree"
	shell:
		"codeml {input} > {log}"

rule long_con_120:
	input:
		"con_{long_con}_120.ctl"
	log:
		"log/{long_con}_120.log"
	output:
		"long_con/{long_con}_120.txt"
	shadow:
		"shallow"
	conda:
		"IQ_tree"
	shell:
		"codeml {input} > {log}"

rule long_con_LRT:
	input:
		long_con_120="long_con/{long_con}_120.txt",
		long_con_10="long_con/{long_con}_10.txt"
	output:
		temp("long_con_LRT/{long_con}_LRT.txt")
	conda:
		"Python"
	script:
		"LRT_snake.py"

#LONG ACC
rule long_acc_ctl:
	input:
		config="codeml.ctl",
		alignment="00_alignments/{long_acc}_retro_masked2.fna",
		tree_10="01_LL_trees/03_acc_terminal1/{long_acc}.nwk",
		tree_120="01_LL_trees/01_acc/{long_acc}.nwk"
	output:
		ctl_10=temp("acc_{long_acc}_10.ctl"),
		ctl_120=temp("acc_{long_acc}_120.ctl")
	shell:
		"""
		seq=$(realpath {input.alignment} | sed 's/\\//\\\\\\//g')
		tree10=$(realpath {input.tree_10} | sed 's/\\//\\\\\\//g')
		tree120=$(realpath {input.tree_120} | sed 's/\\//\\\\\\//g')
		sed -E "s/SEQUENCE/$seq/; s/TREEFILE/$tree10/; s/OUTFILE/long_acc\\/{wildcards.long_acc}_10\\.txt/" {input.config} > {output.ctl_10}
		sed -E "s/SEQUENCE/$seq/; s/TREEFILE/$tree120/; s/OUTFILE/long_acc\\/{wildcards.long_acc}_120\\.txt/" {input.config} > {output.ctl_120}
		"""

rule long_acc_10:
	input:
        	"acc_{long_acc}_10.ctl"
	log:
		"log/{long_acc}_10.log"
	output:
		"long_acc/{long_acc}_10.txt"
	shadow:
		"shallow"
	conda:
		"IQ_tree"
	shell:
		"codeml {input} > {log}"

rule long_acc_120:
	input:
		"acc_{long_acc}_120.ctl"
	log:
		"log/{long_acc}_120.log"
	output:
		"long_acc/{long_acc}_120.txt"
	shadow:
		"shallow"
	conda:
		"IQ_tree"
	shell:
		"codeml {input} > {log}"

rule long_acc_LRT:
	input:
		long_acc_120="long_acc/{long_acc}_120.txt",
		long_acc_10="long_acc/{long_acc}_10.txt"
	output:
		temp("long_acc_LRT/{long_acc}_LRT.txt")
	conda:
		"Python"
	script:
		"LRT_snake.py"

#SHORT CON
rule short_con_ctl:
	input:
		config="codeml.ctl",
		alignment="00_alignments/{short_con}_retro_masked2.fna",
		tree_10="02_SL_trees/02_con_terminal1/{short_con}.nwk",
		tree_120="02_SL_trees/00_con/{short_con}.nwk"
	output:
		ctl_10=temp("con_{short_con}_10.ctl"),
		ctl_120=temp("con_{short_con}_120.ctl")
	shell:
		"""
		seq=$(realpath {input.alignment} | sed 's/\\//\\\\\\//g')
		tree10=$(realpath {input.tree_10} | sed 's/\\//\\\\\\//g')
		tree120=$(realpath {input.tree_120} | sed 's/\\//\\\\\\//g')
		sed -E "s/SEQUENCE/$seq/; s/TREEFILE/$tree10/; s/OUTFILE/short_con\\/{wildcards.short_con}_10\\.txt/" {input.config} > {output.ctl_10}
		sed -E "s/SEQUENCE/$seq/; s/TREEFILE/$tree120/; s/OUTFILE/short_con\\/{wildcards.short_con}_120\\.txt/" {input.config} > {output.ctl_120}
		"""

rule short_con_10:
	input:
        	"con_{short_con}_10.ctl"
	log:
		"log/{short_con}_10.log"
	output:
		"short_con/{short_con}_10.txt"
	shadow:
		"shallow"
	conda:
		"IQ_tree"
	shell:
		"codeml {input} > {log}"

rule short_con_120:
	input:
		"con_{short_con}_120.ctl"
	log:
		"log/{short_con}_120.log"
	output:
		"short_con/{short_con}_120.txt"
	shadow:
		"shallow"
	conda:
		"IQ_tree"
	shell:
		"codeml {input} > {log}"

rule short_con_LRT:
	input:
		short_con_120="short_con/{short_con}_120.txt",
		short_con_10="short_con/{short_con}_10.txt"
	output:
		temp("short_con_LRT/{short_con}_LRT.txt")
	conda:
		"Python"
	script:
		"LRT_snake.py"

#SHORT ACC
rule short_acc_ctl:
	input:
		config="codeml.ctl",
		alignment="00_alignments/{short_acc}_retro_masked2.fna",
		tree_10="02_SL_trees/03_acc_terminal1/{short_acc}.nwk",
		tree_120="02_SL_trees/01_acc/{short_acc}.nwk"
	output:
        	ctl_10=temp("acc_{short_acc}_10.ctl"),
		ctl_120=temp("acc_{short_acc}_120.ctl")
	shell:
        	"""
        	seq=$(realpath {input.alignment} | sed 's/\\//\\\\\\//g')
		tree10=$(realpath {input.tree_10} | sed 's/\\//\\\\\\//g')
        	tree120=$(realpath {input.tree_120} | sed 's/\\//\\\\\\//g')
		sed -E "s/SEQUENCE/$seq/; s/TREEFILE/$tree10/; s/OUTFILE/short_acc\\/{wildcards.short_acc}_10\\.txt/" {input.config} > {output.ctl_10}
		sed -E "s/SEQUENCE/$seq/; s/TREEFILE/$tree120/; s/OUTFILE/short_acc\\/{wildcards.short_acc}_120\\.txt/" {input.config} > {output.ctl_120}
        	"""

rule short_acc_10:
	input:
		"acc_{short_acc}_10.ctl"
	log:
		"log/{short_acc}_10.log"
	output:
		"short_acc/{short_acc}_10.txt"
	shadow:
		"shallow"
	conda:
		"IQ_tree"
	shell:
		"codeml {input} > {log}"

rule short_acc_120:
	input:
		"acc_{short_acc}_120.ctl"
	log:
		"log/{short_acc}_120.log"
	output:
		"short_acc/{short_acc}_120.txt"
	shadow:
		"shallow"
	conda:
		"IQ_tree"
	shell:
		"codeml {input} > {log}"

rule short_acc_LRT:
	input:
		short_acc_120="short_acc/{short_acc}_120.txt",
		short_acc_10="short_acc/{short_acc}_10.txt"
	output:
		temp("short_acc_LRT/{short_acc}_LRT.txt")
	conda:
		"Python"
	script:
		"LRT_snake.py"

#FINAL
rule final_results:
	input:
		long_con=expand("long_con_LRT/{long}_LRT.txt", long=LONG_CON),
		long_acc=expand("long_acc_LRT/{long_acc}_LRT.txt", long_acc=LONG_ACC),
		short_con=expand("short_con_LRT/{short_con}_LRT.txt", short_con=SHORT_CON),
		short_acc=expand("short_acc_LRT/{short_acc}_LRT.txt", short_acc=SHORT_ACC)                
	output:
		"LRT_results.txt"
	shell:
		"""
		echo -e "Orthogroup\\tTrait\\tTRACCER\\tH1likelihood\\tH0likelihood\\tp-value\\tsignificance\\tw0(anc)\\tw1(fore)\\tw2(back)\\tdeltaw" > {output}
		cat {input} >> {output}
		"""

