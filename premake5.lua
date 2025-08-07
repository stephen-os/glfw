project "GLFW"
    kind "StaticLib"
    language "C"
    staticruntime "off"
    
    -- Enable multi-core compilation
    flags { "MultiProcessorCompile" }
    
    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
    
    -- Common files for all platforms
    files
    {
        "include/GLFW/glfw3.h",
        "include/GLFW/glfw3native.h",
        "src/glfw_config.h",
        "src/context.c",
        "src/init.c",
        "src/input.c",
        "src/monitor.c",
        "src/null_init.c",
        "src/null_joystick.c",
        "src/null_monitor.c",
        "src/null_window.c",
        "src/platform.c",
        "src/vulkan.c",
        "src/window.c"
    }
    
    -- Platform-specific settings
    filter "system:windows"
        systemversion "latest"
        
        files
        {
            "src/win32_init.c",
            "src/win32_joystick.c",
            "src/win32_module.c",
            "src/win32_monitor.c",
            "src/win32_time.c",
            "src/win32_thread.c",
            "src/win32_window.c",
            "src/wgl_context.c",
            "src/egl_context.c",
            "src/osmesa_context.c"
        }
        
        defines 
        { 
            "_GLFW_WIN32",
            "_CRT_SECURE_NO_WARNINGS"
        }
        
        links
        {
            "Dwmapi"  -- Removed .lib extension for consistency
        }
        
    filter "system:linux"
        pic "On"
        systemversion "latest"
        
        files
        {
            "src/x11_init.c",
            "src/x11_monitor.c", 
            "src/x11_window.c",
            "src/xkb_unicode.c",
            "src/posix_time.c",
            "src/posix_thread.c",
            "src/glx_context.c",
            "src/egl_context.c",
            "src/osmesa_context.c",
            "src/linux_joystick.c"
        }
        
        defines
        {
            "_GLFW_X11"
        }
        
        -- Linux system libraries
        links
        {
            "X11",
            "Xrandr", 
            "Xinerama",
            "Xcursor",
            "Xi",
            "pthread",
            "dl"
        }
        
    filter "system:macosx"
        systemversion "latest"
        
        files
        {
            "src/cocoa_init.m",
            "src/cocoa_joystick.m",
            "src/cocoa_monitor.m",
            "src/cocoa_window.m",
            "src/cocoa_time.c",
            "src/posix_thread.c",
            "src/nsgl_context.m",
            "src/egl_context.c",
            "src/osmesa_context.c"
        }
        
        defines
        {
            "_GLFW_COCOA"
        }
        
        -- macOS frameworks
        links
        {
            "Cocoa.framework",
            "IOKit.framework",
            "CoreFoundation.framework",
            "CoreVideo.framework"
        }
    
    -- Configuration-specific settings
    filter "configurations:Debug"
        runtime "Debug"
        symbols "On"
        defines { "DEBUG" }
        
    filter "configurations:Release"
        runtime "Release"
        optimize "On"
        defines { "NDEBUG" }
        
    filter "configurations:Dist"
        runtime "Release"
        optimize "On"
        symbols "Off"
        defines { "NDEBUG", "DIST_BUILD" }
        
    -- Clear filters
    filter {}