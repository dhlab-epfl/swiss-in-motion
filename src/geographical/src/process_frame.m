
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

    function process_frame( mb_traj, mb_dtime, mb_atime, mb_filter_l, mb_filter_h, mb_color, mb_output )

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

        % compute last active index %
        mb_lastac = length( mb_tsample );

        % add sampling point to keep trail evanescence %
        mb_tsample = [ mb_dround : mb_disc : mb_around + mb_eva ];

        % parsing sample array %
        for mb_i = 2 : length( mb_tsample )

            % apply time filter - clamping on restricted time range %
            if ( ( mb_tsample(mb_i) >= mb_filter_l ) && ( mb_tsample(mb_i) <= mb_filter_h ) )

                % create output stream %
                mb_stream = fopen( [ mb_output '/' num2str( mb_date + mb_tsample(mb_i) ) '.uv3' ], 'a+' );

                % parsing trail %
                for mb_j = min( mb_i, mb_lastac ) : -1 : max( mb_i - mb_eval, 2 )

                    % compute color %
                    %mb_coleva = 255 - ( ( mb_tsample(mb_i) - mb_tsample(mb_j) ) / mb_eva ) * 255;
                    mb_coleva = 1 - ( ( mb_tsample(mb_i) - mb_tsample(mb_j) ) / mb_eva );

                    % compute vertex %
                    mb_verta = [ mb_sample(mb_j  ,1), mb_sample(mb_j  ,2), 0.0 ] * ( pi / 180 );

                    % compute data %
                    %mb_data = [ 2, mb_coleva, 0, mb_coleva * 0.5 ];
                    mb_data = [ 2, mb_coleva * mb_color ];

                    % export primitive %
                    fwrite( mb_stream, mb_verta(1:3), 'double' );
                    fwrite( mb_stream, mb_data (1:4), 'uint8' );

                    % compute color %
                    %mb_colevb = 255 - ( ( mb_tsample(mb_i) - mb_tsample(mb_j-1) ) / mb_eva ) * 255;
                    mb_colevb = 1 - ( ( mb_tsample(mb_i) - mb_tsample(mb_j-1) ) / mb_eva );

                    % compute vertex %
                    mb_vertb = [ mb_sample(mb_j-1,1), mb_sample(mb_j-1,2), 0.0 ] * ( pi / 180 );;

                    % compute data %
                    % mb_datb = [ 2, mb_colevb, 0, mb_colevb * 0.5 ];
                    mb_datb = [ 2, mb_colevb * mb_color ];

                    % export primitive %
                    fwrite( mb_stream, mb_vertb(1:3), 'double' );
                    fwrite( mb_stream, mb_datb (1:4), 'uint8' );

                end
                
                % delete output stream %
                fclose( mb_stream );

            end

        end

    end
