
    % CROSS : Swiss In Motion
    % 
    %     Nils Hamel - nils.hamel@alumni.epfl.ch
    % 
    %     Copyright (c) 2019-2020 DHLAB, EPFL
    %     Copyright (c) 2020 Republic and Canton of Geneva
    %     Copyright (c) 2020 Centre Universitaire d’Informatique (CUI), University of Geneva
    % 
    % This program is free software: you can redistribute it and/or modify
    % it under the terms of the GNU Affero General Public License as published by
    % the Free Software Foundation, either version 3 of the License, or
    % (at your option) any later version.
    % 
    % This program is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU Affero General Public License for more details.
    % 
    % You should have received a copy of the GNU Affero General Public License
    % along with this program.  If not, see <http://www.gnu.org/licenses/>.

    function grid_time(mb_input, mb_output)

        % discretisation - in seconds %
        mb_disc = 30;

        % derivative multiplier %
        mb_accum = 60 / 2;

        % time boundaries %
        mb_ltime = 946684800 + 0; % 21600;
        mb_htime = 946684800 + 86400; %32400;

        % parsing grid priors %
        for mb_time = mb_ltime + ( mb_disc * mb_accum ) : mb_disc : mb_htime - ( mb_disc * mb_accum )

            % compose file path %
            mb_prior = [ mb_input '/' num2str( mb_time + ( mb_disc * mb_accum ) ) '.dat' ];

            % import grid frame %
            mb_frame_new = dlmread( mb_prior );

            % compose file path %
            mb_prior = [ mb_input '/' num2str( mb_time - ( mb_disc * mb_accum ) ) '.dat' ];

            % import grid frame %
            mb_frame_old = dlmread( mb_prior );

            % renormalise image %
            mb_export = uint8((mb_frame_new-mb_frame_old)*0.5*0.6666666+127.5); % 20 if accumulation is at 1

            % export image %
            imwrite( mb_export(:,end:-1:1)', hot(256), [ mb_output '/' num2str(mb_time) '.png' ] );

        end
        
    end
