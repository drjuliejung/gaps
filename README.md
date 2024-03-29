---
title: "gaps"
author: "Julie Jung"
date: "Jan 26th, 2022"
output:
  pdf_document: default
  html_document:
    df_print: paged
editor_options: 
  chunk_output_type: console
---

Presented here is the data analysis from our gaps experiment, conducted 2013 to 2017 and published in Animal Cognition in 2022. If any of this code and/or analysis proves helpful to you, please cite our paper: 

Julie Jung, Ming Guo, Mark E. Crovella, J. Gregory McDaniel, and Karen M. Warkentin. Frog embryos use multiple levels of temporal pattern in risk assessment for vibration-cued escape hatching. Animal Cognition (2022). https://doi.org/10.1007/s10071-022-01634-4

# load libraries

```{r, warnings=F, echo=T, results='hide'}
library(here)
library(openxlsx)
library(janitor)
library(ggplot2)
library(ggbeeswarm)
library(cowplot)
library(MASS)
library(multcomp)
library(stargazer)
library(knitr)
library(tidyr)
library(dplyr)
library(sciplot) 
library(aod)
library(lme4)
library(dunn.test)
library(DescTools) #dunnett's test
library(R.matlab)
library(car)
```

#FFTs

These frequences are in Hz and from what Ming called "stim 16" and what I call the "base pattern" stimulus. 

```{r}
FFT.df <- read.xlsx(xlsxFile="raw_data.xlsx", sheet="FFTs", stringsAsFactors = TRUE)
```

```{r}
widerFFTs <- FFT.df %>% 
  pivot_longer(-Frequencies, names_to = "Treatment", values_to = "Amps")

str(widerFFTs)
max(widerFFTs$Amps)
```

```{r}
StimColors <- c("black", "red")

Stim_fig <- ggplot(data=widerFFTs, aes(x=Frequencies, y=Amps, color=Treatment)) +
  geom_line(size=1) +
  scale_y_continuous(limits=c(50, 85),
                     breaks=c(84.58859-40, 84.58859-30, 84.58859-20, 84.58859-10, 84.58859), 
                     labels=c("-40", " ", "-20", " ", "0"))+
  scale_x_continuous(limits=c(0, 200),
                     breaks=c(0, 50, 100, 150, 200),
                     labels=c("0", " ", "100", " ", "200"))+
  labs(x = "Frequency (Hz)",
       y = "Relative amplitude (dB)") +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  theme_cowplot(font_size = 12, line_size = 1, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=12, colour= "black")) +
  theme(axis.text.x=element_text(size=12, colour= "black")) +
  theme(axis.title.x=element_text(size=12, colour = "black")) +
  theme(axis.title.y=element_text(size=12, colour = "black")) +
  theme(legend.justification = c(1, 1), legend.position = c(0.9, 0.7), legend.text=element_text(size=12)) +
  scale_colour_manual(name=Treatment,
                      values=StimColors,
                      aesthetics = "colour",
                      guide="legend") +
  theme(legend.position = "NONE") +
  annotate("text", x = 160, y = 62, size=4, color="black", label = "Tines")+
  annotate("text", x = 130, y = 55, size=4, color="red", label = "Tray")
Stim_fig
```

```{r}
ggsave("~/Desktop/StimFig_v2.pdf", 
 plot = Stim_fig, # or give ggplot object name as in myPlot,
 width = 18, height = 10, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 300, 
 useDingbats=FALSE)
```

# stimulus fig (exp1)

Note: The stimulus names in this file are slightly confusing and I apologize for that. It's because Ming Guo had different names for the stimuli initially (stim16 for base pattern, stim21 for primer only, etc.), and at first I renamed the stimuli letters (A-D for Experiment I) before deciding in the paper to have more descriptive names... I probably could have changed all the file names here but for fear of mucking something up accidentally I shall leave that up to you good folks. 

```{r}
library(tuneR)
stimA<- readWave('stimulus_21-primer_only.wav') 
stimB<-readWave('stimulus_17-little_bursts.wav') 
stimC<- readWave('stimulus_16-base_pattern.wav')
stimD<- readWave('stimulus_22-30s_gap.wav')
```

```{r}
str(stimA) # the wav file has one channel (@left) containing 132300 sample points each
str(stimB) #6725250
str(stimC) #6615000
str(stimD) #7375725

# extract signal
sA<- stimA@left #we’ll select and work only with one of the channels from now onwards
sB <- stimB@left
sC <- stimC@left
sD <- stimD@left

# determine duration
#can use str() to calculate duration = sample points / sample rate 
length(sA)/stimA@samp.rate #6 s
length(sB)/stimB@samp.rate #305 s
length(sC)/stimC@samp.rate #300 s
length(sD)/stimD@samp.rate #334.5 s
```

```{r}
#If our wav file has a 16-bit depth (train_audio@bit), this means that the sound pressure values are mapped to integer values that can range from -2^¹⁵ to (2^¹⁵)-1.
#convert our sound array to floating point values ranging from -1 to 1 as follows:
sA <- sA / 2^(stimA@bit -1)
sB <- sB / 2^(stimB@bit -1)
sC <- sC / 2^(stimC@bit -1)
sD <- sD / 2^(stimD@bit -1)

 #Create an array containing the time points first:
sA.timeArray <- (0:(length(sA)-1)) / stimA@samp.rate
sB.timeArray <- (0:(length(sB)-1)) / stimB@samp.rate
sC.timeArray <- (0:(length(sC)-1)) / stimC@samp.rate
sD.timeArray <- (0:(length(sD)-1)) / stimD@samp.rate

sA.df<- data.frame(sA.timeArray, sA)
sB.df<- data.frame(sB.timeArray, sB)
sC.df<- data.frame(sC.timeArray, sC)
sD.df<- data.frame(sD.timeArray, sD)
```

A time representation of the sound can be obtained by plotting the pressure values against the time axis.

```{r}
# demean to remove DC offset
sA = sA - mean(sA)
sB = sB - mean(sB)
sC = sC - mean(sC)
sD = sD - mean(sD)

# plot waveform
sAfig<- plot(sA, type = 'l', xlab = 'Samples', ylab = 'Amplitude', xlim=c(0,length(sA)))
sBfig<- plot(sB, type = 'l', xlab = 'Samples', ylab = 'Amplitude', xlim=c(0,length(sB)))
sCfig<- plot(sC, type = 'l', xlab = 'Samples', ylab = 'Amplitude', xlim=c(0,length(sC)))
sDfig<- plot(sD, type = 'l', xlab = 'Samples', ylab = 'Amplitude', xlim=c(0,length(sD)))
```

```{r}
sA.sub<-sA.df[seq(1, nrow(sA.df), 500), ] #take every 500 rows
sB.sub<-sB.df[seq(1, nrow(sB.df), 500), ] #take every 500 rows
sC.sub<-sC.df[seq(1, nrow(sC.df), 500), ] #take every 500 rows
sD.sub<-sD.df[seq(1, nrow(sD.df), 500), ] #take every 500 rows
```

```{r}
sAfig <- ggplot(data=sA.sub, aes(x=sA.timeArray, y=sA)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 360),
                     breaks=c(0, 60, 120, 180, 240, 300, 360), 
                     labels=c("0", "60", "120", "180", "240", "300", "360"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

sAfig
```

