// vcprojectgen.cpp : 定义控制台应用程序的入口点。
//
// buildvcproj.cpp : 定义控制台应用程序的入口点。 
// 

#include "stdafx.h" 
#include <windows.h> 



FILE *g_pFile=NULL;
const char *g_packsDir=NULL;
int       g_packsDirLen=0;

void Build(const char *packsDir, const char *subdir)
{
    WIN32_FIND_DATAA FindFileData;
    HANDLE hFind = INVALID_HANDLE_VALUE;
    char DirSpec[MAX_PATH];  // directory specification 
    DWORD dwError;
    strcpy_s(DirSpec,packsDir);
    
    int rlen = strlen(DirSpec);
    if(DirSpec[rlen -1]=='\\')
    {
        DirSpec[rlen-1]='0';
    }

    if(subdir&&subdir[0]!=0)
    {
        strcat_s(DirSpec,"\\");
        strcat_s(DirSpec,subdir);
    }

    int saveLen = strlen(DirSpec);
    
    strcat_s(DirSpec,"\\*");      

    
    hFind = FindFirstFileA(DirSpec, &FindFileData);

    DirSpec[saveLen]='\0';

    if (hFind != INVALID_HANDLE_VALUE) 
    {
        do
        {
            if(FindFileData.dwFileAttributes&FILE_ATTRIBUTE_DIRECTORY )
            {
                if(FindFileData.cFileName[0]!='.' 
                    && strstr(FindFileData.cFileName,"objchk")==NULL
                    && strstr(FindFileData.cFileName,"objfre")==NULL
                    )

                {
                    fprintf(g_pFile,"   <Filter "
"\nName=\"%s\""\
"\nFilter=\"cpp;c;h;cc;cxx;def;odl;idl;hpj;bat;asm;asmx\""
"\n>\n",FindFileData.cFileName
                    );
                    Build(DirSpec,FindFileData.cFileName);
                    fprintf(g_pFile,"%s\n","\n  </Filter>\n");
                }
            }
            else
            {
                int len =strlen(FindFileData.cFileName);
                if(len<4 || _strcmpi(FindFileData.cFileName+len-4,".obj")!=0)
                {
                    fprintf(g_pFile,
                    "\n<File"
                    "\nRelativePath=\".%s\\%s\""
                    "\n></File>\n",
                    DirSpec+g_packsDirLen,FindFileData.cFileName);
                }
                
            }

            
        }
        while (FindNextFileA(hFind, &FindFileData) != 0) ;

        dwError = GetLastError();
        FindClose(hFind);
    }


}



int _tmain(int argc, _TCHAR* argv[])
{

    if(argc<3)
    {
        printf("usage:\nbuildvcproj dir destfilename\n"
            "example:\n"
            "buildvcproj c:\\abc abc.xml\n");
        return 0;
    }



	fopen_s(&g_pFile, argv[2], "w");
    if(g_pFile)
    {
        fprintf(g_pFile,"%s",
                            "<?xml version=\"1.0\" encoding=\"gb2312\"?>"
                            "\n<VisualStudioProject"
                            "\n ProjectType=\"Visual C++\""
                            "\n Version=\"9.00\""
                            "\n Name=\"win2ksrc\""
                            "\n ProjectGUID=\"{8B8C6959-68F6-4182-8EA9-87C1E30EBE9E}\""
                            "\n Keyword=\"MakeFileProj\""
                            "\n TargetFrameworkVersion=\"196613\""
                            "\n >"
                            "\n <Platforms>"
                            "\n     <Platform"
                            "\n         Name=\"Win32\""
                            "\n     />"
                            "\n </Platforms>"
                            "\n <ToolFiles>"
                            "\n </ToolFiles>"
                            "\n <Configurations>"
                            "\n     <Configuration"
                            "\n         Name=\"Debug|Win32\""
                            "\n         OutputDirectory=\"$(ConfigurationName)\""
                            "\n         IntermediateDirectory=\"$(ConfigurationName)\""
                            "\n         ConfigurationType=\"0\""
                            "\n         >"
                            "\n         <Tool"
                            "\n             Name=\"VCNMakeTool\""
                            "\n             BuildCommandLine=\"\""
                            "\n             ReBuildCommandLine=\"\""
                            "\n             CleanCommandLine=\"\""
                            "\n             Output=\"win2ksrc.exe\""
                            "\n             PreprocessorDefinitions=\"WIN32;_DEBUG\""
                            "\n             IncludeSearchPath=\"\""
                            "\n             ForcedIncludes=\"\""
                            "\n             AssemblySearchPath=\"\""
                            "\n             ForcedUsingAssemblies=\"\""
                            "\n             CompileAsManaged=\"\""
                            "\n         />"
                            "\n     </Configuration>"
                            "\n     <Configuration"
                            "\n         Name=\"Release|Win32\""
                            "\n         OutputDirectory=\"$(ConfigurationName)\""
                            "\n         IntermediateDirectory=\"$(ConfigurationName)\""
                            "\n         ConfigurationType=\"0\""
                            "\n         >"
                            "\n         <Tool"
                            "\n             Name=\"VCNMakeTool\""
                            "\n             BuildCommandLine=\"\""
                            "\n             ReBuildCommandLine=\"\""
                            "\n             CleanCommandLine=\"\""
                            "\n             Output=\"win2ksrc.exe\""
                            "\n             PreprocessorDefinitions=\"WIN32;NDEBUG\""
                            "\n             IncludeSearchPath=\"\""
                            "\n             ForcedIncludes=\"\""
                            "\n             AssemblySearchPath=\"\""
                            "\n             ForcedUsingAssemblies=\"\""
                            "\n             CompileAsManaged=\"\""
                            "\n         />"
                            "\n     </Configuration>"
                            "\n </Configurations>"
                            "\n <References>"
                            "\n </References>"
                            "\n <Files>"
                            "\n "
                            );
        g_packsDir=argv[1];
        g_packsDirLen= strlen(g_packsDir);
        Build(g_packsDir,"");
        fprintf(g_pFile,"%s",
                            "\n </Files>"
                            "\n <Globals>"
                            "\n </Globals>"
                            "\n</VisualStudioProject>"
                            );


        fclose(g_pFile);
    }
    else
    {
        printf("Can not open file %s\n",argv[2]);
    }

    return 0;
}

