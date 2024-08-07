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
package com.coway.trust.biz.payment.ecash.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("eCashDeductionMapper")
public interface ECashDeductionMapper {


	/**
	 *  E-Cash - List
	 * @param params
	 * @return
	 */
	List<EgovMap> selectECashDeductList(Map<String, Object> params);

	/**
	 *  E-Cash - List
	 * @param params
	 * @return
	 */
	EgovMap selectECashDeductById(Map<String, Object> params);

	/**
     * E-Cash - Create new claim
     * @param params
     */
	Map<String, Object> createECashDeduction(Map<String, Object> param);

	/**
	 * E-Cash - Deactivate eAutoDebitDeduction
	 * @param params
	 * @return
	 */
	void deactivateEAutoDebitDeduction(Map<String, Object> params);

	/**
	 * E-Cash - Deactivate eAutoDebitDeduction_Sub
	 * @param params
	 * @return
	 */
	void deactivateEAutoDebitDeductionSub(Map<String, Object> params);

	/**
	 * E-Cash - Delete eCash Result Item
	 * @param params
	 * @return
	 */
	void deleteECashDeductionResultItem(Map<String, Object> params);

	/**
	 * EE-Cash - Update eCash Result Item
	 * @param params
	 * @return
	 */
	void insertECashDeductionResultItem(Map<String, Object> params);

	/**
	 *  E-Cash - Update eCash Result
	 * @param params
	 * @return
	 */
	void updateECashDeductionResult(Map<String, Object> params);

	/**
	 *  E-Cash_Sub - List
	 * @param params
	 * @return
	 */
	List<EgovMap> selectECashDeductSubList(Map<String, Object> params);

	/**
	 *  E-Cash_Sub - List
	 * @param params
	 * @return
	 */
	List<EgovMap> selectECashDeductSubById(Map<String, Object> params);

	/**
	 *  E-Cash_Sub - List
	 * @param params
	 * @return
	 */
	int selectECashDeductSubByIdCnt(Map<String, Object> params);

	int selectECashDeductBatchGen(Map<String, Object> params);

	int selectECashDeductCCSubByIdCnt(Map<String, Object> params);

	Map<String, Object> createECashGrpDeduction(Map<String, Object> param);

	void updateECashGrpDeductionResult(Map<String, Object> params);

	void insertECashDeductionResultItemBulk(Map<String, Object> params);

	EgovMap selectECashBankResult(Map<String, Object> params);

	EgovMap selectMstConf(Map<String, Object> params);
	List<EgovMap> selectSubConf(Map<String, Object> params);
}