```{r}
sBfig<- ggplot(data=sB.sub, aes(x=sB.timeArray, y=sB)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 360),
                     breaks=c(0, 60, 120, 180, 240, 300, 360), 
                     labels=c("0", "60", "120", "180", "240", "300", "360"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

sBfig
```

```{r}
sCfig <- ggplot(data=sC.sub, aes(x=sC.timeArray, y=sC)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 360),
                     breaks=c(0, 60, 120, 180, 240, 300, 360), 
                     labels=c("0", "60", "120", "180", "240", "300", "360"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

sCfig
```

```{r}
sDfig <- ggplot(data=sD.sub, aes(x=sD.timeArray, y=sD)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 360),
                     breaks=c(0, 60, 120, 180, 240, 300, 360), 
                     labels=c("0", "60", "120", "180", "240", "300", "360"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

sDfig
```

combine plots 
```{r}
Exp1_stimuli <- plot_grid(sAfig, sBfig, sCfig, sDfig, labels = "AUTO", axis = "br", ncol = 1, nrow=4, align = 'v')

ggsave("~/Desktop/Exp1_stimuli_v2.pdf", 
 plot = Exp1_stimuli, # or give ggplot object name as in myPlot,
 width = 18, height = 20, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 300, 
 useDingbats=FALSE)
```

#stimulus fig (exp2)
```{r}
stimC<- readWave('stimulus_16-base_pattern.wav')
stimE<- readWave('stimulus_27-3bursts.wav') 
stimF<-readWave('stimulus_28-10bursts.wav') 
```

```{r}
str(stimC) # the wav file has one channel (@left) containing 6615000 sample points each
str(stimE) #6945750
str(stimF) #6824475

# extract signal
sC<- stimC@left #we’ll select and work only with one of the channels from now onwards
sE <- stimE@left
sF <- stimF@left

# determine duration
#can use str() to calculate duration = sample points / sample rate 
length(sC)/stimC@samp.rate #300 s
length(sE)/stimE@samp.rate #315 s
length(sF)/stimF@samp.rate #309.5 s
```

```{r}
#If our wav file has a 16-bit depth (train_audio@bit), this means that the sound pressure values are mapped to integer values that can range from -2^¹⁵ to (2^¹⁵)-1.
#convert our sound array to floating point values ranging from -1 to 1 as follows:
sC <- sC / 2^(stimC@bit -1)
sE <- sE / 2^(stimE@bit -1)
sF <- sF / 2^(stimF@bit -1)

 #Create an array containing the time points first:
sC.timeArray <- (0:(length(sC)-1)) / stimC@samp.rate
sE.timeArray <- (0:(length(sE)-1)) / stimE@samp.rate
sF.timeArray <- (0:(length(sF)-1)) / stimF@samp.rate

sC.df<- data.frame(sC.timeArray, sC)
sE.df<- data.frame(sE.timeArray, sE)
sF.df<- data.frame(sF.timeArray, sF)
```

A time representation of the sound can be obtained by plotting the pressure values against the time axis.

```{r}
# demean to remove DC offset
sC = sC - mean(sC)
sE = sE - mean(sE)
sF = sF - mean(sF)
```

```{r}
sC.sub<-sC.df[seq(1, nrow(sC.df), 500), ] #take every 500 rows
sE.sub<-sE.df[seq(1, nrow(sE.df), 500), ] #take every 500 rows
sF.sub<-sF.df[seq(1, nrow(sF.df), 500), ] #take every 500 rows
```

```{r}
sCfig <- ggplot(data=sC.sub, aes(x=sC.timeArray, y=sC)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 360),
                     breaks=c(0, 60, 120, 180, 240, 300, 360), 
                     labels=c("0", "60", "120", "180", "240", "300", "360"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

sCfig
```

```{r}
sEfig <- ggplot(data=sE.sub, aes(x=sE.timeArray, y=sE)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 360),
                     breaks=c(0, 60, 120, 180, 240, 300, 360), 
                     labels=c("0", "60", "120", "180", "240", "300", "360"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

sEfig
```


```{r}
sFfig<- ggplot(data=sF.sub, aes(x=sF.timeArray, y=sF)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 360),
                     breaks=c(0, 60, 120, 180, 240, 300, 360), 
                     labels=c("0", "60", "120", "180", "240", "300", "360"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

sFfig
```

combine plots 
```{r}
Exp2_stimuli <- plot_grid(sCfig, sEfig, sFfig, labels = "AUTO", axis = "br", ncol = 1, nrow=3, align = 'v')

ggsave("~/Desktop/Exp2_stimuli_v2.pdf", 
 plot = Exp2_stimuli, # or give ggplot object name as in myPlot,
 width = 18, height = 20, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 300, 
 useDingbats=FALSE)
```

#stimulus fig (exp3)

```{r}
#stimC<- readWave('stimulus_16-base_pattern.wav')
stimD_after3p <- readWave('stimulus_30.wav')
stimG<- readWave('stimulus_31-after_17_pulses.wav') 
stimH<-readWave('stimulus_32-after_43_pulses.wav') 
```

```{r}
str(stimD_after3p) #7210350
str(stimG) #7210350
str(stimH) #7210350

# extract signal
sD3 <- stimD_after3p@left
sG <- stimG@left
sH <- stimH@left

# determine duration
#can use str() to calculate duration = sample points / sample rate 
length(sD3)/stimD_after3p@samp.rate #327
length(sG)/stimG@samp.rate #327 s
length(sH)/stimH@samp.rate #327 s
```

```{r}
#If our wav file has a 16-bit depth (train_audio@bit), this means that the sound pressure values are mapped to integer values that can range from -2^¹⁵ to (2^¹⁵)-1.
#convert our sound array to floating point values ranging from -1 to 1 as follows:
sG <- sG / 2^(stimG@bit -1)
sH <- sH / 2^(stimH@bit -1)

 #Create an array containing the time points first:
sG.timeArray <- (0:(length(sG)-1)) / stimG@samp.rate
sH.timeArray <- (0:(length(sH)-1)) / stimH@samp.rate

sG.df<- data.frame(sG.timeArray, sG)
sH.df<- data.frame(sH.timeArray, sH)
```

A time representation of the sound can be obtained by plotting the pressure values against the time axis.

```{r}
# demean to remove DC offset
sG = sG - mean(sG)
sH = sH - mean(sH)
```

```{r}
#sC.sub<-sC.df[seq(1, nrow(sC.df), 500), ] #take every 500 rows
sG.sub<-sG.df[seq(1, nrow(sG.df), 500), ] #take every 500 rows
sH.sub<-sH.df[seq(1, nrow(sH.df), 500), ] #take every 500 rows
```

```{r}
sGfig <- ggplot(data=sG.sub, aes(x=sG.timeArray, y=sG)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 360),
                     breaks=c(0, 60, 120, 180, 240, 300, 360), 
                     labels=c("0", "60", "120", "180", "240", "300", "360"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

sGfig
```


```{r}
sHfig<- ggplot(data=sH.sub, aes(x=sH.timeArray, y=sH)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 360),
                     breaks=c(0, 60, 120, 180, 240, 300, 360), 
                     labels=c("0", "60", "120", "180", "240", "300", "360"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

sHfig
```

combine plots 
```{r}
Exp3_stimuli <- plot_grid(sCfig, sDfig, sGfig, sHfig, labels = "AUTO", axis = "br", ncol = 1, nrow=4, align = 'v')

ggsave("~/Desktop/Exp3_stimuli_v1.pdf", 
 plot = Exp3_stimuli, # or give ggplot object name as in myPlot,
 width = 18, height = 20, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 300, 
 useDingbats=FALSE)
```

