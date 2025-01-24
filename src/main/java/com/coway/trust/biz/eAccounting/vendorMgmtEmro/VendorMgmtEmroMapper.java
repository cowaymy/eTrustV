package com.coway.trust.biz.eAccounting.vendorMgmtEmro;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("vendorMgmtEmroMapper")
public interface VendorMgmtEmroMapper {

	List<EgovMap> selectBank();

	List<EgovMap> selectSAPCountry();

	List<EgovMap> selectVendorList(Map<String, Object> params);

	EgovMap selectVendorInfo(String reqNo);

	EgovMap selectVendorInfoMaster(String vendorAccId);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	List<EgovMap> selectVendorType();

	List<EgovMap> getAppvExcelInfo(Map<String, Object> params);

	void updateSyncEmro29D(Map<String, Object> params);

	void updateSyncEmro31D(Map<String, Object> params);

	EgovMap getProcurementEmail();

	void insertVendorDiff(Map<String, Object> params);

	EgovMap getEmailDiffContent(Map<String, Object> params);
}
