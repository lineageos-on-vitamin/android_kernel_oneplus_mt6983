# Variables
DTBO_SUPPORT_LIST := k6983v1_64 oplus6983_21007 oplus6983_22021 oplus6983_22021_EVB oplus6983_22921 oplus6983_22823
DTBO_PATH := $(objtree)/arch/arm64/boot/dts/mediatek
DTS_PATH := $(srctree)/arch/arm64/boot/dts/mediatek
CONFIG_FILE := $(objtree)/dtboimg.cfg

# Generate dtboimg.cfg during dtbs target
dtbs: $(CONFIG_FILE)

$(CONFIG_FILE):
	@echo "Generating $(notdir $(CONFIG_FILE))..."
	@rm -f $(CONFIG_FILE)
	@my_dtbo_id=0; \
	for dtbo in $(DTBO_SUPPORT_LIST); do \
		dts_file=$(DTS_PATH)/$$dtbo.dts; \
		dtsino=$$(grep -m 1 'oplus_boardid,dtsino' "$$dts_file" | sed 's/.*dtsino\=\"\([^\"]*\)\".*/\1/'); \
		pcbmask=$$(grep -m 1 'oplus_boardid,pcbmask' "$$dts_file" | sed 's/.*pcbmask\=\"\([^\"]*\)\".*/\1/'); \
		only_dtbo=$$(basename $$dtbo .dtbo); \
		echo "$$only_dtbo.dtbo" >> $(CONFIG_FILE); \
		if [ $$my_dtbo_id -eq 0 ]; then \
			echo " id=" >> $(CONFIG_FILE); \
		else \
			echo " id=$$my_dtbo_id" >> $(CONFIG_FILE); \
		fi; \
		echo " custom0=$$dtsino" >> $(CONFIG_FILE); \
		echo " custom1=$$pcbmask" >> $(CONFIG_FILE); \
		my_dtbo_id=$$(($$my_dtbo_id + 1)); \
	done
	@echo "$(notdir $(CONFIG_FILE)) generated successfully."
