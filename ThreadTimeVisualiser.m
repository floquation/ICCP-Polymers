

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

times = load('Thread_times.output');

meanTimes = mean(times(:,2:end)');
N = length(times(1,2:end));
stdMeanTimes = std(times(:,2:end)') / sqrt(N);
minTimes = min(times(:,2:end)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


meanTimes_manualFit = [80, 33, 25, 20, 17, 20, 23, 30, 40, 60];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(43)
semilogx(0,0)
hold on
errorbar(times(:,1),meanTimes,stdMeanTimes,'kx')
plot(times(:,1),meanTimes_manualFit,'k-')
hold off
xlabel('number of threads')
ylabel('execution time')
title('mean execution time with manual fit')

figure(44)
semilogx(times(:,1),minTimes,'k-')
hold on
semilogx(times(:,1),minTimes,'kx')
hold off
xlabel('number of threads')
ylabel('execution time')
title('minimum execution time')