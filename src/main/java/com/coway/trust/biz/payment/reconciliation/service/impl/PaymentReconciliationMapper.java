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
package com.coway.trust.biz.payment.reconciliation.service.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("paymentReconciliationMapper")
public interface PaymentReconciliationMapper {

	
	/**
	 * selectReconciliationMasterList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectReconciliationMasterList(Map<String, Object> params);
	
	/**
	 * selectDepositList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDepositList(Map<String, Object> params);
	
	/**
	 * selectDepositView 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectDepositView(Map<String, Object> params);
	
	/**
	 * updDepositItem
	 * @param params
	 * @return
	 */
	int updDepositItem(Map<String, Object> params);
	
	/**
	 * updReconDepositDs
	 * @param params
	 * @return
	 */
	int updReconDepositDs(Map<String, Object> params);
	
	/**
	 * updReconDepositMs
	 * @param params
	 * @return
	 */
	int updReconDepositMs(Map<String, Object> params);
	
	/**
	 * selectReconciliationMasterListCount
	 * @param params
	 * @return
	 */
	int selectReconciliationMasterListCount(Map<String, Object> params);
}
