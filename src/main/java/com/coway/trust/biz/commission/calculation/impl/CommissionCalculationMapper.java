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
package com.coway.trust.biz.commission.calculation.impl;

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
@Mapper("commissionCalculationMapper")
public interface CommissionCalculationMapper {

	/**
	 * search Commission Procedure Group List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectCommPrdGroupListl(Map<String, Object> params);

	/**
	 * search Organization Code List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgCdListAll(Map<String, Object> params);

	/**
	 * search Organization Item List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectCalculationList(Map<String, Object> params);

	/**
	 * search Basic Calculation List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectBasicList(Map<String, Object> params);

	/**
	 * search Basic Calculation Sate Select
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	Map<String, Object> selectBasicStatus(Map<String, Object> params);


	/**
	 * Commssion Procedure Call
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	Map<String, Object> callCommProcedure(Map<String, Object> param);

	/**
	 * Commssion Procedure Call Running Log
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int callCommPrdLogIns(Map<String, Object> param);

	/**
	 * Procedure Last Log Extraction Select
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectCommRunningPrdLog(Map<String, Object> param);

	/**
	 * Commssion Procedure Log Update
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int callCommLogUpdate(Map<String, Object> param);

	/**
	 * Commssion Procedure Log Insert(success/fail)
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int callCommPrdLog(Map<String, Object>  param);


	/**
	 * Commssion Procedure Log Select
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectLogList(Map<String, Object> params);

	/**
	 * search Organization Gruop List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectOrgGrList(Map<String, Object> params);

	/**
	 * calculation Data select(CMM0028D CD, CT, HP, HT)
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectCMM0028DCT(Map<String, Object> params);
	List<EgovMap> selectCMM0028DCD(Map<String, Object> params);
	List<EgovMap> selectCMM0028DHP(Map<String, Object> params);
	List<EgovMap> selectCMM0028DHT(Map<String, Object> params);

	/**
	 * CMM0029D CD, CT, HP, HT Data select
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectCMM0029DCT(Map<String, Object> params);
	List<EgovMap> selectCMM0029DCD(Map<String, Object> params);
	List<EgovMap> selectCMM0029DHP(Map<String, Object> params);
	List<EgovMap> selectCMM0029DHT(Map<String, Object> params);

	/**
	 * Basic Data select
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	List<EgovMap> selectCMM0006T(Map<String, Object> params);
	List<EgovMap> selectCMM0007T(Map<String, Object> params);
	List<EgovMap> selectCMM0008T(Map<String, Object> params);
	List<EgovMap> selectCMM0009T(Map<String, Object> params);
	List<EgovMap> selectCMM0010T(Map<String, Object> params);
	List<EgovMap> selectCMM0011T(Map<String, Object> params);
	List<EgovMap> selectCMM0012T(Map<String, Object> params);
	List<EgovMap> selectCMM0013T(Map<String, Object> params);
	List<EgovMap> selectCMM0014T(Map<String, Object> params);
	List<EgovMap> selectCMM0015T(Map<String, Object> params);
	List<EgovMap> selectCMM0016T(Map<String, Object> params);
	List<EgovMap> selectCMM0017T(Map<String, Object> params);
	List<EgovMap> selectCMM0018T(Map<String, Object> params);
	List<EgovMap> selectCMM0019T(Map<String, Object> params);
	List<EgovMap> selectCMM0020T(Map<String, Object> params);
	List<EgovMap> selectCMM0021T(Map<String, Object> params);
	List<EgovMap> selectCMM0022T(Map<String, Object> params);
	List<EgovMap> selectCMM0023T(Map<String, Object> params);
	List<EgovMap> selectCMM0024T(Map<String, Object> params);
	List<EgovMap> selectCMM0025T(Map<String, Object> params);
	List<EgovMap> selectCMM0026T(Map<String, Object> params);
	List<EgovMap> selectCMM0060T(Map<String, Object> params);
	List<EgovMap> selectCMM0067T(Map<String, Object> params);
	List<EgovMap> selectCMM0068T(Map<String, Object> params);
	List<EgovMap> selectCMM0069T(Map<String, Object> params);
	List<EgovMap> selectCMM0070T(Map<String, Object> params);
	List<EgovMap> selectCMM0071T(Map<String, Object> params);

	/**
	 * search Basic Data Count
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int cntCMM0028D(Map<String, Object>  param);
	int cntCMM0029D(Map<String, Object>  param);
	int cntCMM0006T(Map<String, Object>  param);
	int cntCMM0007T(Map<String, Object>  param);
	int cntCMM0008T(Map<String, Object>  param);
	int cntCMM0009T(Map<String, Object>  param);
	int cntCMM0010T(Map<String, Object>  param);
	int cntCMM0011T(Map<String, Object>  param);
	int cntCMM0012T(Map<String, Object>  param);
	int cntCMM0013T(Map<String, Object>  param);
	int cntCMM0014T(Map<String, Object>  param);
	int cntCMM0015T(Map<String, Object>  param);
	int cntCMM0016T(Map<String, Object>  param);
	int cntCMM0017T(Map<String, Object>  param);
	int cntCMM0018T(Map<String, Object>  param);
	int cntCMM0019T(Map<String, Object>  param);
	int cntCMM0020T(Map<String, Object>  param);
	int cntCMM0021T(Map<String, Object>  param);
	int cntCMM0022T(Map<String, Object>  param);
	int cntCMM0023T(Map<String, Object>  param);
	int cntCMM0024T(Map<String, Object>  param);
	int cntCMM0025T(Map<String, Object>  param);
	int cntCMM0026T(Map<String, Object>  param);
	int cntCMM0060T(Map<String, Object>  param);
	int cntCMM0067T(Map<String, Object>  param);
	int cntCMM0068T(Map<String, Object>  param);
	int cntCMM0069T(Map<String, Object>  param);
	int cntCMM0070T(Map<String, Object>  param);
	int cntCMM0071T(Map<String, Object>  param);

	/**
	 * basic Data  Exclude Update
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	void udtDataCMM0006T(Map<String, Object>  param);
	void udtDataCMM0007T(Map<String, Object>  param);
	void udtDataCMM0008T(Map<String, Object>  param);
	void udtDataCMM0009T(Map<String, Object>  param);
	void udtDataCMM0010T(Map<String, Object>  param);
	void udtDataCMM0011T(Map<String, Object>  param);
	void udtDataCMM0012T(Map<String, Object>  param);
	void udtDataCMM0013T(Map<String, Object>  param);
	void udtDataCMM0014T(Map<String, Object>  param);
	void udtDataCMM0015T(Map<String, Object>  param);
	void udtDataCMM0017T(Map<String, Object>  param);
	void udtDataCMM0018T(Map<String, Object>  param);
	void udtDataCMM0019T(Map<String, Object>  param);
	void udtDataCMM0020T(Map<String, Object>  param);
	void udtDataCMM0021T(Map<String, Object>  param);
	void udtDataCMM0022T(Map<String, Object>  param);
	void udtDataCMM0023T(Map<String, Object>  param);
	void udtDataCMM0026T(Map<String, Object>  param);
	void udtDataCMM0060T(Map<String, Object>  param);
	void udtDataCMM0067T(Map<String, Object>  param);
	void udtDataCMM0068T(Map<String, Object>  param);
	void udtDataCMM0069T(Map<String, Object>  param);
	void udtDataCMM0070T(Map<String, Object>  param);
	void udtDataCMM0071T(Map<String, Object>  param);

	/**
     * Adjustment Code List
     */
	List<EgovMap> adjustmentCodeList(Map<String, Object> params);

