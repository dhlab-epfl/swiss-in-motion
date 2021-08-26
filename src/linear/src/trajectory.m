
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

    function trajectory( ls_file, ls_output )

        % avoid header flag %
        ls_flag = 0;

        % create input stream %
        ls_stream = fopen( ls_file, 'r' );

        % parsing input stream %
        while ( ~ feof( ls_stream ) )

            % read stream line %
            line = fgetl( ls_stream );

            % check consistency %
            if ( ~ isempty( line ) )

                % check header flag %
                if ( ls_flag == 0 )

                    % update header flag %
                    ls_flag = 1;

                else

                    % display information %
                    fprintf( 2, 'Line : %s ...\n', line );

                    % standardise line %
                    line = strrep( line, ',', '.' );
                    line = strrep( line, ';', ' ' );

                    % process line %
                    import_process( textscan( line, '%d %f %d %d %d %s %s %f %f %f %f %d %d %d' ), ls_output, 30, 64 );

                    %ls_flag = ls_flag + 1; if ( ls_flag > 1024 ); return; end

                end

            end

        end

        % delete input stream %
        fclose( ls_stream );

    end

    function ls_color = import_get_color( ls_type )

        % type selector %
        switch ( ls_type )

            % type case %
            case   1 ; ls_color = uint8( [253,  61,  58] );
            case   2 ; ls_color = uint8( [255, 149,  39] );
            case   3 ; ls_color = uint8( [255, 203,  47] );
            case   4 ; ls_color = uint8( [ 83, 217, 106] );
            case   5 ; ls_color = uint8( [ 60, 170, 219] );
            case   6 ; ls_color = uint8( [ 22, 127, 252] );
            case   7 ; ls_color = uint8( [ 89,  91, 212] );
            case -99 ; ls_color = uint8( [252,  50,  88] );

            % unknown type %
            otherwise ; ls_color = [];

        end

    end

    function ls_sec = import_date_to_sec( ls_timestring )

        % decompose clock pattern %
        ls_clock = textscan( ls_timestring, '%d:%d:%d' );

        % compute time in second %
        ls_sec = ls_clock{1} * 3600 + ls_clock{2} * 60 + ls_clock{3};

    end

    function ls_round = import_round( ls_sec, ls_res )

        % round time on discretisation mesh %
        ls_round = floor( ls_sec / ls_res ) * ls_res;

    end

    function import_process( ls_data, ls_output, ls_res, memory )

        % comptue travel start and end time %
        ls_dep = import_round( double( import_date_to_sec( ls_data{6}{1} ) ), ls_res );
        ls_arr = import_round( double( import_date_to_sec( ls_data{7}{1} ) ), ls_res );

        % check consistency %
        if ( ls_arr == ls_dep )

            % display message %
            fprintf( 2, 'dropping line : time consistency' );

            % abort process %
            return;

        end

        % extract travel mean %
        ls_type = ls_data{ 4};

        % extract color %
        ls_color = import_get_color( ls_type );

        % check consistency %
        if ( length( ls_color ) == 0 )

            % display message %
            fprintf( 2, 'dropping line : type consistency' );

            % abort process %
            return;

        end

        % extract travel start position %
        ls_dep_x = ls_data{ 8};
        ls_dep_y = ls_data{ 9};

        % extract travel end position %
        ls_arr_x = ls_data{10};
        ls_arr_y = ls_data{11};

        % compute trajectory delta %
        ls_del_x = ls_arr_x - ls_dep_x;
        ls_del_y = ls_arr_y - ls_dep_y;

        % extunction time %
        ls_extinct = import_round( 600, ls_res );

        % parsing time range with step %
        for ls_param = ( ls_dep + ls_res ) : ls_res : ( ls_arr + ls_extinct - ls_res )

            % create output stream %
            ls_stream = fopen( [ ls_output '/' num2str( ls_param + int64( 1120176000 ) ) '.uv3' ], 'at' );

            % trajecotry time range %
            ls_lbound = max( ls_dep, ls_param - ls_extinct );
            ls_ubound = min( ls_arr, ls_param );

            % parsing time range %
            for ls_range = ls_lbound : ls_res : ls_ubound

                % compute color factor %
                ls_cfactor = 1.0 - ( ( ls_param - ls_range ) / ls_extinct );

                % compute position factor %
                ls_pfactor = ( ls_range - ls_dep ) / ( ls_arr - ls_dep );

                % compute current position %
                ls_cpos_x = ls_dep_x + ls_del_x * ls_pfactor;
                ls_cpos_y = ls_dep_y + ls_del_y * ls_pfactor;

                % compute current color %
                ls_ccolor = ls_color * ls_cfactor;

                % check condition %
                if ( ls_range != ls_lbound )

                    % pack position %
                    ls_pose = [ ls_ppos_x, ls_ppos_y, 0.0 ] * ( pi / 180 );

                    % pack data %
                    ls_data = [ 2, ls_pcolor(1), ls_pcolor(2), ls_pcolor(3) ];

                    % export vertex %
                    fwrite( ls_stream, ls_pose, 'double' ); fwrite( ls_stream, ls_data, 'uint8' );

                    % pack position %
                    ls_pose = [ ls_cpos_x, ls_cpos_y, 0.0 ] * ( pi / 180 );

                    % pack data %
                    ls_data = [ 2, ls_ccolor(1), ls_ccolor(2), ls_ccolor(3) ];

                    % export vertex %
                    fwrite( ls_stream, ls_pose, 'double' ); fwrite( ls_stream, ls_data, 'uint8' );

                end

                % push position %
                ls_ppos_x = ls_cpos_x;
                ls_ppos_y = ls_cpos_y;

                % push color %
                ls_pcolor = ls_ccolor;

            end

            % delete output stream %
            fclose( ls_stream );

        end

    end

