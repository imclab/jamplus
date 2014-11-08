function Test()
	-- Test for a clean directory.
	local originalFiles =
	{
		'Jamfile.jam',
		'common/common.jam',
		'common/print.cpp',
		'common/print.h',
		'libA/libA.cpp',
		'libA/libA.jam',
		'project1/project1.cpp',
		'project1/project1.jam',
	}

	local originalDirs =
	{
		'common/',
		'libA/',
		'project1/',
	}

	RunJam{ 'clean' }
	TestDirectories(originalDirs)
	TestFiles(originalFiles)

	if Platform == 'win32' then
		-- First build
		local pattern = [[
*** found 26 target(s)...
*** updating 9 target(s)...
@ C.$(COMPILER).C++ <$(TOOLCHAIN_GRIST):project1>project1.obj
!NEXT!@ C.$(COMPILER).C++ <$(TOOLCHAIN_GRIST):common>print.obj
!NEXT!@ $(C_ARCHIVE) <$(TOOLCHAIN_GRIST):common>common.lib
!NEXT!@ C.$(COMPILER).C++ <$(TOOLCHAIN_GRIST):libA>libA.obj
!NEXT!@ $(C_ARCHIVE) <$(TOOLCHAIN_GRIST):libA>libA.lib
!NEXT!@ $(C_LINK) <$(TOOLCHAIN_GRIST):project1>project1.exe
!NEXT!*** updated 9 target(s)...
]]

		TestPattern(pattern, RunJam())

		local pass1Files =
		{
			'Jamfile.jam',
			'common/common.jam',
			'common/print.cpp',
			'common/print.h',
			'common/$(TOOLCHAIN_PATH)/common/common.release.lib',
			'common/$(TOOLCHAIN_PATH)/common/print.obj',
			'libA/libA.cpp',
			'libA/libA.jam',
			'libA/$(TOOLCHAIN_PATH)/libA/libA.obj',
			'libA/$(TOOLCHAIN_PATH)/libA/libA.release.lib',
			'project1/project1.cpp',
			'project1/project1.jam',
			'project1/$(TOOLCHAIN_PATH)/project1/project1.obj',
			'project1/$(TOOLCHAIN_PATH)/project1/project1.release.exe',
			'?project1/$(TOOLCHAIN_PATH)/project1/project1.release.exe.intermediate.manifest',
			'project1/$(TOOLCHAIN_PATH)/project1/project1.release.pdb',
		}

		local pass1Directories = {
			'common/',
			'libA/',
			'project1/',
			'common/$(TOOLCHAIN_PATH)/',
			'common/$(TOOLCHAIN_PATH)/common/',
			'libA/$(TOOLCHAIN_PATH)/',
			'libA/$(TOOLCHAIN_PATH)/libA/',
			'project1/$(TOOLCHAIN_PATH)/',
			'project1/$(TOOLCHAIN_PATH)/project1/',
		}

		TestFiles(pass1Files)
		TestDirectories(pass1Directories)

		local pattern2 = [[
*** found 26 target(s)...
]]
		TestPattern(pattern2, RunJam())
	else
		-- First build
		local pattern = [[
*** found 18 target(s)...
*** updating 9 target(s)...
@ C.$(COMPILER).C++ <$(TOOLCHAIN_GRIST):project1>project1.o 
@ C.$(COMPILER).C++ <$(TOOLCHAIN_GRIST):common>print.o 
@ $(C_ARCHIVE) <$(TOOLCHAIN_GRIST):common>common.a 
@ C.$(COMPILER).C++ <$(TOOLCHAIN_GRIST):libA>libA.o 
@ $(C_ARCHIVE) <$(TOOLCHAIN_GRIST):libA>libA.a 
@ $(C_LINK) <$(TOOLCHAIN_GRIST):project1>project1
*** updated 9 target(s)...
]]

		TestPattern(pattern, RunJam())

		local pass1Dirs = {
			'common/',
			'libA/',
			'project1/',
			'common/$(TOOLCHAIN_PATH)/',
			'common/$(TOOLCHAIN_PATH)/common/',
			'libA/$(TOOLCHAIN_PATH)/',
			'libA/$(TOOLCHAIN_PATH)/libA/',
			'project1/$(TOOLCHAIN_PATH)/',
			'project1/$(TOOLCHAIN_PATH)/project1/',
		}

		local pass1Files =
		{
			'Jamfile.jam',
			'test.lua',
			'common/common.jam',
			'common/print.cpp',
			'common/print.h',
			'common/$(TOOLCHAIN_PATH)/common/common.release.a',
			'common/$(TOOLCHAIN_PATH)/common/print.o',
			'libA/libA.cpp',
			'libA/libA.jam',
			'libA/$(TOOLCHAIN_PATH)/libA/libA.o',
			'libA/$(TOOLCHAIN_PATH)/libA/libA.release.a',
			'project1/project1.cpp',
			'project1/project1.jam',
			'project1/$(TOOLCHAIN_PATH)/project1/project1.o',
			'project1/$(TOOLCHAIN_PATH)/project1/project1.release',
		}

		TestFiles(pass1Files)
		TestDirectories(pass1Dirs)

		local pattern2 = [[
*** found 18 target(s)...
]]
		TestPattern(pattern2, RunJam())
	end
	
	osprocess.sleep(1.0)
	ospath.touch('common/print.h')

	if Platform == 'win32' then
		local pattern3 = [[
*** found 26 target(s)...
*** updating 4 target(s)...
@ C.$(COMPILER).C++ <$(TOOLCHAIN_GRIST):project1>project1.obj
!NEXT!@ C.$(COMPILER).C++ <$(TOOLCHAIN_GRIST):libA>libA.obj
!NEXT!@ $(C_ARCHIVE) <$(TOOLCHAIN_GRIST):libA>libA.lib
!NEXT!@ $(C_LINK) <$(TOOLCHAIN_GRIST):project1>project1.exe
!NEXT!*** updated 4 target(s)...
]]
		TestPattern(pattern3, RunJam())
	else
		local pattern3 = [[
*** found 18 target(s)...
*** updating 4 target(s)...
@ C.$(COMPILER).C++ <$(TOOLCHAIN_GRIST):project1>project1.o 
@ C.$(COMPILER).C++ <$(TOOLCHAIN_GRIST):libA>libA.o 
@ $(C_ARCHIVE) <$(TOOLCHAIN_GRIST):libA>libA.a 
@ $(C_LINK) <$(TOOLCHAIN_GRIST):project1>project1
*** updated 4 target(s)...
]]
		TestPattern(pattern3, RunJam())
	end

	RunJam{ 'clean' }
	TestDirectories(originalDirs)
	TestFiles(originalFiles)
end

