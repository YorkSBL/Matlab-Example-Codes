% ### EXtimeHist.m ###       11.30.16   C. Bergevin

% Demonstrates how to read in an Excel file of time values, convert those
% to useful #s, and make a relevant histogram (re some "due date")

% Notes
% - When read in, the matrix Aff is a cell array (thus {} brackets are needed)
% - "early entries" (skipN ~13) are significant outliers.... (thereby
% justifying a non-zero value for skipN)

clear
% --------
fileL= './MoH2017_absTimes.xlsx';       % list of times abstracts were submitted (Excel file)
dueDate= '2016/12/01 11:59:59 PM';       % date that abstracts are due
N= 20;                                  % # of bins for histogram
timeT= 1;                           % timescale: 0-days, 1-hours
skipN= 13;                           % # of "early" entries to exclude {0}
logH= 0;                             % boolean re use log-scale for time? {0}
titleS= 'Times relative to due date';
% --------
[junk,A]= xlsread(fileL);   % read in file
A2= A(2+skipN:end); % nix the first line (name tag) and skip over early ones (if specified)
% loop to nix the ' EST' (very kludge!)
for nn=1:numel(A2)
    temp= findstr(A2{nn},' EST');
    temp2= A2{nn};
    A3{nn}= temp2(1:temp);
end
A4= datenum(A3);    % convert submitted times to "the number of days from January 0, 0000"
A5= A4- datenum(dueDate);   % re-reference re the due date
if (timeT==1),  A5= A5*24;    end              % convert to # of hours (leave negative values as *before* due date)
disp(['# of submissions (most recent) included = ',num2str(numel(A5)),' (total in list was ',num2str(numel(A)-1),')']);

% =========
% compute histogram; also allow for option to use log-scale
%if (logH==1), [counts,centers] = hist(log10(abs(A5)),N);
if (logH==1), [counts,centers] = hist(log10((A5)),N);
else [counts,centers] = hist(A5,N);     end

% =========
figure(1); clf; hold on; grid on;
if (logH==1), h1= bar(-centers,counts);
else    h1= bar(centers,counts);    end
h1.FaceColor= [0 0.5 0.5];  % change bar color
h1.EdgeColor= 'w';
xlabel('Submission time relative to due date [days]');
if (timeT==1),  xlabel('Submission time relative to due date [hours]');    end 
if (logH==1&&timeT==1), xlabel('Submission time relative to due date [-log hours]');   end
ylabel('Instances'); title(titleS);
h2= plot([0 0],[0 max(counts+1)],'r--','LineWidth',2);
legend([h2],'Due date!','Location','NorthWest');


