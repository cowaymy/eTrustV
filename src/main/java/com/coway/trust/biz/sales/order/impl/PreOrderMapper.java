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

import com.coway.trust.biz.sales.order.vo.PreOrderVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("preOrderMapper")
public interface PreOrderMapper {

	List<EgovMap> selectPreOrderList(Map<String, Object> params);

	EgovMap selectPreOrderInfo(Map<String, Object> params);

	int selectExistSofNo(Map<String, Object> params);

	void insertPreOrder(PreOrderVO preOrderVO);

	void updatePreOrder(PreOrderVO preOrderVO);

	void updatePreOrderStatus(PreOrderVO preOrderVO);

	void updatePreOrderFailStatus(Map<String, Object> params);

	void InsertPreOrderFailStatus(Map<String, Object> params);

	List<EgovMap> selectPreOrderFailStatus(Map<String, Object> params);

	int selectExistingMember(Map<String, Object> params);

	List<EgovMap> selectAttachList(Map<String, Object> params);

	int selectNextFileId();

	void insertFileDetail(Map<String, Object> flInfo);

	int selRcdTms(Map<String, Object> params);

	void updRcdTms(Map<String, Object> params);

	int selPreOrdId(Map<String, Object> params);

	void updateKeyinSOF(Map<String, Object> params);

	EgovMap checkExtradeSchedule();

	int chkExtradeScheduleEpapan();

	String selectExistingSalesVoucherCode(PreOrderVO preOrderVO);

	void updatePwp(Map<String, Object> params);

	void updateRebate(Map<String, Object> params);
}
