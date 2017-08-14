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
package com.coway.trust.biz.commission.system.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * sample에 관한 데이터처리 매퍼 클래스
 *
 * @author 표준프레임워크센터
 * @since 2014.01.24
 * @version 1.0
 * @see
 * 
 *      <pre>
 *  == 개정이력(Modification Information) ==
 *
 *          수정일          수정자           수정내용
 *  ----------------    ------------    ---------------------------
 *   2014.01.24        표준프레임워크센터          최초 생성
 *
 *      </pre>
 */
@Mapper("commissionSystemMapper")
public interface CommissionSystemMapper {
	/**
	 * search Organization Gruop List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgGrList(Map<String, Object> params);

	/**
	 * search Organization  List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgList(Map<String, Object> params);

	/**
	 * search selectRuleBookOrgMngList List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleBookOrgMngList(Map<String, Object> params);

	/**
	 * check rulebook data 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleBookMngChk(Map<String, Object> params);

	/**
	 * add coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int addCommissionGrid(Map<String, Object> params);

	/**
	 * update coommission rule book management Data : use_yn
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int udtCommissionGridUseYn(Map<String, Object> params);

	/**
	 * update coommission rule book management Data : end_dt
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int udtCommissionGridEndDt(Map<String, Object> params);

	/**
	 * delete coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int delCommissionGrid(Map<String, Object> params);
	
	/**
	 * search Organization Gruop Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgGrCdListAll(Map<String, Object> params);
	
	/**
	 * search Organization Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgCdListAll(Map<String, Object> params);
	
	/**
	 * search Organization Gruop Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgGrCdList(Map<String, Object> params);
	
	/**
	 * search Organization Code List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgCdList(Map<String, Object> params);
	
	/**
	 * search Organization Item List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgItemList(Map<String, Object> params);
	
	
	/**
	 * search Rule Book Mng List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleBookItemMngList(Map<String, Object> params);
	
	/**
	 * check rulebook Item data 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleBookItemMngChk(Map<String, Object> params);
	
	/**
	 * update coommission rule book Item management Data : end_dt
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int udtCommissionItemGridEndDt(Map<String, Object> params);

	/**
	 * add coommission rule book management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int addCommissionItemGrid(Map<String, Object> params);
	
	/**
	 * add coommission rule book Item management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int udtCommissionItemGridUseYn(Map<String, Object> params);
	
	/**
	 * add coommission rule management Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int addCommissionRuleData(Map<String, Object> params);
	
	/**
	 * check rulebook Item data 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleMngChk(Map<String, Object> params);
	
	/**
	 * update coommission rule book Item management Data : end_dt
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int udtCommissionRuleEndDt(Map<String, Object> params);

	/**
	 * search Rule Book Mng List
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectRuleBookMngList(Map<String, Object> params);
	
	
}
