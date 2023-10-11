/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("preBookingOrderMapper")
public interface PreBookingOrderMapper {

	/*List<EgovMap> selectPreBookingOrderList(Map<String, Object> params);

	EgovMap selectPreBookingOrderInfo(Map<String, Object> params);

	int selectExistSofNo(Map<String, Object> params);

	void insertPreBookingOrder(PreBookingOrderVO preBookingOrderVO);

	void updatePreBookingOrder(PreBookingOrderVO preBookingOrderVO);

	void updatePreBookingOrderStatus(PreBookingOrderVO preBookingOrderVO);

	void updatePreBookingOrderFailStatus(Map<String, Object> params);

	void InsertPreBookingOrderFailStatus(Map<String, Object> params);

	List<EgovMap> selectPreBookingOrderFailStatus(Map<String, Object> params);

	int selectExistingMember(Map<String, Object> params);

	List<EgovMap> selectAttachList(Map<String, Object> params);

	int selectNextFileId();

	void insertFileDetail(Map<String, Object> flInfo);

	int selRcdTms(Map<String, Object> params);

	int selPreBookingOrdId(Map<String, Object> params);

	void updateKeyinSOF(Map<String, Object> params);

	String selectExistingSalesVoucherCode(PreBookingOrderVO preBookingOrderVO);*/

  EgovMap checkExtradeSchedule();
}
