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
//для произвольного двоичного кода (с нарезкой на блоки)
 
program hamming;
const max_m=16; //максимальное число контрольных битов (шаблон учебный)
var
   s:string; //входное сообщение в двоичном коде
   ss:string; //блок из сообщения
   n:integer; //длина блока входного сообщения
   c:string; //результат (двоичный код Хэмминга)
   cc:string; //блок результата
   m:integer; //количество контрольных битов для блока сообщения
   b:array[1..max_m]of integer; //контрольные биты   
   w:integer; //вектор ошибки (номер ошибочного бита)
   i,j,k,r,blocks_num,align_s:integer; //вспомогательные переменные
   cc_tmp,cc_tmp2:string; //вспомогательная переменная
   
begin
   //ввод сообщения
   writeln('generate Hamming code for some bits');
   write('s='); readln(s);
   write('block_size='); readln(n);
   
   //выравнивание входного бинарного кода путем добавления
   //границы "01" и нулей для выравнивания слева
   s:='01'+s;
   align_s:=n-(length(s) mod n);
   if align_s=n then align_s:=0;
   for i:=1 to align_s do s:='0'+s;
   blocks_num:=length(s) div n;
   
   //печать выровненного входного бинарного кода
   writeln('===========================');
   writeln('add ',align_s,' zero bits and 01 to S');
   for i:=1 to length(s) do
   begin
      write(s[i]);
      if (i mod n)=0 then write(' ');
   end;
   writeln;
   writeln('===========================');

   //определяем количество контрольных битов в блоке
   k:=1; m:=0;
   while k<n+m do
   begin
      k:=k*2;
      m:=m+1;
   end;
   //вывод количества контрольных битов
   writeln('Number of control bits: m=',m);
   writeln;
   //увеличиваем размер блока на m бит
   n:=n+m;
   
   c:='';
   for i:=1 to blocks_num do
   begin
      //вырезаем n бит из входного сообщения (формируем блок)
      ss:='';
      for j:=1 to n-m do ss:=ss+s[(i-1)*(n-m)+j];

      //создаем заготовку для кода Хэмминга в строковой переменной
      cc:=''; for j:=1 to n do cc:=cc+'0';
      //помечаем символом 'b' места для контрольных битов
      k:=1; for j:=1 to m do begin cc[k]:='b'; k:=k*2; end;
      //в "свободные" биты заготовки заносим биты входного сообщения
      k:=1;
      for j:=1 to n do
         if cc[j]<>'b' then begin cc[j]:=ss[k]; k:=k+1; end;
      //заменяем метки контрольных битов нулями
      k:=1; for j:=1 to m do begin cc[k]:='0'; k:=k*2; end;

      //вычисляем контрольные биты
      k:=1;
      for r:=1 to m do
      begin
         b[r]:=0;
         for j:=1 to n do
            if (j and k)=k then
               if cc[j]='1' then 
                  if b[r]=0 then b[r]:=1 else b[r]:=0;
         k:=k*2;
      end;
      //заносим контрольные биты в соответствующие места кода Хэмминга
      k:=1;
      for j:=1 to m do
      begin
         if b[j]=0 then cc[k]:='0' else cc[k]:='1';
         k:=k*2;
      end;
      
      //наращивание окончательного ответа
      c:=c+cc;
      //печать промежуточного результата
      writeln('block',i:3,': s=',ss,'    c=',cc);
      //печатаем контрольные биты
      write('control bits: ');
      k:=1; for j:=1 to m do begin write('c',k,'=',b[j],' '); k:=k*2; end;
      writeln; writeln;
   end;
   
   writeln('==============================');
   writeln('Hamming code');
   writeln('==============================');
   writeln('length of Hamming code block: ',n);
   writeln(c);
   writeln;

   //проверка работоспособности кода Хэмминга
   randomize;
   writeln('=======================================');
   writeln('checking (doing 1 error in each block)');
   writeln('=======================================');
   //пересчитываем размер блока (для кода Хэмминга)
   s:='';
   for i:=1 to blocks_num do
   begin
      //вырезаем n бит из кода Хэмминга (формируем блок)
      cc:='';
      for j:=1 to n do cc:=cc+c[(i-1)*n+j];
      //инвертируем случайным образом выбранный бит блока кода Хэмминга
      j:=random(n)+1; 
      if cc[j]='0' then cc[j]:='1' else cc[j]:='0';
      //печатаем номер позиции ошибочного бита
      writeln('special error position=',j);

      //пересчитываем контрольные биты кода Хэмминга
      k:=1;
      for r:=1 to m do
      begin
         b[r]:=0;
         for j:=1 to n do
            if (j and k)=k then
               if cc[j]='1' then 
                  if b[r]=0 then b[r]:=1 else b[r]:=0;
         k:=k*2;
      end;
      //вычисляем вектор ошибки (номер неправильного бита в блоке)
      w:=0; for j:=m downto 1 do w:=w*2+b[j];
      //инвертитуем неправильный бит
      //если w=0, то ошибки не было
      cc_tmp:=cc;
      if w<>0 then if cc[w]='1' then cc[w]:='0' else cc[w]:='1';
      //извлекаем из блока кода Хэмминга блок сообщения
      cc_tmp2:=cc;
      k:=1; for j:=1 to m do begin cc[k]:='b'; k:=k*2; end;
      ss:=''; for j:=1 to n do if cc[j]<>'b' then ss:=ss+cc[j];
      cc:=cc_tmp2;
      
      //наращивание окончательного ответа
      s:=s+ss;
      //печать промежуточного результата
      writeln('block',i:3,': c_err=',cc_tmp,'   c=',cc,'    s=',ss);
      //печатаем контрольные биты
      write('control bits: ');
      k:=1; for j:=1 to m do begin write('c',k,'=',b[j],' '); k:=k*2; end;
      writeln;
      writeln('Hamming error position = ',w);
      writeln;
   end;

   //печатаем исправленное сообщение
   writeln('==============================');
   writeln('Decode message:');
   writeln(s);

   //"отрезаем" нули и одну единицу слева от декдированного ответа
   //для извлечения исходного сообщения
   j:=1; while s[j]='0' do j:=j+1;
   j:=j+1; ss:=s; s:='';
   for i:=j to length(ss) do s:=s+ss[i];   
   //печатаем извлеченное из кода Хэмминга сообщение
   writeln('==============================');
   writeln('Original message:');
   writeln(s);
end.
