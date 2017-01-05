//Copyright 2017 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

//учебный шаблон создания помехоустойчивого кода Хэмминга
//для произвольного двоичного кода
 
program hamming;
const max_m=16; //максимальное число контрольных битов (шаблон учебный)
var
   s:string; //входное сообщение в двоичном коде
   c:string; //результат (двоичный код Хэмминга)
   b:array[1..max_m]of integer; //контрольные биты
   n:integer; //длина входного сообщения
   m:integer; //реальное количество контрольных битов
   w:integer; //вектор ошибки (номер ошибочного бита)
   i,j,k:integer; //вспомогательные переменные
   
begin
   //ввод сообщения
   writeln('generate Hamming code for some bits');
   write('s='); readln(s);
   //расчет длины сообщения
   n:=length(s); writeln('n=',n);
   
   //определяем количество контрольных битов
   k:=1; m:=0;
   while k<n+m do
   begin
      k:=k*2;
      m:=m+1;
   end;
   //вывод количества контрольных битов
   writeln('m=',m);
   
   //создаем заготовку для кода Хэмминга в строковой переменной
   c:=''; for i:=1 to n+m do c:=c+'0';
   //помечаем символом 'b' места для контрольных битов
   k:=1; for i:=1 to m do begin c[k]:='b'; k:=k*2; end;
   //в "свободные" биты заготовки заносим биты входного сообщения
   j:=1;
   for i:=1 to n+m do
      if c[i]<>'b' then begin c[i]:=s[j]; j:=j+1; end;
   //заменяем метки контрольных битов нулями
   k:=1; for i:=1 to m do begin c[k]:='0'; k:=k*2; end;
   
   //вычисляем контрольные биты
   k:=1;
   for i:=1 to m do
   begin
      b[i]:=0;
      for j:=1 to n+m do
         if (j and k)=k then
            if c[j]='1' then 
               if b[i]=0 then b[i]:=1 else b[i]:=0;
      k:=k*2;
   end;
   //печатаем контрольные биты
   writeln('control bits:');
   k:=1; for i:=1 to m do begin writeln(k,': ',b[i]); k:=k*2; end;
   
   //заносим контрольные биты в соответствующие места кода Хэмминга
   k:=1;
   for i:=1 to m do
   begin
      if b[i]=0 then c[k]:='0' else c[k]:='1';
      k:=k*2;
   end;

   writeln('==============================');
   writeln('Hamming code');
   writeln('==============================');
   writeln('length of Hamming code: ',n+m);
   writeln(c);
   writeln;

   //проверка работоспособности кода Хэмминга
   writeln('==============================');
   writeln('checking (doing 1 error)');
   writeln('==============================');
   //инвертируем случайным образом выбранный бит кода Хэмминга
   randomize;
   j:=random(n+m)+1; 
   if c[j]='0' then c[j]:='1' else c[j]:='0';
   //печатаем код Хэмминга с внесенной в него ошибкой
   writeln(c);
   writeln('special error position=',j);
   
   //пересчитываем контрольные биты кода Хэмминга
   k:=1;
   for i:=1 to m do
   begin
      b[i]:=0;
      for j:=1 to n+m do
         if (j and k)=k then
            if c[j]='1' then 
               if b[i]=0 then b[i]:=1 else b[i]:=0;
      k:=k*2;
   end;
   //вычисляем вектор ошибки (номер неправильного бита)
   w:=0; for i:=m downto 1 do w:=w*2+b[i];

   //печатаем контрольные биты
   writeln;
   writeln('recalculate control bits:');
   k:=1; for i:=1 to m do begin writeln(k,': ',b[i]); k:=k*2; end;
   //печатаем номер ошибочного бита
   write('Hamming error position = ');
   for i:=m downto 1 do write(b[i]);
   writeln(' = ',w);
   
   //инвертитуем неправильный бит
   //если w=0, то ошибки не было
   if w<>0 then if c[w]='1' then c[w]:='0' else c[w]:='1';
   //печатаем исправленный код Хэмминга
   writeln('==============================');
   writeln('correct Hamming code:');
   writeln(c);
   
   //извлекаем из кода Хэмминга сообщение
   k:=1; for i:=1 to m do begin c[k]:='b'; k:=k*2; end;
   s:=''; for i:=1 to n+m do if c[i]<>'b' then s:=s+c[i];
   
   //печатаем извлеченное из кода Хэмминга сообщение
   writeln('==============================');
   writeln('unpacked s:');
   writeln(s);
end.
