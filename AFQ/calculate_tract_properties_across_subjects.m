clear all, close all

dir_base = '/Users/Desktop/AFQ'; % directory which contains all subject-specific directory, need to specify!
name_subj = {'100206' '100307' '100408' '100610' '101006' '101309' '101410' '102311' '102513'...
'102816' '103111' '103414' '103515' '103818' '104012' '104416' '104820' '105014' '105115'... 
'105216' '105620' '105923' '106016' '106319' '106521' '107018' '107321' '107422' '108121'...
'108222' '108323' '108525' '108828' '109123' '109830' '110411' '110613' '111009' '111312'...
'111413' '111514' '111716' '112112' '112314' '112516' '112920' '113215' '113619' '113922'...
'114217' '114419' '114621' '114823' '115017' '115320' '115825' '116221' '116524' '116726'...
'117122' '117324' '117930' '118124' '118225' '118528' '118730' '118932' '119126' '119732'...
'119833' '120212' '120515' '120717' '121416' '121618' '121921' '122317' '122620' '122822'...
'123117' '123521' '123925' '124220' '124422' '124624' '124826' '126325' '126628' '127630'...
'127933' '128026' '128632' '128935' '129028' '129129' '129331' '129634' '129937' '130316'...
'130417' '130619' '130821' '131217' '131419' '131722' '131823' '131924' '132017' '133019'...
'133625' '133827' '133928' '134021' '134223' '134425' '134728' '134829' '135225' '135730'...
'135932' '136732' '136833' '137229' '137633' '138231' '138837' '139233' '139637' '139839'...
'140117' '140319' '140824' '141119' '141422' '141826' '143325' '144125' '144428' '144731'...
'144832' '145127' '145834' '146129' '146331' '146432' '146533' '146937' '147030' '148032'...
'148133' '148335' '148840' '148941' '149236' '149337' '149539' '149741' '149842' '150625'...
'150726' '151223' '151526' '151728' '151829' '152831' '153025' '153227' '153429'...
'154229' '154431' '154532' '154734' '154936' '155231' '155635' '155938' '156031' '156233'...
'156334' '156435' '156536' '156637' '157336' '157437' '157942' '158035' '158136' '158338'...
'158540' '158843' '159138' '159239' '159441' '159744' '159946' '160123' '160830' '160931'...
'161327' '161630' '161731' '162026' '162228' '162733' '162935' '163129' '163331' '163836'...
'164030' '164131' '164939' '165638' '166438' '167036' '167238' '168139' '168240' '168745'...
'169444' '169747' '170631' '171330' '171532' '171633' '172029' '172130' '172332'...
'172433' '172534' '172938' '173334' '173435' '173536' '173637' '173738' '173839' '173940'...
'174437' '174841' '175035' '175237' '175338' '175439' '175742' '176037' '176239' '176441'...
'176542' '177241' '177645' '178142' '178243' '178647' '178849' '178950' '179245' '179346'...
'180129' '180432' '180735' '180836' '180937' '181131' '181232' '181636' '182436'...
'182739' '183034' '183337' '185341' '185442' '185947' '186444' '187345' '187547' '187850'...
'188347' '188448' '188549' '188751' '189349' '189450' '190031' '191033' '191336' '191841'...
'191942' '192136' '192540' '192843' '193239' '194140' '194645' '194746' '194847' '195041'...
'195849' '195950' '196144' '196346' '196750' '197348' '198249' '198350' '198653'...
'198855' '199150' '199453' '199655' '199958' '200008' '200109' '200311' '200917' '201111'... 
'201414' '201818' '202113' '202719' '203418' '203923' '204016' '204319' '204420' '204521'... 
'205220' '205725' '206222' '207123' '207426' '208125' '208226' '208327' '209127' '209228'... 
'209329' '210011' '210415' '210617' '211114' '211215' '211316' '211417' '211720' '211922'... 
'212116' '212217' '212318' '212419' '212823' '213421' '214019' '214221' '214423'... 
'214726' '217126' '220721' '221319' '223929' '224022' '227432' '228434' '231928' '233326'... 
'236130' '237334' '239944' '245333' '246133' '248339' '250427' '250932' '251833' '255639'... 
'257542' '257845' '263436' '268850' '270332' '275645' '280739' '285345' '285446' '286650'... 
'287248' '290136' '293748' '295146' '297655' '298051' '299154' '300618' '303119' '303624'...
'304020' '304727' '305830' '307127' '308129' '308331' '309636' '310621' '311320' '316633'... 
'316835' '317332' '318637' '320826' '321323' '322224' '330324' '333330' '334635' '336841'... 
'339847' '346137' '346945' '351938' '352132' '353740' '358144' '361234' '361941' '365343'... 
'366042' '366446' '371843' '379657' '380036' '381038' '381543' '386250' '387959' '389357'... 
'390645' '391748' '393247' '393550' '395251' '395756' '395958' '397154' '397760' '397861'... 
'406836' '412528' '414229' '415837' '422632' '424939' '429040' '432332' '433839' '436239'... 
'436845' '441939' '445543' '453441' '456346' '459453' '467351' '473952' '479762' '481951'... 
'485757' '486759' '492754' '495255' '497865' '499566' '500222' '506234' '510326' '512835'... 
'513736' '517239' '519950' '525541' '529549' '529953' '530635' '531536' '536647'... 
'540436' '541943' '545345' '548250' '553344' '555348' '555651' '557857' '559053' '561242'...
'562345' '562446' '566454' '567052' '567961' '568963' '571144' '572045' '573249' '573451'... 
'576255' '579867' '580044' '580650' '580751' '581349' '583858' '585256' '586460' '587664'... 
'588565' '594156' '597869' '598568' '599065' '599469' '599671' '604537' '609143' '611938'... 
'613538' '615744' '616645' '617748' '618952' '622236' '623844' '626648' '627549' '627852'... 
'628248' '633847' '638049' '645450' '645551' '647858' '654350' '654754' '656657' '657659'... 
'660951' '663755' '664757' '667056' '668361' '671855' '672756' '673455' '677766' '677968'... 
'679568' '679770' '680957' '683256' '687163' '690152' '693764' '695768' '700634' '702133'... 
'704238' '705341' '707749' '709551' '715950' '724446' '725751' '729557' '731140' '732243'... 
'734045' '735148' '742549' '744553' '748258' '749058' '751348' '751550' '753150' '759869'... 
'761957' '765056' '767464' '769064' '770352' '771354' '773257' '779370' '782561' '783462'...
'784565' '786569' '788876' '789373' '792564' '800941' '802844' '803240' '810843' '812746'...
'816653' '820745' '825048' '826353' '826454' '833148' '833249' '835657' '837560' '837964'... 
'841349' '843151' '844961' '845458' '849264' '849971' '852455' '856463' '856766' '856968'... 
'859671' '861456' '865363' '867468' '870861' '871762' '871964' '872562' '873968' '877269'... 
'882161' '887373' '891667' '894673' '894774' '896778' '896879' '901139' '901442' '904044'... 
'907656' '910241' '910443' '912447' '917255' '917558' '922854' '927359' '930449' '932554'... 
'942658' '947668' '952863' '955465' '957974' '958976' '959574' '965367' '965771' '966975'... 
'972566' '978578' '983773' '984472' '987983' '990366' '991267' '992673' '992774' '993675' '994273' '996782'}; 

