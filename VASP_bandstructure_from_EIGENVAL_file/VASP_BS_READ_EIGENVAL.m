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
vertices_xval=[1 51 101 151 201 251 300]; vertices_char={'\Gamma','X','M','\Gamma','R','X|M','R'}; %
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
