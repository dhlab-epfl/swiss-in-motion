
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

    function canyon_toimage( dat, date  )

        % Import accumulation grid
        acc = load( dat );

        % Normalisation tests
        %acc = asinh( acc / 500 ); % dist
        acc = asinh( acc / 1000 ); % diff

        % Renormalisation
        acc = ( acc - min( acc(:) ) ) / ( max( acc(:) ) - min( acc(:) ) );

        % Transpose grid
        acc = acc';

        % Invert axis
        acc = acc(end:-1:1,:);

        % Export grid as image (PNG)
        imwrite( uint8( acc * 255 ), hot(256), [ date '.png' ]);

    end