	/**
     * member info Search
     */
	Map<String, Object> memberInfoSearch(Map<String, Object> params);

	/**
     * order Number info Search
     */
	Map<String, Object> ordNoInfoSearch(Map<String, Object> params);

	/**
     * Adjustment Insert
     */
	void adjustmentInsert(Map<String, Object> params);

	/**
     * HP NeoPro Delete
     */
	void neoProDel(Map<String, Object> params);

	/**
     * HP NeoPro Insert
     */
	void neoProInsert(Map<String, Object> params);
	/**
     * CT Data Delete
     */
	void ctUploadDel(Map<String, Object> params);

	/**
     * CT Upload Insert
     */
	void ctUploadInsert(Map<String, Object> params);

	List<EgovMap> incentiveStatus(Map<String, Object> params);
	List<EgovMap> incentiveType(Map<String, Object> params);
	List<EgovMap> incentiveTargetList(Map<String, Object> params);
	List<EgovMap> incentiveSample(Map<String, Object> params);
	int cntUploadBatch(Map<String, Object>  param);
	void insertIncentiveMaster(Map<String, Object> params);
	String selectUploadId(Map<String, Object> params);
	void insertIncentiveDetail(Map<String, Object> params);
	void callIncentiveDetail(int uploadId);
	Map<String, Object> incentiveMasterDetail(int uploadId);
	int incentiveItemCnt(Map<String, Object> params);
	List<EgovMap> incentiveItemList(Map<String, Object> params);
	void removeIncentiveItem(Map<String, Object> params);
	Map<String, Object> incentiveItemAddMem(Map<String, Object> params);
	int cntIncentiveMem(Map<String, Object> params);
	int cntUploadMemberCheck(Map<String, Object> params);
	Map<String, Object> incentiveUploadMember(Map<String, Object> params);
	void incentiveItemInsert(Map<String, Object> params);
	void incentiveItemUpdate(Map<String, Object> params);
	int deactivateCheck(String uploadId);
	void incentiveDeactivate(Map<String, Object> params);
	void callIncentiveConfirm(Map<String, Object> params);

