% function [c,s]=fcs(x);
% Converted to a routine more suitable for use with Matlab, Octave, and Lyme by
% Robert J. McGough
% Michigan State University
% 15 Dec 2008
% It is unlikely that the vectorized operations are optimal, but they
% appear to work.

% function mfcs
%This program is a direct conversion of the corresponding Fortran program in
%S. Zhang & J. Jin "Computation of Special Functions" (Wiley, 1996).
%online: http://iris-lee3.ece.uiuc.edu/~jjin/routines/routines.html
%
%Converted by f2matlab open source project:
%online: https://sourceforge.net/projects/f2matlab/
% written by Ben Barrowes (barrowes@alum.mit.edu)
%

%     =======================================================
%     Purpose: This program computes the Fresnel integrals
%     C(x)and S(x)using subroutine FCS
%     Input :  x --- Argument of C(x)and S(x)
%     Output:  C --- C(x)
%     S --- S(x)
%     Example:
%     x          C(x)S(x)
%     -----------------------------------
%     0.0      .00000000      .00000000
%     0.5      .49234423      .06473243
%     1.0      .77989340      .43825915
%     1.5      .44526118      .69750496
%     2.0      .48825341      .34341568
%     2.5      .45741301      .61918176
%     =======================================================
% x=[];c=[];s=[];
%fprintf(1,'%s \n','please enter x ');
%     READ(*,*)X
%x=2.5;
%fprintf(1,'%s \n','   x          c(x)s(x)');
%[x,c,s]=fcs(x,c,s);
%fprintf(1,'%s \n',' -----------------------------------');
%fprintf(1,[repmat(' ',1,1),'%5.1g',repmat('%15.8g',1,2) ' \n'],x,c,s);
%format(1x,f5.1,2f15.8);
%end
function [c,s]=fcs(x)
%     =================================================
%     Purpose: Compute Fresnel integrals C(x)and S(x)
%     Input :  x --- Argument of C(x)and S(x)
%     Output:  C --- C(x)
%     S --- S(x)
%     =================================================

c=zeros(size(x));
s=zeros(size(x));

eps=1.0e-15;
pi=3.141592653589793e0;
xa=abs(x);
px=pi.*xa;
t=.5e0.*px.*xa;
t2=t.*t;

% if(xa == 0.0);
ixaeq0 = find(xa == 0.0);
c(ixaeq0)=0.0e0;
s(ixaeq0)=0.0e0;


ixalt2p5 = find(xa < 2.5e0 & xa > 0.0);
% elseif(xa < 2.5e0);
r=xa(ixalt2p5);
c(ixalt2p5)=r;
for  k=1:50 
    r=-.5e0.*r.*(4.0e0.*k-3.0e0)./k./(2.0e0.*k-1.0e0)./(4.0e0.*k+1.0e0).*t2(ixalt2p5);
    c(ixalt2p5)=c(ixalt2p5)+r;
    if(abs(r) < abs(c(ixalt2p5))*eps) 
       break;
    end 
end 
s(ixalt2p5)=xa(ixalt2p5).*t(ixalt2p5)./3.0e0;
r=s(ixalt2p5);
for  k=1:50 
    r=-.5e0.*r.*(4.0e0.*k-1.0e0)./k./(2.0e0.*k+1.0e0)./(4.0e0.*k+3.0e0).*t2(ixalt2p5);
    s(ixalt2p5)=s(ixalt2p5)+r;
    if(abs(r)< abs(s(ixalt2p5))*eps) 
        break;
    end 
end 

% apparently this algorithm is unstable in the sense that, if too many
% iterations are perfomed, then the variable 'su' grows infinitely large.
% Thus, must make sure that we use the correct number of iterations for
% each entry 'ix'.
ixalt4p5 = find(xa < 4.5e0 & xa >= 2.5);
% elseif(xa < 4.5e0);
m=fix(42.0+1.75.*t(ixalt4p5));
for ix = 1:length(ixalt4p5) 
su=0.0e0;
% c(ixalt4p5(ix))=0.0e0;
% s(ixalt4p5(ix))=0.0e0;
f1=0.0e0;
f0=1.0e-100;
for  k=m(ix):-1:0 
    f=(2.0*k+3.0)*f0./t(ixalt4p5(ix))-f1;
    if(k == fix(k/2)*2) 
        c(ixalt4p5(ix))=c(ixalt4p5(ix))+f;
    else
        s(ixalt4p5(ix))=s(ixalt4p5(ix))+f;
    end 
    su=su+(2.0e0.*k+1.0e0).*f.*f;
    f1=f0;
    f0=f;
end   
% k=0-1;
q=sqrt(su);
c(ixalt4p5(ix))=c(ixalt4p5(ix)).*xa(ixalt4p5(ix))./q;
s(ixalt4p5(ix))=s(ixalt4p5(ix)).*xa(ixalt4p5(ix))./q;
end

ixagt4p5 = find(xa >= 4.5e0 );
% else;
r=1.0e0;
f=1.0e0;
for  k=1:20 
    r=-.25e0.*r.*(4.0e0.*k-1.0e0).*(4.0e0.*k-3.0e0)./t2(ixagt4p5);
    f=f+r;
end   
r=1.0e0./(px(ixagt4p5).*xa(ixagt4p5));
g=r;
for  k=1:12 
    r=-.25e0.*r.*(4.0e0.*k+1.0e0).*(4.0e0.*k-1.0e0)./t2(ixagt4p5);
    g=g+r;
end    
t0=t(ixagt4p5)-fix(t(ixagt4p5)./(2.0e0.*pi)).*2.0e0.*pi;
c(ixagt4p5)=.5e0+(f.*sin(t0)-g.*cos(t0))./px(ixagt4p5);
s(ixagt4p5)=.5e0-(f.*cos(t0)+g.*sin(t0))./px(ixagt4p5);
% end;

ixlt0 = find(x < 0.0);
% if(x < 0.0e0);
c(ixlt0)=-c(ixlt0);
s(ixlt0)=-s(ixlt0);
% end;
return;
end