#stimulus fig (exp4)
```{r}
#stimC<- readWave('stimulus_16-base_pattern.wav')
#stimD<- readWave('---')
stimI<- readWave('gapped45sec.wav') 
stimJ<-readWave('gapped1min.wav') 
```

```{r}
str(stimI) #7574175
str(stimJ) #7904925

# extract signal
sI <- stimI@left
sJ <- stimJ@left

# determine duration
#can use str() to calculate duration = sample points / sample rate 
length(sI)/stimI@samp.rate #343.5 s
length(sJ)/stimJ@samp.rate #358.5 s
```

```{r}
#If our wav file has a 16-bit depth (train_audio@bit), this means that the sound pressure values are mapped to integer values that can range from -2^¹⁵ to (2^¹⁵)-1.
#convert our sound array to floating point values ranging from -1 to 1 as follows:
sI <- sI / 2^(stimI@bit -1)
sJ <- sJ / 2^(stimJ@bit -1)

 #Create an array containing the time points first:
sI.timeArray <- (0:(length(sI)-1)) / stimI@samp.rate
sJ.timeArray <- (0:(length(sJ)-1)) / stimJ@samp.rate

sI.df<- data.frame(sI.timeArray, sI)
sJ.df<- data.frame(sJ.timeArray, sJ)


sI.sub<-sI.df[seq(1, nrow(sI.df), 600), ] 
sJ.sub<-sJ.df[seq(1, nrow(sJ.df), 700), ] 
```

A time representation of the sound can be obtained by plotting the pressure values against the time axis.

```{r}
# demean to remove DC offset
sI = sI - mean(sI)
sJ = sJ - mean(sJ)
```

```{r}
sIfig <- ggplot(data=sI.sub, aes(x=sI.timeArray, y=sI)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 360),
                     breaks=c(0, 60, 120, 180, 240, 300, 360), 
                     labels=c("0", "60", "120", "180", "240", "300", "360"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

sIfig
```


```{r}
sJfig<- ggplot(data=sJ.sub, aes(x=sJ.timeArray, y=sJ)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 360),
                     breaks=c(0, 60, 120, 180, 240, 300, 360), 
                     labels=c("0", "60", "120", "180", "240", "300", "360"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

sJfig
```

combine plots 
```{r}
Exp4_stimuli <- plot_grid(sCfig, sDfig, sIfig, sJfig, labels = "AUTO", axis = "br", ncol = 1, nrow=4, align = 'v')

ggsave("~/Desktop/Exp4_stimuli_v3.pdf", 
 plot = Exp4_stimuli, # or give ggplot object name as in myPlot,
 width = 18, height = 20, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 300, 
 useDingbats=FALSE)
```

#snake sample fig

```{r}
snake_sample<- readWave('ImantodesSample-2003-C631b[2303].wav') 
```

```{r}
str(snake_sample) #330728

# extract signal
snake <- snake_sample@left

# determine duration
#can use str() to calculate duration = sample points / sample rate 
length(snake)/snake_sample@samp.rate #15 s
```

```{r}
#If our wav file has a 16-bit depth (train_audio@bit), this means that the sound pressure values are mapped to integer values that can range from -2^¹⁵ to (2^¹⁵)-1.
#convert our sound array to floating point values ranging from -1 to 1 as follows:
snake <- snake / 2^(snake_sample@bit -1)

 #Create an array containing the time points first:
snake.timeArray <- (0:(length(snake)-1)) / snake_sample@samp.rate

snake.df<- data.frame(snake.timeArray, snake)

snake.sub<-snake.df[seq(1, nrow(snake.df), 500), ] #take every 600 rows
```

A time representation of the sound can be obtained by plotting the pressure values against the time axis.

```{r}
# demean to remove DC offset
snake = snake - mean(snake)
```

```{r}
snakefig <- ggplot(data=snake.sub, aes(x=snake.timeArray, y=snake)) +
  geom_line(size=0.25) +
  scale_x_continuous(limits=c(0, 15),
                     breaks=c(0, 5, 10, 15), 
                     labels=c("0", "5", "10", "15"))+
  scale_y_continuous(labels=NULL) +
  labs(x = "Time (s)",
       y = "Amplitude") +
  theme_cowplot(font_size = 16, line_size = 0.75, font_family="Helvetica") +
  theme(axis.text.y=element_text(size=16, colour= "black")) +
  theme(axis.text.x=element_text(size=16, colour= "black")) +
  theme(axis.title.x=element_text(size=16, colour = "black")) +
  theme(axis.title.y=element_text(size=16, colour = "black"))+
  theme(legend.position = "NONE")

snakefig
```

combine plots 
```{r}
ggsave("~/Desktop/snakefig2.pdf", 
 plot = snakefig, # or give ggplot object name as in myPlot,
 width = 18, height = 13, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 300, 
 useDingbats=FALSE)
```

#Hatching Data: 

ALL exps I-IV

```{r}
data <- read.xlsx(xlsxFile="raw_data.xlsx", sheet="data") %>%
  clean_names() %>%
  remove_empty() %>%
  mutate(age = age_d + set_up_time_h/24 + set_up_time_m/(60*24), na.rm=T) %>% #seconds not included here
  mutate(mean_stage = (stage_1+stage_2+stage_3)/3) %>% #only relevant for experiment 4 
  mutate(proportion_hatched_trays = number_hatched/n_test_eggs) %>% #only relevant for experiment 4 
  mutate(proportion_hatched_tines = hatched_during_playback/(hatched_during_playback+competent_and_no_hatch_during_playback))%>% #only relevant for experiments 1-3 
  mutate(diff_last_and_first = last_hatched_s - first_hatched_s) %>%
  mutate(diff_75_percent_and_25_percent =  x75_percent_hatched_s - x25_percent_hatched_s) %>%
  mutate(diff_90_percent_and_10_percent = x90_percent_hatched_s - x10_percent_hatched_s) %>%
  fill(stimulus, age, experiment, clutch) #fills stimulus name, embryo age, experiment, etc.

data$experiment<-as.factor(data$experiment)
data$stimulus<-as.factor(data$stimulus)
data$clutch<-as.factor(data$clutch)
data$set<-as.factor(data$set)
data$hatching_response<-as.factor(data$hatching_response)
```

# Ages

Age here we've calculated as age in days of set up time
```{r StageSummary}
quantile(data$age, na.rm=T)
mean(data$age, na.rm=T) #reported in Methods
se(data$age) #reported in Methods
range(data$age, na.rm=T) #reported in Methods
```

# Compare controls for hatching response

prefixonly stimulus in experiment 1 vs. exp 2

```{r}
prefix_only <- subset(data, data$stimulus=="prefixonly", na.rm=T)

glmer0 <- glmer(hatching_response ~ (1|clutch), family=binomial(logit), data=primer_only)

glmer1 <- glmer(hatching_response ~ as.factor(experiment) + (1|clutch), family=binomial(logit), data=primer_only)

Anova(glmer1) #no significant diffs between hatching response to primer only control in E1 vs. E2. 
anova(glmer0, glmer1) #no significant diffs between hatching response to primer only control in E1 vs. E2. 
```

gapsonly stimulus in experiment 1 vs. exp 2

