function prime = primeForm(pcs)

% Computes Forte's prime form from a pitch-class set
% Input:
%   pcs : pitch-class set vector (1 x card, 0-11). Example: C,E,G = [0 4 7];
% Output:
%   prime form : Forte's prime form as list of numbers (0-11)
% Martorell, A. - (2012) Music Technology Group, Universitat Pompeu Fabra (Barcelona)

if isempty(pcs)
    prime = [0];
    return
end
pcs = sort(unique(pcs));
card = size(pcs,2); % get cardinality
% trivial forms
if card == 1
    prime = [0];
    return
end
if card>12, error('Out of cardinality (just 12TET)'); end

normal = normalForm(pcs);
normal0 = mod(normal-normal(1),12); % shift to 0
inverse = 12-normal0;
inversenormal = normalForm(inverse);
inversenormal0 = mod(inversenormal-inversenormal(1),12); % shift to 0
% get most packed to the left candidate
prime = [normal0;inversenormal0];
for i = card:-1:2
    span = prime(:,i)-prime(:,1);
    % shortest extreme spans
    minrow = find(span==min(span));
    if size(minrow,1) == 1, break;
    end
end
prime = prime(minrow(1),:);

% -------------------

function normal = normalForm(pcs)
if isempty(pcs)
    normal = [0];
    return
end
pcs = sort(unique(pcs));
card = size(pcs,2); % get cardinality
% trivial forms
if card == 1
    normal = [0];
    return
end
if card>12, error('Out of cardinality (just 12TET)'); end
    
% create rotation matrix
m = zeros(card);
m(1,:) = pcs;
for i = 2:card
    m(i,:) = [m(i-1,2:card) m(i-1,1)+12];
end
% get create matrix of differences (extrem spans betwwen first column and the rest)
for i = card:-1:2
    span = m(:,i)-m(:,1);
    % shortest extreme spans
    minrow = find(span==min(span));
    if size(minrow,1) == 1, break;
    else
        m = m(minrow,:);
    end
end
% minrow points to the most packed row to the left
% in the case of tie, it's a symmetric pitch-class set, so anyone qualifies
normal = mod(m(minrow(1),:),12);