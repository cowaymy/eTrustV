package com.coway.trust.biz.sales.eSVM.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("eSVMApiMapper")
public interface eSVMApiMapper {

    List<EgovMap> selectQuotationList(Map<String, Object> params);

    EgovMap selectSvmOrdNo(Map<String, Object> params);

    String getMaxPeriodEarlyBirdPromo(Map<String, Object> params);

    EgovMap checkActiveQuot(Map<String, Object> params);

    List<EgovMap> selectProductFilterList(Map<String, Object> params); // Product Filter List

    List<EgovMap> selectComboPackageList(Map<String, Object> params); // Type of Package

    List<EgovMap> selectPackagePromo(Map<String, Object> params); // Package Promotion

    List<EgovMap> selectFilterPromo(Map<String, Object> params); // Filter Promotion

    int selectGSTZeroRateLocation(Map<String, Object> params);

    int selectGSTEURCertificate(Map<String, Object> params);

    EgovMap mPackageInfo(Map<String, Object> params);

    EgovMap selectOrderMemInfo(Map<String, Object> params);

    int getDfltPromo(Map<String, Object> params); // Default Promo ID for Filter Details

    int getTaxRate();

    EgovMap getSVMFilterCharge(Map<String, Object> params); // Filter Details

    EgovMap getPromoDisc(Map<String, Object> params); // On change package information get discount

    EgovMap getOrderCurrentBillMonth(Map<String, Object> params);

    EgovMap getOrdOtstnd(Map<String, Object> params);

    EgovMap getOutrightMemLedge(Map<String, Object> params);

    EgovMap getSMQDocNo(Map<String, Object> params);

    String getSAL0093D_SEQ();

    void insertSal93D(Map<String, Object> params);

    void insertSal94D(Map<String, Object> params);

    EgovMap selectSmqDetail(Map<String, Object> params);

    String selectPackageDesc(Map<String, Object> params);

    String selectPackageInfoDesc(Map<String, Object> params);

    String selectFilterPromoDesc(Map<String, Object> params);

    List<EgovMap> selectSvmFilter(Map<String, Object> params);

    void cancelSal93(Map<String, Object> params);

    void cancelSal298(Map<String, Object> params);

    int selectFileGroupKey();

    int insertSYS0071D(Map<String, Object> param);

    int insertSYS0070M(Map<String, Object> param);

    int getSal298Seq();

    String getPsmDocNo();

    void insertSal298D(Map<String, Object> param);

    void updateProgressStatusSal298D(Map<String, Object> param);

    void insertPay312D(Map<String, Object> param);

    String getCustName(Map<String, Object> param);

    String getSmsTemplate(Map<String, Object> param);

    String getEmailTitle(Map<String, Object> param);

    EgovMap getEmailDetails(Map<String, Object> param);

    List<EgovMap> selectPSMList(Map<String, Object> params);

    List<EgovMap> selectESvmAttachment(Map<String, Object> param);

    int deleteSYS0070M(Map<String, Object> param);

    int deleteSYS0071D(Map<String, Object> param);

    List<EgovMap> getNewUploads(int param);

    EgovMap getOldUploads(Map<String, Object> param);

    int updateSYS0071D(Map<String, Object> param);

    int updateSYS0070M(Map<String, Object> param);

    EgovMap getMemberLevel(Map<String, Object> param);

    EgovMap selectEomDt(Map<String, Object> params);

    EgovMap selectConfigEomDur(Map<String, Object> params);

    EgovMap selectMembershipExpiryDt(Map<String, Object> params);

    String getServicePacIdExist(String salesOrdId);

    EgovMap selectSvcExpire(Map<String, Object> params);

    EgovMap selectSalesPerson(Map<String, Object> params);

    EgovMap selectConfigurationSalesPerson(Map<String, Object> params);

    List<EgovMap> selectSystemConfigurationParamVal(Map<String, Object> params);

    EgovMap checkActiveESvm(Map<String, Object> params);
}