```{r}
gaps_only <- subset(data, data$stimulus=="gapsonly", na.rm=T)

glmer0 <- glmer(hatching_response ~ (1|clutch), family=binomial(logit), data=gaps_only)

glmer1 <- glmer(hatching_response ~ as.factor(experiment) + (1|clutch), family=binomial(logit), data=gaps_only)

Anova(glmer1) #no significant diffs between hatching response to gaps only control in E1 vs. E2. 
anova(glmer0, glmer1) #no significant diffs between hatching response to gaps only control in E1 vs. E2. 
```

base pattern stimulus in experiments 1 - 3

```{r}
base_pattern <- subset(data, data$stimulus=="basepattern", na.rm=T)

glmer0 <- glmer(hatching_response ~ (1|clutch), family=binomial(logit), data=base_pattern)

glmer1 <- glmer(hatching_response ~ as.factor(experiment) + (1|clutch), family=binomial(logit), data=base_pattern)

Anova(glmer1) #no significant diffs between hatching response to base pattern control in E1 vs. E2. vs. E3
anova(glmer0, glmer1) #no significant diffs between hatching response to base pattern control in E1 vs. E2. vs. E3
```

prefix plus gap stimulus in experiment 1 vs exp 3

```{r}
prefix_plus_gap <- subset(data, data$stimulus=="prefixplusgap", na.rm=T)

glmer0 <- glmer(hatching_response ~ (1|clutch), family=binomial(logit), data=prefix_plus_gap)

glmer1 <- glmer(hatching_response ~ as.factor(experiment) + (1|clutch), family=binomial(logit), data=prefix_plus_gap)

Anova(glmer1) #no significant diffs between hatching response to prefix plus gap control in E1 vs. E3
anova(glmer0, glmer1) #no significant diffs between hatching response to prefix plus gap control in E1 vs. E3
```

# Compare controls for hatching TIMING

prefixonly stimulus in experiment 1 vs. exp 2

```{r}
prefix_only <- subset(data, data$stimulus=="prefixonly", na.rm=T)

glm0 <- glm(latency_to_hatch_s ~ 1, family=Gamma(inverse), data=prefix_only)
glm1 <- glm(latency_to_hatch_s ~ as.factor(experiment), family=Gamma(inverse), data=prefix_only) #took out clutch as a random effect here before it was overfit -- got a singularity warning... 

Anova(glm1) #no significant diffs between hatching timing to primer only control in E1 vs. E2. 
anova(glm0, glm1) #no significant diffs between hatching timing to primer only control in E1 vs. E2. 
```

gapsonly stimulus in experiment 1 vs. exp 2

```{r}
gaps_only <- subset(data, data$stimulus=="gapsonly", na.rm=T)

glm0 <- glm(latency_to_hatch_s ~ 1, family=Gamma(inverse), data=gaps_only)
glm1 <- glm(latency_to_hatch_s ~ as.factor(experiment), family=Gamma(inverse), data=gaps_only)

Anova(glm1) # yes significant diffs between hatching timing to gaps only control in E1 vs. E2. 
anova(glm0, glm1) # this doesn't work though
```

base pattern stimulus in experiments 1 - 3

```{r}
base_pattern <- subset(data, data$stimulus=="basepattern", na.rm=T)

glm0 <- glm(latency_to_hatch_s ~ 1, family=Gamma(inverse), data=base_pattern)

glm1 <- glm(latency_to_hatch_s ~ as.factor(experiment), family=Gamma(inverse),  data=base_pattern)

Anova(glm1) #no significant diffs between hatching response to base pattern control in E1 vs. E2. vs. E3
anova(glm0, glm1) # this doesn't work either
```

prefix plus gap stimulus in experiment 1 vs exp 3

```{r}
prefix_plus_gap <- subset(data, data$stimulus=="prefixplusgap", na.rm=T)

glm0 <- glm(latency_to_hatch_s ~ 1, family=Gamma(inverse), data=prefix_plus_gap)

glm1 <- glm(latency_to_hatch_s ~ as.factor(experiment), family=Gamma(inverse), data=prefix_plus_gap)

Anova(glm1) #no significant diffs between hatching response to prefix plus gap control in E1 vs. E3
anova(glm0, glm1) #
```

#Exp 1

####fig

```{r}
exp1_combined <- subset(data, data$experiment==1)
```

```{r}
summary_e1<-
  exp1_combined %>%
  group_by(stimulus) %>%
  summarize(count = n(), #number of individuals per stimulus REPORTED
            mean = mean(proportion_hatched_tines, na.rm=T),
            SE = se(proportion_hatched_tines, na.rm=T), #NA bc only 1 per clutch
            SD = sd(proportion_hatched_tines, na.rm=T)
            )
kable(summary_e1,title="Mean & SE",digits=4)

N_clutches_e1<-
  exp1_combined %>%
  group_by(stimulus, clutch) %>%
  summarize(count = n(), #number of individuals per clutch (each row here is a clutch)
            mean = mean(proportion_hatched_tines, na.rm=T),
            SE = se(proportion_hatched_tines, na.rm=T) #NA bc only 1 per clutch
            )
kable(N_clutches_e1,title="Mean & SE",digits=4)

N_e1<-
  N_clutches_e1 %>%
  group_by(stimulus) %>%
  summarize(count = n(), #number of clutches (REPORTED IN FIG 4)
            meanProportionHatched = mean(mean, na.rm=T),
            SEProportionHatched = se(mean, na.rm=T)
            )
kable(N_e1,title="Mean & SE",digits=4)
```

Since the data we are visualizing here is pretty small, why not forgo the boxplot?

```{r}
# Function to produce summary statistics (mean and +/- se)
data_summary <- function(x) {
   m <- mean(x, na.rm=T)
   ymin <- m-se(x, na.rm=T)
   ymax <- m+se(x, na.rm=T)
   return(c(y=m,ymin=ymin,ymax=ymax))
}

exp1_combined$stimulus <- factor(exp1_combined$stimulus , levels=c("basepattern", "prefixplusgap", "prefixonly", "gapsonly"))

fig_e1 <- exp1_combined %>% ggplot() +
  aes(x=as.factor(stimulus), y=proportion_hatched_tines) +
  geom_dotplot(dotsize=0.5, binaxis='y', stackdir='center', position=position_dodge(), fill='white', stroke=2, binwidth=1/30) +
  stat_summary(fun.data=data_summary, color='red')+
  scale_y_continuous(limits=c(0, 1),
                     breaks=c(0, 0.25, 0.5, 0.75, 1),
                     labels=c("0", " ", "0.5", " ", "1")
                     )+
  scale_x_discrete(labels=c("base pattern", "prefix + gap", "prefix only", "gaps only")) + 
  labs(x = "Stimulus", 
       y = "Proportion hatched") +
  theme(panel.background = element_blank())+
  #theme_cowplot(font_size = 15, line_size = 0.75, font_family="Helvetica") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1)) +
  #theme(axis.text.y=element_text(colour= "black")) +
  #theme(axis.text.x=element_text(colour= "black")) +
  #theme(axis.title.x=element_text(colour = "black")) +
  #theme(axis.title.y=element_text(colour = "black")) +
  theme(legend.position="none")+
  theme(axis.ticks.length=unit(-0.25, "cm"), axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")), axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")) )

fig_e1
```

```{r}
ggsave("~/Desktop/fig_e1.pdf", 
 plot = fig_e1, # or give ggplot object name as in myPlot,
 width = 16, height = 16, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 400, 
 useDingbats=FALSE)
```

