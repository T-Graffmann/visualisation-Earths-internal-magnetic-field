Nmax=185;
Nmin=1;
for in=1:Nmax
% [StepAmount(in),x]=DefLinspaceSteps(Nmin,in);
PointDist(in)=pi/sqrt(in*(in+1))*6371;
end

%   visualisation
% figure('Name','Minimal point distance',NumberTitle='off');
ax1 = axes('Position',[0.2 0.2 0.7 0.7]);
ax2 = axes('Position',[0.4 0.45 0.47 0.3],'Box','on');
grid on
%   big plot
axes(ax1);
P1=plot(PointDist,'Linewidth',2.5,'Color','b');
yticks(0:1000:20000);
ylim([0 PointDist(1)]);
ylabel('$d_{points} [km]$','Interpreter','latex');
xlabel('Maximum Degree $N_{max}$','Interpreter','latex');
grid on
%   small plot
axes(ax2);
P2=plot(Nmax-length(PointDist(PointDist<300))+1:Nmax,PointDist(PointDist<300),'Linewidth',2.5,'Color','gr');
xticks(0:10:Nmax);
yticks(0:50:300);
ylim([0 300]);
h=[P2,P1];
grid on
xlabel('$N_{max}$',Interpreter='latex');
ylabel('$d_{points}$',Interpreter='latex');

axes(ax1);
set(gca,'FontName','SanSerif','FontSize',20);
legend(ax1,h,'$d_{points}$: minimal distance between points in km (up to 300km)','$d_{points}$: minimal distance between points in km (full range)','Interpreter','latex','location','northeast');
axes(ax2);
set(gca,'FontName','SanSerif','FontSize',18);


% tiledlayout(2,1);
% %   left plot
% nexttile;
% grid on;
% axis([0 185 0 2400]);
% ylabel('$d_{points} [km]$','Interpreter','latex');
% xlabel('Maximum Degree $N_{max}$','Interpreter','latex');
% plot(1:185,PointDist(:),'Linewidth',2.5,'Color','gr');
% legend('$d_{points}$: minimal distance between points in km (full range)','Interpreter','latex');
% axes('position',[.65 .175 .25 .25]);
% box on;
% IndexOfInterest=(100:129);
% plot(IndexOfInterest,PointDist(IndexOfInterest));
% axis tight
% 
% %   right plot
% nexttile;
% grid on;
% axis([0 185 0 101]);
% ylabel('$d_{points} [km]$','Interpreter','latex');
% xlabel('Maximum Degree $N_{max}$','Interpreter','latex');
% plot(1:185,PointDist(:),'Linewidth',2.5,'Color','b');
% legend('$d_{points}$: minimal distance between points in km (up to 100km)','Interpreter','latex');



