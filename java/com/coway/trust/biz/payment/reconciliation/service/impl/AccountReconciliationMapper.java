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

@Mapper("accountReconciliationMapper")
public interface AccountReconciliationMapper {

	
	/**
	 * selectJournalMasterList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectJournalMasterList(Map<String, Object> params);
	
	/**
	 * selectJournalMasterView 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectJournalMasterView(Map<String, Object> params);
	
	/**
	 * selectJournalDetailList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectJournalDetailList(Map<String, Object> params);
	
	/**
	 * selectGrossTotal 조회
	 * @param params
	 * @return
	 */
	String selectGrossTotal(Map<String, Object> params);
	
	
	/**
	 * selectCRCStatementGrossTotal 조회
	 * @param params
	 * @return
	 */
	String selectCRCStatementGrossTotal(Map<String, Object> params);
	
	/**
	 * insAccGLRoutes
	 * @param params
	 * @return
	 */
	int insAccGLRoutes(Map<String, Object> params);
	
	/**
	 * updJournalTrans
	 * @param params
	 * @return
	 */
	int updJournalTrans(Map<String, Object> params);
	
	/**
	 * selectReconJournalTransactions 조회
	 * @param params
	 * @return
	 */
	EgovMap selectReconJournalTransactions(Map<String, Object> params);
	
	/**
	 * selectOrderIDByOrderNo
	 * @param params
	 * @return
	 */
	String selectOrderIDByOrderNo(Map<String, Object> params);
	
	/**
	 * selectOutStandingView
	 * @param params
	 * @return
	 */
	Map<String, Object> selectOutStandingView(Map<String, Object> param);
	
	/**
	 * selectASInfoList 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectASInfoList(Map<String, Object> params);
}
