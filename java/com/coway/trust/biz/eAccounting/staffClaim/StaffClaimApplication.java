package com.coway.trust.biz.eAccounting.staffClaim;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface StaffClaimApplication {

	void insertStaffClaimAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);

	void updateStaffClaimAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params);

	void deleteStaffClaimAttachBiz(FileType type, Map<String, Object> params);
}
