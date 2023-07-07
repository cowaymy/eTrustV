package com.coway.trust.biz.eAccounting.smGmClaim;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface SmGmClaimApplication {

	void insertSmGmClaimAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);

	void updateSmGmClaimAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);

	void deleteSmGmClaimAttachBiz(FileType type, Map<String, Object> params);

}