	int cntCMM0028T(Map<String, Object>  param);
	int cntCMM0029T(Map<String, Object>  param);

	List<EgovMap> selectCMM0028TCT(Map<String, Object> params);
	List<EgovMap> selectCMM0028TCD(Map<String, Object> params);
	List<EgovMap> selectCMM0028THP(Map<String, Object> params);
	List<EgovMap> selectCMM0029TCT(Map<String, Object> params);
	List<EgovMap> selectCMM0029TCD(Map<String, Object> params);
	List<EgovMap> selectCMM0029THP(Map<String, Object> params);

	List<EgovMap> selectSimulCMM0018T(Map<String, Object> params);
	List<EgovMap> selectSimulCMM0019T(Map<String, Object> params);
	List<EgovMap> selectSimulCMM0020T(Map<String, Object> params);
	List<EgovMap> selectSimulCMM0021T(Map<String, Object> params);
	List<EgovMap> selectSimulCMM0024T(Map<String, Object> params);

	int cntSimulCMM0018T(Map<String, Object>  param);
	int cntSimulCMM0019T(Map<String, Object>  param);
	int cntSimulCMM0020T(Map<String, Object>  param);
	int cntSimulCMM0021T(Map<String, Object>  param);
	int cntSimulCMM0024T(Map<String, Object>  param);

	List<EgovMap> runningPrdCheck(Map<String, Object> params);
	List<EgovMap> runPrdTimeValid(Map<String, Object> params);

	void prdBatchSuccessHistory(Map<String, Object> params);

	int mboMasterUploadId();
	List<EgovMap> mboTargetList(Map<String, Object> params);
	int mboActiveUploadBatch(Map<String, Object>  param);
	void insertMboMaster(Map<String, Object> params);
	void insertMboDetail(Map<String, Object> params);
	void callMboDetail(int uploadId);
	Map<String, Object> mboMasterDetail(int uploadId);
	int mboItemCnt(Map<String, Object> params);
	List<EgovMap> mboItemList(Map<String, Object> params);
	void mboDeactivate(Map<String, Object> params);
	void callMboConfirm(Map<String, Object> params);
	void removeMboItem(Map<String, Object> params);
	int cntMboMem(Map<String, Object> params);
	void mboItemInsert(Map<String, Object> params);
	void mboItemUpdate(Map<String, Object> params);
	int deactivateMboCheck(String uploadId);

