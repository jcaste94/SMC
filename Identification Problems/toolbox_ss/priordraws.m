function parasim = priordraws(prior, trspec, nsimul)
% Function to generate prior draws
% - Now prior draws are within bounds
% Minchul Shin (Penn)
% Last Date: 5/8/2014

% some housekeeping
pshape   = prior(:,1);
pmean    = prior(:,2);
pstdd    = prior(:,3);
pmask    = prior(:,4);
pfix     = prior(:,5);
pmaskinv = 1- pmask;
pshape   = pshape.*pmaskinv;

% parameter specification: transformation
trspec(:,1) = trspec(:,1).*pmaskinv;
bounds      = trspec(:,2:3);

% define some variables
npara = size(prior,1);

% loop to generate parameter draws
parasim = zeros(nsimul,npara);

for i=1:npara
    
    if pmask(i)==1
        parasim(:,i) = ones(nsimul,1)*pfix(i);
        
    else
        
        % beta prior
        if pshape(i)==1
            a = (1-pmean(i))*pmean(i)^2/pstdd(i)^2 - pmean(i);
            b = a*(1/pmean(i) - 1);
            parasim(:,i) = betarnd(a,b,nsimul,1);
            
            % check bound and re-draw
            for j=1:1:sum(outbound)
                notvalid = 1;
                while notvalid
                    temp_para = betarnd(a,b,1,1);
                    
                    if ((bounds(i,1) < temp_para)&&(temp_para < bounds(i,2)))
                        parasim(outboundset(j),i) = temp_para;
                        notvalid = 0;
                    end
                end
            end
            
        % gamma prior
        elseif pshape(i) == 2
            b = pstdd(i)^2/pmean(i);
            a = pmean(i)/b;
            parasim(:,i) = gamrnd(a,b,nsimul,1);
            
            % check bound and re-draw
            for j=1:1:sum(outbound)
                notvalid = 1;
                while notvalid
                    temp_para = gamrnd(a,b,1,1);
                    
                    if ((bounds(i,1) < temp_para)&&(temp_para < bounds(i,2)))
                        parasim(outboundset(j),i) = temp_para;
                        notvalid = 0;
                    end
                end
            end
            
        % gauusian prior
        elseif pshape(i)==3
            a = pmean(i);
            b = pstdd(i);
            parasim(:,i) = a + b*randn(nsimul,1);
            
            % check bound and re-draw
            for j=1:1:sum(outbound)
                notvalid = 1;
                while notvalid
                    temp_para = a + b*randn(1,1);
                    
                    if ((bounds(i,1) < temp_para)&&(temp_para < bounds(i,2)))
                        parasim(outboundset(j),i) = temp_para;
                        notvalid = 0;
                    end
                end
            end
            
        % inverse gamma prior
        elseif pshape(i)==4
            a = pmean(i);
            b = pstdd(i);
            parasim(:,i) = sqrt( b*a^2./sum( (randn(b,nsimul)).^2 )' );
            
            % check bound and re-draw
            outbound = ~((bounds(i,1) < parasim(:,i)).*(parasim(:,i) < bounds(i,2)));
            outboundset = find(outbound);
            for j=1:1:sum(outbound)
                notvalid = 1;
                while notvalid
                    temp_para = sqrt( b*a^2./sum( (randn(b,1)).^2 )' );
                    
                    if ((bounds(i,1) < temp_para)&&(temp_para < bounds(i,2)))
                        parasim(outboundset(j),i) = temp_para;
                        notvalid = 0;
                    end
                end
            end
            
        % uniform prior
        elseif pshape(i)==5
            a = pmean(i);
            b = pstdd(i);
            parasim(:,i) = a + (b-a)*rand(nsimul,1);
            
            % check bound and re-draw
            outbound = ~((bounds(i,1) < parasim(:,i)).*(parasim(:,i) < bounds(i,2)));
            outboundset = find(outbound);
            for j=1:1:sum(outbound)
                notvalid = 1;
                while notvalid
                    temp_para = a + (b-a)*rand(1,1);
                    
                    if ((bounds(i,1) < temp_para)&&(temp_para < bounds(i,2)))
                        parasim(outboundset(j),i) = temp_para;
                        notvalid = 0;
                    end
                end
            end

        % no prior, fixed
        elseif pshape(i)==0
            a = pmean(i);
            parasim(:,i) = a*ones(nsimul,1);
            
        end
    end    
end	% i loop













