function Q01_L01

%TRECHO 1
L1 = 200;
w1 = 1.5;

%TRECHO 2
L2 = 800;
w2 = 0.6;

L = L1+L2;
w = (w1*L1+w2*L2)/(L1+L2)

V = 700;
H = 700;
n = 500;

[l,h,v,t,a]=catenaria(L,H,V,w,n); %Aproximando por uma catenária 
for i = 1:n
    if(l(i)==L1)
        xi = h(i);
        yi = v(i);
        break
    end
end
 
 Respmin = fmincon(@(B)Vinculo1(L1,L2,H,V,w1,w2,n,B),[xi,yi],[],[],[],[],[0 0],[H V]);
 
 %Foi necessário aumentar as iterações, o default de 'fsolve' é 100 por variável a ser
 %definida (200 em nosso caso).
 options = optimset('fsolve');
 options = optimset(options,'MaxFunEvals',1000);
 Respsolve = fsolve(@(B)Vinculo2(L1,L2,H,V,w1,w2,n,B),[xi,yi],options);
 %clc
 fprintf('\n============================================================\nAs coordenadas da transição entre as duas linhas são:\n');
 fprintf('\nVia minimizacao: x = %.4f y = %.4f\n',Respmin(1),Respmin(2));
 fprintf('\nVia sistema de equacao: x = %.4f y = %.4f\n',Respsolve(1),Respsolve(2));
 fprintf('============================================================\n');

%Trecho feito para ilustrar a deslumbrante catenária obtida. 
% [l1,h1,v1,t1,a1]=catenaria(L1,Respmin(1),Respmin(2),w1,n);
% [l2,h2,v2,t2,a2]=catenaria(L2,H-Respmin(1),V-Respmin(2),w2,n);
% h2 = h2+Respmin(1);
% v2 = v2+Respmin(2);
% f=figure;
% plot(h1,v1)
% xlabel('H (m)')
% ylabel('V (m)')
% hold on
% plot(h2,v2,'r')
%disp(v1) %Verificar que a catenária não toca o solo.

%Função utilizada para minimização
function E=Vinculo1(L1,L2,H,V,w1,w2,n,B)
[l1,h1,v1,t1,a1]=catenaria(L1,B(1),B(2),w1,n);

[l2,h2,v2,t2,a2]=catenaria(L2,H-B(1),V-B(2),w2,n);

Fh = t1(n+1)*cosd(a1(n+1))-t2(1)*cosd(a2(1));
Fv = t1(n+1)*sind(a1(n+1))-t2(1)*sind(a2(1));

E = Fh^2+Fv^2;

%Função utilizada para explicitar o sistema a ser resolvido com o auxílio
%da função 'fsolve'.
function R=Vinculo2(L1,L2,H,V,w1,w2,n,B)
[l1,h1,v1,t1,a1]=catenaria(L1,B(1),B(2),w1,n);
 
[l2,h2,v2,t2,a2]=catenaria(L2,H-B(1),V-B(2),w2,n);
 
R(1) = t1(n+1)-t2(1);
R(2)= a1(n+1)-a2(1);