#### stats for phat per clutch

compare "prefixonly" vs. "gapsonly" vs. "basepattern" vs. "prefixplusgap" 

```{r}
shapiro.test(exp1_combined$proportion_hatched_tines) #P<0.05, so not normal 
```

```{r}
kruskal.test(proportion_hatched_tines ~ stimulus, data=exp1_combined) #reported in results exp 1
```

```{r}
test<-pairwise.wilcox.test(exp1_combined$proportion_hatched_tines,
                     exp1_combined$stimulus, 
                     p.adjust.method = "none")
```

```{r}
library(multcompView)
test$p.value
library(reshape)
(a <- melt(test$p.value))
a.cc  <-  na.omit(a)
a.pvals  <-  a.cc[, 3]
names(a.pvals)  <-  paste(a.cc[, 1], a.cc[, 2], sep="-")
a.pvals
multcompLetters(a.pvals)
```

##midpoint hatching timing

```{r}
nogaps_BPvsPPG <- subset(data, data$experiment==1 & (data$stimulus=="basepattern" | data$stimulus=="prefixplusgap") , na.rm=T)

kruskal.test(x50_percent_hatched_s ~ stimulus, data=nogaps_BPvsPPG)

pairwise.wilcox.test(nogaps_BPvsPPG$x50_percent_hatched_s,
                     nogaps_BPvsPPG$gaps_removed, 
                     p.adjust.method = "none")
```

##midrange hatching timing

```{r}
pairwise.wilcox.test(nogaps_BPvsPPG$diff_75_percent_and_25_percent,
                     nogaps_BPvsPPG$gaps_removed, 
                     p.adjust.method = "none")
```

#Exp 2

####fig

```{r}
exp2_combined <- subset(data, data$experiment==2)

N_summary_e2<-
  exp2_combined %>%
  group_by(stimulus) %>%
  summarize(count = n(), #number of individuals per stimulus
            mean = mean(proportion_hatched_tines, na.rm=T),
            SE = se(proportion_hatched_tines, na.rm=T)
            )
kable(N_summary_e2,title="Mean & SE",digits=4)


N_clutches_e2<-
  exp2_combined %>%
  group_by(stimulus, clutch) %>%
  summarize(count = n(), #number of individuals per clutch (each row here is a clutch)
            mean = mean(proportion_hatched_tines, na.rm=T),
            SE = se(proportion_hatched_tines, na.rm=T) #NA bc only 1 per clutch
            )
kable(N_clutches_e2,title="Mean & SE",digits=4)

N_e2<-
  N_clutches_e2 %>%
  group_by(stimulus) %>%
  summarize(count = n(), #number of clutches
            meanProportionHatched = mean(mean, na.rm=T),
            SEProportionHatched = se(mean, na.rm=T)
            )
kable(N_e2,title="Mean & SE",digits=4)
```

with dotplot 

```{r}
exp2_combined$stimulus <- factor(exp2_combined$stimulus , levels=c("basepattern", "tenpulsegroups", "threepulsegroups"))

fig_e2 <- exp2_combined %>% ggplot() +
  aes(x=as.factor(stimulus), y=proportion_hatched_tines) +
  geom_dotplot(dotsize=0.5, binaxis='y', stackdir='center', position=position_dodge(), fill='white', stroke=2, binwidth=1/30) +
  stat_summary(fun.data=data_summary, color='red')+
  scale_y_continuous(limits=c(0, 1),
                     breaks=c(0, 0.25, 0.5, 0.75, 1),
                     labels=c("0", " ", " ", " ", "1")
                     )+
  scale_x_discrete(labels=c("base pattern", "10-pulse groups", "3-pulse groups")) + 
  labs(x = NULL, 
       y = "Proportion of clutch hatched") +
  theme(panel.background = element_blank())+
  #theme_cowplot(font_size = 15, line_size = 0.75, font_family="Helvetica") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1)) +
  #theme(axis.text.y=element_text(colour= "black")) +
  #theme(axis.text.x=element_text(colour= "black")) +
  #theme(axis.title.x=element_text(colour = "black")) +
  #theme(axis.title.y=element_text(colour = "black")) +
  theme(legend.position="none")+
  theme(axis.ticks.length=unit(-0.25, "cm"), axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")), axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")) )

fig_e2
```

```{r}
ggsave("~/Desktop/fig_e2.pdf", 
 plot = fig_e2, # or give ggplot object name as in myPlot,
 width = 16, height = 16, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 400, 
 useDingbats=FALSE)
```

#### stats for phat per clutch

```{r}
shapiro.test(exp2_combined$proportion_hatched_tines) #P<0.05, so not normal! 
```

```{r}
kruskal.test(proportion_hatched_tines ~ stimulus, data=exp2_combined)
```

```{r}
test<-pairwise.wilcox.test(exp2_combined$proportion_hatched_tines,
                     exp2_combined$stimulus, 
                     p.adjust.method = "none")
```

```{r}
library(multcompView)
test$p.value
library(reshape)
(a <- melt(test$p.value))
a.cc  <-  na.omit(a)
a.pvals  <-  a.cc[, 3]
names(a.pvals)  <-  paste(a.cc[, 1], a.cc[, 2], sep="-")
a.pvals
multcompLetters(a.pvals)
```

## per pulse analysis

If you consider a per-pulse basis, i.e. if you calculate proportion hatched by the number of pulses in each stimulus (PH/150 or PH/30, etc) is the hatching response actually *relatively higher* for the stimulus with fewer pulses? Probably yes? even though N is low. 

```{r}
exp2_combined <- exp2_combined %>% 
  mutate(perpulse = case_when(stimulus=="basepattern" ~ proportion_hatched_tines/150,
                              stimulus=="tenpulsegroups" ~ proportion_hatched_tines/70,
                              stimulus=="threepulsegroups" ~ proportion_hatched_tines/30)) %>% 
  mutate(normalized_perpulse = (perpulse-min(perpulse, na.rm=T))/(max(perpulse, na.rm=T)-min(perpulse, na.rm=T)))

```

```{r}
shapiro.test(exp2_combined$perpulse) #P<0.05, so not normal 

kruskal.test(perpulse ~ stimulus, data=exp2_combined)

test<-pairwise.wilcox.test(exp2_combined$perpulse,
                     exp2_combined$stimulus, 
                     p.adjust.method = "none")

```

```{r}
#library(multcompView)
test$p.value
#library(reshape)
(a <- melt(test$p.value))
a.cc  <-  na.omit(a)
a.pvals  <-  a.cc[, 3]
names(a.pvals)  <-  paste(a.cc[, 1], a.cc[, 2], sep="-")
a.pvals
multcompLetters(a.pvals)
```

Revise figure

```{r}
exp2_combined$stimulus <- factor(exp2_combined$stimulus , levels=c("basepattern", "tenpulsegroups", "threepulsegroups"))

range(exp2_combined$normalized_perpulse, na.rm=T)

fig_e2_perpulse <- exp2_combined %>% ggplot() +
  aes(x=as.factor(stimulus), y=normalized_perpulse) +
  geom_dotplot(dotsize=0.5, binaxis='y', stackdir='center', position=position_dodge(), fill='white', stroke=2, binwidth=1/30) +
  stat_summary(fun.data=data_summary, color='red')+
    geom_dotplot(dotsize=0.5, binaxis='y', stackdir='center', position=position_dodge(), fill='white', stroke=2, binwidth=1/30) +
  
  scale_y_continuous(limits=c(0, 1),
                     breaks=c(0, 0.25, 0.5, 0.75, 1),
                     labels=c("0", " ", " ", " ", "1")
                     )+
  scale_x_discrete(labels=c("base pattern", "10-pulse groups", "3-pulse groups")) + 
  labs(x = NULL, 
       y = "Hatching response (normalized, per pulse)") +
  theme(panel.background = element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1)) +
  theme(legend.position="none")+
  theme(axis.ticks.length=unit(-0.25, "cm"), axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")), axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")) )

fig_e2_perpulse
```

