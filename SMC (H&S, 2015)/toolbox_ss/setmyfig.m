function setmyfig(fig, position, version)
% set figures
if nargin == 1
    position = [1.7, 1.2, 17, 6.5];
    version = 1; %new version
end

if nargin == 2
    version = 1; %new version
end


set(fig, 'color', 'w');
set(fig, 'units', 'inches');
set(fig, 'position', position);
% set(fig, 'paperpositionmode', 'auto');
% set(fig, 'outerPosition', position);
set(fig, 'paperpositionmode', 'manual');
set(fig, 'PaperPosition', [0,0,position(3), position(4)]);

if version == 1
    ti = get(gca,'TightInset');  %left, down, up, right
    set(gca,'LooseInset',[ti(1)+0.01, ti(2)*3, ti(3), ti(4)])
end

% set(gca,'LooseInset',get(gca,'TightInset')*20)


% set(gcf, 'PaperPosition',[0 0 position(3)+ti(1)+ti(3) position(4)+ti(2)+ti(4)]);
% set(gcf, 'PaperPosition',[0 0 position(3)+100 position(4)+ti(2)+ti(4)]);
    
