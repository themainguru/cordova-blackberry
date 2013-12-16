@ECHO OFF
goto comment
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
:comment
setlocal enabledelayedexpansion

set /P CORDOVA_VERSION=<%~dps0..\VERSION
set CORDOVA_HOME_DIR=!USERPROFILE!\.cordova\lib\blackberry10\cordova\!CORDOVA_VERSION!
set LOCAL_NODE_BINARY=!CORDOVA_HOME_DIR!\bin\dependencies\node\bin
set LOCAL_BBTOOLS_BINARY=!CORDOVA_HOME_DIR!\bin\dependencies\bb-tools\bin

for /f "usebackq delims=" %%e in (`whereis where 2^>nul`) do (
  set FOUNDWHERE=%%e
)
set FOUNDJAVAAT=
for /f "usebackq delims=" %%e in (`%FOUNDWHERE% java 2^>nul`) do (
  set "FOUNDJAVAAT=%%~dpe"
)
if not defined FOUNDJAVAAT (
  for /f "usebackq delims=" %%e in (`%FOUNDWHERE% "%ProgramFiles(x86)%\java\jre7\bin;%ProgramW6432%\java\jre7\bin;":java 2^>nul`) do (
    set "FOUNDJAVAAT=%%~dpe"
  )
)
if defined FOUNDJAVAAT (
  set "PATH=!PATH!;!FOUNDJAVAAT!"
)

if defined CORDOVA_NODE (
  if exist "!CORDOVA_NODE!" (
    if defined CORDOVA_BBTOOLS (
      if exist "!CORDOVA_BBTOOLS!" (
        goto end
      )
    )
  )
)

if exist "!LOCAL_NODE_BINARY!" (
  set CORDOVA_NODE=!LOCAL_NODE_BINARY!
) else (
  for /f "usebackq delims=" %%e in (`%FOUNDWHERE% node 2^>nul`) do (
    set CORDOVA_NODE=%%~dpe
  )
)

if exist "!LOCAL_BBTOOLS_BINARY!" (
  set CORDOVA_BBTOOLS=!LOCAL_BBTOOLS_BINARY!
) else (
  for /f "usebackq delims=" %%e in (`%FOUNDWHERE% blackberry-nativepackager 2^>nul`) do (
    set CORDOVA_BBTOOLS=%%~dpe
  )
)

if not exist "!CORDOVA_NODE!\node.exe" (
  echo node cannot be found on the path. Aborting.
  exit /b 2
)
if not exist "!CORDOVA_NODE!\npm" (
  echo npm cannot be found on the path. Aborting.
  exit /b 2
)
if not defined FOUNDJAVAAT (
  echo java cannot be found on the path. Aborting.
  exit /b 2
)
if not exist "!CORDOVA_BBTOOLS!\blackberry-nativepackager.bat" (
  echo blackberry-nativepackager cannot be found on the path. Aborting.
  exit /b 2
)
if not exist "!CORDOVA_BBTOOLS!\blackberry-deploy.bat" (
  echo blackberry-deploy cannot be found on the path. Aborting.
  exit /b 2
)
if not exist "!CORDOVA_BBTOOLS!\blackberry-signer.bat" (
  echo blackberry-signer cannot be found on the path. Aborting.
  exit /b 2
)
if not exist "!CORDOVA_BBTOOLS!\blackberry-debugtokenrequest.bat" (
  echo blackberry-debugtokenrequest cannot be found on the path. Aborting.
  exit /b 2
)

"!CORDOVA_NODE!\node" "%~dp0\check_reqs.js" %*

:end

exit /b 0
