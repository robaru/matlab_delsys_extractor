# MATLAB Utility for Processing Delsys EMG Data

This repository provides a MATLAB function, `extract_delsys_data`, designed to simplify and process data exported from the **Delsys Trigno Wireless EMG system**. I have found the exported data from the [Delsys File Utility](https://delsys.com/support/software/) organized in a complex structure, making it challenging to work with directly. This function facilitates data extraction, transformation, and resampling, aiming to provide a data structure easier to work with.

---

## Key Features

### 1. **Simplified Data Extraction**
The function extracts specific channels and fields from the Delsys data structure, streamlining the transformation process.

### 2. **Resampling Capability**
Handles variations in sampling frequencies across different sensors by providing a resampling option. This ensures consistent sampling rates for synchronized analysis.

### 3. **Optional Data Plotting**
Includes a plotting feature to visualize the processed data directly from MATLAB.

---

## Function Overview

### Function Signature
```matlab
datastreams = extract_delsys_data(data_path, names, flag_resample, flag_plotting)
```

### Inputs
1. **`data_path`**  
   Path to the `.mat` file exported from the Delsys File Utility. The file should include fields:
   - `Time`: Time vector for the data.
   - `Channels`: Cell array of channel names.
   - `Fs`: Sampling frequency for each channel.
   - `Data`: Data matrix (rows correspond to channels).

2. **`names`**  
   A cell array specifying the channels and fields to extract. Format:  
   `{channel_name, field_name, resample_fs}`  
   - `channel_name`: Name of the channel to extract.
   - `field_name`: Specific field to extract (e.g., EMG, ACC).
   - `resample_fs`: New sampling frequency (used if resampling is enabled).

3. **`flag_resample`** (Optional)  
   - Set to `1` to enable resampling.
   - Default: `0` (no resampling).

4. **`flag_plotting`** (Optional)  
   - Set to `1` to enable data visualization.
   - Default: `0` (no plotting).

### Outputs
**`datastreams`**: A cell array where each row corresponds to extracted data:
- Column 1: Extracted data matrix.
- Column 2: Sampling frequency.
- Column 3: Channel name.
- Column 4: Field name.

---

## Example Usage

```matlab
% Load Delsys exported data
data_path = 'data.mat';

% Define channels and fields to extract
names = {
    'muscle1', 'emg', 500;  % Extract emg data from channel muscle1 and resample to 500 Hz
    'hand2', 'acc', 50    % Extract accelerometer data from channel hand2 and resample to 50 Hz
};

% Extract and resample data with visualization
datastreams = extract_delsys_data(data_path, names, 1, 1);
```

The result will be something like this: 

![Plot Example](plot.png)

---

## Repository Contents
- **`extract_delsys_data.m`**: The main MATLAB function for extracting and processing Delsys data.
- **`example_usage.m`**: A sample script to demonstrate usage.
- **`README.md`**: Documentation for the repository.

---

## Requirements
- **MATLAB** (Tested on version `R2022b` or later)
- Data exported from the **Delsys File Utility**.

---

## Getting Started
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo-name.git
   ```
2. Open MATLAB and navigate to the cloned repository.
3. Use the `example_usage.m` script to test the function with your data.

---

## Contribution
Contributions are welcome! Feel free to open issues or submit pull requests to improve the function or add new features.

---

If you find this repository helpful, please star it and share your feedback.


## License

This project is licensed under the [EUPL v1.2](https://eupl.eu/1.2/en/) License.