```{r}
ggsave("~/Desktop/fig_e2_perpulse.pdf", 
 plot = fig_e2_perpulse, # or give ggplot object name as in myPlot,
 width = 16, height = 16, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 400, 
 useDingbats=FALSE)
```


##midpoint hatching timing

```{r}
nogaps_3vs10vsBP <- subset(data, data$experiment==2 & (data$stimulus=="basepattern" | data$stimulus=="threepulsegroups"| data$stimulus=="tenpulsegroups") , na.rm=T)

kruskal.test(x50_percent_hatched_s ~ stimulus, data=nogaps_3vs10vsBP)

pairwise.wilcox.test(nogaps_3vs10vsBP$x50_percent_hatched_s,
                     nogaps_3vs10vsBP$gaps_removed, 
                     p.adjust.method = "none")
```

##midrange hatching timing

```{r}
pairwise.wilcox.test(nogaps_3vs10vsBP$diff_75_percent_and_25_percent,
                     nogaps_3vs10vsBP$gaps_removed, 
                     p.adjust.method = "none")
```


# Exp 3

#### fig

```{r}
exp3_combined <- subset(data, data$experiment==3)
```

```{r}
summary_e3<-
  exp3_combined %>%
  group_by(stimulus) %>%
  summarize(count = n(), #number of individuals per stimulus
            mean = mean(proportion_hatched_tines, na.rm=T),
            SE = se(proportion_hatched_tines, na.rm=T), #NA bc only 1 per clutch
            SD = sd(proportion_hatched_tines, na.rm=T)
            )
kable(summary_e3,title="Mean & SE",digits=4)

N_clutches_e3<-
  exp3_combined %>%
  group_by(stimulus, clutch) %>%
  summarize(count = n(), #number of individuals per clutch (each row here is a clutch)
            mean = mean(proportion_hatched_tines, na.rm=T),
            SE = se(proportion_hatched_tines, na.rm=T) #NA bc only 1 per clutch
            )
kable(N_clutches_e3,title="Mean & SE",digits=4)

N_e3<-
  N_clutches_e3 %>%
  group_by(stimulus) %>%
  summarize(count = n(), #number of clutches
            meanProportionHatched = mean(mean, na.rm=T),
            SEProportionHatched = se(mean, na.rm=T)
            )
kable(N_e3,title="Mean & SE",digits=4)
```

with dotplot 

```{r}
exp3_combined$stimulus <- factor(exp3_combined$stimulus , levels=c("basepattern", "prefixplusgap", "gapafterseventeen", "gapafterfortythree"))

fig_e3 <- exp3_combined %>% ggplot() +
  aes(x=as.factor(stimulus), y=proportion_hatched_tines) +
  geom_dotplot(dotsize=0.5, binaxis='y', stackdir='center', position=position_dodge(), fill='white', stroke=2, binwidth=1/30) +
  stat_summary(fun.data=data_summary, color='red')+
  scale_y_continuous(limits=c(0, 1),
                     breaks=c(0, 0.25, 0.5, 0.75, 1),
                     labels=c("0", " ", " ", " ", "1")
                     )+
  scale_x_discrete(labels=c("base pattern", "assessment (gap at 3 pulses)", "peak hatching (gap at 17 pulses)", "post-peak hatching (gap at 43 pulses)")) + 
  labs(x = NULL, 
       y = "Proportion of clutch hatched") +
  theme(panel.background = element_blank())+
  #theme_cowplot(font_size = 15, line_size = 0.75, font_family="Helvetica") +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1)) +
  #theme(axis.text.y=element_text(colour= "black")) +
  #theme(axis.text.x=element_text(colour= "black")) +
  #theme(axis.title.x=element_text(colour = "black")) +
  #theme(axis.title.y=element_text(colour = "black")) +
  theme(legend.position="none")+
  theme(axis.ticks.length=unit(-0.25, "cm"), axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")), axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")) )

fig_e3
```

```{r}
ggsave("~/Desktop/fig_e3.pdf", 
 plot = fig_e3, # or give ggplot object name as in myPlot,
 width = 16, height = 16, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 400, 
 useDingbats=FALSE)
```

#### stats for phat per clutch

```{r}
shapiro.test(exp3_combined$proportion_hatched_tines) #P.0.05, so normal! BUT I'LL stay consistent with others
```

```{r}
kruskal.test(proportion_hatched_tines ~ stimulus, data=exp3_combined)
```

```{r}
test<-pairwise.wilcox.test(exp3_combined$proportion_hatched_tines,
                     exp3_combined$stimulus, 
                     p.adjust.method = "none")
```

```{r}
library(multcompView)
test$p.value
library(reshape)
(a <- melt(test$p.value))
a.cc  <-  na.omit(a)
a.pvals  <-  a.cc[, 3]
names(a.pvals)  <-  paste(a.cc[, 1], a.cc[, 2], sep="-")
a.pvals
multcompLetters(a.pvals)
```

##midpoint hatching timing

```{r}
nogaps_e3allstims <- subset(data, data$experiment==3, na.rm=T)

kruskal.test(x50_percent_hatched_s ~ stimulus, data=nogaps_e3allstims)

pairwise.wilcox.test(nogaps_e3allstims$x50_percent_hatched_s,
                     nogaps_e3allstims$gaps_removed, 
                     p.adjust.method = "none")
```

##midrange hatching timing

```{r}
pairwise.wilcox.test(nogaps_e3allstims$diff_75_percent_and_25_percent,
                     nogaps_e3allstims$gaps_removed, 
                     p.adjust.method = "none")
```


# Exp 4

####fig

```{r}
exp4_combined <- subset(data, data$experiment==4)
```

To get number of clutches
```{r}
N_summary_e4<-
  exp4_combined %>%
  group_by(stimulus) %>%
  summarize(count = n(), #number of individuals per stimulus
            mean = mean(proportion_hatched_trays, na.rm=T),
            SE = se(proportion_hatched_trays, na.rm=T) 
            )
kable(N_summary_e4,title="Mean & SE",digits=4)

N_clutches_e4<-
  exp4_combined %>%
  group_by(stimulus, clutch) %>%
  summarize(count = n(), #number of individuals per clutch (each row here is a clutch)
            mean = mean(proportion_hatched_trays, na.rm=T),
            SE = se(proportion_hatched_trays, na.rm=T) #sometimes multiple per clutch!!
            )
kable(N_clutches_e4,title="Mean & SE",digits=4)

# number of trays per "no gap" = N clutches + 2
# number of trays per "45 s gap" = N clutches + 1 

N_e4<-
  N_clutches_e4 %>%
  group_by(stimulus) %>%
  summarize(count = n(), #number of clutches (REPORTED)
            meanProportionHatched = mean(mean, na.rm=T),
            SEProportionHatched = se(mean, na.rm=T)
            )
kable(N_e4,title="Mean & SE",digits=4)

# "no gap" = N = 35
# "45 s gap" N = 17
```

