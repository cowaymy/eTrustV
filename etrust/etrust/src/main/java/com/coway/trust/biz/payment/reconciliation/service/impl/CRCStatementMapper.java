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

import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;
import com.coway.trust.biz.sample.SampleDefaultVO;
import com.coway.trust.biz.sample.SampleVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("crcStatementMapper")
public interface CRCStatementMapper {

	
	/**
	 * CRC Statement Transaction 리스트 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectCRCStatementTranList(Map<String, Object> params);
	
	/**
     * CRC Statement Transaction 정보 수정
     * @param params
     */	
	void updateCRCStatementTranList(Map<String, Object> params);
	
	/**
	 * CRCStatementRunningNo 가져오기
	 * @return
	 */
	String getCRCStatementRunningNo();
	
	/**
	 * CRCStatement Sequence 가져오기
	 * @return
	 */
	Integer getCRCStatementSEQ();
	
	/**
     * CRC Statement 정보 등록
     * @param params
     */	
	void insertCRCStatement(Map<String, Object> params);
	
	/**
     * CRC Transaction 정보 등록
     * @param params
     */	
	void insertCRCTransaction(Map<String, Object> params);
	
	/**
	 * CRC Statement Transaction 리스트 조회
	 * @param params
	 * @return
	 */
	Map<String, Object> testCallStoredProcedure(Map<String, Object> param);

}
