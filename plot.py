#!/usr/bin/env python3

# Reads a given NetCDF file as input, and uses xarray and matplotlib
# to create one plot of a variable for each time step available.
# Source: https://stackoverflow.com/a/49043058

from argparse import ArgumentParser

from pathlib import Path

import xarray as xr
import matplotlib
import matplotlib.pyplot as plt

def main():
    parser = ArgumentParser(description='Plot one PNG file to each time step value of a NetCDF variable')
    parser.add_argument('-i', '--input', dest='input', required=True)
    parser.add_argument('-v', '--variable', dest='variable', required=True)
    parser.add_argument('-o', '--output', dest='output', required=True)

    args = parser.parse_args()

    matplotlib.use('Agg')
    file_name = Path(args.input)
    output_path = Path(args.output).resolve()
    with xr.open_dataset(filename_or_obj=file_name, engine='netcdf4') as ds:
        for t in range(ds.time.shape[0]):
            da = ds[args.variable].isel(time=t)
            plt.figure()
            da.plot()
            output_file = output_path / f'frame_{t}.png'
            plt.savefig(str(output_file))
            plt.close()


if __name__ == '__main__':
    main()