```{r}
exp4_combined$stimulus <- factor(exp4_combined$stimulus, levels=c("nogap", "thirtysgap", "fortyfivesgap", "sixtysgap"))

fig_e4 <- exp4_combined %>% ggplot() +
  aes(x=as.factor(stimulus), y=proportion_hatched_trays) +
  geom_dotplot(dotsize=0.5, binaxis='y', stackdir='center', position=position_dodge(), fill='white', stroke=2, binwidth=1/30) +
  stat_summary(fun.data=data_summary, color='red')+
  scale_y_continuous(limits=c(0, 1),
                     breaks=c(0, 0.25, 0.5, 0.75, 1),
                     labels=c("0", " ", " ", " ", "1")
                     )+
  scale_x_discrete(labels=c("base pattern", "30 s gap", "45 s gap", "60 s gap")) + 
  labs(x = NULL, 
       y = "Proportion of tray hatched") +
  theme(panel.background = element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1)) +
  theme(legend.position="none")+
  theme(axis.ticks.length=unit(-0.25, "cm"), axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")), axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")) )

fig_e4
```

```{r}
ggsave("~/Desktop/fig_e4.pdf", 
 plot = fig_e4, # or give ggplot object name as in myPlot,
 width = 16, height = 16, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 400, 
 useDingbats=FALSE)
```

#### stats

```{r}
shapiro.test(exp4_combined$proportion_hatched_trays) #P<0.05, so not normal 

kruskal.test(proportion_hatched_trays ~ stimulus, data=exp4_combined)

test<-pairwise.wilcox.test(exp4_combined$proportion_hatched_trays,
                     exp4_combined$stimulus, 
                     p.adjust.method = "none")
```

```{r}
#library(multcompView)
test$p.value
#library(reshape)
(a <- melt(test$p.value))
a.cc  <-  na.omit(a)
a.pvals  <-  a.cc[, 3]
names(a.pvals)  <-  paste(a.cc[, 1], a.cc[, 2], sep="-")
a.pvals
multcompLetters(a.pvals)
```

#### latency to hatch 

```{r}
N_summary_e4_ltoh<- exp4_combined %>%
  filter(!is.na(latency_to_hatch_s)) %>% #to filter out the NAs
  group_by(stimulus) %>%
  summarize(count = n(), #number of individuals per stimulus
            mean = mean(latency_to_hatch_s, na.rm=T),
            SE = se(latency_to_hatch_s, na.rm=T) #sometimes multiple per clutch!! and sometimes no latency available bc none hatched
            )
kable(N_summary_e4_ltoh,title="Mean & SE",digits=4)

N_clutches_e4_ltoh<-
  exp4_combined %>%
  filter(!is.na(latency_to_hatch_s)) %>% #to filter out the NAs
  group_by(stimulus, clutch) %>%
  summarize(count = n(), #number of individuals per clutch (each row here is a clutch)--- i should count these up to make sure it lines up with what's reported in the figures right now. 
            mean = mean(latency_to_hatch_s, na.rm=T),
            SE = se(latency_to_hatch_s, na.rm=T) #sometimes multiple per clutch!! and sometimes no latency available bc none hatched
            )
kable(N_clutches_e4_ltoh,title="Mean & SE",digits=4)

#45s gap : c249 has 2 latencies
#no gap: c93 has 2 latencies

N_e4_ltoh<-
  N_clutches_e4_ltoh %>%
  group_by(stimulus) %>%
  summarize(count = n(), #number of CLUTCHES
            meanLtoH = mean(mean, na.rm=T),
            SELtoH = se(mean, na.rm=T)
            )
kable(N_e4_ltoh,title="Mean & SE",digits=4)

#45s gap: N trays = 16 + 1 = 17
#no gap: N trays = 29 + 1 = 30

#right now in figure 8b: 
# big font : N of trays (subscript = N embryos)
# 8c) N of trays tested for latencies (subscript = N embryos for which we got latencies - difference is number of trays where no embryos hatched)
# 8d) N of trays tested for latencies (subscript = N embryos for which we got latencies - difference is number of trays where no embryos hatched)

```

```{r}
range(exp4_combined$latency_to_hatch_s, na.rm = T)

fig_e4_ltoh <- exp4_combined %>% ggplot() +
  aes(x=as.factor(stimulus), y=latency_to_hatch_s) +
  #geom_dotplot(dotsize=0.5, binaxis='y', stackdir='center', position=position_dodge(), fill='white', stroke=2, binwidth=1/30) + 
    geom_dotplot(dotsize=0.5, binaxis='y', stackdir='center', position=position_dodge(), fill='white', stroke=2, binwidth=3.5) + #use binwidth=3.8 or 4 to make a little bigger
  stat_summary(fun.data=data_summary, color='red')+
  scale_y_continuous(limits=c(0, 140),
                     breaks=c(0, 30, 60, 90, 120),
                     labels=c("0", " ", "60", " ", "120")
                     )+
  scale_x_discrete(labels=c("base pattern", "30 s gap", "45 s gap", "60 s gap")) + 
  labs(x = NULL, 
       y = "Latency to hatch (s)") +
  theme(panel.background = element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1)) +
  theme(legend.position="none")+
  theme(axis.ticks.length=unit(-0.25, "cm"), axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")), axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")) )

fig_e4_ltoh
```

```{r}
ggsave("~/Desktop/e4_ltoh_plots.pdf", 
 plot = fig_e4_ltoh, # or give ggplot object name as in myPlot,
 width = 16, height = 16, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 400, 
 useDingbats=FALSE)
```

#### stats

```{r}
shapiro.test(exp4_combined$latency_to_hatch_s) #P<0.05, so not normal 

kruskal.test(latency_to_hatch_s ~ stimulus, data=exp4_combined)

test<-pairwise.wilcox.test(exp4_combined$latency_to_hatch_s, exp4_combined$stimulus, 
                     p.adjust.method = "none")
```

```{r}
#library(multcompView)
test$p.value
#library(reshape)
(a <- melt(test$p.value))
a.cc  <-  na.omit(a)
a.pvals  <-  a.cc[, 3]
names(a.pvals)  <-  paste(a.cc[, 1], a.cc[, 2], sep="-")
a.pvals
multcompLetters(a.pvals)
```

###subtract gaps

Using conditional formatting in dplyr
```{r}
#if tines_trays == stim C --> no change to lto_h 
#if tines_trays == stim D and lto_h > 0.5 (30 sec), then subtract 0.5 from lto_h
#if tines_trays == stim I and lto_h > 0.75 (45 sec), then subtract 0.75 from lto_h
#if tines_trays == stim J and lto_h > 1 (min), then subtract 1 from lto_h
exp4_combined <- exp4_combined %>%
  mutate(trunc_ltoh = case_when(stimulus=="nogap" ~ latency_to_hatch_s,
                                stimulus=="thirtysgap" & latency_to_hatch_s>30 ~ latency_to_hatch_s-30, 
                                stimulus=="fortyfivesgap" & latency_to_hatch_s>45 ~ latency_to_hatch_s-45,
                                stimulus=="sixtysgap" & latency_to_hatch_s>60 ~ latency_to_hatch_s-60, 
                                TRUE ~ as.numeric(as.character(latency_to_hatch_s))
                                ))
```
Values that are never matched by a logical test get a default replacement value: NA. To keep these values from getting NAs, include a final catch-all test and replacement in the last line. 


