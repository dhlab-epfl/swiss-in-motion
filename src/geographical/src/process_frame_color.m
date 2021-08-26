
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

    function [ mb_color mb_flag ] = process_frame_color( mb_mode, mb_split, mb_data )

        if ( strcmp( mb_mode, 'motif-semaine' ) == 1 ) 

            % check data availability %
            if ( isempty( mb_data{6} ) )

                % send message %
                error( 'missing data : JOURS_SEMA' );

            end

            % check data availability %
            if ( isempty( mb_data{7} ) )

                % send message %
                error( 'missing data : MOTIF' );

            end

            # convert value #
            mb_dat6 = str2num( strrep( mb_split{1,mb_data{6}}, "\"", " " ) );
            mb_dat7 = str2num( strrep( mb_split{1,mb_data{7}}, "\"", " " ) );

            % switch on day of week %
            if ( mb_dat6 > 1 )

                % switch on motif %
                if ( ( mb_dat7 >= 6 ) && ( mb_dat7 <= 8 ) )

                    % assign color %
                    %mb_color = [ 0x59, 0x5b, 0xd4 ];
                    mb_color = [ 0xfd, 0x3d, 0x3a ];

                else

                    % assign color %
                    %mb_color = [ 0x3c, 0xaa, 0xdb ];
                    mb_color = [ 0xff, 0xcb, 0x2f ];

                end

                % assign flag %
                mb_flag = true;

            else

                % switch on motif %
                if ( ( mb_dat7 >= 6 ) && ( mb_dat7 <= 8 ) )

                    % assign color %
                    mb_color = [ 0xfd, 0x3d, 0x3a ];

                else

                    % assign color %
                    mb_color = [ 0xff, 0xcb, 0x2f ];

                end

                % assign flag %
                mb_flag = false;

            end

        else

            % assign default color %
            mb_color = [ 255, 0, 128 ];

            % assign flag %
            mb_flag = true;

        end

    end
