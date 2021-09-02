package com.coway.trust.biz.sales.eSVM.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("eSVMApiMapper")
public interface eSVMApiMapper {

    List<EgovMap> selectQuotationList(Map<String, Object> params);

    EgovMap selectSvmOrdNo(Map<String, Object> params);

    List<EgovMap> selectProductFilterList(Map<String, Object> params); // Product Filter List

    List<EgovMap> selectComboPackageList(Map<String, Object> params); // Type of Package

    List<EgovMap> selectPackagePromo(Map<String, Object> params); // Package Promotion

    List<EgovMap> selectFilterPromo(Map<String, Object> params); // Filter Promotion

    int selectGSTZeroRateLocation(Map<String, Object> params);

    int selectGSTEURCertificate(Map<String, Object> params);

    EgovMap mPackageInfo(Map<String, Object> params);

    EgovMap selectOrderMemInfo(Map<String, Object> params);

    int getDfltPromo(Map<String, Object> params); // Default Promo ID for Filter Details

    EgovMap getSVMFilterCharge(Map<String, Object> params); // Filter Details

}
