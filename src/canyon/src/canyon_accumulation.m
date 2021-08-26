
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

    function canyon_accumulation( path, date_, factor )

        % List available grids
        list = dir( [ path '/*' ] );

        % Load first image for dimension
        tmp = load( [ path '/' list(1).name ] );

        % Initialise accumulator
        acc = zeros( size( tmp ) );

        % Compute step value
        step = fix( size( list, 1 ) / factor ) ;

        % Initialise counter
        r = 1;

        % Parisng grid files
        for file = 1 : 1 : size( list, 1 )

            % Load current grid
            part = load( [ path '/' list(file).name ] );

            % Accumulation process
            acc = acc + part;

            % Check modular condition for step exportation
            if ( ( mod( file, step ) == 0 ) )

                % Export accumulator state
                dlmwrite( [ date_ '_' sprintf( '%i', r ) '.dat' ], acc, ' ' );

                % Reset accumulator
                acc = zeros( size( tmp ) );

                % Update counter
                r = r + 1;

            end

        end

    end
