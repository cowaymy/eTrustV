package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface TransferService {

	
	List<EgovMap> selectMemberLevel(Map<String, Object> params);
	
	List<EgovMap> selectFromTransfer(Map<String, Object> params);
	
	List<EgovMap> selectTransferList(Map<String, Object> params);
	
	boolean insertTransferMember(Map<String, Object> params,SessionVO sessionVo);
	
	String selectBranchId(int codeId);
}
