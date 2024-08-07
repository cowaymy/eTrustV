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

import com.coway.trust.biz.payment.payment.service.PayDHistoryVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("advBillingBatchMapper")
public interface AdvBillingBatchMapper {
	
	/**
	 * CommitionDeduction 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBillingBatch(Map<String, Object> params);
	
	/**
	 * OrderNo가 SalesMaster정보에 있는지 조회
	 * @param params
	 * @return
	 */
	EgovMap selectSalesOrderMaster(String params);
	
	/**
	 * Master정보 저장
	 * @param params
	 * @return
	 */
	void insertAccAdvanceBillBatchM(Map<String, Object> params);
	
	/**
	 * Sub정보 저장
	 * @param params
	 * @return
	 */
	void insertAccAdvanceBillBatchD(Map<String, Object> params);
	
	/**
	 * Master정보 Update
	 * @param params
	 * @return
	 */
	void updateAccAdvanceBillBatchM(Map<String, Object> params);
	
	/**
	 * 마스터 정보 조회
	 * @param params
	 * @return
	 */
	EgovMap selectBatchMasterInfo(Map<String, Object> params);
	
	/**
	 * 디테일 정보 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectBatchDetailInfo(Map<String, Object> params);
	
	/**
	 * Master정보 Update
	 * @param params
	 * @return
	 */
	void updateAccAdvanceBillBatchM2(Map<String, Object> params);
	
	/**
	 * Detail정보 Update
	 * @param params
	 * @return
	 */
	void updateAccAdvanceBillBatchD2(Map<String, Object> params);
	
	/**
	 * updBillBatchUpload
	 * @param params
	 * @return
	 */
	void updBillBatchUpload(Map<String, Object> params);

}
