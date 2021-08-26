
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

    function grid( mb_path, mb_output )

        % discretisation - in seconds %
        mb_disc = 30;

        % accumulation parameter %
        mb_accum = 1; %60;

        % time boundaries %
        mb_ltime = 946684800 + 0; % 21600;
        mb_htime = 946684800 + 86400; %32400;

        % grid boundaries %
        mb_lgrid_x = 2480000; %2485000; %2485400;
        mb_hgrid_x = 2840000; %2834000; %2833800;
        mb_lgrid_y = 1070000; %1075000; %1075300;
        mb_hgrid_y = 1300000; %1296000; %1295900;

        % grid hectometric factor %
        mb_factor = 1000;

        % grid size %
        mb_gridw = (mb_hgrid_x-mb_lgrid_x)/mb_factor; 
        mb_gridh = (mb_hgrid_y-mb_lgrid_y)/mb_factor;

        % maximum tracking %
        mb_maxval = 0;

        % parsing grid priors %
        for mb_time = mb_ltime : mb_disc : mb_htime

            % display information %
            fprintf( 2, 'Processing time : %i ...\n', mb_time );

            % reset grid frame %
            mb_frame = zeros(mb_gridw,mb_gridh);

            % accumulation mechanism %
            for mb_i = mb_time : mb_disc : mb_time + ( ( mb_accum - 1 ) * mb_disc )

                % parsing sources %
                for mb_layer = 1 : size( mb_path, 2 )

                    % display message %
                    fprintf( 2, '    Layer %s\n', mb_path{1,mb_layer} );

                    % compute prior path %
                    mb_prior = [ mb_path{1,mb_layer} '/' num2str( mb_i ) '.dat' ];

                    % check frame %
                    if ( exist( mb_prior, 'file' ) == 2 )

                        % display information %
                        fprintf( 2, '        %i\n', mb_i );

                        % import data from prior %
                        mb_data = dlmread( mb_prior );

                        % re-normalise coordinates %
                        mb_data(:,1) = 1 + fix( ( mb_data(:,1) - mb_lgrid_x ) / mb_factor );
                        mb_data(:,2) = 1 + fix( ( mb_data(:,2) - mb_lgrid_y ) / mb_factor );

                        % parsing data %
                        for mb_j = 1 : size( mb_data, 1 )

                            % check coordinates %
                            if ( mb_data(mb_j,1) >= 1 )
                            if ( mb_data(mb_j,1) <= mb_gridw )
                            if ( mb_data(mb_j,2) >= 1 )
                            if ( mb_data(mb_j,2) <= mb_gridh )

                                % add statistical weight to grid unit
                                mb_frame(mb_data(mb_j,1),mb_data(mb_j,2)) = mb_frame(mb_data(mb_j,1),mb_data(mb_j,2)) + mb_data(mb_j,4);

                            end
                            end
                            end
                            end

                        end

                    end

                end

            end

            % compute maximum value %
            mb_localmax = max( mb_frame(:) );

            % detect maximum %
            if ( mb_localmax > mb_maxval )

                % keep maximum %
                mb_maxval = mb_localmax;

            end

            % export grid %
            dlmwrite( [ mb_output '/' num2str( mb_time ) '.dat' ], mb_frame, ' ' );

        end

        % display information %
        fprintf( 2, 'Maximum statistical weight : %f\n', mb_maxval );

    end

