#import "@local/bootlin:0.1.0": *

#import "@local/bootlin-yocto:0.1.0": *

#import "@local/bootlin-utils:0.1.0": *

#import "../../typst/local/themeBootlin.typ": *

#import "../../typst/local/common.typ": *

#show: bootlin-theme.with( aspect-ratio: "16-9", config-common(
handout: "handout" in sys.inputs and sys.inputs.handout == "1", ))

#show raw.where(block: true): set block(fill: luma(240), inset: 1em,
radius:0.5em, width:100%)

#show raw.where(block: false): r => text(fill: color-link)[#r]

#show raw.where(lang: "c", block: true): r => {

set block(fill: luma(240), inset: 0.4em, radius: 0.5em, width: 95%,
breakable: true, above: 12pt, below: 12pt)

set text(11pt)

r

}

== ASoC DAPM

===  DAPM

- DAPM stands for Dynamic Audio Power Management.

- The goal is to save as much power as possible by shutting down audio
  routes that are not in use.

- This may affect the whole card or just part of it.

- To achieve this, the topology needs to be described. For this we have
  two objects: DAPM widgets and DAPM routes.

- The DAPM widgets represent various components of an audio system, such
  as audio inputs, outputs, mixers, and amplifiers.

- The routes are connecting widgets together.

===  `snd_soc_dapm_widget`

- An array of #kstruct("snd_soc_dapm_widget") is registered by the
  component.

- Many helpers exist to avoid filling the struct manually:

  #kfile("include/sound/soc-dapm.h")

  ```c
  #define SND_SOC_DAPM_INPUT(wname) 
  {       .id = snd_soc_dapm_input, .name = wname, .kcontrol_news = NULL, 
          .num_kcontrols = 0, .reg = SND_SOC_NOPM }
  #define SND_SOC_DAPM_OUTPUT(wname) 
  {       .id = snd_soc_dapm_output, .name = wname, .kcontrol_news = NULL, 
          .num_kcontrols = 0, .reg = SND_SOC_NOPM }
  #define SND_SOC_DAPM_MIC(wname, wevent) 
  {       .id = snd_soc_dapm_mic, .name = wname, .kcontrol_news = NULL, 
          .num_kcontrols = 0, .reg = SND_SOC_NOPM, .event = wevent, 
          .event_flags = SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD}
  [...]
  #define SND_SOC_DAPM_PGA(wname, wreg, wshift, winvert,
           wcontrols, wncontrols) 
  {       .id = snd_soc_dapm_pga, .name = wname, 
          SND_SOC_DAPM_INIT_REG_VAL(wreg, wshift, winvert), 
          .kcontrol_news = wcontrols, .num_kcontrols = wncontrols}
  [...]
  #define SND_SOC_DAPM_MUX(wname, wreg, wshift, winvert, wcontrols) 
  {       .id = snd_soc_dapm_mux, .name = wname, 
          SND_SOC_DAPM_INIT_REG_VAL(wreg, wshift, winvert), 
          .kcontrol_news = wcontrols, .num_kcontrols = 1}
  #define SND_SOC_DAPM_DEMUX(wname, wreg, wshift, winvert, wcontrols) 
  {       .id = snd_soc_dapm_demux, .name = wname, 
          SND_SOC_DAPM_INIT_REG_VAL(wreg, wshift, winvert), 
          .kcontrol_news = wcontrols, .num_kcontrols = 1}
  ```

===  `snd_soc_dapm_widget`

#kfile("include/sound/soc-dapm.h")

```c
#define SND_SOC_DAPM_DAC(wname, stname, wreg, wshift, winvert) 
{       .id = snd_soc_dapm_dac, .name = wname, .sname = stname, 
        SND_SOC_DAPM_INIT_REG_VAL(wreg, wshift, winvert) }
#define SND_SOC_DAPM_DAC_E(wname, stname, wreg, wshift, winvert, 
                           wevent, wflags)                                
{       .id = snd_soc_dapm_dac, .name = wname, .sname = stname, 
        SND_SOC_DAPM_INIT_REG_VAL(wreg, wshift, winvert), 
        .event = wevent, .event_flags = wflags}

#define SND_SOC_DAPM_ADC(wname, stname, wreg, wshift, winvert) 
{       .id = snd_soc_dapm_adc, .name = wname, .sname = stname, 
        SND_SOC_DAPM_INIT_REG_VAL(wreg, wshift, winvert), }
#define SND_SOC_DAPM_ADC_E(wname, stname, wreg, wshift, winvert, 
                           wevent, wflags)                                
{       .id = snd_soc_dapm_adc, .name = wname, .sname = stname, 
        SND_SOC_DAPM_INIT_REG_VAL(wreg, wshift, winvert), 
        .event = wevent, .event_flags = wflags}


/* generic widgets */
#define SND_SOC_DAPM_REG(wid, wname, wreg, wshift, wmask, won_val, woff_val) 
{       .id = wid, .name = wname, .kcontrol_news = NULL, .num_kcontrols = 0, 
        .reg = wreg, .shift = wshift, .mask = wmask, 
        .on_val = won_val, .off_val = woff_val, }
#define SND_SOC_DAPM_SUPPLY(wname, wreg, wshift, winvert, wevent, wflags) 
{       .id = snd_soc_dapm_supply, .name = wname, 
        SND_SOC_DAPM_INIT_REG_VAL(wreg, wshift, winvert), 
        .event = wevent, .event_flags = wflags}
#define SND_SOC_DAPM_REGULATOR_SUPPLY(wname, wdelay, wflags)            
{       .id = snd_soc_dapm_regulator_supply, .name = wname, 
        .reg = SND_SOC_NOPM, .shift = wdelay, .event = dapm_regulator_event, 
        .event_flags = SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD, 
        .on_val = wflags}
```

