package com.coway.trust.biz.eAccounting.contract;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface ContractService {

	List<EgovMap> selectContractTrackingList(Map<String, Object> params);

	String selectNextContractNo();

	void insertVendorTrackingInfo(Map<String, Object> params);

	EgovMap selectContractTrackingViewDetails(Map<String, Object> params);

	List<EgovMap> selectContractCycleDetails(Map<String, Object> params);

	void updateVendorTrackingInfo(Map<String, Object> params);

	void insertPreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs);

	void updatePreOrderAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs);

	void deleteVendorTrackingInfo(Map<String, Object> params);

}
