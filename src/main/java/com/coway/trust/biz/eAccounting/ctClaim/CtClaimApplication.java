package com.coway.trust.biz.eAccounting.ctClaim;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface CtClaimApplication {
	
	void insertCtClaimAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void updateCtClaimAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void deleteCtClaimAttachBiz(FileType type, Map<String, Object> params);
}
