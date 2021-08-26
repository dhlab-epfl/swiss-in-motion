
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

    function process(mb_csvfile, mb_output)

        % csv file specification :
        %
        % as the coma is used to separate point in WKT, the semi-colon is used
        % as the csv main delimiter.

        % create target %
        mb_target{1} = 'WKT';           % geometry %
        mb_target{2} = 'TIME_DEPAR';    % departure time %
        mb_target{3} = 'TIME_ARRIV';    % arrival time %
        mb_target{4} = 'free';
        mb_target{5} = 'WP';            % statistical weight %

        mb_target{6} = 'JOURS_SEMA';    % week or week-end %
        mb_target{7} = 'MOTIF';         % reason of mobility %

        % create input stream %
        mb_stream = fopen(mb_csvfile);

        % check stream %
        if ( mb_stream < 0 )

            % send message %
            error( 'unable to open csv file' );

        end

        % read first line - header %
        mb_header = fgetl( mb_stream );

        % decompose header %
        mb_header = strsplit( mb_header, ';', 'CollapseDelimiters', false );

        % initialise data pointer %
        mb_data = cell( size( mb_target ) );

        % parsing header %
        for mb_j = 1 : size( mb_header, 2 )

            % parsing target %
            for mb_i = 1 : size( mb_target, 2 )

                % detection %
                if ( strfind(mb_header{mb_j}, mb_target{mb_i}) )

                    % assign detected index %
                    mb_data{mb_i} = mb_j;

                end

            end

        end
        
        % read next line %
        mb_line = fgetl( mb_stream );

        % define filtering times %
        mb_filter_l = 0; %21600;
        mb_filter_h = 86400; %32400;

        % parsing csv file %
        while ( ischar(mb_line) )

            % decompose string %
            mb_split = strsplit(mb_line, ';', 'CollapseDelimiters', false );

            % display information %
            fprintf( 2, 'Processing with time %s - %s\n', mb_split{1,mb_data{2}}, mb_split{1,mb_data{3}} );

            % extract time %
            mb_dtime = process_clock(mb_split{1,mb_data{2}});
            mb_ftime = process_clock(mb_split{1,mb_data{3}});

            % check wkt string %
            if ( ~ isempty(mb_split{1,mb_data{1}}) )

                % avoid null time range %
                if ( ( mb_ftime - mb_dtime ) > 0 )

                    % check filter %
                    if ( mb_ftime > mb_filter_l )
                    if ( mb_dtime < mb_filter_h )

                        % error management %
                        try

                            % extract trajectory %
                            mb_traj = process_readwkt(mb_split{1,mb_data{1}});

                            % display information %
                            fprintf( 2, 'Compute frame ... ' );

                            % query color %
                            [ mb_color mb_flag ] = process_frame_color( 'motif-semaine', mb_split, mb_data );

                            % check flag %
                            if ( mb_flag == true )

                                % compute frames %
                                process_frame(mb_traj, mb_dtime, mb_ftime, mb_filter_l, mb_filter_h, mb_color, mb_output );

                            end

                            % compute grid %
                            %process_grid(mb_traj, mb_dtime, mb_ftime, mb_split{1,mb_data{5}}, mb_filter_l, mb_filter_h, mb_output );

                            % display information %
                            fprintf( 2, 'Done\n' );

                        % error management %
                        catch

                            % display message %
                            fprintf( 2, 'Error on data processing\n' );

                        end

                    end
                    end

                else

                    % display information %
                    fprintf( 2, 'Warning : null time range\n' );

                end

            else

                % display information %
                fprintf( 2, 'Warning : empty wkt string\n' );

            end

            % read next line %
            mb_line = fgetl( mb_stream );

        end

        % delete input stream %
        fclose( mb_stream );

    end

    function mb_traj = process_readwkt(mb_string)

        % check data type %
        if ( isempty(strfind(mb_string, "MULTILINESTRING")) )

            % check data type %
            if ( isempty(strfind(mb_string, "POINT")) )

                % remove wkt descriptor %
                mb_string = strrep(mb_string,"\"LINESTRING (", "" );

                % remove wkt trailing %
                mb_string = strrep(mb_string,")\"" , "" );

                % remove wkt comma %
                mb_string = strrep(mb_string,",", " " );

                % split string on space %
                mb_string = strsplit(mb_string, ' ' );

                % convert string to numbers %
                mb_string = cellfun(@str2num,mb_string);

                % return trajectory as an array of point %
                mb_traj = reshape(mb_string,[2,size(mb_string,2)/2])';

                % add altitude column %
                mb_traj = [ mb_traj, zeros(size(mb_traj,1),1) ];

            else

                % remove wkt descriptor %
                mb_string = strrep(mb_string,"\"POINT Z (", "" );

                % remove wkt trailing %
                mb_string = strrep(mb_string,")\"" , "" );

                % split string on space %
                mb_string = strsplit(mb_string, ' ' );

                % convert string to numbers %
                mb_string = cellfun(@str2num,mb_string);

                % return trajectory as an array of point %
                mb_traj = reshape(mb_string,[3,size(mb_string,2)/3])';

                % add altitude column %
                mb_traj = [ mb_traj; mb_traj + [ 1, 1, 0 ] ];

            end

        else

            % remove wkt descriptor %
            mb_string = strrep(mb_string,"\"MULTILINESTRING Z ((", "" );

            % remove wkt trailing %
            mb_string = strrep(mb_string,"))\"", "" );

            % remove wkt comma %
            mb_string = strrep(mb_string,",", " " );

            % split string on space %
            mb_string = strsplit(mb_string, ' ' );

            % convert string to numbers %
            mb_string = cellfun(@str2num,mb_string);

            % return trajectory as an array of point %
            mb_traj = reshape(mb_string,[3,size(mb_string,2)/3])';

        end

    end

    function mb_second = process_clock(mb_string)

        % decompose clock string %
        mb_component = strsplit( mb_string, ':' );

        % compute amount of seconds since midnight %
        mb_second = ( str2num(mb_component{1,1}) * 60 + str2num(mb_component{1,2}) ) * 60 + str2num(mb_component{1,3});

    end

