% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)
distances = ssd(descr1, descr2);

if strcmp(matching, 'one-way')
    [~,I]=min(distances,[],2); % minimum distance from a point in img1 to points in img2
    [~,c]=size(descr1);
    matches=[1:c;I'];
    %error('Not implemented.');
elseif strcmp(matching, 'mutual')
    [~,I]=min(distances,[],2); % minimum distance from a point in img1 to points in img2
    [~,c]=size(descr1);
    m1=[1:c;I'];
    [~,I]=min(distances,[],1); % minimum distance from a point in img2 to points in img1
    [~,c]=size(descr2);
    m2=[1:c;I];
    
    t1=table(m1(1,:)',m1(2,:)');
    t2=table(m2(2,:)',m2(1,:)');
    t3=ismember(t1,t2);        % common matches in both cases
    t4=t1(t3,:);
    f=table2array(t4);
    matches=f';
    
    %error('Not implemented.');
elseif strcmp(matching, 'ratio')
    [~,I]=min(distances,[],2); % minimum distance from a point in img1 to points in img2
    [~,c]=size(descr1);
    m1=[1:c;I'];
    a=mink(distances,2,2);     % second nearest neighbour
    a(:,3)=a(:,1)./a(:,2);     % Ratio test
    idx=a(:,3)<0.5;            % Threshold= 0.5
    matches=m1(:,idx');
    %error('Not implemented.');
else
    error('Unknown matching type.');
end
end

function distances = ssd(descr1, descr2)

distances=pdist2(descr1',descr2','squaredeuclidean');
%error('Not implemented.');
end