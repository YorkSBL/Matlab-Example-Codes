% ### EXcircularMembraneV.m ###   2020.10.22

% [IN PROGRESS; works but can use further tweaking]
% Note:
% o Modified version of EXcircularMembrane1.m
% o Code below is taken from Mathworks demonstration
% + https://www.mathworks.com/help/pde/ug/vibration-of-a-circular-membrane-using-the-matlab-eigs-function.html
% + openExample('pde/eigsExample')
% o REQS: PDE Toolbox

% Purpose: "This example shows how to calculate the vibration modes of a circular membrane. The calculation
% of vibration modes requires the solution of the eigenvalue partial differential equation."

% Useful refs:
% o https://en.wikipedia.org/wiki/Vibrations_of_a_circular_membrane
% o http://www-solar.mcs.st-and.ac.uk/~alan/MT3601/Fundamentals/node60.html
% o http://www.people.fas.harvard.edu/~djmorin/waves/miscellaneous.pdf
% o https://courses.physics.illinois.edu/phys406/sp2017/Lecture_Notes/P406POM_Lecture_Notes/P406POM_Lect4_Part2.pdf

clear
% ====================================
% ---- Create a PDE Model
numberOfPDE = 1; % {1}
radius = 1.5; % {1}
% ---- Define PDE Coefficients and Boundary Conditions
c = 1e2;
a = 0;
f = 0;
d = 10;
% ---- Eigenval params
sigma = 1e2;
numberEigenvalues = 6;
% ====================================
model = createpde(numberOfPDE);
g = decsg([1 0 0 radius]','C1',('C1')');
geometryFromEdges(model,g);
specifyCoefficients(model,'m',0,'d',d,'c',c,'a',a,'f',f);
bOuter = applyBoundaryCondition(model,'dirichlet','Edge',(1:4),'u',0);
% ---
if (1==1)
    figure(1); clf; pdegplot(model,'EdgeLabels','on');
    axis equal; title('Geometry With Edge Labels Displayed');
end
% ---- Generate Mesh & Solve the Eigenvalue Problem Using eigs
generateMesh(model,'Hmax',0.2);
FEMatrices = assembleFEMatrices(model,'nullspace');
K = FEMatrices.Kc;
B = FEMatrices.B;
M = FEMatrices.M;
[eigenvectorsEigs,eigenvaluesEigs] = eigs(K,M,numberEigenvalues,sigma);
eigenvaluesEigs = diag(eigenvaluesEigs);
[maxEigenvaluesEigs, maxIndex] = max(eigenvaluesEigs);
eigenvectorsEigs = B*eigenvectorsEigs;
% ---- Solve the Eigenvalue Problem Using solvepdeeig
r = [min(eigenvaluesEigs)*.99 max(eigenvaluesEigs)*1.01];
result = solvepdeeig(model,r);
eigenvectorsPde = result.Eigenvectors;
eigenvaluesPde = result.Eigenvalues;
% ---- Contour plot
h = figure(2);
for n=1:numberEigenvalues
    subplot(3,2,n); axis equal
    %pdeplot(model,'XYData', eigenvectorsEigs(:,n),'Contour','on');
    pdeplot(model,'XYData', eigenvectorsPde(:,n),'Contour','on');
    xlabel('x'); ylabel('y');
end
% ----

% Uses delaunay.m below to convert 3 Nx1 arrays to 2-D arrays that can be
% plotted via surf (or trisurf as done here)
% [https://www.mathworks.com/matlabcentral/answers/444524-change-plot3-to-surface]
x= model.Mesh.Nodes(1,:);
y= model.Mesh.Nodes(2,:);
tri=delaunay(x,y);
h3 = figure(3); clf;
tP=120;
for m=1:tP
    for n=1:numberEigenvalues
        zval= eigenvectorsPde(:,n);
        z= zval*cos(2*pi*m/tP);
        subplot(3,2,n);
        trisurf(tri,x,y,z); view([0 45]); axis off; grid off; colormap jet;
        % --- fix vertical axis and color bar lim
        zlim([-max(abs(zval)) max(abs(zval))]); caxis([-max(abs(zval)) max(abs(zval))]);
        if (1==1);  shading interp;     end     % turn on to "smooth" coloring {0}    
    end
    pause(0.03);
end

% plot3(model.Mesh.Nodes(1,:),model.Mesh.Nodes(2,:),eigenvectorsPde(:,n),'.')
