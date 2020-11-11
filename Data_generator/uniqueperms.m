function pu = uniqueperms(vec)
vec = vec(:);
n = length(vec);

uvec = unique(vec);
nu = length(uvec);

if isempty(vec)
  pu = [];
elseif nu == 1
  pu = vec';
elseif n == nu
  pu = perms(vec);
else
  pu = cell(nu,1);
  for i = 1:nu
    v = vec;
    ind = find(v==uvec(i),1,'first');
    v(ind) = [];
    temp = uniqueperms(v);
    pu{i} = [repmat(uvec(i),size(temp,1),1),temp];
  end
  pu = cell2mat(pu);
end
end