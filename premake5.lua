ROOT_DIR = _MAIN_SCRIPT_DIR
BUILD_DIR = path.join(_MAIN_SCRIPT_DIR, 'build')

----------------------------------------------------------------------------------------------------
function GetCompiler()
    if _TARGET_OS == 'windows'  then
        compiler = 'vc141'
    elseif _OS == 'macosx' then
        compiler = 'xcode'
    else
        compiler = 'gcc50'
    end

    return compiler
end

----------------------------------------------------------------------------------------------------
function GetVariant()
    variant = ('%{cfg.system}-%{cfg.platform}-'.. GetCompiler() .. '-%{cfg.buildcfg}')
    return variant
end

----------------------------------------------------------------------------------------------------
workspace 'sdl2'
    filter { 'system:windows' }
        platforms{'x86_64', 'x86'}
    filter { 'system:linux or macosx' }
        platforms{'x86_64'}
    filter {}

    configurations { 'Debug', 'Release' }

    filter 'configurations:Debug'
        defines { '_DEBUG' }
        optimize 'Off'
    filter 'configurations:Release'
        defines { 'NDEBUG' }
        optimize 'On'
    filter {}

    cppdialect 'C++14'
    editandcontinue 'Off'
    exceptionhandling 'Off'
    floatingpoint 'Fast'
    symbols 'Full'
    rtti 'Off'
    warnings 'Extra'

    location (BUILD_DIR)

    flags
    {
        'MultiProcessorCompile',
        'FatalWarnings',
    }

    filter { 'system:linux' }
        buildoptions
        {
            '-ggdb',              -- Enable gdb debugging
            '-pthread',           -- Enable posix threads
            '-fstack-protector',  -- Buffer overflow protection
        }
    filter { 'system:macosx' }
        buildoptions
        {
            '-ggdb',
        }
    filter {}

    include 'premake-sdl2.lua'
