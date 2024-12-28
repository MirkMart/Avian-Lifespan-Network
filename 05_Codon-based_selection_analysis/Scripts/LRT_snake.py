from scipy.stats import chi2
import re
import os

#extract the directory name in order to know characteristic of the orthogroup analysed
directory = os.path.dirname(snakemake.input[0])

#from the full model result, extract the likelihood, the numbero fo degrees of freedom, and the three values of omega inferred
def full_likelihood(full_model):
	with open(full_model, "r") as file:
		for line in file:
			if "lnL" in line:
				line_lnL = line.rstrip()
			elif "(dN/dS) for branches" in line:
				line_w = line.rstrip()	
	
	pattern = r"[-+]?\d*\.\d+|\d+"
	#set the following variables as global ones, so other functions can access to them
	global likefull, paramfull, w0, w1, w2
	likefull = float(re.findall(pattern, line_lnL)[2])
	paramfull = int(re.findall(pattern, line_lnL)[1])
	w0 = float(re.findall(pattern, line_w)[0])
	w1 = float(re.findall(pattern, line_w)[1])
	w2 = float(re.findall(pattern, line_w)[2])

#from the reduced model result extract the likelihood
def reduced_likelihood(reduced_model):
	with open(reduced_model, "r") as file:
		for line in file:
			if "lnL" in line:
				line_lnL = line.rstrip()
				break
	
	pattern = r"[-+]?\d*\.\d+|\d+"
	global likered, paramredu
	likered = float(re.findall(pattern, line_lnL)[2])
	paramredu = int(re.findall(pattern, line_lnL)[1])

#perform the LRT writing the result in a specific file with all the values worthy to be successively nalysed 
def LRT(likefull, likered, doffull, dofred, outfile, wildcard, directory, w0, w1, w2):
	p_val = "{:.2e}".format(chi2.sf(2*(likefull-likered),(doffull-dofred)))
	significance = "Significant" if float(p_val) <= 0.05 else "Not significant"
	trait = "SL" if "short" in directory else  "LL"
	traccer = "accelerated" if "acc" in directory else "constrained"
	deltaw = round(w1 - w2, 5)
	with open(outfile, "a") as file:
		file.write(f"{wildcard}\t{trait}\t{traccer}\t{likefull}\t{likered}\t{p_val}\t{significance}\t{w0}\t{w1}\t{w2}\t{deltaw}\n")

full_likelihood(snakemake.input[0])
reduced_likelihood(snakemake.input[1])
LRT(likefull, likered, paramfull, paramredu, snakemake.output[0], snakemake.wildcards, directory, w0, w1, w2)
