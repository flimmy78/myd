data = csvread('mydata.csv')
dmin = zeros(17,1)
dmax = zeros(17,1)
dmean = zeros(17,1)
dvar = zeros(17,1)
dsk = zeros(17,1)
dku = zeros(17,1)
dskku = zeros(17,1)
dbianyi = zeros(17,1)

for i = 1:17
x = data(((i-1)*10+1) : (i*10));
dmin(i) = min(x)
dmax(i) = max(x)
dmean(i) = mean(x)
dvar(i) = var(x)
dsk(i) = skewness(x)
dku(i) = kurtosis(x)
dskku(i) = dsk(i)*dku(i)
dbianyi(i) = std(x)./abs(mean(x))
end

distanceij = zeros(17,17);
newclass = zeros(17,17);
k = ones(17,1);
for i = 1 : 17
	newclass(i,k(i)) = i;

	for j = 1 : 17
		%k = 1;
		distanceij(i,j) = (dmin(i) - dmin(j))^2 + (dmax(i) - dmax(j))^2 + (dmean(i) - dmean(j))^2 + (dvar(i) - dvar(j))^2;
		distanceij(i,j) = distanceij(i,j) + (dsk(i) - dsk(j))^2 + (dku(i) - dku(j))^2 + (dskku(i) - dskku(j))^2 + (dbianyi(i) - dbianyi(j))^2;
		distanceij(i,j) = distanceij(i,j)^0.5;
		if(distanceij(i,j) < 0.2 && (i ~= j))
		k(i) = k(i) + 1
		newclass(i,k(i)) = j
		end
	end
end
distanceij
newclass

for i = 1 : 17
	for j = 1 : 17
	n = newclass(i,j)
	if(n == 0)
		break;
	end
		for z = 2 : 17
			if(newclass(n,z) == 0)
				break;
			end
			if(ismember(newclass(n,z),newclass(i,:))==1)
			continue;
			end
			k(i)=k(i)+1;
			 newclass(i,k(i))=newclass(n,z);
		end
	end
end
lastclass = zeros(17,17);
row = 1
for i = 1 : 17
	if(ismember(i,lastclass)==0)
		lastclass(row , :) = newclass(i , :);
		k(row) = k(i);
		row = row + 1;
		
	end
end
lastclass
k

e = zeros(row,1)
for ii = 1 : row
	for z = 1 : 17
			if(lastclass(ii,z) == 0)
				break;
			end
			e(ii) = e(ii) + dmean(lastclass(ii,z),1);
	end
e(ii) = e(ii)/k(ii);
end
total = 170;
sum0 = 0;  
w0 = 0;  
maximum = 0.0;  
total_value = sum(data);  
for ii=1:row  
    w0 = w0 + k(ii)*10;  
    if (w0 == 0)  
        continue;  
    end  
    w1 = total - w0;  
    if (w1 == 0)  
        break;  
    end  
    sum0 = sum0 +  e(ii) * k(ii)*10;  
    m0 = sum0 / w0;  
    m1 = (total_value - sum0) / w1;  
    icv = w0 * w1 * (m0 - m1) * (m0 - m1);  
    if ( icv >= maximum )  
        level = ii;  
        maximum = icv;  
    end  
    maximum
    level
   dmaxlast = 0;
    for ii = 1 : 17
    		if(	lastclass(level,ii) == 0)
				break;
				end
				if(dmax(lastclass(level,ii),1) > dmaxlast)
				 dmaxlast = dmax(lastclass(level,ii),1);
				 end
    end
    dmaxlast
    x = 1 : 170;
    plot(x,data)
    hold on;
    y = zeros(170)+dmaxlast;
    plot(x,y)
    newclass

		a = [dmin,dmax,dmean,dvar,dsk,dku,dskku,dbianyi]
    hold off;
end  