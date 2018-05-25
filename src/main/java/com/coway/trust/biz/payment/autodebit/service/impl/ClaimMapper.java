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
package com.coway.trust.biz.payment.autodebit.service.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("claimMapper")
public interface ClaimMapper {


	/**
	 * Auto Debit - Claim List 리스트 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectClaimList(Map<String, Object> params);

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
	 * Auto Debit - Claim Result Update : 아이템 등록
	 * @param params
	 * @return
	 */
	void insertClaimResultItemBulk(Map<String, Object> params);

	/**
	 * Auto Debit - Claim Result Update : 아이템 등록
	 * @param params
	 * @return
	 */
	void updateClaimResultItemArrange(Map<String, Object> params);

	/**
	 * Auto Debit - Claim Result Update : 아이템 등록
	 * @param params
	 * @return
	 */
	void removeItmId(Map<String, Object> params);

	/**
	 * Auto Debit - Claim Result Update : 결과 조회
	 * @param params
	 * @return
	 */
	EgovMap selectUploadResultBank(Map<String, Object> params);

	/**
	 * Auto Debit - Claim Result Update : 결과 조회
	 * @param params
	 * @return
	 */
	EgovMap selectUploadResultCRC(Map<String, Object> params);



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
	 * Auto Debit - Claim 조회
	 * @param params
	 * @return
	 */
	List<EgovMap> selectClaimDetailByIdPaging(Map<String, Object> params);

	/**
     * Auto Debit - Claim 생성 프로시저 호출
     * @param params
     */
	Map<String, Object> createClaim(Map<String, Object> param);

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

	/**
	 * Claim List - Schedule Claim Batch Pop-up 리스트 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap> selectScheduleClaimBatchPop(Map<String, Object> params);

	/**
	 * Claim List - Schedule Claim Batch Setting Pop-up 리스트 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap> selectScheduleClaimSettingPop(Map<String, Object> params);

	/**
	 * Claim List - Schedule Claim Batch Setting Pop-up 리스트 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	int isScheduleClaimSettingPop(Map<String, Object> params);

	/**
	 * Claim List - Schedule Claim Batch Setting Pop-up 저장
	 * @param params
	 * @param model
	 * @return
	 */
	void saveScheduleClaimSettingPop(Map<String, Object> params);

	/**
	 * Claim List - Schedule Claim Batch Setting Pop-up 삭제
	 * @param params
	 * @param model
	 * @return
	 */
	void removeScheduleClaimSettingPop(Map<String, Object> params);

	 /**
	 * Claim List - Regenerate CRC File 전체 카운트 조회
	 * @param params
	 * @return
	 */
	int selectClaimDetailByIdCnt(Map<String, Object> params);

	int selectClaimDetailBatchGen(Map<String, Object> params);

	/**
	 * Auto Debit - Claim Result Deactivate 처리 : 아이템 삭제
	 * @param params
	 * @return
	 */
	void deleteClaimFileDownloadInfo(Map<String, Object> params);

	/**
	 * Auto Debit - Claim Result Deactivate 처리 : 아이템 삭제
	 * @param params
	 * @return
	 */
	void insertClaimFileDownloadInfo(Map<String, Object> params);

	/**
	 * Claim List - Schedule Claim Batch Setting Pop-up 리스트 조회
	 * @param
	 * @param params
	 * @param model
	 * @return
	 */
	List<EgovMap> selectClaimFileDown(Map<String, Object> params);

}
