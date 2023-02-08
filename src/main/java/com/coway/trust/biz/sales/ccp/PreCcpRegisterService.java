package com.coway.trust.biz.sales.ccp;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface PreCcpRegisterService {

	int submitPreCcpSubmission(Map<String, Object> params) throws Exception;

	EgovMap getExistCustomer(Map<String, Object> params);

	List<EgovMap> selectPreCcpStatus();

	List<EgovMap> searchPreCcpRegisterList(Map<String, Object> params);

}