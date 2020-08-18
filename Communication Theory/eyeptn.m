function eyeptn(y,T) 


% eyeptnF(y, T) 
%
% y          : 出力信号
% T	     : ナイキスト間隔
%
%アイパターンの表示

figure

hold
for m = T:fix((length(y)-1)/T)
   plot(y((m-1)*T:(m+1)*T))
end
hold off





