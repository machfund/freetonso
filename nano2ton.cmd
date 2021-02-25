@if (@x)==(@y) @end /***** js converter nanotons to tons ******
     @echo off

     cscript //E:JScript //nologo "%~f0" %*
     exit /b 0

 @if (@x)==(@y) @end ******  end comment *********/

 var args=WScript.Arguments;
 WScript.Echo(parseFloat((args.Item(0)/1000000000).toFixed(2)));