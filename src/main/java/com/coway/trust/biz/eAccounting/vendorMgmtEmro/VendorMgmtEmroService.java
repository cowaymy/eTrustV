package com.coway.trust.biz.eAccounting.vendorMgmtEmro;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface VendorMgmtEmroService {

	List<EgovMap> selectBank();

	List<EgovMap> selectSAPCountry();

	List<EgovMap> selectVendorList(Map<String, Object> params);

	EgovMap selectVendorInfo(String reqNo);

	EgovMap selectVendorInfoMaster(String vendorAccId);

	List<EgovMap> selectAttachList(String atchFileGrpId);

	List<EgovMap> getAppvExcelInfo(Map<String, Object> params);

	void saveEmroData(Map<String, ArrayList<Object>> params, int userId);
}
