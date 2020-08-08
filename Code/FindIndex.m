function Indice=FindIndex(vertex,rates)
%INPUT:
%
%vertex=containing the vertices of the ir or cs
%rates=zero rates or spread
%
%OUTPUT:
%Indice=position of the vertex in the dates of the rates


    Indice=zeros(1,length(vertex));
    for i=1:length(vertex)
    Indice(i)=find(rates(:,1)==vertex(i));
    end
    

end 