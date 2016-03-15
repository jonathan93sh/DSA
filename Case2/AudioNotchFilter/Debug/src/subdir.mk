################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/AudioNotchFilter.c \
../src/ISR.c \
../src/Initialize.c \
../src/Process_data.c 

OBJS += \
./src/AudioNotchFilter.doj \
./src/ISR.doj \
./src/Initialize.doj \
./src/Process_data.doj 

C_DEPS += \
./src/AudioNotchFilter.d \
./src/ISR.d \
./src/Initialize.d \
./src/Process_data.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.doj: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: CrossCore Blackfin C/C++ Compiler'
	ccblkfn.exe -c -file-attr ProjectName="AudioNotchFilter" -proc ADSP-BF533 -flags-compiler --no_wrap_diagnostics -si-revision 0.6 -g -D_DEBUG -I"C:\Users\kbe\Dropbox\ETISB\firstWeeks\AudioNotchFilter\system" -structs-do-not-overlap -no-multiline -warn-protos -double-size-32 -decls-strong -cplbs -gnu-style-dependencies -MD -Mo "$(basename $@).d" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


