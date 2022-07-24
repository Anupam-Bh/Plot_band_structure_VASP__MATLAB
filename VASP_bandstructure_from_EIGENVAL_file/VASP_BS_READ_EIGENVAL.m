%% Read EIGENVAL FILE and plot band-structure
clc
close all
clear all
% fermi=input('Enter Fermi energy (eV):  ');

A=fileread('OUTCAR');
B=strfind(A,'E-fermi');
fermi=str2double(A(B+10:B+19))
% fermi=0
filename='EIGENVAL';
fid=fopen(filename,'r');
i=0;
while feof(fid)==0
    i=i+1;
    S=fgetl(fid);;
    str=sprintf(S);

    X=strsplit(str,{' ','\t'});
    if i==1
        nion=str2double(X(2))
        spin=str2double(X(5))
    end
    if i==6
        num_e=str2double(X(2))
        NKPTS=str2double(X(3))
        NBANDS=str2double(X(4))
        break;
    end
    clear X S
end
fclose(fid); 
% read eigenvalues
E=zeros(NKPTS,NBANDS);
occup=zeros(NKPTS,NBANDS);
K=zeros(NKPTS,3);
fid=fopen(filename,'r');
i=0;
while feof(fid)==0
    i=i+1;
    S=fgetl(fid);
    str=sprintf(S);
    X=strsplit(str,{' ','\t'});
    if i>=8
        ikpt=floor((i-7)/(NBANDS+2))+1;
        iband=rem((i-8),(NBANDS+2));
        if iband==0
            K(ikpt,:)= str2double(X(2:4));
        elseif iband<=NBANDS 
            E(ikpt,iband)=str2double(X(3))-fermi;
            occup(ikpt,iband)= str2double(X(4));
        end
    end
    clear str X S
end
%% Plot
figure('PaperPositionMode','Auto')
for i=37:NBANDS
    pl=plot(E(:,i),'k','Linewidth',2,'color',[0.4 0.7 .2]);
    hold on
end
grid on;
%   xlim([1,NKPTS]);
 vertices_xval=[1 51 101 151 201 251 300]; vertices_char={'\Gamma','X','M','\Gamma','R','X|M','R'}; %
%vertices_xval=[1 51 101 150];vertices_char={'\Gamma','X','X1','\Gamma'}
%   xlim([700,1301]);
% vertices_xval=[1 1000 NKPTS];
% vertices_char={'L''','\Gamma','L'};
% xlim([600,1400]);
% vertices_xval=[1 101 201 301]; vertices_char_x= {'L'' <-','\Gamma','-> L'};  
% vertices_yval=[0.01 0.04 0.07];vertices_char_y={'-0.01','0.04','0.07'};
% set(gca,'XTick',x)
% set(gca,'XTickLabel',xlab)
% set(gca,'xlim',[1 1000],'ylim',[-10 10],'Xtick',vertices_xval,'Xticklabel',vertices_char_x,'Ytick',vertices_yval,'Yticklabel',vertices_char_y,'Xgrid','on','Ygrid','on',...
%        'Fontweight','normal','Fontsize',28);
set(gca,'xlim',[1 NKPTS],'ylim',[-2 2],'Xtick',vertices_xval,'Xticklabel',vertices_char,'Xgrid','on','Ygrid','on',...
       'Fontweight','normal','Fontsize',20,'FontName','times');
ylabel('E-E_{f} (eV)');
ax = gca;
% ax.YAxis.TickLabelFormat = '%,.3f';
%  ax.YAxis.Exponent = 0;
% title('Band-structure');
box on;
set(gca,'Position',[0.25    0.1557    0.7    0.76])
pbaspect([1.5 1 1]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 9 6])
%% Plot wanniertools BS plot as superimposed
% fid=fopen('bulkek.dat','r');
% C=textscan(fid, '%f %f %*[^\n]','headerLines',2);
% fclose(fid);
% numbands=0;
% for i=1:length(C{1})
%     if C{1}(i)==C{1}(1)
%         numbands=numbands+1;
%         if C{1}(i)==C{1}(1) && numbands==2
%             numk=i-1;
%         end
%     end
% end
%  for i=1:numbands
%     plw=plot(C{1}((((i-1)*numk)+1):((i*numk)))*(2001/C{1}(numk)),C{2}((((i-1)*numk)+1):((i*numk))),'*r','MarkerSize',2);
%     hold on
%  end
% % xlim([0,max(C{1})]);
% ylim([-0.1,0.1]);ylabel('E-E_f (eV)');
% legend([pl(1) plw(1)],'DFT','Wannier bands');
% set(gca,'xlim',[800 1200],'Xtick',vertices_xval,'Xticklabel',vertices_char_x,'Ytick',vertices_yval,'Yticklabel',vertices_char_y,'Xgrid','on','Ygrid','on',...
%        'Fontweight','normal','Fontsize',28);