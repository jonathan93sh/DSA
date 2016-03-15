################################################################################
# Automatically-generated file. Do not edit!
################################################################################

SHELL := ${ComSpec}

-include ../makefile.init

RM := clean

# All of the sources participating in the build are defined here
-include sources.mk
-include system/startup_ldf/subdir.mk
-include system/subdir.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(DSP_DEPS)),)
-include $(DSP_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
LINKER_LOG_OUTPUTS += \
linker_log.xml \


# All Target
all: AudioNotchFilter.dxe

# Tool invocations
AudioNotchFilter.dxe: $(OBJS) $(LDF_SRCS)
	@echo 'Building target: $@'
	@echo 'Invoking: CrossCore Blackfin Linker'
	ccblkfn.exe -proc ADSP-BF533 -si-revision 0.6 -TC:/Users/kbe/Dropbox/ETISB/firstWeeks/AudioNotchFilter/system/startup_ldf/app.ldf -no-mem -LC:/Users/kbe/Dropbox/ETISB/firstWeeks/AudioNotchFilter/Debug/system/startup_ldf -flags-link -MDDEBUG -add-debug-libpaths -o AudioNotchFilter.dxe $(OBJS) $(LDF_SRCS)  -flags-link -od,.\.
	@echo 'Finished building target: $@'
	@echo ' '

linker_log.xml: AudioNotchFilter.dxe $(OBJS) $(LDF_SRCS)

# Other Targets
clean:
	-$(RM) $(C++_DEPS)$(OBJS)$(C_DEPS)$(ASM_DEPS)$(CC_DEPS)$(DSP_DEPS)$(DXE)$(CPP_DEPS)$(LINKER_LOG_OUTPUTS)$(S_DEPS)$(CXX_DEPS) AudioNotchFilter.dxe
	-@echo ' '

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
