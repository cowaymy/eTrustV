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
package com.coway.trust.biz.common.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.payment.reconciliation.service.CRCStatementVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("commonMapper")
public interface CommonMapper {
	List<EgovMap> selectCodeList(Map<String, Object> params);

	List<EgovMap> selectI18NList();
	
	/****** ACCOUNT CODE *********/
    List<EgovMap> getAccountCodeList(Map<String, Object> params);
    
    int insertAccountCode(Map<String, Object> params);
	
    /***********************************/
        
    /*general Code*/
	List<EgovMap> getMstCommonCodeList(Map<String, Object> params);
	
	List<EgovMap> getDetailCommonCodeList(Map<String, Object> params);
	
    int addCommCodeGrid(Map<String, Object> addList );
    
    int updCommCodeGrid(Map<String, Object> updateList);
    
    int addDetailCommCodeGrid(Map<String, Object> addList );
    
    int updDetailCommCodeGrid(Map<String, Object> updateList);
    

    List<EgovMap> selectBranchList(Map<String, Object> params);
    

    /**
	 * Account 정보 조회 (크레딧 카드 리스트 / 은행 계좌 리스트)
	 * @param params
	 * @return
	 */
	List<EgovMap> getAccountList(Map<String, Object> params);
	
	/**
	* Branch ID로 User 정보 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> getUsersByBranch(Map<String, Object> params);
    
	
	List<EgovMap> selectAddrSelCode(Map<String, Object> params);

	List<EgovMap> selectProductCodeList();

}