	int cffMasterUploadId();
	List<EgovMap> cffList(Map<String, Object> params);
	int cffActiveUploadBatch(Map<String, Object>  param);
	void insertCffMaster(Map<String, Object> params);
	void insertCffDetail(Map<String, Object> params);
	void callCffDetail(int uploadId);
	Map<String, Object> cffMasterDetail(int uploadId);
	int cffItemCnt(Map<String, Object> params);
	List<EgovMap> cffItemList(Map<String, Object> params);
	void cffDeactivate(Map<String, Object> params);
	void callCffConfirm(Map<String, Object> params);
	void removeCffItem(Map<String, Object> params);
	int cntCffMem(Map<String, Object> params);
	void cffItemInsert(Map<String, Object> params);
	void cffItemUpdate(Map<String, Object> params);
	int deactivateCffCheck(String uploadId);

	List<EgovMap> nonIncentiveType(Map<String, Object> params);
	List<EgovMap> nonIncentiveSample(Map<String, Object> params);
	void insertNonIncentiveMaster(Map<String, Object> params);
	String selectNonIncentiveUploadId(Map<String, Object> params);
	void insertNonIncentiveDetail(Map<String, Object> params);
	void callNonIncentiveDetail(int uploadId);
	List<EgovMap> nonIncentiveTargetList(Map<String, Object> params);
	Map<String, Object> nonIncentiveMasterDetail(int uploadId);
	int nonIncentiveItemCnt(Map<String, Object> params);
	List<EgovMap> nonIncentiveItemList(Map<String, Object> params);
	Map<String, Object> nonIncentiveItemAddMem(Map<String, Object> params);
	int cntNonIncentiveMem(Map<String, Object> params);
	int cntUploadNonIncentiveMemberCheck(Map<String, Object> params);
	Map<String, Object> nonIncentiveUploadMember(Map<String, Object> params);
	void nonIncentiveItemUpdate(Map<String, Object> params);
	void nonIncentiveItemInsert(Map<String, Object> params);
	void removeNonIncentiveItem(Map<String, Object> params);
	int nonIncentiveDeactivateCheck(String uploadId);
	void nonIncentiveDeactivate(Map<String, Object> params);
	void callNonIncentiveConfirm(Map<String, Object> params);
	int cntNonIncentiveUploadBatch(Map<String, Object>  param);
	int selectUploadTypeId(Map<String, Object> params);

	List<EgovMap> advIncentiveType(Map<String, Object> params);
	List<EgovMap> advIncentiveSample(Map<String, Object> params);
	void insertAdvIncentiveMaster(Map<String, Object> params);
	String selectAdvIncentiveUploadId(Map<String, Object> params);
	void insertAdvIncentiveDetail(Map<String, Object> params);
	void callAdvIncentiveDetail(int uploadId);
	int cntAdvIncentiveUploadBatch(Map<String, Object>  param);
	Map<String, Object> advIncentiveMasterDetail(int uploadId);
	int advIncentiveItemCnt(Map<String, Object> params);
	List<EgovMap> advIncentiveItemList(Map<String, Object> params);
	int cntUploadAdvIncentiveMemberCheck(Map<String, Object> params);
	Map<String, Object> advIncentiveUploadMember(Map<String, Object> params);
	void advIncentiveItemUpdate(Map<String, Object> params);
	void advIncentiveItemInsert(Map<String, Object> params);
	void removeAdvIncentiveItem(Map<String, Object> params);
	int advIncentiveDeactivateCheck(String uploadId);
	void advIncentiveDeactivate(Map<String, Object> params);
	void callAdvIncentiveConfirm(Map<String, Object> params);
	List<EgovMap> advIncentiveTargetList(Map<String, Object> params);

}
