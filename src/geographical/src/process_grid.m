
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

    function process_grid( mb_traj, mb_dtime, mb_atime, mb_wp, mb_filter_l, mb_filter_h, mb_output, mb_switch )

        % discretisation - in seconds %
        mb_disc = 30;

        % evanescence length - in seconds %
        mb_eva = mb_disc * 10;

        % fake date - in UTC seconds %
        mb_date = 946684800;

        % compute evanescence size in discretisation count %
        mb_eval = round( mb_eva / mb_disc );
        
        % align starting time on discretisation %
        mb_dround = fix( mb_dtime / mb_disc ) * mb_disc;

        % check alignement %
        if ( mb_dround < mb_dtime ); mb_dround = mb_dround + mb_disc; end

        % align arriving time on discretisation %
        mb_around = fix( mb_atime / mb_disc ) * mb_disc;

        % compute sampling array - true time %
        mb_tsample = [ mb_dround : mb_disc : mb_around ];

        % compute normalised sampling array %
        mb_nsample = ( mb_tsample - mb_dtime ) / ( mb_atime - mb_dtime );

        % compute trajectory sample %
        mb_sample = trajectory( mb_traj(:,1:2), mb_nsample );

        % check directory %
        if ( ~ exist( [ mb_output '/' mb_switch ], 'dir' ) )

            % create directory #
            system( [ 'mkdir -p ' mb_output '/' mb_switch ] );

        end

        % parsing sample array %
        for mb_i = 1 : size( mb_sample, 1 )

            % apply time filter - clamping on restricted time range %
            if ( ( mb_tsample(mb_i) >= mb_filter_l ) && ( mb_tsample(mb_i) <= mb_filter_h ) )

                % create output stream %
                mb_stream = fopen( [ mb_output '/' mb_switch num2str( mb_date + mb_tsample(mb_i) ) '.dat' ], 'a+' );

                % export position and weight %
                fprintf( mb_stream, '%f %f %f %f\n', mb_sample(mb_i,1), mb_sample(mb_i,2), 0, str2num(mb_wp) );
                
                % delete output stream %
                fclose( mb_stream );

            end

        end

    end
