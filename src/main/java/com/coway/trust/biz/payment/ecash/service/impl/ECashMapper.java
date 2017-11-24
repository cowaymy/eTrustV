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

@Mapper("eCashMapper")
public interface ECashMapper {


	/**
	 *  E-Cash - List
	 * @param params
	 * @return
	 */
	List<EgovMap> selectECashList(Map<String, Object> params);

	/**
     * E-Cash - Create new claim
     * @param params
     */
	Map<String, Object> createECashDeduction(Map<String, Object> param);

	/**
	 * Auto Debit - Claim Result Deactivate 처리 : 아이템 삭제
	 * @param params
	 * @return
	 */
	void deleteClaimResultItem(Map<String, Object> params);

	/**
	 * Auto Debit - Claim Result Update : 아이템 등록
	 * @param params
	 * @return
	 */
	void insertClaimResultItem(Map<String, Object> params);

	/**
	 * Auto Debit - Claim Result Deactivate 처리 : 마스터 수정
	 * @param params
	 * @return
	 */
	void updateClaimResultStatus(Map<String, Object> params);

	/**
	 * Auto Debit - Claim 조회
	 * @param params
	 * @return
	 */
	EgovMap selectClaimById(Map<String, Object> params);

	/**
	 * Auto Debit - Claim 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectClaimDetailById(Map<String, Object> params);

	/**
	 * Auto Debit - Claim Result Update Live
	 * @param params
	 * @return
	 */
	void updateClaimResultLive(Map<String, Object> params);

	/**
	 * Auto Debit - Claim Result Update NEXT DAY
	 * @param params
	 * @return
	 */
	void updateClaimResultNextDay(Map<String, Object> params);

	/**
	 * Auto Debit - Claim Fail Deduction SMS 상세 리스트 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectFailClaimDetailList(Map<String, Object> params);

	/**
	 * Auto Debit - Fail Deduction SMS 재발송 처리
	 * @param params
	 * @return
	 */
	void sendFaileDeduction(Map<String, Object> params);

}
