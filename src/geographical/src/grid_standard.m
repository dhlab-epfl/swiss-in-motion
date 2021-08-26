
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

    function grid_standard( mb_input, mb_color, mb_output, mb_maximum )

        % discretisation - in seconds %
        mb_disc = 30;

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

        % parsing grid priors %
        for mb_time = mb_ltime : mb_disc : mb_htime

            % display message %
            fprintf( 2, 'Processing time %i ...\n', mb_time );

            % reset grid frame %
            mb_frame = zeros(mb_gridh,mb_gridw,3);

            % processing layer %
            for mb_layer = 1 : size( mb_input, 2 )

                % display message %
                fprintf( 2, '    Layer %s\n', mb_input{1,mb_layer} );

                % compose file path %
                mb_prior = [ mb_input{1,mb_layer} '/' num2str( mb_time ) '.dat' ];

                % check frame existance %
                if ( exist( mb_prior, 'file' ) == 2 )

                    % display message %
                    fprintf( 2, '        %i\n', mb_time );

                    % import and prepare component %
                    mb_component = repmat( flip( dlmread( mb_prior, ' ' )', 1 ), [1,1,3] );

                    % apply color to layer %
                    mb_component(:,:,1) = mb_component(:,:,1) * mb_color{1,mb_layer}(1);
                    mb_component(:,:,2) = mb_component(:,:,2) * mb_color{1,mb_layer}(2);
                    mb_component(:,:,3) = mb_component(:,:,3) * mb_color{1,mb_layer}(3);

                    % import grid frame %
                    mb_frame = mb_frame + mb_component;

                else

                    % display message %
                    fprintf( 2, '    Missing layer\n' ); 

                end

            end

            % renormalise image %
            mb_export = uint8( ( asinh(mb_frame/2) / asinh(mb_maximum/2) ) * 255 );

            % export image %
            imwrite( mb_export, [ mb_output '/' num2str(mb_time) '.png' ] );

        end
        
    end
