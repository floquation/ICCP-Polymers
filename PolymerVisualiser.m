N_polymeres = 1;
min_poly_number = 5;

fit_cut_off = 0.4;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

polymereX = load('B4_polymereX.output');
polymereY = load('B4_polymereY.output');
thread = load('B4_thread.output');



%% Polymer visualisation

if N_polymeres == 0
    N_polymeres = length(polymereX(:,1));
    min_poly_number = 1;
end

if(ishandle(1))
    close(1)
end
figure(1)
plot(polymereX(min_poly_number:(N_polymeres+min_poly_number-1),:)',polymereY(min_poly_number:(N_polymeres+min_poly_number-1),:)');
xlabel('x')
ylabel('y')
title('Polymers')

%% Thread activeness

if(max(thread)>0)

figure(2)
hist(thread+0.5,0.5:max(thread+0.5))
xlabel('Thread Number')
ylabel('Number of polymers created')
title('Thread activeness')

end

%% Polymer simularity


%% Square Distance
N = length(polymereX(1,:));
sqDst = zeros(length(polymereX(:,1)),N);

for i = 1:1:N
    sqDst(:,i) = (polymereX(:,i)-polymereX(:,1)).^2 + (polymereY(:,i)-polymereY(:,1)).^2;
end

meanSqDst = mean(sqDst);
stdSqDst = std(sqDst)/sqrt(N);

figure(3)
errorbar(1:N,meanSqDst,stdSqDst,'kx')
xlabel('Polymer length')
ylabel('<r^2>')
title('Square length as a function of polymer length')


figure(6)
ax = axes();
errorbar(1:N,meanSqDst,stdSqDst,'kx')
set(ax, 'YScale', 'log');
set(ax, 'XScale', 'log');
axis([3 N 0 meanSqDst(end)*1.5])
xlabel('Polymer length')
ylabel('<r^2>')
title('Square length as a function of polymer length')


meanDst = mean(sqrt(sqDst));
stdDst = std(sqrt(sqDst))/sqrt(N);

figure(4)
errorbar(1:N,meanDst,stdDst,'kx')
xlabel('Polymer length')
ylabel('sqrt(<r^2>)')
title('Length as a function of polymer length')


%% Fit in log-scale

fit_cut_off = fit_cut_off*N; %TODO: Edit-point

x = log([3:fit_cut_off]-1);
y = log(meanSqDst(3:fit_cut_off));

y2 = y - 3/4*x;

[P,S] = polyfit(x,y,1);
[P2,S2] = polyfit(x,y2,0);

figure(7)
ax = axes();
plot(exp(x)+1,exp(polyval(P2,x)+3/4*x),'b-') %Fit with \nu = 3/4
hold on
plot(exp(x)+1,exp(polyval(P,x)),'r-')        %Fit with \nu arbitrary
errorbar(1:N,meanSqDst,stdSqDst,'kx')
hold off
set(ax, 'YScale', 'log');
set(ax, 'XScale', 'log');
axis([3 N 0 meanSqDst(end)*1.5])
xlabel('Polymer length')
ylabel('<r^2>')
title('Square length as a function of polymer length')
legend({'\nu = 3/4','\nu arbitrary'})


% %% Square Distance fitting
% 
% % Define the data sets that you are trying to fit the
% 
% % function to.
% 
% X=1:1:N;
% 
% Y=meanSqDst;
% 
% % Initialize the coefficients of the function.
% 
% X0=[1 0.75]';
% 
% % Calculate the new coefficients using LSQNONLIN.
% 
% x=lsqnonlin(@fit_simp,X0,[],[],[],X,Y);
% 
% % Plot the original and experimental data.
% 
% Y_new = x(1) + x(2).*exp(x(3).*X)+x(4).*exp(x(5).*X);
% 
% figure(5)
% plot(X,Y,'+r',X,Y_new,'b')


%% Polymer similarity






%% Polymer visualisation II

if N_polymeres == 0
    N_polymeres = length(polymereX(:,1));
    min_poly_number = 1;
end

if(ishandle(33))
    close(33)
end
figure(33)
plot(polymereX',polymereY');
hold on
t = 0:0.1:2*pi;
plot(sqrt(meanSqDst(end))*cos(t),sqrt(meanSqDst(end))*sin(t),'k-');
hold off
xlabel('x')
ylabel('y')
title('Polymers')

