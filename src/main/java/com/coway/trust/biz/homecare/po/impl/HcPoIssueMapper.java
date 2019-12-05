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
package com.coway.trust.biz.homecare.po.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("hcPoIssueMapper")
public interface HcPoIssueMapper {

	// CDC 목록조회
	public List<EgovMap> selectCdcList() throws Exception;

	// main 조회
	public int selectHcPoIssueMainListCnt(Map<String, Object> obj) throws Exception;
	public List<EgovMap> selectHcPoIssueMainList(Map<String, Object> obj) throws Exception;

	// sub 조회
	public List<EgovMap> selectHcPoIssueSubList(Map<String, Object> obj) throws Exception;

	// main insert
	public void insertHcPoIssueMain(Map<String, Object> obj) throws Exception;
	// main update
	public void updateHcPoIssueMain(Map<String, Object> obj) throws Exception;

	// sub insert
	public void insertHcPoIssueSub(Map<String, Object> obj) throws Exception;
	// sub update
	public void updateHcPoIssueSub(Map<String, Object> obj) throws Exception;
	// sub delete
	public void deleteHcPoIssueSub(Map<String, Object> obj) throws Exception;

	// issue
	public void updateIssueHcPoIssue(Map<String, Object> obj) throws Exception;

	// approval / denial
	public void updateApprovalHcPoIssue(Map<String, Object> obj) throws Exception;

	// main-sub delete
	public void deleteHcPoIssuePoSub(Map<String, Object> obj) throws Exception;
	public void deleteHcPoIssuePoMain(Map<String, Object> obj) throws Exception;

	public void updateHCPoDetailKeySort(Map<String, String> obj) throws Exception;

}