% 3 HCP subject {'151425' '198451' '524135' } were exluded for AFQ analyses, because the Probtrack were not working on them
% 2 hcp subject {'169040' '179548' } were excluded because they don't have valid anaotmical scans
% 2 hcp subject {'101107' '212015'} did not have all tom ROIS
% so totally 675 subjects for AFQ analysis

fs = filesep; % platform-specific file separator
k  = 1;

% loop through all subjects
%===========================================================================
while (k<=length(name_subj)),
    
    sub_dir = fullfile(dir_base,name_subj{k}); %% Where the 'tract_properties.mat' is stored
    cd(sub_dir)
    load tract_properties
    
    
    
    %% each column for each fiber
    for i=1:20
        allsubject.meanVOLUME(k,i)= afq20tract.info(1,i); %% row is for each subject, colums are for each of 20 tracts
        allsubject.meanFA(k,i)= afq20tract.info(2,i); %% row is for each subject, colums are for each of 20 tracts
        allsubject.meanMD(k,i)= afq20tract.info(3,i); %% row is for each subject, colums are for each of 20 tracts
        allsubject.meanRD(k,i)= afq20tract.info(4,i); %% row is for each subject, colums are for each of 20 tracts
        allsubject.meanAD(k,i)= afq20tract.info(5,i); %% row is for each subject, colums are for each of 20 tracts
        allsubject.streamline(k,i)= afq20tract.info(6,i); %% row is for each subject, colums are for each of 20 tracts
    end
    
    %     column 1='Left Thalamic Radiation'
    %     column 2='Right Thalamic Radiation'
    %     column 3='Left Corticospinal'
    %     column 4='Right Corticospinal'
    %     column 5='Left Cingulum Cingulate'
    %     column 6='Right Cingulum Cingulate'
    %     column 7='Left Cingulum Hippocampus'
    %     column 8='Right Cingulum Hippocampus'
    %     column 9='Callosum Forceps Major'
    %     column 10='Callosum Forceps Minor'
    %     column 11='Left IFOF'
    %     column 12='Right IFOF'
    %     column 13='Left ILF'
    %     column 14='Right ILF'
    %     column 15='Left SLF'
    %     column 16='Right SLF'
    %     column 17='Left Uncinate'
    %     column 18='Right Uncinate'
    %     column 19='Left Arcuate'
    %     column 20='Right Arcuate'
    
    
    %%% last column to show the subjet ID
    allsubject.meanVOLUME(k,21)= str2num(name_subj{k});
    allsubject.meanFA(k,21)= str2num(name_subj{k});
    allsubject.meanMD(k,21)= str2num(name_subj{k});
    allsubject.meanRD(k,21)= str2num(name_subj{k});
    allsubject.meanAD(k,21)= str2num(name_subj{k});
    allsubject.streamline(k,21)= str2num(name_subj{k});
    
    % Switch to next subject
    %=======================================
    k   = k + 1;
    
end  %%% end of main loop


cd(dir_base)

save('mean_tract_properties_across_subjects.mat', 'allsubject');

xlswrite('major_fiber_meanVOLUME.xlsx',allsubject.meanVOLUME);
xlswrite('major_fiber_meanFA.xlsx',allsubject.meanFA);
xlswrite('major_fiber_meanMD.xlsx',allsubject.meanMD);
xlswrite('major_fiber_meanRD.xlsx',allsubject.meanRD);
xlswrite('major_fiber_meanAD.xlsx',allsubject.meanAD);
xlswrite('major_fiber_streamline.xlsx',allsubject.streamline);

