/* industrial-dual-0-20ma-bricklet
 * Copyright (C) 2013 Olaf Lüke <olaf@tinkerforge.com>
 *
 * 020ma.h: Implementation of Industrial Dual 0-20mA Bricklet messages
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#ifndef INDUSTRIAL_DUAL_020MA_H
#define INDUSTRIAL_DUAL_020MA_H

#include <stdint.h>

#include "bricklib/com/com_common.h"

#define I2C_MODE_FAST 0
#define I2C_MODE_SLOW 1

#define SAMPLE_RATE_240_SPS 0
#define SAMPLE_RATE_60_SPS  1
#define SAMPLE_RATE_15_SPS  2
#define SAMPLE_RATE_4_SPS   3

#define CONFIG_READY (1 << 7)
#define CONFIG_CHANNEL_SELECTION_0 (0 << 5)
#define CONFIG_CHANNEL_SELECTION_1 (1 << 5)
#define CONFIG_CONVERSION_CONTINOUS (1 << 4)
#define CONFIG_CONVERSION_SINGLE_SHOT (0 << 4)
#define CONFIG_CONVERSION_SAMPLE_RATE_240_SPS (SAMPLE_RATE_240_SPS << 2)
#define CONFIG_CONVERSION_SAMPLE_RATE_60_SPS (SAMPLE_RATE_60_SPS << 2)
#define CONFIG_CONVERSION_SAMPLE_RATE_15_SPS (SAMPLE_RATE_15_SPS << 2)
#define CONFIG_CONVERSION_SAMPLE_RATE_4_SPS (SAMPLE_RATE_4_SPS << 2)
#define CONFIG_GAIN_X1 (0 << 0)
#define CONFIG_GAIN_X2 (1 << 0)
#define CONFIG_GAIN_X3 (2 << 0)
#define CONFIG_GAIN_X4 (3 << 0)

#define FID_GET_CURRENT 1
#define FID_SET_CURRENT_CALLBACK_PERIOD 2
#define FID_GET_CURRENT_CALLBACK_PERIOD 3
#define FID_SET_CURRENT_CALLBACK_THRESHOLD 4
#define FID_GET_CURRENT_CALLBACK_THRESHOLD 5
#define FID_SET_DEBOUNCE_PERIOD 6
#define FID_GET_DEBOUNCE_PERIOD 7
#define FID_SET_SAMPLE_RATE 8
#define FID_GET_SAMPLE_RATE 9
#define FID_CURRENT 10
#define FID_CURRENT_REACHED 11

typedef struct {
	MessageHeader header;
} __attribute__((__packed__)) GetSampleRate;

typedef struct {
	MessageHeader header;
	uint8_t rate;
} __attribute__((__packed__)) GetSampleRateReturn;

typedef struct {
	MessageHeader header;
	uint8_t rate;
} __attribute__((__packed__)) SetSampleRate;

void mcp3422_write_configuration(const uint8_t channel, const uint8_t rate);
int32_t mcp3422_read_current(const int32_t old_current);

void get_sample_rate(const ComType com, const GetSampleRate *data);
void set_sample_rate(const ComType com, const SetSampleRate *data);

void invocation(const ComType com, const uint8_t *data);
void constructor(void);
void destructor(void);
void tick(const uint8_t tick_type);

#endif
