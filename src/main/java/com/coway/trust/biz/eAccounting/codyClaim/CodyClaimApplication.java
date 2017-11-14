package com.coway.trust.biz.eAccounting.codyClaim;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface CodyClaimApplication {
	
	void insertCodyClaimAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void updateCodyClaimAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);
	
	void deleteCodyClaimAttachBiz(FileType type, Map<String, Object> params);
}
