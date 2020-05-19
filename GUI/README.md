![logo](https://github.com/topbobo/Plan2Dance/blob/master/Plan2Dance/logo.png)
# Plan2Dance: Planning Based Choreographing from Musics

Our Website: www.sfree.top/Plan2Dance and GUI download: www.sfree.top/Plan2Dance/download

## Motivation

&emsp;&emsp;The ﬁeld of dancing robots has drawn much attention from numerous sources.
> e.g. QRIO [Geppert, 2004], HRP-2 [Nakaoka et al., 2005], [Bi et al., 2018],  [Wu et al., 2019].

&emsp;&emsp;There are many actions that have hard constraints and cannot be executed subsequently or have to be executed subsequently.

**Opportunity:** Those systems often either limited to a predeﬁned set of dances (together with music) or demonstrate little variance with respect to external stimuli. They either:
- Only consider the beat-motion synchronization and application of limited posture relations, or
- Hard to incorporate humans’ knowledge in choreography, or 
- Need  music-dance data sets which is not easy to collect.

**Challenges:** 
How to represent experts' knowledge in dance choreography? It is nontrivial, e.g.,

- The evaluation of dances is difficult and, most of the time, very flexible;
- Keeping stability alone is already difficult and most of the time, closely relative to hardware, which makes it difficult to represent general knowledge.

In this work we present Plan2Dance, an automated choreography system using temporal planning approach to tackle this challenge.

### Notes:
1. Currently Plan2Dance GUI only works on Windows OS;
2. For the sake of builtin memory limitation in our experimental robot's, the length of the input music is restricted to less than 1 minute. The exceeding part will be cut off directly.

**Check out the wiki for more information.**
https://github.com/topbobo/Plan2Dance/wiki
