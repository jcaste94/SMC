% script to recover parameters
eval(['[param, paranames] = psel_', modelname, '(param);']);
for para_ind = 1:1:length(param)
    %eval([paranames{para_ind}, '=', num2str(param(para_ind),'% 20.17f'), ';']);
    eval([paranames{para_ind}, '=', 'param(para_ind);']);
end
