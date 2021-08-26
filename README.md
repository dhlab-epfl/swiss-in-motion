# Overview

This repository holds the scripts used to create the precursor data to the [4D platform](https://github.com/nils-hamel/eratosthene-suite) in the context of the study of the Swiss mobility. The code is written in _Octave/MATLAB_ and was used in the context of the _CROSS_ project _Swiss in Motion_.

# Structure

Three groups of script are available :

* linear : Used to create the first phase linear approximation of the mobility

* geographical : used to create the second phase geographical representation of the mobility

* canyon : these last experimental group was made to deduce mobility canyon model on presence grids (composed by the _geographical_ approach)

These scripts can be used within an _Octave/MATLAB_ prompt and are tested under _Octave_ on _Ubuntu 16.04_. In addition, some parameters are tweaked directly in the code. These scripts remaining research and experimental.

# Data

The used data are coming from the _Swiss Federal Statistical Office_ and are the result of repeated [micro-census survey (MMRT)](https://www.bfs.admin.ch/bfs/fr/home/statistiques/mobilite-transports/enquetes/mzmv.html).

# Copyright and License

**swiss-in-motion** - Nils Hamel <br />
Copyright (c) 2019-2020 DHLAB, EPFL <br />
Copyright (c) 2020 Republic and Canton of Geneva <br />
Copyright (c) 2020 Centre Universitaire d’Informatique (CUI), University of Geneva

This program is licensed under the terms of the AGNU GPLv3.
