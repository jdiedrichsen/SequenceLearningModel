% simulations with the deaults of the function 
%%things to work on:
% does the nmber of opions raise the reaction time
% what is the best paratmet combo for MT /RT

[IPIs, Exam] =    slm_diagModel();

% fliplr([0.2:.2:3])
%% Recepie for model diagnosis
close all

[IPIs, Exam] = slm_diagModel( 'numSimulations' , 100,...
     'SigEps' , 0.01 ,'DecayParam' , 2 ,'Aintegrate' , 0.9785 , 'theta_stim' , .0084 , 'Capacity' , 4 ,...
     'SeqLength' , 14,'Horizons' , [1:14],'Ainhibit' , [0.0],'DecayParam' , 2);

 
[IPIs, Exam] =    slm_diagModel( 'numSimulations' , 50,...
     'SigEps' , 0.01 ,'DecayParam' , 2 ,'Aintegrate' , 0.976 , 'theta_stim' , .01 , 'Capacity' , 3 ,...
     'SeqLength' , 14,'Horizons' , [14],'Ainhibit' , [0.0],'DecayParam' , 2);
 
 
 [R,SIM,Trials,Models]=slm_testModel('simpleSeq','SigEps' , 0.01 ,'DecayParam' , 2 , 'Aintegrate' , 0.976 , 'theta_stim' , .0084 ,...
    'Horizons' , [1:14] , 'numSimulations' , 100 , 'Capacity' , 1,'VizProgress',0,'SeqLength' , 14);
%% Capacity
A = getrow(IPIs , IPIs.singleH==14);
A = IPIs;
figure('color' , 'white')
subplot(211)
lineplot(A.Capacity , A.MT , 'style_thickline')
title('MT')
grid on
set(gca , 'FontSize' , 16)
xlabel('Buffer Size')
subplot(212)
lineplot(A.Capacity , A.RT,'style_thickline')
title('RT')
xlabel('Buffer Size') 
grid on
set(gca , 'FontSize' , 16)
%% Horizon
A = IPIs;
figure('color' , 'white')
subplot(211)
lineplot(A.singleH , A.MT , 'style_thickline')
title('MT')
grid on
set(gca , 'FontSize' , 16)
xlabel('Horizon')
subplot(212)
lineplot(A.singleH , A.RT,'style_thickline')
title('RT')
xlabel('Horizon') 
grid on
set(gca , 'FontSize' , 16)
%%
A = IPIs;
IPIs = getrow(A , A.a == 1);

ipiMat = zeros(5 , 5);
for tn = 1:length(IPIs.MT)
    stim = Exam.T.stimulus(tn,:);
    for pr = 1:size(stim , 2)-1
        ipiMat(stim(pr) , stim(pr+1)) = ipiMat(stim(pr) , stim(pr+1)) + IPIs.ipi(pr);
    end
end
ipiMat= ipiMat/tn;
imagesc(ipiMat)
axis square

IPIs.a = ones(length(IPIs.MT) , 1);
IPIs1.a = zeros(length(IPIs1.MT) , 1);

IPIs = addstruct(IPIs , IPIs1);







A = IPIs1;
figure('color' , 'white')
subplot(211)
lineplot(A.Ainhibit , A.MT)
title('MT')
xlabel('Ainhibit')
subplot(212)
lineplot(A.Ainhibit , A.RT)
title('RT')
xlabel('Ainhibit') 

  
  
  
  
 
A = getrow(IPIs , IPIs.singleH==14);
figure('color' , 'white')
subplot(211)
lineplot(A.Capacity , A.MT)
title('MT')
xlabel('Capacity')
subplot(212)
lineplot(A.Capacity , A.RT)
title('RT')
xlabel('Capacity')

A14 = getrow(IPIs , IPIs.singleH == 14 & IPIs.RT>=700 &IPIs.RT<=800 & IPIs.MT>=4500 & IPIs.MT<=5000);
plot(A14.MT , A14.RT)


A1 = getrow(IPIs , IPIs.singleH == 1 & IPIs.RT>=630 &IPIs.RT<=670 & IPIs.MT>=6300 & IPIs.MT<=6800);
plot(A1.MT , A1.RT)

% visually inspect
A = A14;
figure
for i = 1:length(A.MT)
    a = A.Aintegrate(i);
    t = A.theta_stim(i);
    s = A.SigEps(i);
    c = A.Capacity(i);
    d = A.DecayParam(i);
    T = getrow(A1 , A1.Aintegrate == a & A1.theta_stim == t & A1.Capacity == c &...
        A1.SigEps == s & A1.DecayParam == d);
    if ~isempty(T.Aintegrate)
        Target = getrow(IPIs , IPIs.Aintegrate == a & IPIs.theta_stim == t & ...
            IPIs.Capacity == c & IPIs.SigEps == s & IPIs.DecayParam == d);
    end
    subplot(211)
    lineplot(Target.singleH , Target.MT)
    subplot(212)
    lineplot(Target.singleH , Target.RT)
    title(num2str(i))
    pause()
    drawnow
end

% best i = 37 ~ 41
i = 41;
a = A14.Aintegrate(i);
t = A14.theta_stim(i);
s = A14.SigEps(i);
c = A14.Capacity(i);
d = A14.DecayParam(i);
Target = getrow(IPIs , IPIs.Aintegrate == a & IPIs.theta_stim == t & ...
            IPIs.Capacity == c & IPIs.SigEps == s & IPIs.DecayParam == d);

A = Target;
figure('color' , 'white')
subplot(211)
lineplot(A.singleH , A.MT)
title('MT')
xlabel('Horizon')
subplot(212)
lineplot(A.singleH , A.RT)
title('RT')
xlabel('Horizon')

%% recipie for learning

Sequences = [3 4 2 2 4 4 2 4 5 2 4 1 2 4;
             5 1 2 4 5 1 2 4 1 2 3 2 4 1;
             1 3 1 2 4 2 3 1 2 4 4 5 1 2];
         
[R,SIM,Trials,Models]=slm_testModel('SeqLearn','Sequences' , Sequences , 'SigEps' , 0.01 ,'DecayParam' , 2 , 'Aintegrate' , 0.976 , 'theta_stim' , .0084 , 'Capacity' , 4,'VizProgress',0);
[R,SIM,Trials,Models]=slm_testModel('simpleSeq','SigEps' , 0.01 ,'DecayParam' , 2 , 'Aintegrate' , 0.976 , 'theta_stim' , .0084 ,...
    'Horizons' , [1:14] , 'numSimulations' , 100 , 'Capacity' , 1,'VizProgress',0,'SeqLength' , 14);

[R,SIM,Trials,Models]=slm_testModel('simpleSeq' , 'SigEps' , 0.01 ,'DecayParam' , 2 ,...
    'Aintegrate' , 0.98 , 'theta_stim' , .0084 , 'Capacity' , 3,'Ainhibit', 0.001,'SeqLength',14);


[IPIs, Exam] =    slm_diagModel( 'Ainhibit' , [0.0],'DecayParam' , 2);