===  DAPM example

#kfile("sound/soc/codecs/pcm3168a.c")

```c
static const struct snd_soc_dapm_widget pcm3168a_dapm_widgets[] = {
        SND_SOC_DAPM_DAC("DAC1", "Playback", PCM3168A_DAC_OP_FLT,
                        PCM3168A_DAC_OPEDA_SHIFT, 1),
        SND_SOC_DAPM_DAC("DAC2", "Playback", PCM3168A_DAC_OP_FLT,
                        PCM3168A_DAC_OPEDA_SHIFT + 1, 1),
        SND_SOC_DAPM_DAC("DAC3", "Playback", PCM3168A_DAC_OP_FLT,
                        PCM3168A_DAC_OPEDA_SHIFT + 2, 1),
        SND_SOC_DAPM_DAC("DAC4", "Playback", PCM3168A_DAC_OP_FLT,
                        PCM3168A_DAC_OPEDA_SHIFT + 3, 1),

        SND_SOC_DAPM_OUTPUT("AOUT1L"),
        SND_SOC_DAPM_OUTPUT("AOUT1R"),
        SND_SOC_DAPM_OUTPUT("AOUT2L"),
        SND_SOC_DAPM_OUTPUT("AOUT2R"),
        SND_SOC_DAPM_OUTPUT("AOUT3L"),
        SND_SOC_DAPM_OUTPUT("AOUT3R"),
        SND_SOC_DAPM_OUTPUT("AOUT4L"),
        SND_SOC_DAPM_OUTPUT("AOUT4R"),
```

Note: on the #link("https://www.ti.com/lit/gpn/pcm3168a")[PCM3168A] DACs
and ADCs can only be powered down in pairs.

===  DAPM example

#kfile("sound/soc/codecs/pcm3168a.c")

```c
        SND_SOC_DAPM_ADC("ADC1", "Capture", PCM3168A_ADC_PWR_HPFB,
                        PCM3168A_ADC_PSVAD_SHIFT, 1),
        SND_SOC_DAPM_ADC("ADC2", "Capture", PCM3168A_ADC_PWR_HPFB,
                        PCM3168A_ADC_PSVAD_SHIFT + 1, 1),
        SND_SOC_DAPM_ADC("ADC3", "Capture", PCM3168A_ADC_PWR_HPFB,
                        PCM3168A_ADC_PSVAD_SHIFT + 2, 1),

        SND_SOC_DAPM_INPUT("AIN1L"),
        SND_SOC_DAPM_INPUT("AIN1R"),
        SND_SOC_DAPM_INPUT("AIN2L"),
        SND_SOC_DAPM_INPUT("AIN2R"),
        SND_SOC_DAPM_INPUT("AIN3L"),
        SND_SOC_DAPM_INPUT("AIN3R")
};
```

===  `snd_soc_dapm_route`

- An array of #kstruct("snd_soc_dapm_route") is registered by the
  component to define the routes.

#kfile("include/sound/soc-dapm.h")

```c
struct snd_soc_dapm_route {
        const char *sink;
        const char *control;
        const char *source;

        /* Note: currently only supported for links where source is a supply */
        int (*connected)(struct snd_soc_dapm_widget *source,
                         struct snd_soc_dapm_widget *sink);

        struct snd_soc_dobj dobj;
};
```

===  DAPM routes example

#kfile("sound/soc/codecs/pcm3168a.c")

```c
static const struct snd_soc_dapm_route pcm3168a_dapm_routes[] = {
        /* Playback */
        { "AOUT1L", NULL, "DAC1" },
        { "AOUT1R", NULL, "DAC1" },

        { "AOUT2L", NULL, "DAC2" },
        { "AOUT2R", NULL, "DAC2" },

        { "AOUT3L", NULL, "DAC3" },
        { "AOUT3R", NULL, "DAC3" },

        { "AOUT4L", NULL, "DAC4" },
        { "AOUT4R", NULL, "DAC4" },

        /* Capture */
        { "ADC1", NULL, "AIN1L" },
        { "ADC1", NULL, "AIN1R" },

        { "ADC2", NULL, "AIN2L" },
        { "ADC2", NULL, "AIN2R" },

        { "ADC3", NULL, "AIN3L" },
        { "ADC3", NULL, "AIN3R" }
};
```
