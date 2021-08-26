
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

    function mb_switch = process_grid_switch( mb_mode, mb_split, mb_data )

        if ( strcmp( mb_mode, 'static-house' ) == 1 )

            % check data availability %
            if ( isempty( mb_data{8} ) )

                % send message %
                error( 'missing data : Motif_Cat' );

            end

            % extract code %
            mb_dat8 = str2num( strrep( mb_split{1,mb_data{8}}, "\"", " " ) );

            % check switch %
            if ( mb_dat8 == 7 )

                % return switch %
                mb_switch = 'house/';

            else

                % return switch %
                mb_switch = 'other/';

            end

        else

            % retrun no switch %
            mb_switch = '';

        end

    end
