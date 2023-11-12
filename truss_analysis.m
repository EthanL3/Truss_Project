load('PracticeProblemInput.mat'); 
[Cr, Cc] = size(C);
coeMat = zeros(Cr, Cc);

for i = 1:Cr
    memberMatches = find(C(i,:) == 1);

    for j = 1:length(memberMatches)
        jointMatches(j,:) = find(C(:,memberMatches(j)) == 1);
    end

    [jR, ~] = size(jointMatches);

    for k = 1:jR
        
       if (jointMatches(k,1) == i)
            distX = X(jointMatches(k,2)) - X(jointMatches(k,1));
       else
            distX = X(jointMatches(k,1)) - X(jointMatches(k,2));
       end
       
       distY = Y(jointMatches(k,1)) - Y(jointMatches(k,2));

       unit = distX / sqrt(distX^2 + distY^2);

       if (isnan(unit))
           unit = 0;
       end
       
       unitVectors(k) = unit;
    end

    coeVec = zeros(1,Cc);

    for g = 1:length(memberMatches)
        coeVec(memberMatches(g)) = unitVectors(g);
    end
    
    Ax(i,:) = coeVec;
end

for i = 1:Cr
    memberMatches = find(C(i,:) == 1);

    for j = 1:length(memberMatches)
        jointMatches(j,:) = find(C(:,memberMatches(j)) == 1);
    end

    [jR, ~] = size(jointMatches);

    for k = 1:jR

       if (jointMatches(k,1) == i)
           distY = Y(jointMatches(k,2)) - Y(jointMatches(k,1));
       else
           distY = Y(jointMatches(k,1)) - Y(jointMatches(k,2));
       end
                 
       distX = X(jointMatches(k,2)) - X(jointMatches(k,1));
       unit = distY / sqrt(distX^2 + distY^2);
       
       if (isnan(unit))
           unit = 0;
       end
       
       unitVectors(k) = unit;
    end

    coeVec = zeros(1,Cc);

    for g = 1:length(memberMatches)
        coeVec(memberMatches(g)) = unitVectors(g);
    end
    
    Ay(i,:) = coeVec;
end
disp(Ax);
disp(Ay);