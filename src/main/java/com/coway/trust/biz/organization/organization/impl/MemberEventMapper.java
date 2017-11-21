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
package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;


import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("memberEventMapper")
public interface MemberEventMapper {

	List<EgovMap> reqPersonComboList();
	
	List<EgovMap> reqStatusComboList();
	
	List<EgovMap> selectOrganizationEventList(Map<String, Object> params);
	
	EgovMap  getMemberEventDetailPop(Map<String, Object> params);
	
	List<EgovMap> selectPromteDemoteList(Map<String, Object> params);
	
	EgovMap  selectMemberPromoEntries(Map<String, Object> params);
	
	EgovMap  getMemberOrganizations(Map<String, Object> params);
	
	EgovMap  getDocNoes(int code);

	EgovMap getMemberOrganizationsMemId(String memId);
	
	EgovMap getMemberOrganizationsMemUpId(String memUpId);
	
	EgovMap getMemberOrganizationsMemPrId(String memUpId);
	
	EgovMap getMemberSearch(String memUpId);
	
	void updateMemberOrganizations(Map<String, Object> params);
	
	void updateDocNoes(Map<String, Object> params);
	
	void updateMember(Map<String, Object> params);
	
	void updateMemberPromoEntry(Map<String, Object> params);
	
	
	EgovMap selectDeptCode(int promoId);
	
	int selectMemUpId(String lastDeptCode);
	
	void updateMemberBranch(Map<String, Object> params);
	
	EgovMap  getAvailableChild(Map<String, Object> params);
	
}	
