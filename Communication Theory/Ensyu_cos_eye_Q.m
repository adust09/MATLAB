%コサインロールオフフィルタによる帯域制限とアイパターン
%　           2019/10/09 Copyright　Hiroshi Ochi
clear all
close all

%　問１　各種パラメータの設定
alpha = input('ロールオフ率　alpha = ');
T = input('シンボル間隔　T = '); %オーバサンプリング率と同義
taplength = input('送受信各フィルタのインパルス応答長（タップ数）　taplength = ');

%送受信ルートコサインロールオフフィルタの設計
rt=rcosdesign(alpha, ceil(taplength/T),T, 'sqrt');
rt=rt/max(abs(fft(rt,512)));

figure(1)
freqz(rt); %周波数特性

figure(2)
stem(rt); %インパルス応答

% ここから送受信システムの記述
%　NRZ符号を作成　問1-2：23行から38行までの説明
NRZ1 = round(rand(1,1000)); 
NRZ=[];

% NRZを多値に変換　　
for u=1:length(NRZ1)/2;
   m=[NRZ1(2*u-1) NRZ1(2*u)];
   r=2*bi2de(m)-1;   
   NRZ=[NRZ r];
end

%NRZを零補間する　　
input_1=[];
for i=1:length(NRZ)
    input_1 =[input_1 NRZ(i) zeros(1,T-1)];
end 
NRZ_s = input_1;

%送信波形：送信機ルートロールオフフィルタリング(rtとNRZ_sの畳み込み）

yt = conv(rt,NRZ_s);

%アイパターンの表示
eyeptn(yt,T);% 関数eyeptn.mで定義 figure(3)

% チャネル伝搬後の受信波形＝アンテナ受信点
ch=[1]; %チャネルインパルス応答　問２では値を変更のこと
yr=conv(ch,yt);

%アンテナ受信時点のアイパターン
eyeptn(yr,T);  % figure(4)

%受信機側のルートロールオフフィルタリング
yy = conv(rt,yr);

%受信アイパターンの表示
eyeptn(yy,T);% figure(5)　問２でチャネルを通した場合と
             %そうでない場合とで図が異なる理由を議論せよ。

%送信・受信システムの時間領域動　作記述は以上で終わり。
%以下は検証のための記述。
%送信パルスデータのスペクトル表示
figure(6)
plot(abs(fft(NRZ_s)))
%受信波のスペクトル表示
figure(7)
plot(abs(fft(yy)))  % 問1-3：　Fig3との相違について議論しなさい。

%送信受信機システム全体のインパルス応答と周波数応答
h=conv(rt,rt);  % 問5（1）: hは何を表すのか？なぜこのコマンドを使うのか？
figure(8)
stem(h)         % 問5（2）：このhの波形は、教科書のどの式と図に対応？式番号・図番号を示せ。
figure(9)
freqz(h)
