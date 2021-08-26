
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

    function [ mb_point ] = trajectory(mb_traj, mb_sample)

        % compute segment vector %
        mb_segment = (mb_traj - circshift(mb_traj,1))(2:end,:);

        % compute segment norm %
        mb_norm = cellfun(@norm,num2cell(mb_segment,2));

        % normalise norm %
        mb_norm = mb_norm / sum(mb_norm);

        % compute cumulative norms %
        mb_cumu = cumsum( mb_norm );

        % initialise point array %
        mb_point = zeros( length( mb_sample ), 2 );

        % parsing sampling parameter %
        for mb_i = 1 : length( mb_sample )

            % compute sampled point %
            mb_point(mb_i,:) = trajectory_point( mb_traj, mb_norm, mb_cumu, mb_segment, mb_sample(mb_i) );

        end

    end

    function mb_point = trajectory_point( mb_traj, mb_norm, mb_cumu, mb_segment, mb_param )

        % case study %
        if (mb_param<=0)

            % return trajectory starting point %
            mb_point = mb_traj(1,:);

        elseif (mb_param>=1)

            % return trajectory end point %
            mb_point = mb_traj(end,:);

        else
        
            % initialise index %
            mb_i = 1;

            % detect index %
            while(mb_param>mb_cumu(mb_i)); mb_i = mb_i + 1; end

            % update parameter origin %
            if (mb_i>1)
                mb_param = mb_param - mb_cumu(mb_i-1);
            end

            % parameter normalisation %
            mb_param = mb_param / mb_norm(mb_i);

            % compute and return point %
            mb_point = mb_traj(mb_i,:)+mb_segment(mb_i,:)*mb_param;

        end

    end
