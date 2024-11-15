function datastreams = extract_delsys_data(delsys_data, names, flag_resample, flag_plotting)
% EXTRACT_DELSYS_DATA Extracts and processes data from Delsys sensors.
%
%   datastreams = EXTRACT_DELSYS(delsys_data, names, flag_resample)
%   extracts data from the provided Delsys data structure based on the
%   specified channel names and fields. Optionally, the data can be 
%   resampled to a different sampling rate.
%
%   INPUTS:
%       delsys_data   - A structure obtained from Delsys export utility with the following fields:
%                       'Time'     : Time vector for the data.
%                       'Channels' : Cell array of channel names.
%                       'Fs'       : Sampling frequency of the data.
%                       'Data'     : Data matrix with rows corresponding to channels.
%       names         - A cell array where each row specifies a channel name
%                       and the required field name to extract. The format is:
%                       {channel_name, field_name, resample_fs}
%                       resample_fs is the new sampling frequency if resampling is needed.
%       flag_resample - (Optional) A flag indicating whether to resample the data.
%                       Default is 0 (no resampling).
%       flag_plotting - (Optional) A flag indicating whether to plot the data.
%                       Default is 0 (no plotting).
%
%   OUTPUTS:
%       datastreams   - A cell array where each row contains the extracted data
%                       and associated information for each specified channel:
%                       {data, sampling_rate, channel_name, field_name}
%
%   EXAMPLE:
%       delsys_data = load('data.mat')
%       names = {'EMG1', 'EMG', 500; 'ACC1', 'ACC', 50};
%       datastreams = extract_delsys(delsys_data, names, 1);
%
%   Author: Roberto Barumerli
%   Date: 2021-09-30
%   Version: 1.0
%   Email: roberto.barumerli@univr.it 

    assert(isfield(delsys_data, 'Time'))
    assert(isfield(delsys_data, 'Channels'))
    assert(isfield(delsys_data, 'Fs'))
    assert(isfield(delsys_data, 'Data'))

    assert(iscell(names) & size(names, 2) > 1)

    if ~exist("flag_resample", "var")
        flag_resample = 0;
    end

    if ~exist("flag_plotting", "var")
        flag_plotting = 0;
    end

    % this is aligned with names
    datastreams = cell(size(names, 1), 2);
    
    for n = 1:size(names, 1)
        channels = {}; 

        % load names into channels (using cell array because easier) 
        for i=1:size(delsys_data.Channels); channels{i,1} = delsys_data.Channels(i,:); end
        
        % find idx with name 
        idx_channel = cellfun(@(x) contains(x, names{n,1}, 'IgnoreCase', true), channels);
    
        assert(sum(idx_channel) > 0, 'name %s not found in the channels', names{n,1})
    
        % get data
        dt = delsys_data.Data(idx_channel,:); 
        fs = delsys_data.Fs(idx_channel,:); 
        time = delsys_data.Time(idx_channel,:); 
        
        if ~isempty(names{n,2}) % if empty keep them all
            % look for specific field (EMG, ACC...) of the selected channel
            idx_field = cellfun(@(x) contains(x, names{n,2}, 'IgnoreCase', true), channels(idx_channel, :));
            
            assert(sum(idx_field) > 0, 'channel %s: name %s not found in the fields', names{n,1}, names{n,2})
    
            % keep only select fields
            dt = dt(idx_field,:);
            fs = fs(idx_field,:);
            time = time(idx_field,:);
        else 
            error('Not supported since EMG and accelerometer have different fs. Add a second row in names.')
        end
    
        % since we are extracting the same quantity with multiple channels,
        % these should have the same sampling rate
        assert(length(unique(fs)) == 1, 'way to many sampling rates')
        fs = unique(fs); 
    
        % collapsing time to a single dimension
        time = time(1, :);
    
        % delsys does some zero padding to align the data with different
        % sampling rates. 
        % To solve this, we compute the diff and we take the last position
        % going to zero
        idx_sample = find(diff(dt(1,:)==0));
        dt = dt(:, 1:idx_sample(end));
        time = time(:, 1:idx_sample(end));
    
        % resample? 
        if flag_resample
            assert(names{n,3} > 0, 'something is wrong with the resampling fs');
    
            fs =  names{n,3};
            dt = resample(dt', time, fs)'; % transposing
        end
    
        % save data and sampling rate
        datastreams{n,1} = dt;
        datastreams{n,2} = fs;
        datastreams{n,3} = names{n, 1};
        datastreams{n,4} = names{n, 2};
    end

    if flag_plotting
        figure
        nsp = size(datastreams, 1);
        for i=1:nsp
            subplot(nsp,1,i)
            plot((1:(length(datastreams{i,1})))/datastreams{i,2}, datastreams{i,1})
            ylabel(strcat(datastreams{i,3:4}))
        end
        xlabel('Time')
    end
end
