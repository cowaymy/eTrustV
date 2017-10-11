package com.coway.trust.biz.commission.calculation;

import java.util.List;
import java.util.Map;

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
    
    /********************************************************
     *  Basic Data Exclude update
     * @param params
     * @return
     *********************************************************/
    void udtDataCMM0006T(Map<String, Object> param);
    void udtExcludeDataCMM0006T(Map<String, Object> param);
    
    void udtDataCMM0007T(Map<String, Object> param);
    void udtExcludeDataCMM0007T(Map<String, Object> param);
    
    void udtDataCMM0008T(Map<String, Object> param);
    void udtExcludeDataCMM0008T(Map<String, Object> param);
    
    void udtDataCMM0009T(Map<String, Object> param);
    void udtExcludeDataCMM0009T(Map<String, Object> param);
    
    void udtDataCMM0010T(Map<String, Object> param);
    void udtExcludeDataCMM0010T(Map<String, Object> param);
    
    void udtDataCMM0011T(Map<String, Object> param);
    void udtExcludeDataCMM0011T(Map<String, Object> param);
    
    void udtDataCMM0012T(Map<String, Object> param);
    void udtExcludeDataCMM0012T(Map<String, Object> param);
    
    void udtDataCMM0013T(Map<String, Object> param);
    void udtExcludeDataCMM0013T(Map<String, Object> param);
    
    void udtDataCMM0014T(Map<String, Object> param);
    void udtExcludeDataCMM0014T(Map<String, Object> param);
    
    void udtDataCMM0015T(Map<String, Object> param);
    void udtExcludeDataCMM0015T(Map<String, Object> param);
    
    void udtDataCMM0017T(Map<String, Object> param);
    void udtExcludeDataCMM0017T(Map<String, Object> param);
    
    void udtDataCMM0018T(Map<String, Object> param);
    void udtExcludeDataCMM0018T(Map<String, Object> param);
    
    void udtDataCMM0019T(Map<String, Object> param);
    void udtExcludeDataCMM0019T(Map<String, Object> param);
    
    void udtDataCMM0020T(Map<String, Object> param);
    void udtExcludeDataCMM0020T(Map<String, Object> param);
    
    void udtDataCMM0021T(Map<String, Object> param);
    void udtExcludeDataCMM0021T(Map<String, Object> param);
    
    void udtDataCMM0022T(Map<String, Object> param);
    void udtExcludeDataCMM0022T(Map<String, Object> param);
    
    void udtDataCMM0023T(Map<String, Object> param);
    void udtExcludeDataCMM0023T(Map<String, Object> param);
    
    void udtDataCMM0026T(Map<String, Object> param);
    void udtExcludeDataCMM0026T(Map<String, Object> param);
    
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
     * HP NeoPro insert
     */
    void neoProInsert(Map<String, Object> params);
    
    /**
     * CT Delete
     */
    void ctUploadDel(Map<String, Object> params);
    
    /**
     * CT Upload insert
     */
    void ctUploadInsert(Map<String, Object> params);
}
