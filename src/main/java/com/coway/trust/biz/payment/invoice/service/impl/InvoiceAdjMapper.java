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
package com.coway.trust.biz.payment.invoice.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("invoiceAdjMapper")
public interface InvoiceAdjMapper {
	/**
	 * InvoiceAdjustment(CN/DN) List 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectInvoiceAdjList(Map<String, Object> params);
	
	/**
	 * New Invoice Master 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectNewAdjMaster(Map<String, Object> params);
	
	/**
	 * New Invoice Detail 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectNewAdjDetailList(Map<String, Object> params);
	
	 /**
	 * Adjustment CN/DN AccID  조회
	 * @param params
	 * @return
	 */
	EgovMap getAdjustmentCnDnAccId(Map<String, Object> params);
	
	 /**
	 * Adjustment ID 채번
	 * @param params
	 * @return
	 */
	int getAdjustmentId();

	 /**
	 * Adjustment request Master 등록
	 * @param params
	 * @return
	 */
	void saveNewAdjMaster(Map<String, Object> params);
	
	 /**
	 * Adjustment request Detail  등록
	 * @param params
	 * @return
	 */
	void saveNewAdjDetail(Map<String, Object> params);
}
