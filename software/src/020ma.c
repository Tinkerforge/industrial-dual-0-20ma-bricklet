/* industrial-dual-0-20ma-bricklet
 * Copyright (C) 2013 Olaf Lüke <olaf@tinkerforge.com>
 *
 * 020ma.c: Implementation of Industrial Dual 0-20mA Bricklet messages
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

#include "020ma.h"

#include "brickletlib/bricklet_entry.h"
#include "brickletlib/bricklet_simple.h"
#include "bricklib/bricklet/bricklet_communication.h"
#include "config.h"

#define I2C_EEPROM_ADDRESS_HIGH 84


#define I2C_ADDRESS_FLOAT 105 // 0b1101001
#define I2C_ADDRESS_HIGH 106  // 0b1101010
#define I2C_ADDRESS_LOW 104   // 0b1101000

#define SIMPLE_UNIT_CURRENT 0

const SimpleMessageProperty smp[] = {
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_VALUE, SIMPLE_DIRECTION_GET}, // TYPE_GET_CURRENT
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_PERIOD, SIMPLE_DIRECTION_SET}, // TYPE_SET_CURRENT_CALLBACK_PERIOD
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_PERIOD, SIMPLE_DIRECTION_GET}, // TYPE_GET_CURRENT_CALLBACK_PERIOD
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_SET}, // TYPE_SET_CURRENT_CALLBACK_THRESHOLD
	{SIMPLE_UNIT_CURRENT, SIMPLE_TRANSFER_THRESHOLD, SIMPLE_DIRECTION_GET}, // TYPE_GET_CURRENT_CALLBACK_THRESHOLD
	{0, SIMPLE_TRANSFER_DEBOUNCE, SIMPLE_DIRECTION_SET}, // TYPE_SET_DEBOUNCE_PERIOD
	{0, SIMPLE_TRANSFER_DEBOUNCE, SIMPLE_DIRECTION_GET}, // TYPE_GET_DEBOUNCE_PERIOD
};

const SimpleUnitProperty sup[] = {
	{mcp3422_read_current, SIMPLE_SIGNEDNESS_INT, FID_CURRENT, FID_CURRENT_REACHED, SIMPLE_UNIT_CURRENT} // current
};

const uint8_t smp_length = sizeof(smp);

void invocation(const ComType com, const uint8_t *data) {
	const SimpleGetValue *sgv = (SimpleGetValue*)data;
	switch(sgv->header.fid) {
		case FID_GET_CURRENT:
		case FID_SET_CURRENT_CALLBACK_PERIOD:
		case FID_GET_CURRENT_CALLBACK_PERIOD:
		case FID_SET_CURRENT_CALLBACK_THRESHOLD:
		case FID_GET_CURRENT_CALLBACK_THRESHOLD:
			if(sgv->sensor > 1) {
				BA->com_return_error(data, sizeof(MessageHeader), MESSAGE_ERROR_CODE_INVALID_PARAMETER, com);
				return;
			}

		case FID_SET_DEBOUNCE_PERIOD:
		case FID_GET_DEBOUNCE_PERIOD: {
			simple_invocation(com, data);
			break;
		}

		case FID_SET_SAMPLE_RATE: {
			set_sample_rate(com, (SetSampleRate*)data);
			break;
		}

		case FID_GET_SAMPLE_RATE: {
			get_sample_rate(com, (GetSampleRate*)data);
			break;
		}

		default: {
			BA->com_return_error(data, sizeof(MessageHeader), MESSAGE_ERROR_CODE_NOT_SUPPORTED, com);
			break;
		}
	}
}

void constructor(void) {
	simple_constructor();
	mcp3422_write_configuration(0, SAMPLE_RATE_4_SPS);

	BC->sample_wait = BC->next_sample_wait;
}

void destructor(void) {
	simple_destructor();
}

void tick(const uint8_t tick_type) {
	simple_tick(tick_type);
	BC->tick++;
}

void select(void) {
	const uint8_t port = BS->port - 'a';
	BA->bricklet_select(port);
}

void deselect(void) {
	const uint8_t port = BS->port - 'a';
	BA->bricklet_deselect(port);
}

void mcp3422_write_configuration(const uint8_t channel, const uint8_t rate) {
	uint8_t value = CONFIG_CONVERSION_SINGLE_SHOT | CONFIG_GAIN_X1 | CONFIG_READY;

	switch(channel) {
		case 0: value |= CONFIG_CHANNEL_SELECTION_0; break;
		case 1: value |= CONFIG_CHANNEL_SELECTION_1; break;
	}

	switch(rate) {
		case 0: value |= CONFIG_CONVERSION_SAMPLE_RATE_240_SPS; BC->next_sample_wait = 1000/240; break;
		case 1: value |= CONFIG_CONVERSION_SAMPLE_RATE_60_SPS; BC->next_sample_wait = 1000/60; break;
		case 2: value |= CONFIG_CONVERSION_SAMPLE_RATE_15_SPS; BC->next_sample_wait = 1000/15; break;
		case 3: value |= CONFIG_CONVERSION_SAMPLE_RATE_4_SPS; BC->next_sample_wait = 1000/4; break;
	}

   	if(BA->mutex_take(*BA->mutex_twi_bricklet, 0)) {
		BA->TWID_Write(BA->twid,
					  I2C_ADDRESS_FLOAT,
					  0,
					  0,
					  &value,
					  1,
					  NULL);
		BA->mutex_give(*BA->mutex_twi_bricklet);

		BC->current_channel = channel;
		BC->current_rate = rate;
		BC->next_rate = rate;
   	}
}

int32_t mcp3422_read_current(const int32_t old_current) {
	if(BC->sample_wait > 0) {
		BC->sample_wait--;
		return BC->value[BC->current_channel];
	}

	uint8_t value[4];
	uint8_t num_values = 3;
	if(BC->current_rate == SAMPLE_RATE_4_SPS) {
		num_values = 4;
	}

	const uint8_t port = BS->port - 'a';
	BA->bricklet_select(port);
   	if(BA->mutex_take(*BA->mutex_twi_bricklet, 0)) {
		BA->TWID_Read(BA->twid,
					  I2C_ADDRESS_FLOAT,
					  0,
					  0,
					  (uint8_t *)&value,
					  num_values,
					  NULL);
		BA->mutex_give(*BA->mutex_twi_bricklet);
   	}
	BA->bricklet_deselect(port);

	if(value[num_values-1] & CONFIG_READY) {
		return BC->value[BC->current_channel];
	}

	int32_t ret_na = 0;
	switch(BC->current_rate) { // LSB: 1mV, 12 bit
		case SAMPLE_RATE_240_SPS: {
			const int32_t measurement = value[1] | ((value[0] & 0x0F) << 8);
			ret_na = measurement*1000000/91;
			break;
		}

		case SAMPLE_RATE_60_SPS: { // LSB: 250µV, 14 bit
			const int32_t measurement = value[1] | ((value[0] & 0x3F) << 8);
			ret_na = measurement*250000/91;
			break;
		}

		case SAMPLE_RATE_15_SPS: { // LSB: 62.5µV, 16 bit
			const int32_t measurement = value[1] | (value[0] << 8);
			ret_na = measurement*62500/91;
			break;
		}

		case SAMPLE_RATE_4_SPS: { // LSB: 15.625µV, 18 bit
			const int32_t measurement = value[2] | (value[1] << 8) | ((value[0] & 0x03) << 16);
			ret_na = measurement*15625/91;
			break;
		}
	}

	BC->value[BC->current_channel] = ret_na;
	mcp3422_write_configuration(1 - BC->current_channel, BC->next_rate);

	BC->sample_wait = BC->next_sample_wait;

    return ret_na;
}

void get_sample_rate(const ComType com, const GetSampleRate *data) {
	GetSampleRateReturn gsrr;

	gsrr.header         = data->header;
	gsrr.header.length  = sizeof(GetSampleRateReturn);
	gsrr.rate           = BC->current_rate;

	BA->send_blocking_with_timeout(&gsrr, sizeof(GetSampleRateReturn), com);
}

void set_sample_rate(const ComType com, const SetSampleRate *data) {
	if(data->rate > SAMPLE_RATE_4_SPS) {
		BA->com_return_error(data, sizeof(MessageHeader), MESSAGE_ERROR_CODE_INVALID_PARAMETER, com);
		return;
	}

	BC->next_rate = data->rate;
	BA->com_return_setter(com, data);
}
