%% Band-structure extraction from MedeA

clc
clear all
fid=fopen('Bandstructure.data');
i=0;
while feof(fid)==0
    S=fgetl(fid);
    str=sprintf(S);
    clear X S
    X=strsplit(str,{',','{',' ','}','\t'});
    if strcmp(X(1),'y')==1
        i=i+1;
        bandnum(i)=str2double(X(2));
        bands(i,:)=str2double(X(3:length(X)-1));
        
    elseif strcmp(X(1),'x')==1
        kvalues=str2double(X(2:length(X)-1));
    elseif strcmp(X(1),'symmetryPoints')==1
        vertices_char=X(2:2:length(X)-1)
        vert_x=str2double(X(3:2:length(X)-1));
        vertices_xval(1)=vert_x(1);
        for j=2:vertices_num
            vertices_xval(j)=vertices_xval(j-1)+vert_x(j);
        end
        clear j;
    elseif strcmp(X(1),'nSymmetryPoints')==1
        vertices_num=str2double(X(2))
    elseif strcmp(X(1),'nSpin')==1
        spin=str2double(X(2))
    end
end
clear i;
fclose(fid);

%% Plot

Xpoints=1:length(kvalues);
if spin==1
    for i=1:length(bandnum)
        figure(1)
        plot(Xpoints,bands(i,:),'r','LineWidth',1.0);
        hold on
    end
    %gridlines
    %yticks=[-0.4 -0.2 0.0 0.2 0.4];
    xlim([0 max(Xpoints)]);
    %xlim([950 1052]);
    %vertices_xval=[950 1001 1052];
    ylabel('E-E_{f} (eV)');
    vertices_char={'\Gamma'    'X'    'W'    '\Gamma'    'L'    'W'}
   set(gca,'ylim',[-2 2],'Xtick',vertices_xval,'Xticklabel',vertices_char,'Xgrid','on','Ygrid','on',...
       'Fontweight','normal','Fontsize',17,'Fontname','SansSerif');
    pbaspect([1.5 1 1])
    % print('Screen','-dpng','-r0')
elseif spin==2
    for i=1:length(bandnum)
        if bandnum(i)<(length(bandnum)/2)
%             subplot(1,2,1)
            plot(Xpoints,bands(i,:),'r','LineWidth',1.3);
            hold on
%         else
%             subplot(1,2,2)
%             plot(Xpoints,bands(i,:),'b','LineWidth',1.3);
%             hold on
        end
    end
    
%     subplot(1,2,1)
    ylabel('E-E_{f} (eV)');
    set(gca,'xlim',[0 max(Xpoints)],'ylim',[-0.1 0.1],'Xtick',vertices_xval,'Xticklabel',vertices_char,'Xgrid','on','Ygrid','on',...
        'Fontweight','normal','Fontsize',17,'Fontname','times');
    
%     subplot(1,2,2)
%     ylabel('E-E_{f} (eV)');
%     set(gca,'xlim',[0 max(Xpoints)],'ylim',[-3 3],'Xtick',vertices_xval,'Xticklabel',vertices_char,'Xgrid','on','Ygrid','on',...
%         'Fontweight','bold','Fontsize',17,'Fontname','times'); 
end