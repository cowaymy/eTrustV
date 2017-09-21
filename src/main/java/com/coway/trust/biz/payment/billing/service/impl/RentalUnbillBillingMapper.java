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
package com.coway.trust.biz.payment.billing.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("rentalUnbillBillingMapper")
public interface RentalUnbillBillingMapper {

	/**
	 * selectCustBillOrderNoList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCustBillOrderList_U(Map<String, Object> params);
	
	/**
	 * selectUnbilledRentalBillingSchedule 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectUnbilledRentalBillingSchedule(Map<String, Object> params);
	
	
	/**
	 * getTaskIdSeq_U 조회
	 * @param params
	 * @return
	 */
	int getTaskIdSeq_U();
	
	/**
	 * insBillTaskLog
	 * @param params
	 * @return
	 */
	void insBillTaskLog_U(Map<String, Object> params);
	
	/**
	 * selectSalesOrderMs 조회
	 * @param params
	 * @return
	 */
	EgovMap selectSalesOrderMs_U(Map<String, Object> params);
	
	/**
	 * insTaskLogOrder
	 * @param params
	 * @return
	 */
	void insTaskLogOrder_U(Map<String, Object> params);
	
	
	/**
	 * confirmTaxesManualBill
	 * @param params
	 * @return
	 */
	void confirmTaxesManualBill(Map<String, Object> params);
}
