@if (@x)==(@y) @end /***** js-converter hex to decimal ******
     @echo off

     cscript //E:JScript //nologo "%~f0" %*
     exit /b 0

 @if (@x)==(@y) @end ******  end comment *********/

 var args=WScript.Arguments;
 var number=args.Item(0);

 WScript.Echo(parseInt(number,16));