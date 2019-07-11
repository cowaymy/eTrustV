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
package com.coway.trust.biz.payment.payment.service.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.payment.payment.service.PayDHistoryVO;
import com.coway.trust.biz.payment.payment.service.RentalCollectionByBSSearchVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("commDeductionMapper")
public interface CommDeductionMapper {
	/**
	 * CommitionDeduction 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCommitionDeduction(Map<String, Object> params);


	/**
	 * Master로그에 존재하는 데이터 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectExistLogMList(Map<String, Object> params);

	/**
	 * Master데이터 저장
	 * @param params
	 * @return
	 */
	void insertMaster(Map<String, Object> params);

	/**
	 * Detail데이터 저장
	 * @param params
	 * @return
	 */
	void insertDetail(Map<String, Object> params);

	/**
	 * fileRefNo에 해당하는 Master View 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMasterView(EgovMap params);

	/**
	 * logDetail 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectLogDetail(Map<String, Object> params);

	/**
	 * paymentResult에 대한 Detail
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDetailForPaymentResult(Map<String, Object> params);

	/**
	 * createPaymentProcedure
	 * @param params
	 * @return
	 */
	void createPaymentProcedure(EgovMap params);

	void deactivateCommissionDeductionStatus(Map<String, Object> param);

}
