% This file is a part of drivecycle, a code to import xlsx data for various
% vehicle drivecycles.
% 
% Copyright (C) 2020 Ciarán O'Reilly <ciaran@kth.se>
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

classdef drivecycle
  methods(Static)
    
    %%
    function drivecycle=import(drivecycle)
      if ~isstruct(drivecycle)
        name = drivecycle;
        drivecycle = [];
        drivecycle.name = name;
      end
      tabledata = [drivecycle.name,'.xlsx'];
      t = readtable(tabledata);
      vel = t.vel/3.6; %km/h to m/s
      t = t.t;
      n=length(t);
      D=spdiags(repmat([-0.5 0 0.5],n,1),-1:1,n,n)+sparse([1 1 n n],[1 2 n-1 n],[-1 0.5 -0.5 1]);
      dt=D*t;
      dx=vel.*dt;
      x=cumsum(dx);
      acc=D*vel./dt;
      r=sum(acc<0)/numel(acc);
      acc(acc<0)=0;
      drivecycle.t=t;
      drivecycle.x=x;
      drivecycle.vel=vel;
      drivecycle.acc=acc;
      drivecycle.r=r;
      drivecycle.cr=sum(dx);
      drivecycle.cd=sum(vel.^3.*dt);
      drivecycle.ca=sum(acc.*vel.*dt);
    end
    
    %%
    function plotdc(drivecycle,v1,v2)
      eval(['plot(drivecycle.',v1,',drivecycle.',v2,'); xlabel(''',v1,'''),ylabel(''',v2,''')'])
    end

  end
end