# Copyright Statement:
#
# This software/firmware and related documentation ("MediaTek Software") are
# protected under relevant copyright laws. The information contained herein
# is confidential and proprietary to MediaTek Inc. and/or its licensors.
# Without the prior written permission of MediaTek inc. and/or its licensors,
# any reproduction, modification, use or disclosure of MediaTek Software,
# and information contained herein, in whole or in part, shall be strictly prohibited.
#
# MediaTek Inc. (C) 2010. All rights reserved.
#
# BY OPENING THIS FILE, RECEIVER HEREBY UNEQUIVOCALLY ACKNOWLEDGES AND AGREES
# THAT THE SOFTWARE/FIRMWARE AND ITS DOCUMENTATIONS ("MEDIATEK SOFTWARE")
# RECEIVED FROM MEDIATEK AND/OR ITS REPRESENTATIVES ARE PROVIDED TO RECEIVER ON
# AN "AS-IS" BASIS ONLY. MEDIATEK EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NONINFRINGEMENT.
# NEITHER DOES MEDIATEK PROVIDE ANY WARRANTY WHATSOEVER WITH RESPECT TO THE
# SOFTWARE OF ANY THIRD PARTY WHICH MAY BE USED BY, INCORPORATED IN, OR
# SUPPLIED WITH THE MEDIATEK SOFTWARE, AND RECEIVER AGREES TO LOOK ONLY TO SUCH
# THIRD PARTY FOR ANY WARRANTY CLAIM RELATING THERETO. RECEIVER EXPRESSLY ACKNOWLEDGES
# THAT IT IS RECEIVER'S SOLE RESPONSIBILITY TO OBTAIN FROM ANY THIRD PARTY ALL PROPER LICENSES
# CONTAINED IN MEDIATEK SOFTWARE. MEDIATEK SHALL ALSO NOT BE RESPONSIBLE FOR ANY MEDIATEK
# SOFTWARE RELEASES MADE TO RECEIVER'S SPECIFICATION OR TO CONFORM TO A PARTICULAR
# STANDARD OR OPEN FORUM. RECEIVER'S SOLE AND EXCLUSIVE REMEDY AND MEDIATEK'S ENTIRE AND
# CUMULATIVE LIABILITY WITH RESPECT TO THE MEDIATEK SOFTWARE RELEASED HEREUNDER WILL BE,
# AT MEDIATEK'S OPTION, TO REVISE OR REPLACE THE MEDIATEK SOFTWARE AT ISSUE,
# OR REFUND ANY SOFTWARE LICENSE FEES OR SERVICE CHARGE PAID BY RECEIVER TO
# MEDIATEK FOR SUCH MEDIATEK SOFTWARE AT ISSUE.
#
# The following software/firmware and/or related documentation ("MediaTek Software")
# have been modified by MediaTek Inc. All revisions are subject to any receiver's
# applicable license agreements with MediaTek Inc.


# Copyright (C) 2007 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Just bump this if you want to force a clean build.
# **********************************************************************
# WHEN DOING SO
# 1. DELETE ANY "add-clean-step" ENTRIES THAT HAVE PILED UP IN THIS FILE.
# 2. REMOVE ALL FILES NAMED CleanSpec.mk.
# 3. BUMP THE VERSION.
# IDEALLY, THOSE STEPS SHOULD BE DONE ATOMICALLY.
# **********************************************************************
#
INTERNAL_CLEAN_BUILD_VERSION := 6
#
# ***********************************************************************
# Do not touch INTERNAL_CLEAN_BUILD_VERSION if you've added a clean step!
# ***********************************************************************

# If you don't need to do a full clean build but would like to touch
# a file or delete some intermediate files, add a clean step to the end
# of the list.  These steps will only be run once, if they haven't been
# run before.
#
# E.g.:
#     $(call add-clean-step, touch -c external/sqlite/sqlite3.h)
#     $(call add-clean-step, rm -rf $(PRODUCT_OUT)/obj/STATIC_LIBRARIES/libz_intermediates)
#
# Always use "touch -c" and "rm -f" or "rm -rf" to gracefully deal with
# files that are missing or have been moved.
#
# Use $(PRODUCT_OUT) to get to the "out/target/product/blah/" directory.
# Use $(OUT_DIR) to refer to the "out" directory.
#
# If you need to re-do something that's already mentioned, just copy
# the command and add it to the bottom of the list.  E.g., if a change
# that you made last week required touching a file and a change you
# made today requires touching the same file, just copy the old
# touch step and add it to the end of the list.
#
# ************************************************
# NEWER CLEAN STEPS MUST BE AT THE END OF THE LIST
# ************************************************

# For example:
#$(call add-clean-step, rm -rf $(OUT_DIR)/target/common/obj/APPS/AndroidTests_intermediates)
#$(call add-clean-step, rm -rf $(OUT_DIR)/target/common/obj/JAVA_LIBRARIES/core_intermediates)
#$(call add-clean-step, find $(OUT_DIR) -type f -name "IGTalkSession*" -print0 | xargs -0 rm -f)
#$(call add-clean-step, rm -rf $(PRODUCT_OUT)/data/*)

# ************************************************
# NEWER CLEAN STEPS MUST BE AT THE END OF THE LIST
# ************************************************

ifeq ($(ENABLE_CLEAN_SPEC),true)
# Get the path of the top of the tree.
# for example:
# /home/bob/master/framework/base => /home/bob/master
# See function gettop in build/envsetup.sh.
define get-top-dir
$(if $(1),$(if $(wildcard $(1)/build/core/envsetup.mk),$(1),$(strip \
  $(call get-top-dir,$(patsubst %/,%,$(dir $(1)))))))
endef

ifneq ($(ONE_SHOT_MAKEFILE),)
cs_subdirs := $(patsubst %/,%,$(dir $(ONE_SHOT_MAKEFILE)))
abs_cs_subdirs := $(filter /%,$(cs_subdirs))
ifneq ($(abs_cs_subdirs),)
# Convert absolute path to relative path, e.g. when using mm.
abs_top_path := $(call get-top-dir,$(word 1,$(abs_cs_subdirs)))
cs_subdirs := $(filter-out /%,$(cs_subdirs)) \
  $(patsubst $(abs_top_path)/%,%,$(abs_cs_subdirs))

abs_top_path :=
abs_cs_subdirs :=
endif
else
cs_subdirs := .
endif

subdir_cleanspecs := \
    $(shell build/tools/findleaves.py --prune=out --prune=.repo --prune=.git $(cs_subdirs) CleanSpec.mk)
include $(subdir_cleanspecs)
cs_subdirs :=
subdir_cleanspecs :=
endif
