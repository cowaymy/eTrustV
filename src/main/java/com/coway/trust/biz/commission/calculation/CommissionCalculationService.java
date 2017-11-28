package com.coway.trust.biz.commission.calculation;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CommissionCalculationService
{
	/**
     *  search Commission Procedure Group List
     * @param params
     * @return
     */
    List<EgovMap> selectCommPrdGroupListl(Map<String, Object> params);
    
    /**
     *  search Organization Code List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgCdListAll(Map<String, Object> params);
    
    /**
     *  search Calculation List
     * @param params
     * @return
     */
    List<EgovMap> selectCalculationList(Map<String, Object> params);
    
    /**
     *  search Basic Calculation List
     * @param params
     * @return
     */
    List<EgovMap> selectBasicList(Map<String, Object> params);
    
    /**
     *  search Basic Calculation State Select
     * @param params
     * @return
     */
    Map<String, Object> selectBasicStatus(Map<String, Object> params);
    
    /**
     *  call Commission Procedure
     * @param params
     * @return
     */
    Map<String, Object> callCommProcedure(Map<String, Object> param);
    
    
    /**
     *  procedure Log Insert 
     * @param params
     * @return
     */
    int callCommPrdLogIns(Map<String, Object> param);
    
    /**
     *  procedure Last Log Extraction Select  
     * @param params
     * @return
     */
    List<EgovMap> selectCommRunningPrdLog(Map<String, Object> obj);
    
    /**
     *  procedure Log Update 
     * @param params
     * @return
     */
    void callCommPrdLogUpdate(Map<String, Object> param);
    
    /**
     *  procedure Fail Log Update
     * @param params
     * @return
     */
    int callCommFailNextPrdLog(Map<String, Object> param);
    
    /**
     *  procedure Log Select 
     * @param params
     * @return
     */
    List<EgovMap> selectLogList(Map<String, Object> params);
    
    
    /**
     *  search Organization Gruop List
     * @param params
     * @return
     */
    List<EgovMap> selectOrgGrList(Map<String, Object> params);
    
    
    
    /********************************************************
     *  calculation Date Select 
     * @param params
     * @return
     *********************************************************/
    int cntCMM0028D(Map<String, Object> params);
    List<EgovMap> selectData7001(Map<String, Object> params);
    int cntCMM0029D(Map<String, Object> params);
    List<EgovMap> selectData7002(Map<String, Object> params);

    /********************************************************
     *  Basic Date Select 
     * @param params
     * @return
     *********************************************************/
    int cntCMM0006T(Map<String, Object> params);
    List<EgovMap> selectCMM0006T(Map<String, Object> params);
    int cntCMM0007T(Map<String, Object> params);
    List<EgovMap> selectCMM0007T(Map<String, Object> params);
    int cntCMM0008T(Map<String, Object> params);
    List<EgovMap> selectCMM0008T(Map<String, Object> params);
    int cntCMM0009T(Map<String, Object> params);
    List<EgovMap> selectCMM0009T(Map<String, Object> params);
    int cntCMM0010T(Map<String, Object> params);
    List<EgovMap> selectCMM0010T(Map<String, Object> params);
    int cntCMM0011T(Map<String, Object> params);
    List<EgovMap> selectCMM0011T(Map<String, Object> params);
    int cntCMM0012T(Map<String, Object> params);
    List<EgovMap> selectCMM0012T(Map<String, Object> params);
    int cntCMM0013T(Map<String, Object> params);
    List<EgovMap> selectCMM0013T(Map<String, Object> params);
    int cntCMM0014T(Map<String, Object> params);
    List<EgovMap> selectCMM0014T(Map<String, Object> params);
    int cntCMM0015T(Map<String, Object> params);
    List<EgovMap> selectCMM0015T(Map<String, Object> params);
    int cntCMM0016T(Map<String, Object> params);
    List<EgovMap> selectCMM0016T(Map<String, Object> params);
    int cntCMM0017T(Map<String, Object> params);
    List<EgovMap> selectCMM0017T(Map<String, Object> params);
    int cntCMM0018T(Map<String, Object> params);
    List<EgovMap> selectCMM0018T(Map<String, Object> params);
    int cntCMM0019T(Map<String, Object> params);
    List<EgovMap> selectCMM0019T(Map<String, Object> params);
    int cntCMM0020T(Map<String, Object> params);
    List<EgovMap> selectCMM0020T(Map<String, Object> params);
    int cntCMM0021T(Map<String, Object> params);
    List<EgovMap> selectCMM0021T(Map<String, Object> params);
    int cntCMM0022T(Map<String, Object> params);
    List<EgovMap> selectCMM0022T(Map<String, Object> params);
    int cntCMM0023T(Map<String, Object> params);
    List<EgovMap> selectCMM0023T(Map<String, Object> params);
    int cntCMM0024T(Map<String, Object> params);
    List<EgovMap> selectCMM0024T(Map<String, Object> params);
    int cntCMM0025T(Map<String, Object> params);
    List<EgovMap> selectCMM0025T(Map<String, Object> params);
    int cntCMM0026T(Map<String, Object> params);
    List<EgovMap> selectCMM0026T(Map<String, Object> params);
    int cntCMM0060T(Map<String, Object> params);
    List<EgovMap> selectCMM0060T(Map<String, Object> params);
    int cntCMM0067T(Map<String, Object> params);
    List<EgovMap> selectCMM0067T(Map<String, Object> params);
    int cntCMM0068T(Map<String, Object> params);
    List<EgovMap> selectCMM0068T(Map<String, Object> params);
    
    /********************************************************
     *  Basic Data Exclude update
     * @param params
     * @return
     *********************************************************/
    void udtDataCMM0006T(Map<String, Object> param);
    void udtDataCMM0007T(Map<String, Object> param);
    void udtDataCMM0008T(Map<String, Object> param);
    void udtDataCMM0009T(Map<String, Object> param);
    void udtDataCMM0010T(Map<String, Object> param);
    void udtDataCMM0011T(Map<String, Object> param);
    void udtDataCMM0012T(Map<String, Object> param);
    void udtDataCMM0013T(Map<String, Object> param);
    void udtDataCMM0014T(Map<String, Object> param);
    void udtDataCMM0015T(Map<String, Object> param);
    void udtDataCMM0017T(Map<String, Object> param);
    void udtDataCMM0018T(Map<String, Object> param);
    void udtDataCMM0019T(Map<String, Object> param);
    void udtDataCMM0020T(Map<String, Object> param);
    void udtDataCMM0021T(Map<String, Object> param);
    void udtDataCMM0022T(Map<String, Object> param);
    void udtDataCMM0023T(Map<String, Object> param);
    void udtDataCMM0026T(Map<String, Object> param);
    void udtDataCMM0060T(Map<String, Object> param);
    void udtDataCMM0067T(Map<String, Object> param);
    void udtDataCMM0068T(Map<String, Object> param);
    
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
     * HP NeoPro insert
     */
    void neoProInsert(Map<String, ArrayList<Object>> params, SessionVO sessionVO);
    
    
    /**
     * CT Upload insert
     */
    void ctUploadInsert(Map<String, ArrayList<Object>> params, SessionVO sessionVO);
    
    List<EgovMap> incentiveStatus(Map<String, Object> params);
    List<EgovMap> incentiveType(Map<String, Object> params);
    List<EgovMap> incentiveTargetList(Map<String, Object> params);
    List<EgovMap> incentiveSample(Map<String, Object> params);
    int cntUploadBatch(Map<String, Object> params);
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
    
}
