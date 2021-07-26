#!/usr/bin/env python
import sys, re
argvs = sys.argv
import os
import numpy as np
import pandas as pd
pd.set_option("display.max_colwidth", 20)
pd.set_option("display.max_columns", 20)
pd.set_option("display.max_rows", 300)

import matplotlib
import matplotlib.pyplot as plt
import matplotlib as mpl
fm = mpl.font_manager
import seaborn as sns

dpi=300
wide = 1920
height = 1080

# input
in_f = argvs[1]
out_f = argvs[2]

# dataframe
df = pd.read_csv(in_f, sep="\t", names=["chrom", "position","read"])
df = df.astype({"position": int, "read": int})


# visualization
import matplotlib.patches as mpatches

plt.rcParams['font.family'] = "Arial"
plt.rcParams['font.size'] = 10
dpi=300
wide=2000
height = 1000

fig = plt.figure(figsize=(wide/dpi, height/dpi))

plt.bar(df["position"], df["read"] , width=1.0)

plt.tight_layout()

plt.savefig(out_f, dpi=300, bbox_inches="tight")