### for sample sizes

how many hatchlings do we have latency data for? (which which we got latency)

```{r}
N_summary_e4_truncltoh<- exp4_combined %>%
  filter(!is.na(trunc_ltoh)) %>% #to filter out the NAs
  group_by(stimulus) %>%
  summarize(count = n(), #number of individuals per stimulus
            mean = mean(trunc_ltoh, na.rm=T),
            SE = se(trunc_ltoh, na.rm=T) #sometimes multiple per clutch!! and sometimes no latency available bc none hatched
            )
kable(N_summary_e4_truncltoh,title="Mean & SE",digits=4)

N_clutches_e4_ltoh<-
  exp4_combined %>%
  filter(!is.na(trunc_ltoh)) %>% #to filter out the NAs
  group_by(stimulus, clutch) %>%
  summarize(count = n(), #number of individuals per clutch (each row here is a clutch)--- i should count these up to make sure it lines up with what's reported in the figures right now. 
            mean = mean(trunc_ltoh, na.rm=T),
            SE = se(trunc_ltoh, na.rm=T) #sometimes multiple per clutch!! and sometimes no latency available bc none hatched
            )
kable(N_clutches_e4_ltoh,title="Mean & SE",digits=4)

N_e4_ltoh<-
  N_clutches_e4_ltoh %>%
  group_by(stimulus) %>%
  summarize(count = n(), #number of CLUTCHES
            meanLtoH = mean(mean, na.rm=T),
            SELtoH = se(mean, na.rm=T)
            )
kable(N_e4_ltoh,title="Mean & SE",digits=4)
```

```{r}
latency_clutches_e4<-
  exp4_combined %>%
  group_by(stimulus, clutch) %>%
  summarize(num = n(), #sample sizes for individuals per clutch
            meanlat = mean(trunc_ltoh, na.rm=TRUE)
            )
kable(latency_clutches_e4, digits=3)

N_latency_clutches_e4 <- latency_clutches_e4 %>%
  group_by(stimulus) %>%
  summarise(clutches= n(), #number of clutches
            meanlatency = mean(meanlat, na.rm=TRUE),
            medianlatency = median(meanlat, na.rm=TRUE),
            SEnumlatency = sd(meanlat, na.rm=TRUE)/sqrt(n())
            )
kable(N_latency_clutches_e4, digits=3)
```


```{r}
range(exp4_combined$trunc_ltoh, na.rm=T)

fig_e4_ltoh_trunc <- exp4_combined %>% ggplot() +
  aes(x=as.factor(stimulus), y=trunc_ltoh) +
  #geom_dotplot(dotsize=0.5, binaxis='y', stackdir='center', position=position_dodge(), fill='white', stroke=2, binwidth=1/30) + 
    geom_dotplot(dotsize=0.5, binaxis='y', stackdir='center', position=position_dodge(), fill='white', stroke=2, binwidth=3.5) + #use binwidth=3.8 or 4 to make a little bigger
  stat_summary(fun.data=data_summary, color='red')+
  scale_y_continuous(limits=c(0, 140),
                     breaks=c(0, 30, 60, 90, 120),
                     labels=c("0", " ", "30", " ", "60") #converting from seconds to # of vibration pulses bc 1 pulse every 2 seconds
                     )+
  scale_x_discrete(labels=c("base pattern", "30 s gap", "45 s gap", "60 s gap")) + 
  labs(x = NULL, 
       y = "Latency (# of vibration pulses)") +
  theme(panel.background = element_blank())+
  theme(panel.border = element_rect(colour = "black", fill=NA, size=1)) +
  theme(legend.position="none")+
  theme(axis.ticks.length=unit(-0.25, "cm"), axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")), axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")) )

fig_e4_ltoh_trunc
```

```{r}
ggsave("~/Desktop/e4_ltoh_boxplots_trunc.pdf", 
 plot = fig_e4_ltoh_trunc, # or give ggplot object name as in myPlot,
 width = 16, height = 16, 
 units = "cm", # other options c("in", "cm", "mm"), 
 dpi = 400, 
 useDingbats=FALSE)
```

#### stats

```{r}
shapiro.test(exp4_combined$trunc_ltoh) #P<0.05, so not normal 

kruskal.test(trunc_ltoh ~ stimulus, data=exp4_combined)

test<-pairwise.wilcox.test(exp4_combined$trunc_ltoh,
                     exp4_combined$stimulus, 
                     p.adjust.method = "none")
```

```{r}
#library(multcompView)
test$p.value
#library(reshape)
(a <- melt(test$p.value))
a.cc  <-  na.omit(a)
a.pvals  <-  a.cc[, 3]
names(a.pvals)  <-  paste(a.cc[, 1], a.cc[, 2], sep="-")
a.pvals
multcompLetters(a.pvals)
```

# hatching over extra 3 pulses

what fraction of total hatched embryos hatched during or after these last 3 "extra" pulses in the "prefix + gap" stimulus (stimulus D or stimulus 22 for Ming)?

```{r}
#hatching times for stimulus 22 (stim D, primer + gaps), experiment 1
hatching_times_D <- readMat("hatching_times_22.mat")

#stimulus length = 6 + 28.5 + 300 = 334.5
#334.5 s
##334.5 s-6s = 328.5

# matrix of 12 lists --> 12 trials of this stimulus (12 clutches) 
# each list = hatching times for any embryos that hatched
df<-data.frame(unlist(hatching_times_D), nrow=length(hatching_times_D), byrow=TRUE)
#any embryos that hatched and the TIMES at which they hatched (in seconds)

#how many hatched? i.e.how many elements in this matrix?
length(df$unlist.hatching_times_D.) #340 individuals hatched

#how much hatching in the LAST 3 pulses (6 seconds)?
subsetdf<- subset(df, unlist.hatching_times_D.>=328.5)
length(subsetdf$unlist.hatching_times_D.) #2 individuals hatched in the last 6 seconds

2/340 #2 hatched in the last 6 seconds out of 340
```

# hatching over pulses in gaps only

how many hatching did the gaps only stimulus (only 10 pulses) elicit, compared to hatching from the first 10 pulses of other stimuli?

could provide evidence that this is probs not simply a reflection of the low total number of pulses in this stimulus - i.e. if the more rapid accumulation of 10 pulses in other stimuli elicited more hatching... 

SO How much hatching occurred in response to the first 10 pulses of all the other stimuli? 

gaps only stimulus from exp 1
```{r}
#hatching times for stimulus 17_1 (stim B, gapsonly), experiment 1
hatching_times_17_1 <- readMat("hatching_times_17_1.mat")

# matrix of 10 lists --> 10 trials of this stimulus (10 clutches) 
# each list = hatching times for any embryos that hatched
df<-data.frame(unlist(hatching_times_17_1), nrow=length(hatching_times_17_1), byrow=TRUE)
#any embryos that hatched and the TIMES at which they hatched (in seconds)

#how many hatched? i.e.how many elements in this matrix?
length(df$unlist.hatching_times_17_1.) #13 individuals hatched

#how much hatching in the first 10 pulses?
subsetdf<- subset(df, unlist.hatching_times_17_1.<=(2*10))
length(subsetdf$unlist.hatching_times_17_1.) #2 individuals hatched in the first 10 pulses (20 seconds)

2/13 #only 2 out of 13 hatched in the first 10 pulses (20 seconds) 
```


