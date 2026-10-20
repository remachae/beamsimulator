# Beam Simulator

### Explore beam propagation for light-sheet microscopy

A MATLAB application for simulating illumination beams, visualizing their propagation, and exploring the relationship between main-lobe width, optical sectioning, and beam length.

**MATLAB · Fourier optics · Light-sheet microscopy**

[Getting started](#getting-started) · [Beam configurations](#beam-configurations) · [Analysis](#understanding-the-results) · [Repository structure](#repository-structure)

## Overview

Beam Simulator combines an interactive MATLAB interface with numerical routines for pupil construction, field propagation, and beam analysis.

- Define pupil amplitude and phase profiles.
- Simulate beam propagation using an angular-spectrum method.
- Visualize beam cross-sections and integrated intensity distributions.
- Calculate main-lobe width, optical-sectioning thickness, and beam length.

## Getting started

### Requirements

- **MATLAB** with support for App Designer `.mlapp` files. The bundled app was saved with R2017b; compatibility with other releases has not been verified.
- **Image Processing Toolbox** for the TIFF-upload path, which uses `padarray`.
- Sufficient memory to handle padded three-dimensional field arrays.

### Installation

Download the repository using **Code → Download ZIP**, or clone it:

```bash
git clone https://github.com/remachae/beamsimulator.git
```

### Launch the app

Set MATLAB’s **Current Folder** to the repository root, then run:

```matlab
addpath(fullfile(pwd, 'GeneralFunctions'));
LightSheet_Simulator
```

Alternatively, open `LightSheet_Simulator.mlapp` in App Designer and click **Run**.

### First simulation

1. Open the **Gaussian beam** tab.
2. Enter a nonzero numerical aperture, for example `0.2`.
3. Keep the initial wavelength of `488 nm`, refractive index of `1.33`, and **Linear** excitation.
4. Click **Simulate** to generate the beam plots.
5. Click **Analyze** to calculate the beam metrics.

This is a suggested starting configuration, not a validated benchmark. Enter the NA explicitly: the application initializes beam parameters through the parameter-change callbacks.

## Beam configurations

The following configurations have corresponding pupil-generation branches in the source:

| Configuration | Pupil model | Main controls |
| --- | --- | --- |
| Gaussian | Gaussian amplitude | NA |
| Focused flat-top | Uniform circular aperture | NA |
| Airy | Circular aperture with a cubic phase mask | NA, phase amplitude |
| Dithered Bessel beam lattice | Gaussian annular amplitude modulated by a periodic grid | NA, epsilon |
| Spherically aberrated | Circular aperture with a quartic radial phase | NA, phase amplitude |
| Double beam | Two displaced Gaussian amplitudes | NA, separation parameter |

The interface also includes **Bessel beam** and **Upload** tabs. The standalone Bessel branch is missing from the current pupil-generation code, and the TIFF-upload workflow requires further validation.

## Understanding the results

The application displays beam cross-sections and integrated intensity projections. Analysis is performed on the projection integrated along `y`.

| Metric | Definition in the implementation |
| --- | --- |
| **Main Lobe Width** | Sampled width around the peak at the **1/e intensity** threshold. This is not FWHM. |
| **Optical Sectioning** | Window width containing at least **1 − 1/e ≈ 63.2%** of the transverse integrated intensity, using the implemented search around the peak. |
| **Length** | Distance between the positions on either side of the minimum where optical-sectioning thickness reaches twice its minimum value. |

Wavelength is entered in **nanometres** and converted internally to **micrometres**. Reported widths and lengths are therefore in micrometres.

Missing threshold crossings or profiles extending beyond the simulation window can produce `NaN` values or analysis errors.

## Repository structure

| File or folder | Description |
| --- | --- |
| [`LightSheet_Simulator.mlapp`](LightSheet_Simulator.mlapp) | Interactive MATLAB application |
| [`simulatebeam_gui.m`](simulatebeam_gui.m) | Simulation entry point called by the app |
| [`GeneralFunctions/`](GeneralFunctions/) | Numerical routines for setup, pupil construction, propagation, visualization, and analysis |

### Main numerical routines

| Routine | Purpose |
| --- | --- |
| `prepare_data_gui.m` | Initializes physical parameters, grid sizes, and padding |
| `derivePhysicalAndNumericalParameters.m` | Calculates wave numbers, spatial sampling, and propagation step |
| `createMeshgrids.m` | Constructs spatial and frequency grids and propagation operators |
| `compute_E_in_bfp.m` | Builds the pupil amplitude and complex phase factor |
| `myFFT.m` | Applies the project's shifted Fourier-transform convention |
| `propVolInt.m` | Propagates the field and returns intensity and complex field volumes |
| `integrate_and_slice_gui.m` | Displays beam slices and integrated projections |
| `analysisbeam_gui.m` | Calculates optical sectioning, main-lobe width, and beam length |

Several setup files are scripts that depend on the calling workspace rather than standalone functions.

## Implementation notes

- In the main simulation path, `x` is the propagation direction, and `y` and `z` are transverse coordinates. The intensity volume is indexed as `(z, y, x)`.
- The **Two photon** selection changes numerical sampling. The inspected propagation path still calculates intensity as `abs(E).^2`; it does not apply a separate nonlinear fluorescence response.
- The **Save** callback writes pupil amplitude and phase TIFFs rather than a complete MATLAB workspace. Complex phase handling requires validation before using these files for pupil reconstruction.
- Some legacy axis labels and helper functions use different conventions. Check array indexing when interpreting exported or intermediate data.

## Reproducibility

When sharing results, record:

- Repository commit and MATLAB release.
- Beam configuration and numerical aperture.
- Wavelength and refractive index.
- Excitation selection.
- Additional phase, epsilon, or separation parameters.
- Any changes to the numerical grid or sampling.

## Questions and feedback

For questions or bug reports, open a [GitHub issue](https://github.com/remachae/beamsimulator/issues). Include your MATLAB release, simulation parameters, and any error messages or relevant screenshots.
