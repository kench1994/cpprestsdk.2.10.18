target("cpprest")
    set_kind("shared")
    -- if is_kind("static") then
    --     add_defines("_NO_ASYNCRTIMP", "_NO_PPLXIMP")
    -- end
    set_pcxxheader("./Release/src/pch/stdafx.h")
    add_headerfiles(
        "./Release/src/http/client/http_client_impl.h",
        "./Release/src/http/common/connection_pool_helpers.h",
        "./Release/src/http/common/internal_http_helpers.h",
        "./Release/src/http/listener/http_server_impl.h"
    )
    add_files(
        "./Release/src/http/client/http_client.cpp",
        "./Release/src/http/client/http_client_msg.cpp",
        "./Release/src/http/common/http_compression.cpp",
        "./Release/src/http/common/http_helpers.cpp",
        "./Release/src/http/common/http_msg.cpp",
        "./Release/src/http/listener/http_listener.cpp",
        "./Release/src/http/listener/http_listener_msg.cpp",
        "./Release/src/http/listener/http_server_api.cpp",
        "./Release/src/http/oauth/oauth1.cpp",
        "./Release/src/http/oauth/oauth2.cpp",
        "./Release/src/json/json.cpp",
        "./Release/src/json/json_parsing.cpp",
        "./Release/src/json/json_serialization.cpp",
        "./Release/src/uri/uri.cpp",
        "./Release/src/uri/uri_builder.cpp",
        "./Release/src/utilities/asyncrt_utils.cpp",
        "./Release/src/utilities/base64.cpp",
        "./Release/src/utilities/web_utilities.cpp"
    )
    add_includedirs("./Release/src/pch/", "./Release/include");
    if is_plat("linux") then
        add_defines("_GLIBCXX_USE_SCHED_YIELD", "_GLIBCXX_USE_NANOSLEEP")
    end
    add_includedirs("../boost_1_58_0")
    add_defines("CPPREST_EXCLUDE_COMPRESSION", "CPPREST_EXCLUDE_WEBSOCKETS")


    add_includedirs("../openssl-1.0.2k/include")

    if not is_plat("windows") then
        add_defines("CPPREST_FORCE_HTTP_CLIENT_ASIO", "CPPREST_FORCE_HTTP_LISTENER_ASIO")
        add_syslinks("pthread")
        add_cxxflags("-fPIC", "-Wno-return-type-c-linkage", "-fvisibility=hidden",
            "-Wno-unneeded-internal-declaration", "-fno-strict-aliasing", "-fpermissive"
        )
        add_ldflags("-Wl,--no-undefined", "-Wl,--exclude-libs,ALL", "-Wl,-Bsymbolic")
        add_headerfiles("./Release/include/pplx/*.h", "./Release/include/pplx/threadpool.h")
        add_files("./Release/src/http/listener/http_server_asio.cpp", 
            "./Release/src/pplx/pplxlinux.cpp", 
            "./Release/src/pplx/pplx.cpp",
            "./Release/src/http/client/http_client_asio.cpp",
            "./Release/src/http/client/x509_cert_utilities.cpp",
            "./Release/src/pplx/threadpool.cpp"
        )
    else
        set_basename("cpprestsdk_2_10_18")
        add_defines("_ASYNCRT_EXPORT", "_PPLX_EXPORT", "_USRDLL")
        add_syslinks("winhttp", "httpapi", "bcrypt", "crypt32")
        add_defines("WIN32", "_WIN32", "_WINDOWS", "UNICODE", "_UNICODE", "_SCL_SECURE_NO_WARNINGS")
        add_cxxflags("/MP")
        add_ldflags("/profile", "/OPT:REF", "/OPT:ICF", "/permissive-")
        add_files(
            "./Release/src/pplx/pplxwin.cpp", 
            "./Release/src/pplx/threadpool.cpp",
            "./Release/src/http/client/http_client_winhttp.cpp",
            "/Release/src/http/listener/http_server_httpsys.cpp",
            "./Release/src/pplx/pplx.cpp",
            "./Release/src/pplx/threadpool.cpp"
        )
    end
    -- after_build(function (target)
    --     local arch = "x86_64"
    --     os.mkdir("build-out")
    --     os.cp("./build/linux", "build-out")
    --     -- if is_arch("arm64-v8a") then
    --     --     arch = "arm64-v8a"
    --     --     os.trycp(target:targetfile(), "./build-out")
    --     -- else
    --     --     os.trycp(target:targetfile(), "")
    --     -- end
    -- end)
    -- on_clean(function (target)
    --     os.tryrm("./build")
    -- end)
target_end()